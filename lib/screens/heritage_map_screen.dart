import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/providers/locale_provider.dart';
import 'package:ebzim_app/core/services/news_service.dart';
import 'package:ebzim_app/core/models/news_post.dart';

class HeritageMapScreen extends ConsumerStatefulWidget {
  const HeritageMapScreen({super.key});

  @override
  ConsumerState<HeritageMapScreen> createState() => _HeritageMapScreenState();
}

class _HeritageMapScreenState extends ConsumerState<HeritageMapScreen> {
  final MapController _mapController = MapController();
  String _selectedFilter = 'ALL';
  String _mapLayer = 'ALL'; // ALL, PROJECTS, DISCOVERY

  dynamic _selectedItem;
  List<WikiLandmark> _wikiLandmarks = [];
  final Set<int> _loadedWikiIds = {}; // Track IDs to prevent duplicates
  bool _isLoadingWiki = false;
  LatLng? _lastFetchCenter;

  // Global Wonders to show when zooming out
  final List<WikiLandmark> _globalWonders = [
    WikiLandmark(
      pageId: -1, title: 'أهرامات الجيزة', description: 'من عجائب الدنيا السبع القديمة', 
      imageUrl: 'https://images.unsplash.com/photo-1539667468225-eebb663053e6?w=400&auto=format&fit=crop', 
      lat: 29.9792, lon: 31.1342
    ),
    WikiLandmark(
      pageId: -2, title: 'برج إيفل', description: 'المعلم الأيقوني لمدينة باريس', 
      imageUrl: 'https://images.unsplash.com/photo-1511739001486-6bfe10ce785f?w=400&auto=format&fit=crop', 
      lat: 48.8584, lon: 2.2945
    ),
    WikiLandmark(
      pageId: -3, title: 'برج بيزا المائل', description: 'برج جرس إيطالي مشهور بميلانه', 
      imageUrl: 'https://images.unsplash.com/photo-1528114039593-4366cc08227d?w=400&auto=format&fit=crop', 
      lat: 43.7230, lon: 10.3966
    ),
    WikiLandmark(
      pageId: -4, title: 'الكولوسيوم', description: 'مدرج روماني أثري في روما', 
      imageUrl: 'https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&auto=format&fit=crop', 
      lat: 41.8902, lon: 12.4922
    ),
    WikiLandmark(
      pageId: -5, title: 'البتراء', description: 'المدينة الوردية الأثرية بالأردن', 
      imageUrl: 'https://images.unsplash.com/photo-1579606031201-987efecab8ac?w=400&auto=format&fit=crop', 
      lat: 30.3285, lon: 35.4444
    ),
    WikiLandmark(
      pageId: -6, title: 'تاج محل', description: 'ضريح رخامي ضخم في الهند', 
      imageUrl: 'https://images.unsplash.com/photo-1524492412937-b28074a5d7da?w=400&auto=format&fit=crop', 
      lat: 27.1751, lon: 78.0421
    ),
  ];

  String _stripDiacritics(String str) {
    var withDia = 'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    var withoutDia = 'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';
    for (int i = 0; i < withDia.length; i++) {
      str = str.replaceAll(withDia[i], withoutDia[i]);
    }
    return str;
  }

  @override
  void initState() {
    super.initState();
    _fetchWikiLandmarks(const LatLng(36.1915, 5.4110));
  }

