import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
  
  // Static seeded historical landmarks in Sétif
  final List<_Landmark> _staticLandmarks = [
    _Landmark(
      id: "ain_elfouara",
      nameAr: "عين الفوارة",
      nameFr: "Ain El Fouara",
      descAr: "المعلم التاريخي الأبرز في سطيف.",
      descFr: "Le monument historique le plus célèbre de Sétif.",
      location: const LatLng(36.1895, 5.4098),
      category: "HERITAGE",
      image: "https://res.cloudinary.com/do3ygqlnl/image/upload/v1777077119/ebzim/static/ain_fouara.jpg"
    ),
    _Landmark(
      id: "museum_setif",
      nameAr: "المتحف الوطني للآثار",
      nameFr: "Musée National",
      descAr: "شريك جمعية إبزيم، يحتوي على أندر المقتنيات الرومانية.",
      descFr: "Partenaire d'Ebzim, contenant des objets romains rares.",
      location: const LatLng(36.1911, 5.4128),
      category: "HERITAGE",
      image: "https://res.cloudinary.com/do3ygqlnl/image/upload/v1777077119/ebzim/static/museum.jpg"
    ),
  ];

  dynamic _selectedItem;

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
          
          // Add static landmarks if filtered
          if (_selectedFilter == 'ALL' || _selectedFilter == 'HERITAGE') {
            for (var l in _staticLandmarks) {
              markers.add(_buildMarker(l, isDark));
            }
          }
          
          // Add dynamic projects
          for (var p in projects) {
            if (_selectedFilter == 'ALL' || _selectedFilter == p.category) {
              markers.add(_buildMarker(p, isDark));
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

  Marker _buildMarker(dynamic item, bool isDark) {
    final String id = item is _Landmark ? item.id : (item as NewsPost).id;
    final LatLng loc = item is _Landmark ? item.location : LatLng(item.latitude!, item.longitude!);
    final String cat = item is _Landmark ? item.category : (item as NewsPost).category;
    
    final bool isSelected = (_selectedItem is _Landmark && (_selectedItem as _Landmark).id == id) ||
                           (_selectedItem is NewsPost && (_selectedItem as NewsPost).id == id);

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
      {'id': 'HERITAGE', 'label': isAr ? 'التراث' : 'Patrimoine'},
      {'id': 'ASSOCIATIVE', 'label': isAr ? 'نشاط جمعوي' : 'Associatif'},
      {'id': 'CULTURAL', 'label': isAr ? 'ثقافي' : 'Culturel'},
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

  Widget _buildDetailCard(dynamic item, bool isAr, bool isDark) {
    final String title = item is _Landmark ? (isAr ? item.nameAr : item.nameFr) : (item as NewsPost).getTitle(isAr ? 'ar' : 'fr');
    final String desc = item is _Landmark ? (isAr ? item.descAr : item.descFr) : (item as NewsPost).getSummary(isAr ? 'ar' : 'fr');
    final String img = item is _Landmark ? item.image : (item as NewsPost).imageUrl;
    final String cat = item is _Landmark ? item.category : (item as NewsPost).category;

    return GestureDetector(
      onTap: item is NewsPost ? () => context.push('/news/${item.id}', extra: item) : null,
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

class _Landmark {
  final String id;
  final String nameAr;
  final String nameFr;
  final String descAr;
  final String descFr;
  final LatLng location;
  final String category;
  final String image;

  const _Landmark({
    required this.id,
    required this.nameAr,
    required this.nameFr,
    required this.descAr,
    required this.descFr,
    required this.location,
    required this.category,
    required this.image,
  });
}
