import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  

  dynamic _selectedItem;
  List<WikiLandmark> _wikiLandmarks = [];
  bool _isLoadingWiki = false;

  @override
  void initState() {
    super.initState();
    _fetchWikiLandmarks(const LatLng(36.1915, 5.4110));
  }

  Future<void> _fetchWikiLandmarks(LatLng center) async {
    if (_isLoadingWiki) return;
    setState(() => _isLoadingWiki = true);
    try {
      final url = Uri.parse(
          'https://ar.wikipedia.org/w/api.php?action=query&generator=geosearch&ggscoord=${center.latitude}|${center.longitude}&ggsradius=10000&ggslimit=30&prop=coordinates|pageimages|description&piprop=thumbnail&pithumbsize=400&format=json&origin=*');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final pages = data['query']?['pages'] as Map<String, dynamic>? ?? {};
        final List<WikiLandmark> newLandmarks = [];
        for (var page in pages.values) {
          if (page['coordinates'] != null) {
            newLandmarks.add(WikiLandmark(
              pageId: page['pageid'],
              title: page['title'] ?? '',
              description: page['description'] ?? 'معلم تاريخي (ويكيبيديا)',
              imageUrl: page['thumbnail']?['source'] ?? '',
              lat: page['coordinates'][0]['lat'],
              lon: page['coordinates'][0]['lon'],
            ));
          }
        }
        if (mounted) {
          setState(() {
            _wikiLandmarks = newLandmarks;
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
          
          // Add dynamic projects
          for (var p in projects) {
            if (_selectedFilter == 'ALL' || _selectedFilter == p.category) {
              markers.add(_buildMarker(p, isDark));
            }
          }

          // Add Wikipedia Landmarks
          if (_selectedFilter == 'ALL' || _selectedFilter == 'RESTORATION' || _selectedFilter == 'CULTURAL') {
            for (var w in _wikiLandmarks) {
              markers.add(_buildWikiMarker(w, isDark));
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
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor)),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Marker _buildWikiMarker(WikiLandmark item, bool isDark) {
    final bool isSelected = _selectedItem is WikiLandmark && (_selectedItem as WikiLandmark).pageId == item.pageId;

    return Marker(
      point: LatLng(item.lat, item.lon),
      width: 60,
      height: 60,
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedItem = item);
          _mapController.move(LatLng(item.lat, item.lon), 16.0);
        },
        child: AnimatedScale(
          scale: isSelected ? 1.3 : 1.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.elasticOut,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isSelected ? Colors.purple : Colors.indigo,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3))],
            ),
            child: const Icon(
              Icons.account_balance_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }

  Marker _buildMarker(NewsPost item, bool isDark) {
    final String id = item.id;
    final LatLng loc = LatLng(item.latitude!, item.longitude!);
    final String cat = item.category;
    
    final bool isSelected = _selectedItem is NewsPost && (_selectedItem as NewsPost).id == id;

    return Marker(
      point: loc,
      width: 60,
      height: 60,
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedItem = item);
          _mapController.move(loc, 16.0);
        },
        child: AnimatedScale(
          scale: isSelected ? 1.3 : 1.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.elasticOut,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.accentColor : AppTheme.primaryColor,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3))],
            ),
            child: Icon(
              _getIconForCategory(cat),
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
      ),
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

    return GestureDetector(
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
