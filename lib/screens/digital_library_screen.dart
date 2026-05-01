import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/widgets/ebzim_background.dart';
import 'package:ebzim_app/core/localization/l10n/app_localizations.dart';
import 'package:ebzim_app/core/models/publication.dart';
import 'package:ebzim_app/core/services/publication_service.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Digital Library Screen — Premium Bookshelf UI
// ─────────────────────────────────────────────────────────────────────────────

class DigitalLibraryScreen extends ConsumerStatefulWidget {
  const DigitalLibraryScreen({super.key});

  @override
  ConsumerState<DigitalLibraryScreen> createState() => _DigitalLibraryScreenState();
}

class _DigitalLibraryScreenState extends ConsumerState<DigitalLibraryScreen> {
  String _searchQuery = '';
  PublicationCategory? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final publicationsAsync = ref.watch(allPublicationsProvider);
    final allPublications = publicationsAsync.value ?? [];
    
    final filteredPublications = allPublications.where((p) {
      final matchesSearch = p.getTitle(isAr ? 'ar' : 'en').toLowerCase().contains(_searchQuery.toLowerCase()) || 
                           p.getAuthor(isAr ? 'ar' : 'en').toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCat = _selectedCategory == null || p.category == _selectedCategory;
      return matchesSearch && matchesCat;
    }).toList();

    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          loc.libTitle,
          style: GoogleFonts.tajawal(fontWeight: FontWeight.w900, fontSize: 20, letterSpacing: 1),
        ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? Colors.black26 : Colors.white24,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: EbzimBackground(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top + kToolbarHeight + 10),
            
