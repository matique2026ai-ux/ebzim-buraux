import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/widgets/ebzim_background.dart';
import 'package:ebzim_app/core/common_widgets/glass_card.dart';
import 'package:ebzim_app/core/models/statute_article.dart';
import 'package:ebzim_app/core/services/statute_service.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Statute Screen — Professional Founding Charter Viewer
// ─────────────────────────────────────────────────────────────────────────────

class StatuteScreen extends ConsumerStatefulWidget {
  const StatuteScreen({super.key});

  @override
  ConsumerState<StatuteScreen> createState() => _StatuteScreenState();
}

class _StatuteScreenState extends ConsumerState<StatuteScreen> with TickerProviderStateMixin {
  late TabController _subLocaleController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _subLocaleController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _subLocaleController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statutes = ref.watch(statuteServiceProvider).getStatutes();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Statute | القانون الأساسي',
          style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isDark ? Colors.black.withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.2)),
            ),
            child: TabBar(
              controller: _subLocaleController,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(
                color: AppTheme.accentColor,
                borderRadius: BorderRadius.circular(8),
              ),
              labelColor: isDark ? AppTheme.primaryColor : Colors.white,
              unselectedLabelColor: isDark ? Colors.white54 : AppTheme.primaryColor.withValues(alpha: 0.6),
              labelStyle: GoogleFonts.tajawal(fontWeight: FontWeight.w800, fontSize: 12),
              tabs: const [
                Tab(text: 'ARABIC'),
                Tab(text: 'ENGLISH'),
                Tab(text: 'FRANÇAIS'),
              ],
            ),
          ),
        ),
      ),
      body: EbzimBackground(
        child: TabBarView(
          controller: _subLocaleController,
          children: [
            _StatuteListView(statutes: statutes, localeIdx: 0, isDark: isDark),
            _StatuteListView(statutes: statutes, localeIdx: 1, isDark: isDark),
            _StatuteListView(statutes: statutes, localeIdx: 2, isDark: isDark),
          ],
        ),
      ),
    );
  }
}

class _StatuteListView extends StatelessWidget {
  final List<StatuteArticle> statutes;
  final int localeIdx;
  final bool isDark;

  const _StatuteListView({
    required this.statutes,
    required this.localeIdx,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top + 130;
    
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(24, topPadding, 24, 100),
      physics: const BouncingScrollPhysics(),
      itemCount: statutes.length,
      itemBuilder: (context, index) {
        final article = statutes[index];
        final isAr = localeIdx == 0;
        final title = [article.titleAr, article.titleEn, article.titleFr][localeIdx];
        final content = [article.contentAr, article.contentEn, article.contentFr][localeIdx];
        final label = [article.sectionLabelAr, article.sectionLabelEn, article.sectionLabelFr][localeIdx];

        return Column(
          crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (index == 0 || statutes[index-1].sectionLabelAr != article.sectionLabelAr) ...[
              const SizedBox(height: 32),
              _SectionHeader(label: label, isDark: isDark, isAr: isAr),
              const SizedBox(height: 16),
            ],
            _ArticleCard(
              articleNumber: article.number,
              title: title,
              content: content,
              isDark: isDark,
              isAr: isAr,
            ).animate().fadeIn(delay: Duration(milliseconds: 100 * index)).slideY(begin: 0.05),
            const SizedBox(height: 12),
          ],
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  final bool isDark;
  final bool isAr;
  const _SectionHeader({required this.label, required this.isDark, required this.isAr});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isAr ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isAr) Container(width: 24, height: 2, color: AppTheme.accentColor, margin: const EdgeInsets.only(right: 8)),
        Text(
          label.toUpperCase(),
          style: GoogleFonts.tajawal(
            color: AppTheme.accentColor,
            fontWeight: FontWeight.w900,
            fontSize: 10,
            letterSpacing: 2,
          ),
        ),
        if (isAr) Container(width: 24, height: 2, color: AppTheme.accentColor, margin: const EdgeInsets.only(left: 8)),
      ],
    );
  }
}

class _ArticleCard extends StatelessWidget {
  final int articleNumber;
  final String title;
  final String content;
  final bool isDark;
  final bool isAr;

  const _ArticleCard({
    required this.articleNumber,
    required this.title,
    required this.content,
    required this.isDark,
    required this.isAr,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      border: Border.all(
        color: isDark 
            ? AppTheme.accentColor.withValues(alpha: 0.15)
            : AppTheme.accentColor.withValues(alpha: 0.1),
        width: 1.5,
      ),
      color: isDark 
          ? Colors.white.withValues(alpha: 0.02)
          : Colors.white.withValues(alpha: 0.65),
      child: Column(
        crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isAr ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!isAr) _NumberBadge(number: articleNumber),
              if (!isAr) const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  textAlign: isAr ? TextAlign.end : TextAlign.start,
                  style: GoogleFonts.tajawal(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: isDark ? const Color(0xFFF0EDE6) : AppTheme.primaryColor,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              if (isAr) const SizedBox(width: 16),
              if (isAr) _NumberBadge(number: articleNumber),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            textAlign: isAr ? TextAlign.end : TextAlign.start,
            style: GoogleFonts.cairo(
              fontSize: 14,
              height: 1.8, // Enhanced reading height for institutional text
              color: isDark 
                  ? Colors.white.withValues(alpha: 0.85) 
                  : AppTheme.primaryColor.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}

class _NumberBadge extends StatelessWidget {
  final int number;
  const _NumberBadge({required this.number});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.accentColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.3)),
      ),
      child: Text(
        'ART. $number',
        style: GoogleFonts.inter(
          color: AppTheme.accentColor,
          fontWeight: FontWeight.w900,
          fontSize: 9,
        ),
      ),
    );
  }
}