  Future<void> _fetchWikiLandmarks(LatLng center) async {
    if (_isLoadingWiki) return;
    setState(() => _isLoadingWiki = true);
    try {
      final lang = ref.read(localeProvider).languageCode;
      final wikiSub = lang == 'ar' ? 'ar' : (lang == 'fr' ? 'fr' : 'en');
      final url = Uri.parse(
          'https://$wikiSub.wikipedia.org/w/api.php?action=query&generator=geosearch&ggscoord=${center.latitude}|${center.longitude}&ggsradius=10000&ggslimit=30&prop=coordinates|pageimages|description&piprop=thumbnail&pithumbsize=400&format=json&origin=*');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final pages = data['query']?['pages'] as Map<String, dynamic>? ?? {};
        final List<WikiLandmark> newLandmarks = [];
        
        // Robust Blacklist: Remove administrative and modern infrastructure
        final blacklistedKeywords = [
          'aeroport', 'universite', 'stade', 'hopital', 'gare', 'clinique', 
          'ecole', 'lycee', 'hotel', 'commune', 'wilaya', 'daira', 'entreprise',
          'ville', 'village', 'arrondissement', 'quartier', 'centre', 'usine', 'barrage', 'institut', 'faculte',
          'بلدية', 'ولاية', 'دائرة', 'مدينة', 'قرية', 'حي ', 'مستشفى', 'جامعة', 'مطار', 'ثانوية', 'ابتدائية', 'متوسطة', 'فندق'
        ];

        for (var page in pages.values) {
          final int pageId = page['pageid'] ?? 0;
          if (page['coordinates'] != null && !_loadedWikiIds.contains(pageId)) {
            final title = _stripDiacritics((page['title'] ?? '').toLowerCase());
            final desc = _stripDiacritics((page['description'] ?? '').toLowerCase());
            
            bool isBlacklisted = blacklistedKeywords.any((kw) => title.contains(kw) || desc.contains(kw));
            
            if (!isBlacklisted && page['thumbnail'] != null) {
              _loadedWikiIds.add(pageId);
              newLandmarks.add(WikiLandmark(
                pageId: pageId,
                title: page['title'] ?? '',
                description: page['description'] ?? 'معلم أو مكان بارز',
                imageUrl: page['thumbnail']?['source'] ?? '',
                lat: page['coordinates'][0]['lat'],
                lon: page['coordinates'][0]['lon'],
              ));
            }
          }
        }
        if (mounted) {
          setState(() {
            _wikiLandmarks.addAll(newLandmarks);
            _lastFetchCenter = center;
          });
        }
      }
    } catch (e) {
      debugPrint('Wiki Error: $e');
    } finally {
      if (mounted) setState(() => _isLoadingWiki = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAr = ref.watch(localeProvider).languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final newsAsync = ref.watch(newsProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? Colors.black54 : Colors.white70,
              shape: BoxShape.circle,
            ),
            child: Icon(isAr ? Icons.arrow_forward : Icons.arrow_back, color: isDark ? Colors.white : Colors.black87),
          ),
          onPressed: () => context.pop(),
        ),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isDark ? Colors.black54 : Colors.white70,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            isAr ? 'خريطة الأنشطة والمشاريع' : 'Carte des Projets',
            style: GoogleFonts.tajawal(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: newsAsync.when(
        data: (posts) {
          final projects = posts.where((p) => p.latitude != null && p.longitude != null).toList();
          
          final List<Marker> markers = [];
          
          // Add dynamic projects (Ebzim Field Projects)
          if (_mapLayer == 'ALL' || _mapLayer == 'PROJECTS') {
            for (var p in projects) {
              if (_selectedFilter == 'ALL' || _selectedFilter == p.category) {
                final isSelected = _selectedItem is NewsPost && (_selectedItem as NewsPost).id == p.id;
                markers.add(_buildMarker(p, isDark, isSelected));
              }
            }
          }

          // Add Discovery Layer (Wikipedia + Global Wonders)
          if (_mapLayer == 'ALL' || _mapLayer == 'DISCOVERY') {
            if (_selectedFilter == 'ALL' || _selectedFilter == 'RESTORATION' || _selectedFilter == 'CULTURAL') {
              for (var w in _wikiLandmarks) {
                final isSelected = _selectedItem is WikiLandmark && (_selectedItem as WikiLandmark).pageId == w.pageId;
                markers.add(_buildWikiMarker(w, isDark, isSelected));
              }
              for (var gw in _globalWonders) {
                final isSelected = _selectedItem is WikiLandmark && (_selectedItem as WikiLandmark).pageId == gw.pageId;
                markers.add(_buildWikiMarker(gw, isDark, isSelected));
              }
            }
          }

          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: const LatLng(36.1915, 5.4110),
                  initialZoom: 14.5,
                  onTap: (tapPosition, point) {
                    setState(() => _selectedItem = null);
                  },
                  onPositionChanged: (pos, hasGesture) {
                    if (hasGesture && pos.center != null) {
                      // Only fetch if moved more than ~2km from last fetch
                      double distance = 0;
                      if (_lastFetchCenter != null) {
                        const Distance distanceCalculator = Distance();
                        distance = distanceCalculator.as(LengthUnit.Meter, _lastFetchCenter!, pos.center!);
                      }

                      if (!_isLoadingWiki && (_lastFetchCenter == null || distance > 2000)) {
                        _fetchWikiLandmarks(pos.center!);
                      }
                    }
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
                    userAgentPackageName: 'com.ebzim.app',
                  ),
                  MarkerLayer(markers: markers),
                ],
              ),
              
              // Top Filter Bar
              Positioned(
                top: MediaQuery.of(context).padding.top + 70,
                left: 0, right: 0,
                child: _buildFilterBar(isAr, isDark),
              ),

              // Selection Card
              AnimatedPositioned(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                bottom: _selectedItem != null ? 30 : -400,
                left: 20,
                right: 20,
                child: _selectedItem == null
                    ? const SizedBox.shrink()
                    : _buildDetailCard(_selectedItem, isAr, isDark),
              ),

              // Floating Layer Switcher
              PositionedDirectional(
                bottom: 120,
                end: 20,
                child: _buildLayerSwitcher(isAr, isDark),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor)),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Marker _buildWikiMarker(WikiLandmark item, bool isDark, bool isSelected) {
    return Marker(
      point: LatLng(item.lat, item.lon),
      width: 65, height: 65,
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedItem = item);
          _mapController.move(LatLng(item.lat, item.lon), 16.0);
        },
        child: _buildMarkerWidget(Icons.auto_awesome, Colors.purpleAccent, isSelected),
      ),
    );
  }

  Marker _buildMarker(NewsPost item, bool isDark, bool isSelected) {
    return Marker(
      point: LatLng(item.latitude!, item.longitude!),
      width: 65, height: 65,
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedItem = item);
          _mapController.move(LatLng(item.latitude!, item.longitude!), 16.0);
        },
        child: _buildMarkerWidget(_getIconForCategory(item.category), AppTheme.primaryColor, isSelected),
      ),
    );
  }

  Widget _buildMarkerWidget(IconData icon, Color color, bool isSelected) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (isSelected)
          Container(
            width: 45, height: 45,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.3),
            ),
          ).animate(onPlay: (controller) => controller.repeat())
           .scale(duration: 1000.ms, begin: const Offset(1, 1), end: const Offset(2.2, 2.2))
           .fadeOut(duration: 1000.ms),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 15, spreadRadius: 2)],
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ).animate(target: isSelected ? 1 : 0)
         .scale(duration: 400.ms, curve: Curves.elasticOut),
      ],
    );
  }

  IconData _getIconForCategory(String category) {
    switch (category.toUpperCase()) {
      case 'HERITAGE': case 'RESTORATION': return Icons.museum_rounded;
      case 'PROJECT': return Icons.assignment_rounded;
      case 'ASSOCIATIVE': return Icons.groups_rounded;
      case 'SOCIAL': return Icons.favorite_rounded;
      case 'CULTURAL': return Icons.palette_rounded;
      case 'SCIENTIFIC': return Icons.science_rounded;
      default: return Icons.location_on_rounded;
    }
  }

  Widget _buildFilterBar(bool isAr, bool isDark) {
    final filters = [
      {'id': 'ALL', 'label': isAr ? 'الكل' : 'Tous'},
      {'id': 'ASSOCIATIVE', 'label': isAr ? 'نشاط جمعوي' : 'Activité Associative'},
      {'id': 'PROJECT', 'label': isAr ? 'مشروع مؤسساتي' : 'Projet Institutionnel'},
      {'id': 'RESTORATION', 'label': isAr ? 'حماية التراث' : 'Protection du Patrimoine'},
      {'id': 'CULTURAL', 'label': isAr ? 'نشاط ثقافي' : 'Activité Culturelle'},
      {'id': 'SOCIAL', 'label': isAr ? 'مبادرة اجتماعية' : 'Initiative Sociale'},
      {'id': 'SCIENTIFIC', 'label': isAr ? 'بحث علمي' : 'Recherche Scientifique'},
    ];

    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (ctx, i) {
          final f = filters[i];
          final active = _selectedFilter == f['id'];
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = f['id']!),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: active ? AppTheme.accentColor : (isDark ? Colors.black87 : Colors.white),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: active ? Colors.transparent : Colors.white24),
              ),
              child: Center(
                child: Text(
                  f['label']!,
                  style: GoogleFonts.tajawal(
                    color: active ? Colors.black : (isDark ? Colors.white : Colors.black87),
                    fontWeight: active ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _getCategoryLabel(String category, bool isAr) {
    switch (category.toUpperCase()) {
      case 'PROJECT': return isAr ? 'مشروع مؤسساتي' : 'Projet Institutionnel';
      case 'RESTORATION': return isAr ? 'حماية التراث والآثار' : 'Protection du Patrimoine';
      case 'CULTURAL': return isAr ? 'مهرجان / نشاط ثقافي' : 'Activité Culturelle';
      case 'SCIENTIFIC': return isAr ? 'ندوة / بحث علمي' : 'Recherche Scientifique';
      case 'ASSOCIATIVE': return isAr ? 'نشاط جمعوي' : 'Activité Associative';
      case 'SOCIAL': return isAr ? 'مبادرة اجتماعية' : 'Initiative Sociale';
      default: return isAr ? 'مشروع ميداني' : 'Projet Terrain';
    }
  }

  Widget _buildDetailCard(dynamic item, bool isAr, bool isDark) {
    String title = '';
    String desc = '';
    String img = '';
    String cat = '';
    VoidCallback? onTap;

    if (item is WikiLandmark) {
      title = item.title;
      desc = item.description;
      img = item.imageUrl;
      cat = isAr ? 'موسوعة ويكيبيديا' : 'Wikipedia';
      onTap = null; // Maybe open external link in future
    } else if (item is NewsPost) {
      title = item.getTitle(isAr ? 'ar' : 'fr');
      desc = item.getSummary(isAr ? 'ar' : 'fr');
      img = item.imageUrl;
      cat = _getCategoryLabel(item.category, isAr);
      onTap = () => context.push('/project/${item.id}', extra: item);
    }

    return Stack(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E2124) : Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 30, offset: const Offset(0, 10))],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (img.isNotEmpty)
                    SizedBox(
                      height: 140,
                      width: double.infinity,
                      child: CachedNetworkImage(imageUrl: img, fit: BoxFit.cover),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: AppTheme.accentColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                          child: Text(cat, style: const TextStyle(color: AppTheme.accentColor, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 8),
                        Text(title, style: GoogleFonts.cairo(color: isDark ? Colors.white : Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(desc, style: TextStyle(color: isDark ? Colors.white70 : Colors.black54, fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        PositionedDirectional(
          top: 10,
          end: 10,
          child: Material(
            color: Colors.black54,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => setState(() => _selectedItem = null),
              child: const Padding(
                padding: EdgeInsets.all(6.0),
                child: Icon(Icons.close, color: Colors.white, size: 18),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLayerSwitcher(bool isAr, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: isDark ? Colors.black87 : Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.3)),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLayerItem(Icons.layers_rounded, 'ALL', isAr ? 'الكل' : 'Tout', isDark),
          const SizedBox(height: 4),
          _buildLayerItem(Icons.construction_rounded, 'PROJECTS', isAr ? 'ميدانية' : 'Terrain', isDark),
          const SizedBox(height: 4),
          _buildLayerItem(Icons.public_rounded, 'DISCOVERY', isAr ? 'استكشاف' : 'Découverte', isDark),
        ],
      ),
    );
  }

  Widget _buildLayerItem(IconData icon, String layer, String label, bool isDark) {
    final isSelected = _mapLayer == layer;
    return GestureDetector(
      onTap: () => setState(() => _mapLayer = layer),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accentColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? Colors.black : (isDark ? Colors.white70 : Colors.black54), size: 20),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: isSelected ? Colors.black : (isDark ? Colors.white38 : Colors.black38))),
          ],
        ),
      ),
    );
  }
}

class WikiLandmark {
  final int pageId;
  final String title;
  final String description;
  final String imageUrl;
  final double lat;
  final double lon;

  WikiLandmark({
    required this.pageId,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.lat,
    required this.lon,
  });
}