            // ── Hero Text ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Column(
                children: [
                  Text(
                    isAr ? 'معارف لا حدود لها' : 'Boundless Knowledge',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.accentColor,
                    ),
                  ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2),
                  const SizedBox(height: 8),
                  Text(
                    isAr 
                      ? 'تصفح أحدث البحوث والكتب والمقالات القيمة'
                      : 'Explore the latest research, books, and valuable articles',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ).animate().fadeIn(delay: 200.ms, duration: 800.ms),
                ],
              ),
            ),
            
            const SizedBox(height: 16),

            // ── Search & Filter ─────────────────────────────────────────────
            _SearchAndFilterBar(
              onSearch: (v) => setState(() => _searchQuery = v),
              onCategoryToggle: (cat) => setState(() => _selectedCategory = (_selectedCategory == cat ? null : cat)),
              selectedCategory: _selectedCategory,
              isAr: isAr,
              isDark: isDark,
            ),
            
            // ── Bookshelf Grid ────────────────────────────────────────────────────────
            Expanded(
              child: publicationsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.accentColor)),
                error: (e, _) => Center(child: Text(isAr ? 'خطأ في تحميل المكتبة' : 'Error loading library')),
                data: (_) => filteredPublications.isEmpty
                  ? _NoResults(isAr: isAr)
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.55, // Adjusted to fit book + title comfortably
                        crossAxisSpacing: 24,
                        mainAxisSpacing: 32,
                      ),
                      itemCount: filteredPublications.length,
                      itemBuilder: (context, index) {
                        final pub = filteredPublications[index];
                        return _BookCard(
                          pub: pub,
                          isAr: isAr,
                          isDark: isDark,
                          onTap: () => _showDetails(context, pub, isAr, isDark),
                        ).animate().fadeIn(delay: Duration(milliseconds: 50 * index)).slideY(begin: 0.1);
                      },
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetails(BuildContext context, Publication pub, bool isAr, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _PublicationDetailsSheet(pub: pub, isAr: isAr, isDark: isDark),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Components
// ─────────────────────────────────────────────────────────────────────────────

class _SearchAndFilterBar extends StatelessWidget {
  final Function(String) onSearch;
  final Function(PublicationCategory) onCategoryToggle;
  final PublicationCategory? selectedCategory;
  final bool isAr;
  final bool isDark;

  const _SearchAndFilterBar({
    required this.onSearch,
    required this.onCategoryToggle,
    required this.selectedCategory,
    required this.isAr,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Premium Search Field
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.15), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: TextField(
              onChanged: onSearch,
              style: GoogleFonts.tajawal(fontSize: 15, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.libSearchHint,
                hintStyle: GoogleFonts.tajawal(color: isDark ? Colors.white30 : Colors.black38),
                prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.accentColor, size: 22),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 18),
              ),
            ),
          ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.05),
        ),
        
        // Filter Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: PublicationCategory.values.map((cat) {
              final isSelected = selectedCategory == cat;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: ChoiceChip(
                  label: Text(cat.getLabel(isAr ? 'ar' : 'en')),
                  selected: isSelected,
                  onSelected: (_) => onCategoryToggle(cat),
                  backgroundColor: isDark ? const Color(0xFF151515) : const Color(0xFFF5F5F5),
                  selectedColor: AppTheme.accentColor,
                  labelStyle: GoogleFonts.tajawal(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: isSelected ? Colors.white : (isDark ? Colors.white70 : AppTheme.primaryColor),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(color: isSelected ? Colors.transparent : AppTheme.accentColor.withValues(alpha: 0.2)),
                  ),
                  showCheckmark: false,
                  elevation: isSelected ? 4 : 0,
                  shadowColor: AppTheme.accentColor.withValues(alpha: 0.5),
                ),
              ).animate().fadeIn(delay: Duration(milliseconds: 400 + (cat.index * 50))).slideY(begin: 0.1);
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _BookCard extends StatelessWidget {
  final Publication pub;
  final bool isAr;
  final bool isDark;
  final VoidCallback onTap;

  const _BookCard({required this.pub, required this.isAr, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // The Physical Book Cover
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.35),
                    blurRadius: 15,
                    offset: const Offset(8, 12),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: const Offset(2, 4),
                  ),
                ],
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Cover Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: CachedNetworkImage(
                      imageUrl: pub.thumbnailUrl,
                      placeholder: (context, url) => Container(color: isDark ? Colors.grey[900] : Colors.grey[200]),
                      errorWidget: (context, url, error) => Container(color: AppTheme.primaryColor, child: const Icon(Icons.book, color: Colors.white)),
                      fit: BoxFit.cover,
                    ),
                  ),
                  
                  // Glossy Overlay for 3D realism
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.white.withValues(alpha: 0.25),
                            Colors.white.withValues(alpha: 0.0),
                            Colors.black.withValues(alpha: 0.1),
                          ],
                          stops: const [0.0, 0.15, 1.0],
                        ),
                      ),
                    ),
                  ),
                  
                  // Book Spine Shadow
                  Positioned(
                    top: 0, bottom: 0, 
                    left: isAr ? null : 0, 
                    right: isAr ? 0 : null,
                    width: 14,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: isAr ? Alignment.centerRight : Alignment.centerLeft,
                          end: isAr ? Alignment.centerLeft : Alignment.centerRight,
                          colors: [
                            Colors.black.withValues(alpha: 0.4),
                            Colors.transparent,
                          ],
                        ),
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(isAr ? 0 : 6),
                          right: Radius.circular(isAr ? 6 : 0),
                        ),
                      ),
                    ),
                  ),
                  
                  // Category Badge (Elegant Tag)
                  Positioned(
                    top: 10,
                    right: isAr ? null : 10,
                    left: isAr ? 10 : null,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.5)),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            pub.category.getLabel(isAr ? 'ar' : 'en').toUpperCase(),
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 9, 
                              fontWeight: FontWeight.w900, 
                              color: AppTheme.accentColor,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Book Meta
          Text(
            pub.getTitle(isAr ? 'ar' : 'en'),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: GoogleFonts.tajawal(
              fontWeight: FontWeight.w900, 
              fontSize: 14, 
              height: 1.3,
              color: isDark ? Colors.white : AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            pub.getAuthor(isAr ? 'ar' : 'en'),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: GoogleFonts.tajawal(
              fontSize: 11, 
              color: isDark ? Colors.white60 : Colors.black54, 
              fontWeight: FontWeight.w600
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Beautiful Publication Details Sheet
// ─────────────────────────────────────────────────────────────────────────────

class _PublicationDetailsSheet extends StatelessWidget {
  final Publication pub;
  final bool isAr;
  final bool isDark;

  const _PublicationDetailsSheet({required this.pub, required this.isAr, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0A0F0C) : const Color(0xFFFDFCF8),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5), 
            blurRadius: 50,
            offset: const Offset(0, -10),
          )
        ],
      ),
      child: Stack(
        children: [
          // Background Aesthetic Pattern
          Positioned(
            top: -100, right: -100,
            child: Container(
              width: 300, height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [AppTheme.accentColor.withValues(alpha: 0.1), Colors.transparent]),
              ),
            ),
          ),
          
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    // Drag Handle
                    Container(
                      width: 48, height: 5, 
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.3), 
                        borderRadius: BorderRadius.circular(10)
                      )
                    ),
                    const SizedBox(height: 32),
                    
                    // Large 3D Hero
                    _PublicationHero(pub: pub, isAr: isAr).animate().scale(delay: 200.ms, duration: 600.ms, curve: Curves.easeOutBack),
                    
                    const SizedBox(height: 40),
                    
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        children: [
                          // Category Label
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.accentColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.3)),
                            ),
                            child: Text(
                              pub.category.getLabel(isAr ? 'ar' : 'en').toUpperCase(),
                              style: GoogleFonts.tajawal(color: AppTheme.accentColor, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ).animate().fadeIn(delay: 300.ms),
                          
                          const SizedBox(height: 16),
                          
                          // Title
                          Text(
                            pub.getTitle(isAr ? 'ar' : 'en'),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.tajawal(
                              fontSize: 26, 
                              fontWeight: FontWeight.w900, 
                              height: 1.3,
                              color: isDark ? Colors.white : AppTheme.primaryColor,
                            ),
                          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),
                          
                          const SizedBox(height: 12),
                          
                          // Author
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.edit_note_rounded, size: 18, color: AppTheme.accentColor.withValues(alpha: 0.8)),
                              const SizedBox(width: 8),
                              Text(
                                pub.getAuthor(isAr ? 'ar' : 'en'),
                                style: GoogleFonts.tajawal(
                                  fontSize: 16, 
                                  color: isDark ? Colors.white70 : Colors.black54, 
                                  fontWeight: FontWeight.w700
                                ),
                              ),
                            ],
                          ).animate().fadeIn(delay: 500.ms),
                          
                          const SizedBox(height: 36),
                          
                          // Summary / Description
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.black.withValues(alpha: 0.02),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
                            ),
                            child: Text(
                              pub.getSummary(isAr ? 'ar' : 'en'),
                              textAlign: isAr ? TextAlign.justify : TextAlign.start,
                              style: GoogleFonts.cairo(
                                fontSize: 15, 
                                height: 1.8, 
                                color: isDark ? Colors.white.withValues(alpha: 0.85) : Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.05),
                          
                        ],
                      ),
                    ),
                    const SizedBox(height: 120), // Padding for bottom bar
                  ],
                ),
              ),
            ],
          ),
          
          // Fixed Bottom Bar
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: _ActionBottomBar(pub: pub, isAr: isAr, isDark: isDark)
              .animate().fadeIn(delay: 800.ms).slideY(begin: 0.5),
          ),
        ],
      ),
    );
  }
}

