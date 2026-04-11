import 'package:flutter/material.dart';
import 'package:ebzim_app/core/localization/l10n/app_localizations.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/widgets/ebzim_background.dart';
import 'package:ebzim_app/core/common_widgets/glass_card.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class MembershipDiscoverScreen extends StatelessWidget {
  const MembershipDiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppTheme.accentColor,
        title: Text(
          loc.dashMembershipDiscover.toUpperCase(),
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2),
        ),
        centerTitle: true,
      ),
      body: EbzimBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 100.0),
          child: Column(
            children: [
              // Header Icon and Title
              const Icon(Icons.workspace_premium, color: AppTheme.accentColor, size: 64)
                  .animate().fadeIn().scale(delay: 200.ms),
              const SizedBox(height: 24),
              Text(
                loc.dashMembershipInvite,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Aref Ruqaa',
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
              const SizedBox(height: 16),
              Text(
                loc.dashMembershipLearnMore,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 16,
                  height: 1.5,
                ),
              ).animate().fadeIn(delay: 600.ms),
              const SizedBox(height: 48),

              // Benefits / Pillars Grid (Simulated)
              _BenefitCard(
                icon: Icons.history_edu,
                title: loc.dashPillar2,
                desc: loc.onb3Desc,
              ).animate().fadeIn(delay: 800.ms).slideX(begin: 0.1),
              const SizedBox(height: 16),
              _BenefitCard(
                icon: Icons.palette_outlined,
                title: loc.dashPillar1,
                desc: loc.onb2Desc,
              ).animate().fadeIn(delay: 1000.ms).slideX(begin: 0.1),
              const SizedBox(height: 16),
              _BenefitCard(
                icon: Icons.diversity_3_outlined,
                title: loc.dashPillar3,
                desc: loc.onb1Desc,
              ).animate().fadeIn(delay: 1200.ms).slideX(begin: 0.1),

              const SizedBox(height: 64),

              // Strong CTA
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () => context.push('/membership/apply'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentColor,
                    foregroundColor: AppTheme.primaryColor,
                    elevation: 10,
                    shadowColor: AppTheme.accentColor.withValues(alpha: 0.3),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    loc.dashJoinAction,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ).animate().fadeIn(delay: 1400.ms).shimmer(duration: 2.seconds),
              
              const SizedBox(height: 32),
              
              // Secondary Note
              Text(
                loc.dashAccountNote,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.4),
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BenefitCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;
  const _BenefitCard({required this.icon, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.accentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppTheme.accentColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.6),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
