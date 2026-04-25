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
      pageId: -6, title: 'تاج محل', description: 'ضريح رخامي ضخم في الهند - إحدى عجائب العالم السبع.', 
      imageUrl: 'https://images.unsplash.com/photo-1524492412937-b28074a5d7da?w=800&auto=format&fit=crop', 
      lat: 27.1751, lon: 78.0421
    ),
    WikiLandmark(
      pageId: -7, title: 'البتراء', description: 'المدينة الوردية الأثرية بالأردن - إحدى عجائب العالم السبع.', 
      imageUrl: 'https://images.unsplash.com/photo-1580619305218-8423a7ef79b4?w=800&auto=format&fit=crop', 
      lat: 30.3285, lon: 35.4444
    ),
    WikiLandmark(
      pageId: -8, title: 'تمثال الحرية', description: 'رمز الحرية في نيويورك، الولايات المتحدة', 
      imageUrl: 'https://images.unsplash.com/photo-1524231757912-21f4fe3a7200?w=800&auto=format&fit=crop', 
      lat: 40.6892, lon: -74.0445
    ),
    WikiLandmark(
      pageId: -9, title: 'مقام الشهيد', description: 'رمز الاستقلال الجزائري - الجزائر العاصمة', 
      imageUrl: 'https://images.unsplash.com/photo-1626014303757-646c21dc35b7?w=800&auto=format&fit=crop', 
      lat: 36.7458, lon: 3.0597
    ),
    WikiLandmark(
      pageId: -10, title: 'عين الفوارة - سطيف', 
      description: 'أيقونة مدينة سطيف وأشهر نافورة في الجزائر، تحفة فنية ومعلم تاريخي يتوسط قلب المدينة.',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/67/Ain_El_Fouara_2013.JPG/800px-Ain_El_Fouara_2013.JPG',
      lat: 36.189444, lon: 5.405
    ),
    WikiLandmark(
      pageId: -11, title: 'جميلة (كويكول) - سطيف', 
      description: 'موقع أثري روماني استثنائي ومصنف ضمن التراث العالمي لليونسكو، يضم أجمل الفسيفساء في العالم.',
      imageUrl: 'https://images.unsplash.com/photo-1629216142718-f0278783478d?w=800&auto=format&fit=crop',
      lat: 36.320, lon: 5.736
    ),
    WikiLandmark(
      pageId: -12, title: 'تيمقاد - باتنة', 
      description: 'مدينة رومانية كاملة الأركان ومصنفة عالمياً، تلقب بـ "بومباي شمال إفريقيا" لعظمة تخطيطها.',
      imageUrl: 'https://images.unsplash.com/photo-1596468138838-9e320f75e77d?w=800&auto=format&fit=crop',
      lat: 35.4856, lon: 6.4678
    ),
    WikiLandmark(
      pageId: -13, title: 'تيبازة الأثرية', 
      description: 'مجمع أثري ساحري يجمع بين عبق التاريخ الروماني وجمال البحر الأبيض المتوسط.',
      imageUrl: 'https://images.unsplash.com/photo-1565439396115-46f90bc1b193?w=800&auto=format&fit=crop',
      lat: 36.5925, lon: 2.4419
    ),
    WikiLandmark(
      pageId: -14, title: 'وادي ميزاب - غرداية', 
      description: 'تحفة معمارية وحضارية فريدة، تعكس عبقرية الإنسان في التأقلم مع البيئة الصحراوية.',
      imageUrl: 'https://images.unsplash.com/photo-1534067783941-51c9c23ecefd?w=800&auto=format&fit=crop',
      lat: 32.4883, lon: 3.6733
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

  // Persistent Cache to prevent landmarks from disappearing
  final Map<int, WikiLandmark> _landmarkCache = {};

  Future<void> _fetchWikiLandmarks(LatLng center) async {
    if (_isLoadingWiki) return;
    setState(() => _isLoadingWiki = true);
    
    try {
      final lang = ref.read(localeProvider).languageCode;
      final wikiSub = lang == 'ar' ? 'ar' : (lang == 'fr' ? 'fr' : 'en');
      
      final uri = Uri.https('$wikiSub.wikipedia.org', '/w/api.php', {
        'action': 'query',
        'generator': 'geosearch',
        'ggscoord': '${center.latitude}|${center.longitude}',
        'ggsradius': '20000',
        'ggslimit': '150',
        'prop': 'coordinates|pageimages|description',
        'piprop': 'thumbnail',
        'pithumbsize': '400',
        'format': 'json',
        'origin': '*',
      });

      final response = await http.get(uri).timeout(const Duration(seconds: 10));
      
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
            
            if (!isBlacklisted) {
              _loadedWikiIds.add(pageId);
              newLandmarks.add(WikiLandmark(
                pageId: pageId,
                title: page['title'] ?? '',
                description: page['description'] ?? (lang == 'ar' ? 'معلم تاريخي أو موقع أثري' : 'Site historique ou monument'),
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
                    if (_selectedItem != null) {
                      setState(() => _selectedItem = null);
                    }
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
                top: 100, left: 20, right: 20,
                child: _buildFilterBar(isAr, isDark),
              ),

              // Selection Card
              if (_selectedItem != null)
                _buildDetailCard(_selectedItem, isAr, isDark),

              // Floating Layer Switcher
              PositionedDirectional(
                bottom: 120,
                end: 20,
                child: _buildLayerSwitcher(isAr, isDark),
              ),

              // Manual Refresh Button (for network issues)
              PositionedDirectional(
                bottom: 300,
                end: 20,
                child: FloatingActionButton.small(
                  onPressed: () {
                    setState(() {
                      _loadedWikiIds.clear();
                      _wikiLandmarks.clear();
                      _lastFetchCenter = null;
                    });
                    _fetchWikiLandmarks(_mapController.camera.center);
                    ref.invalidate(newsProvider);
                  },
                  backgroundColor: isDark ? Colors.black87 : Colors.white,
                  child: Icon(Icons.refresh_rounded, color: AppTheme.accentColor),
                ),
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
    // Special theme for Global Wonders (like Ain El Fouara)
    final bool isWonder = item.pageId < 0;
    final Color markerColor = isWonder ? Colors.amber : Colors.purpleAccent;
    final IconData markerIcon = isWonder ? Icons.museum_rounded : Icons.auto_awesome;

    return Marker(
      point: LatLng(item.lat, item.lon),
      width: 65, height: 65,
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedItem = item);
          _mapController.move(LatLng(item.lat, item.lon), 16.0);
        },
        child: _buildMarkerWidget(markerIcon, markerColor, isSelected),
      ),
    );
  }

  Marker _buildMarker(NewsPost p, bool isDark, bool isSelected) {
    final bool isAssociative = p.category == 'ASSOCIATIVE';
    final String? logoUrl = isAssociative 
      ? 'https://res.cloudinary.com/do3ygqlnl/image/upload/v1776845780/ebzim/cms/mti7fecdjsmdfj5ialwg.png'
      : null;

    return Marker(
      point: LatLng(p.latitude!, p.longitude!),
      width: 65, height: 65,
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedItem = p);
          _mapController.move(LatLng(p.latitude!, p.longitude!), 16.0);
        },
        child: _buildMarkerWidget(
          isAssociative ? Icons.groups : Icons.construction,
          isAssociative ? Colors.amber : Colors.orange,
          isSelected,
          imageUrl: logoUrl,
        ),
      ),
    );
  }

  Widget _buildMarkerWidget(IconData icon, Color color, bool isSelected, {String? imageUrl}) {
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
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 15, spreadRadius: 2)],
          ),
          child: imageUrl != null 
            ? ClipOval(
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: 38, height: 38,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Icon(icon, color: Colors.white, size: 20),
                  errorWidget: (context, url, error) => Icon(icon, color: Colors.white, size: 20),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(6),
                child: Icon(icon, color: Colors.white, size: 22),
              ),
        ).animate()
         .scale(
           duration: 400.ms, 
           curve: Curves.elasticOut,
           begin: const Offset(1, 1),
           end: isSelected ? const Offset(1.2, 1.2) : const Offset(1, 1),
         ),
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
      onTap = null;
    } else if (item is NewsPost) {
      title = item.getTitle(isAr ? 'ar' : 'fr');
      desc = item.getSummary(isAr ? 'ar' : 'fr');
      img = item.imageUrl;
      cat = _getCategoryLabel(item.category, isAr);
      onTap = () => context.push('/project/${item.id}', extra: item);
    }

    return Positioned(
      bottom: 24,
      left: 16,
      right: 16,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Hero(
            tag: 'detail_card',
            child: Material(
              color: Colors.transparent,
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E2124) : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 40,
                        offset: const Offset(0, 15),
                      )
                    ],
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
                            child: CachedNetworkImage(
                              imageUrl: img,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.black12,
                                child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: AppTheme.accentColor.withValues(alpha: 0.1),
                                child: const Center(
                                  child: Icon(Icons.museum_outlined, color: AppTheme.accentColor, size: 40),
                                ),
                              ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: AppTheme.accentColor.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  cat,
                                  style: const TextStyle(
                                    color: AppTheme.accentColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                title,
                                style: GoogleFonts.cairo(
                                  color: isDark ? Colors.white : Colors.black87,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                desc,
                                style: TextStyle(
                                  color: isDark ? Colors.white70 : Colors.black54,
                                  fontSize: 13,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => setState(() => _selectedItem = null),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.accentColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.black45, blurRadius: 10, offset: const Offset(0, 2))
                  ],
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 18),
              ),
            ),
          ),
        ],
      ),
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
