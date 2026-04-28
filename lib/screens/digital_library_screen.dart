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
import 'package:ebzim_app/core/common_widgets/glass_card.dart';
import 'package:ebzim_app/core/localization/l10n/app_localizations.dart';
import 'package:ebzim_app/core/models/publication.dart';
import 'package:ebzim_app/core/services/publication_service.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Digital Library Screen — Institutional Knowledge Base
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
    final theme = Theme.of(context);
    
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
          style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: EbzimBackground(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top + 56),
            
            // ── Search & Filter ─────────────────────────────────────────────
            _SearchAndFilterBar(
              onSearch: (v) => setState(() => _searchQuery = v),
              onCategoryToggle: (cat) => setState(() => _selectedCategory = (_selectedCategory == cat ? null : cat)),
              selectedCategory: _selectedCategory,
              isAr: isAr,
              isDark: isDark,
            ),
            
            // ── Grid ────────────────────────────────────────────────────────
            Expanded(
              child: publicationsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.accentColor)),
                error: (e, _) => Center(child: Text(isAr ? 'خطأ في تحميل المكتبة' : 'Error loading library')),
                data: (_) => filteredPublications.isEmpty
                  ? _NoResults(isAr: isAr)
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 100),
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.62,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: filteredPublications.length,
                      itemBuilder: (context, index) {
                        final pub = filteredPublications[index];
                        return _PublicationCard(
                          pub: pub,
                          isAr: isAr,
                          isDark: isDark,
                          onTap: () => _showDetails(context, pub, isAr, isDark),
                        ).animate().fadeIn(delay: Duration(milliseconds: 50 * index)).slideY(begin: 0.05);
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.1)),
            ),
            child: TextField(
              onChanged: onSearch,
              style: GoogleFonts.tajawal(fontSize: 14),
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.libSearchHint,
                hintStyle: GoogleFonts.tajawal(color: isDark ? Colors.white30 : Colors.black26),
                prefixIcon: const Icon(Icons.search, color: AppTheme.accentColor, size: 20),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: PublicationCategory.values.map((cat) {
              final isSelected = selectedCategory == cat;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: FilterChip(
                  label: Text(cat.getLabel(isAr ? 'ar' : 'en')),
                  selected: isSelected,
                  onSelected: (_) => onCategoryToggle(cat),
                  backgroundColor: isDark ? Colors.white10 : Colors.white54,
                  selectedColor: AppTheme.accentColor,
                  labelStyle: GoogleFonts.tajawal(
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                    color: isSelected ? Colors.white : (isDark ? Colors.white70 : AppTheme.primaryColor),
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  side: BorderSide(color: isSelected ? Colors.transparent : AppTheme.accentColor.withValues(alpha: 0.2)),
                  showCheckmark: false,
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class _PublicationCard extends StatelessWidget {
  final Publication pub;
  final bool isAr;
  final bool isDark;
  final VoidCallback onTap;

  const _PublicationCard({required this.pub, required this.isAr, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Expanded(
            child: GlassCard(
              padding: EdgeInsets.zero,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark 
                    ? AppTheme.accentColor.withValues(alpha: 0.15)
                    : AppTheme.accentColor.withValues(alpha: 0.1),
                width: 1.5,
              ),
              color: isDark 
                  ? Colors.white.withValues(alpha: 0.02)
                  : Colors.white.withValues(alpha: 0.65),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: pub.thumbnailUrl,
                      placeholder: (context, url) => Container(color: Colors.grey.withValues(alpha: 0.2)),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    Positioned(
                      top: 8,
                      right: isAr ? 8 : null,
                      left: isAr ? null : 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.accentColor.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          pub.category.getLabel(isAr ? 'ar' : 'en').toUpperCase(),
                          style: GoogleFonts.playfairDisplay(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            pub.getTitle(isAr ? 'ar' : 'en'),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: isAr ? TextAlign.end : TextAlign.start,
            style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 13, height: 1.2),
          ),
          const SizedBox(height: 2),
          Text(
            pub.getAuthor(isAr ? 'ar' : 'en'),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: isAr ? TextAlign.end : TextAlign.start,
            style: GoogleFonts.tajawal(fontSize: 10, color: isDark ? Colors.white54 : Colors.black45),
          ),
        ],
      ),
    );
  }
}

class _PublicationDetailsSheet extends StatelessWidget {
  final Publication pub;
  final bool isAr;
  final bool isDark;

  const _PublicationDetailsSheet({required this.pub, required this.isAr, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A2E26) : const Color(0xFFFAF9F6),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 40)],
      ),
      child: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(10))),
                    Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          _PublicationHero(pub: pub),
                          const SizedBox(height: 24),
                          Text(
                            pub.getTitle(isAr ? 'ar' : 'en'),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.tajawal(fontSize: 22, fontWeight: FontWeight.w900, height: 1.2),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            pub.getAuthor(isAr ? 'ar' : 'en'),
                            style: GoogleFonts.tajawal(fontSize: 15, color: AppTheme.accentColor, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            pub.getSummary(isAr ? 'ar' : 'en'),
                            textAlign: isAr ? TextAlign.end : TextAlign.start,
                            style: GoogleFonts.cairo(fontSize: 14, height: 1.6, color: isDark ? Colors.white70 : Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _ActionBottomBar(pub: pub, isAr: isAr, isDark: isDark),
          ),
        ],
      ),
    );
  }
}

class _PublicationHero extends StatelessWidget {
  final Publication pub;
  const _PublicationHero({required this.pub});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: CachedNetworkImage(imageUrl: pub.thumbnailUrl, fit: BoxFit.cover),
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
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
          decoration: BoxDecoration(
            color: (isDark ? Colors.black : Colors.white).withValues(alpha: 0.7),
            border: Border(top: BorderSide(color: AppTheme.accentColor.withValues(alpha: 0.2))),
          ),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => launchUrl(Uri.parse(pub.pdfUrl)),
                  icon: const Icon(Icons.picture_as_pdf_rounded),
                  label: Text(AppLocalizations.of(context)!.libOpenPdf),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 54),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.2)),
                ),
                child: const IconButton(
                  onPressed: null, // Share functionality could go here
                  icon: Icon(Icons.share_outlined, color: AppTheme.accentColor),
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
          Icon(Icons.search_off_rounded, size: 64, color: AppTheme.accentColor.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text(
            isAr ? 'لم يتم العثور على نتائج' : 'No results found',
            style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
