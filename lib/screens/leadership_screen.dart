import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ebzim_app/core/localization/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';import 'package:ebzim_app/core/services/member_service.dart';
import 'package:ebzim_app/core/providers/locale_provider.dart';
import 'package:ebzim_app/core/widgets/ebzim_background.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ebzim_app/core/common_widgets/ebzim_sliver_app_bar.dart';

class LeadershipScreen extends ConsumerWidget {
  const LeadershipScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final isRtl = ref.watch(localeProvider).languageCode == 'ar';
    final leadersAsync = ref.watch(leadershipProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: EbzimBackground(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            EbzimSliverAppBar(
              leading: IconButton(
                icon: Icon(isRtl ? Icons.arrow_forward : Icons.arrow_back, color: AppTheme.accentColor),
                onPressed: () => context.pop(),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 80.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loc.leadHeroBadge.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 2, color: AppTheme.accentColor)
                    ).animate().fadeIn().slideY(begin: 0.2),
                    const SizedBox(height: 12),
                    Text(
                      loc.leadHeroTitle,
                      style: GoogleFonts.tajawal(fontSize: 40, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)
                    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
                    const SizedBox(height: 12),
                    Text(
                      loc.leadHeroSub,
                      style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8))
                    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
                    const SizedBox(height: 48),

                    // Beautiful Glass Search Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.03),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.1)),
                          ),
                          child: TextField(
                            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                            decoration: InputDecoration(
                              hintText: loc.leadSearchHint,
                              hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5), fontSize: 14),
                              prefixIcon: const Icon(Icons.search, color: AppTheme.accentColor),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                      ),
                    ).animate().fadeIn(delay: 600.ms),
                  ],
                ),
              ),
            ),
            
            leadersAsync.when(
              data: (members) {
                final executive = members.firstWhere((m) => m.isExecutive, orElse: () => members.first);
                final board = members.where((m) => !m.isExecutive).toList();

                return SliverList(
                  delegate: SliverChildListDelegate([
                    // Executive Spotlight
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: _SpotlightMemberCard(member: executive),
                    ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.1),
                    const SizedBox(height: 48),
                    
                    // Board Divider
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        children: [
                          Text('أعضاء اللجان', style: GoogleFonts.tajawal(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                          const SizedBox(width: 16),
                          Expanded(child: Container(height: 1, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2))),
                        ],
                      ),
                    ).animate().fadeIn(delay: 1000.ms),
                    const SizedBox(height: 24),
                    
                    // Board Grid
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.55,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: board.length,
                        itemBuilder: (context, index) {
                          return _BoardMemberCard(member: board[index]).animate().fadeIn(delay: (1200 + index * 200).ms).scale();
                        },
                      ),
                    ),
                    
                    const SizedBox(height: 80),
                  ]),
                );
              },
              loading: () => const SliverFillRemaining(child: Center(child: CircularProgressIndicator(color: AppTheme.accentColor))),
              error: (e, s) => SliverFillRemaining(child: Center(child: Text(e.toString(), style: TextStyle(color: Theme.of(context).colorScheme.onSurface)))),
            ),
          ],
        ),
      ),
    );
  }
}

class _SpotlightMemberCard extends StatelessWidget {
  final Member member;
  const _SpotlightMemberCard({required this.member});

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    final name = member.getName(lang);
    final role = member.getRole(lang);
    final bio = member.getBio(lang);

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
              )
            ]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                child: Image.asset(member.imageUrl, height: 400, fit: BoxFit.cover),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: AppTheme.accentColor.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                      child: Text(member.category.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2, color: AppTheme.accentColor)),
                    ),
                    const SizedBox(height: 16),
                    Text(name, style: GoogleFonts.tajawal(fontSize: 32, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                    const SizedBox(height: 8),
                    Text(role, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.accentColor)),
                    const SizedBox(height: 16),
                    Text('"$bio"', style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8), height: 1.5)),
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

class _BoardMemberCard extends StatelessWidget {
  final Member member;
  const _BoardMemberCard({required this.member});

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    final name = member.getName(lang);
    final role = member.getRole(lang);
    final bio = member.getBio(lang);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.asset(member.imageUrl, fit: BoxFit.cover),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.tajawal(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                      const SizedBox(height: 4),
                      Text(role.toUpperCase(), maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: AppTheme.accentColor)),
                      const SizedBox(height: 8),
                      Text(bio, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
