import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/providers/locale_provider.dart';

class HeritageMapScreen extends ConsumerStatefulWidget {
  const HeritageMapScreen({super.key});

  @override
  ConsumerState<HeritageMapScreen> createState() => _HeritageMapScreenState();
}

class _HeritageMapScreenState extends ConsumerState<HeritageMapScreen> {
  final MapController _mapController = MapController();
  
  // Static seeded historical landmarks in Sétif
  final List<_Landmark> _landmarks = [
    _Landmark(
      id: "ain_elfouara",
      nameAr: "عين الفوارة",
      nameFr: "Ain El Fouara",
      descAr: "المعلم التاريخي الأبرز في سطيف.",
      descFr: "Le monument historique le plus célèbre de Sétif.",
      location: const LatLng(36.1895, 5.4098),
      type: "MONUMENT",
      image: "https://placehold.co/400x300/081C10/D4AF37?text=Ain+El+Fouara"
    ),
    _Landmark(
      id: "museum_setif",
      nameAr: "المتحف الوطني للآثار",
      nameFr: "Musée National des Antiquités",
      descAr: "شريك جمعية إبزيم، يحتوي على أندر المقتنيات الرومانية.",
      descFr: "Partenaire d'Ebzim, contenant des objets romains rares.",
      location: const LatLng(36.1911, 5.4128),
      type: "MUSEUM",
      image: "https://placehold.co/400x300/081C10/D4AF37?text=National+Museum"
    ),
    _Landmark(
      id: "caserne",
      nameAr: "الثكنة التاريخية بالحامة",
      nameFr: "Caserne Historique - El Hamman",
      descAr: "مشروع ترميم وصون لمعالم الذاكرة الوطنية.",
      descFr: "Projet de restauration mémorielle.",
      location: const LatLng(36.1965, 5.4102),
      type: "PROJECT",
      image: "https://placehold.co/400x300/081C10/D4AF37?text=Caserne+Historique"
    ),
  ];

  _Landmark? _selectedLandmark;

  @override
  Widget build(BuildContext context) {
    final isAr = ref.watch(localeProvider).languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Use CartoDB voyager for light mode, dark_all for dark mode
    final tileUrl = isDark
        ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
        : 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png';

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
            isAr ? 'خريطة المعالم التراثية' : 'Carte du Patrimoine',
            style: GoogleFonts.tajawal(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(36.1915, 5.4110), // Setif Center
              initialZoom: 14.5,
              onTap: (tapPosition, point) {
                setState(() => _selectedLandmark = null);
              },
            ),
            children: [
              TileLayer(
                urlTemplate: tileUrl,
                userAgentPackageName: 'com.ebzim.app',
              ),
              MarkerLayer(
                markers: _landmarks.map((l) => Marker(
                  point: l.location,
                  width: 60,
                  height: 60,
                  child: GestureDetector(
                    onTap: () {
                      setState(() => _selectedLandmark = l);
                      _mapController.move(l.location, 16.0);
                    },
                    child: AnimatedScale(
                      scale: _selectedLandmark?.id == l.id ? 1.3 : 1.0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.elasticOut,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: _selectedLandmark?.id == l.id ? AppTheme.accentColor : AppTheme.primaryColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0,3))],
                            ),
                            child: Icon(
                              l.type == 'MUSEUM' ? Icons.account_balance : l.type == 'PROJECT' ? Icons.handyman : Icons.account_balance_outlined,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )).toList(),
              ),
            ],
          ),

          // Bottom Sheet / Card overlay
          AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutCubic,
            bottom: _selectedLandmark != null ? 30 : -250,
            left: 20,
            right: 20,
            child: _selectedLandmark == null
                ? const SizedBox.shrink()
                : _buildLandmarkCard(_selectedLandmark!, isAr, isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildLandmarkCard(_Landmark l, bool isAr, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2124) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 30,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 120,
              child: Image.network(
                l.image,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.accentColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          l.type,
                          style: const TextStyle(color: AppTheme.accentColor, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isAr ? l.nameAr : l.nameFr,
                    style: GoogleFonts.cairo(
                      color: isDark ? Colors.white : Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isAr ? l.descAr : l.descFr,
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            )
          ],
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
  final String type;
  final String image;

  const _Landmark({
    required this.id,
    required this.nameAr,
    required this.nameFr,
    required this.descAr,
    required this.descFr,
    required this.location,
    required this.type,
    required this.image,
  });
}
