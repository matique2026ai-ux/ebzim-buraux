import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/common_widgets/ebzim_sliver_app_bar.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: CustomScrollView(
        slivers: [
          // AppBar
          EbzimSliverAppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppTheme.primaryColor),
              onPressed: () => context.pop(),
            ),
          ),

          // Hero Section
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(24),
              height: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [AppTheme.primaryColor, Color(0xFF004B3E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  // Pattern Overlay (simulated via slight opacity shapes)
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 200, height: 200,
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.02), shape: BoxShape.circle),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(color: AppTheme.accentColor, borderRadius: BorderRadius.circular(20)),
                          child: Text(loc.culturalCurator, style: const TextStyle(color: AppTheme.textDark, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2)),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          loc.aboutHeroTitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: Theme.of(context).textTheme.headlineMedium?.fontFamily,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          loc.aboutHeroSubtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 16, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Our Story
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(width: 32, height: 1, color: AppTheme.secondaryColor),
                      const SizedBox(width: 16),
                      Text(loc.aboutStoryBadge.toUpperCase(), style: const TextStyle(color: AppTheme.secondaryColor, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 2)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    loc.aboutStoryTitle,
                    style: TextStyle(fontFamily: Theme.of(context).textTheme.headlineMedium?.fontFamily, fontSize: 36, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    loc.aboutStoryText1,
                    style: TextStyle(fontSize: 18, height: 1.6, color: AppTheme.textDark.withValues(alpha: 0.8)),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.only(left: 24), // Ideally should branch RTL/LTR border direction
                    decoration: BoxDecoration(border: Border(left: BorderSide(color: AppTheme.secondaryColor, width: 4))),
                    child: Text(
                      loc.aboutStoryQuote,
                      style: TextStyle(fontFamily: Theme.of(context).textTheme.headlineMedium?.fontFamily, fontSize: 22, fontStyle: FontStyle.italic, color: AppTheme.primaryColor.withValues(alpha: 0.8)),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Values grid (Mission / Vision / Values)
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 32),
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
              child: Column(
                children: [
                  _buildValueCard(
                    context, 
                    icon: Icons.explore, 
                    title: loc.aboutMission, 
                    desc: loc.aboutMissionText, 
                    isPrimary: false
                  ),
                  const SizedBox(height: 24),
                  _buildValueCard(
                    context, 
                    icon: Icons.visibility, 
                    title: loc.aboutVision, 
                    desc: loc.aboutVisionText, 
                    isPrimary: true
                  ),
                  const SizedBox(height: 24),
                  _buildValuesListCard(
                    context, 
                    title: loc.aboutValues, 
                    values: [loc.aboutValue1, loc.aboutValue2, loc.aboutValue3, loc.aboutValue4]
                  ),
                ],
              ),
            ),
          ),

          // Headquarters Section
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: AppTheme.secondaryColor, size: 16),
                            const SizedBox(width: 8),
                            Text(loc.aboutHqBadge.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 2, color: AppTheme.secondaryColor)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(loc.aboutHqTitle, style: TextStyle(fontFamily: Theme.of(context).textTheme.headlineMedium?.fontFamily, fontSize: 32, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                        const SizedBox(height: 16),
                        Text(loc.aboutHqText, style: TextStyle(fontSize: 16, height: 1.5, color: AppTheme.textDark.withValues(alpha: 0.8))),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32)),
                          child: Text(loc.aboutHqAction1.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2)),
                        ),
                      ],
                    ),
                  ),
                  // Image
                  Container(
                    height: 250,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
                      image: DecorationImage(image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuBTvgHEYhItjGo49a_nxC4gXGxPXGg3UPEP8RUxfxqNKpgJ-sUVT4GJAT0AJz5CUk0NLS_BROGTN9nsvMR62FIN5b6pDJh1tgwuCwgtlrWJyMqOydCj7rmMgYlrtN-KXo_4Jy8nUMRxvtIYqUedUpBBijhO_JP7jdwdDy9ChMhSyIwURAF95-syoc1uWCzZ4Bh5wSSxbOoI4awrSe1-8eqwRWFcvJtvzMh1CZnnwi28EyQxRZtBtpoRQiISgFZwWwWJ5eeFE2g8Sxyi'), fit: BoxFit.cover),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Final Quote
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 64.0),
              child: Column(
                children: [
                  Text("“", style: TextStyle(fontFamily: Theme.of(context).textTheme.headlineMedium?.fontFamily, fontSize: 80, color: AppTheme.accentColor.withValues(alpha: 0.3), height: 0.5)),
                  Text(
                    loc.aboutQuote,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: Theme.of(context).textTheme.headlineMedium?.fontFamily, fontSize: 24, fontStyle: FontStyle.italic, color: AppTheme.primaryColor, height: 1.4),
                  ),
                  const SizedBox(height: 32),
                  Container(width: 40, height: 1, color: AppTheme.secondaryColor.withValues(alpha: 0.5)),
                  const SizedBox(height: 16),
                  Text(loc.aboutQuoteAuthor.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2, color: AppTheme.textDark.withValues(alpha: 0.5))),
                ],
              ),
            ),
          ),
          
          const SliverToBoxAdapter(child: SizedBox(height: 80)), // Padding for bottom nav eventually
        ],
      ),
    );
  }

  Widget _buildValueCard(BuildContext context, {required IconData icon, required String title, required String desc, required bool isPrimary}) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isPrimary ? AppTheme.primaryColor : AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [if (isPrimary) BoxShadow(color: AppTheme.primaryColor.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: isPrimary ? Colors.white.withValues(alpha: 0.1) : AppTheme.primaryColor.withValues(alpha: 0.05),
            radius: 32,
            child: Icon(icon, size: 32, color: isPrimary ? AppTheme.accentColor : AppTheme.primaryColor),
          ),
          const SizedBox(height: 24),
          Text(title, style: TextStyle(fontFamily: Theme.of(context).textTheme.headlineMedium?.fontFamily, fontSize: 28, fontWeight: FontWeight.bold, color: isPrimary ? Colors.white : AppTheme.primaryColor)),
          const SizedBox(height: 16),
          Text(desc, style: TextStyle(fontSize: 16, color: isPrimary ? Colors.white.withValues(alpha: 0.8) : AppTheme.textDark.withValues(alpha: 0.7))),
        ],
      ),
    );
  }

  Widget _buildValuesListCard(BuildContext context, {required String title, required List<String> values}) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.05),
            radius: 32,
            child: const Icon(Icons.verified, size: 32, color: AppTheme.primaryColor),
          ),
          const SizedBox(height: 24),
          Text(title, style: TextStyle(fontFamily: Theme.of(context).textTheme.headlineMedium?.fontFamily, fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
          const SizedBox(height: 16),
          ...values.map((v) => Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              children: [
                const CircleAvatar(radius: 4, backgroundColor: AppTheme.secondaryColor),
                const SizedBox(width: 16),
                Text(v.toUpperCase(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2, color: AppTheme.textDark.withValues(alpha: 0.7))),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