class _PublicationHero extends StatelessWidget {
  final Publication pub;
  final bool isAr;
  const _PublicationHero({required this.pub, required this.isAr});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 270,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.4), blurRadius: 30, offset: const Offset(0, 20)),
          BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(imageUrl: pub.thumbnailUrl, fit: BoxFit.cover),
          ),
          // Deep glossy overlay for hero
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.white.withValues(alpha: 0.3),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.2),
                ],
                stops: const [0.0, 0.2, 1.0],
              ),
            ),
          ),
          // Strong spine
          Positioned(
            top: 0, bottom: 0, left: isAr ? null : 0, right: isAr ? 0 : null,
            width: 16,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: isAr ? Alignment.centerRight : Alignment.centerLeft,
                  end: isAr ? Alignment.centerLeft : Alignment.centerRight,
                  colors: [Colors.black.withValues(alpha: 0.5), Colors.transparent],
                ),
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(isAr ? 0 : 8),
                  right: Radius.circular(isAr ? 8 : 0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionBottomBar extends StatelessWidget {
  final Publication pub;
  final bool isAr;
  final bool isDark;

  const _ActionBottomBar({required this.pub, required this.isAr, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: EdgeInsets.fromLTRB(24, 20, 24, MediaQuery.of(context).padding.bottom + 20),
          decoration: BoxDecoration(
            color: (isDark ? const Color(0xFF050806) : Colors.white).withValues(alpha: 0.85),
            border: Border(top: BorderSide(color: AppTheme.accentColor.withValues(alpha: 0.15))),
          ),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => launchUrl(Uri.parse(pub.pdfUrl)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 58),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 10,
                    shadowColor: AppTheme.accentColor.withValues(alpha: 0.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.menu_book_rounded, size: 22),
                      const SizedBox(width: 12),
                      Text(
                        AppLocalizations.of(context)!.libOpenPdf,
                        style: GoogleFonts.tajawal(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Download or Share Button
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
                ),
                child: IconButton(
                  onPressed: () {}, // Implementation for download/share
                  icon: const Icon(Icons.bookmark_add_outlined),
                  color: isDark ? Colors.white : AppTheme.primaryColor,
                  iconSize: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NoResults extends StatelessWidget {
  final bool isAr;
  const _NoResults({required this.isAr});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.auto_stories_rounded, size: 80, color: AppTheme.accentColor.withValues(alpha: 0.2)),
          const SizedBox(height: 24),
          Text(
            isAr ? 'المكتبة فارغة حالياً' : 'The library is currently empty',
            style: GoogleFonts.tajawal(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            isAr ? 'لم يتم العثور على أي منشورات تطابق بحثك' : 'No publications matched your search',
            style: GoogleFonts.cairo(fontSize: 14, color: Colors.grey),
          ),
        ],
      ).animate().fadeIn().scale(delay: 200.ms),
    );
  }
}
