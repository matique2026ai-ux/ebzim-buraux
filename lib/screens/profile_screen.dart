import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ebzim_app/core/localization/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/services/user_profile_service.dart';
import 'package:ebzim_app/core/services/membership_service.dart';
import 'package:ebzim_app/core/services/auth_service.dart';
import 'package:ebzim_app/core/widgets/ebzim_background.dart';
import 'package:ebzim_app/core/common_widgets/glass_card.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ebzim_app/core/common_widgets/ebzim_sliver_app_bar.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final userAsync = ref.watch(currentUserProvider);
    final statusAsync = ref.watch(membershipStatusProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final textColor = isDark ? Colors.white : theme.colorScheme.onSurface;
    final accentColor = AppTheme.accentColor;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      body: EbzimBackground(
        child: userAsync.when(
          data: (user) {
            final isRtl = Localizations.localeOf(context).languageCode == 'ar';
            final displayName = isRtl ? user.nameAr : user.name;
            final isPublic = user.membershipLevel == 'PUBLIC';

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                EbzimSliverAppBar(
                  actions: [
                    IconButton(
                      icon: Icon(Icons.settings_outlined, color: AppTheme.accentColor),
                      onPressed: () => context.push('/settings'),
                    ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 140, 24, 120),
                    child: Column(
                      children: [
                        // --- AVATAR & LEVEL ---
                        Center(
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.2), width: 4),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.accentColor.withValues(alpha: 0.08),
                                      blurRadius: 40,
                                      spreadRadius: 4,
                                    )
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundColor: textColor.withValues(alpha: 0.05),
                                  backgroundImage: user.imageUrl.startsWith('http') 
                                      ? NetworkImage(user.imageUrl) 
                                      : null,
                                  child: !user.imageUrl.startsWith('http')
                                      ? const Icon(Icons.person, color: AppTheme.accentColor, size: 40)
                                      : null,
                                ),
                              ),
                              Positioned(
                                bottom: -15,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: isPublic ? (isDark ? Colors.white : Colors.black.withValues(alpha: 0.05)) : accentColor,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.2),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      )
                                    ],
                                  ),
                                  child: Text(
                                    isPublic ? loc.dashMemberLevelPublic : loc.dashMemberLevelMember,
                                    style: TextStyle(
                                      color: isPublic ? (isDark ? AppTheme.primaryColor : const Color(0xFF003300)) : Colors.black,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn().scale(),

                        const SizedBox(height: 48),

                        // --- NAME & ID ---
                        Text(
                          displayName,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineLarge?.copyWith(fontSize: 32),
                        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),

                        const SizedBox(height: 8),

                        statusAsync.when(
                          data: (status) => Text(
                            '${isPublic ? loc.dashAccountStatus : loc.dashboardStatus}: ID-${user.id.substring(user.id.length - 6).toUpperCase()}',
                            style: GoogleFonts.cairo(
                              color: accentColor.withValues(alpha: 0.7),
                              fontSize: 12,
                              letterSpacing: 1.2,
                            ),
                          ),
                          loading: () => const SizedBox(height: 16),
                          error: (err, stack) => const SizedBox(height: 16),
                        ),

                        const SizedBox(height: 40),

                        // --- SECTION: ACCOUNT INFO ---
                        _SectionHeader(title: loc.profilePersonal),
                        const SizedBox(height: 12),
                        GlassCard(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              _ProfileTile(
                                icon: Icons.alternate_email,
                                label: loc.profileEmail,
                                value: user.email,
                              ),
                              Divider(color: isDark ? Colors.white10 : Colors.black12),
                              _ProfileTile(
                                icon: Icons.phone_android,
                                label: loc.profilePhone,
                                value: user.phone.isNotEmpty ? user.phone : '—',
                              ),
                              if (!isPublic) ...[
                                Divider(color: isDark ? Colors.white10 : Colors.black12),
                                _ProfileTile(
                                  icon: Icons.verified_user_outlined,
                                  label: loc.profileActiveSince,
                                  value: user.membershipExpiry != null 
                                      ? '${user.membershipExpiry!.year - 1}' 
                                      : '—',
                                ),
                              ],
                            ],
                          ),
                        ).animate().slideX(begin: 0.05, delay: 400.ms).fadeIn(),

                        const SizedBox(height: 32),

                        // --- SECTION: MEMBERSHIP ACCESS (CTA) ---
                        if (isPublic) ...[
                          _SectionHeader(title: loc.dashJoinTitle),
                          const SizedBox(height: 12),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => context.push('/membership/discover'),
                              borderRadius: BorderRadius.circular(20),
                              child: GlassCard(
                                padding: const EdgeInsets.all(20),
                                border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.3)),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: AppTheme.accentColor.withValues(alpha: 0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(Icons.workspace_premium, color: accentColor),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            loc.dashMembershipDiscover,
                                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: textColor),
                                          ),
                                          Text(
                                            loc.dashMembershipInvite,
                                            style: theme.textTheme.bodySmall?.copyWith(color: textColor.withValues(alpha: 0.6)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(Icons.chevron_right, color: accentColor),
                                  ],
                                ),
                              ),
                            ),
                          ).animate().slideX(begin: 0.05, delay: 500.ms).fadeIn(),
                          const SizedBox(height: 32),
                        ],

                        // --- SECTION: PREFERENCES & SECURITY ---
                        _SectionHeader(title: loc.settingsPrivacy),
                        const SizedBox(height: 12),
                        GlassCard(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            children: [
                              _ActionTile(
                                icon: Icons.language,
                                title: loc.profileLang,
                                textColor: textColor,
                                onTap: () => context.push('/settings'),
                              ),
                              _ActionTile(
                                icon: Icons.lock_outline,
                                title: loc.authResetPassword,
                                textColor: textColor,
                                onTap: () => context.push('/auth/forgot-password'),
                              ),
                              _ActionTile(
                                icon: Icons.help_outline,
                                title: loc.settingsHelp,
                                textColor: textColor,
                                onTap: () => context.push('/support'),
                              ),
                            ],
                          ),
                        ).animate().slideX(begin: 0.05, delay: 600.ms).fadeIn(),

                        const SizedBox(height: 48),

                        // --- LOGOUT ---
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              ref.read(authProvider.notifier).logout();
                              context.go('/splash');
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: GlassCard(
                              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                              border: Border.all(color: textColor.withValues(alpha: 0.05)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.logout_rounded, color: textColor.withValues(alpha: 0.4), size: 20),
                                  const SizedBox(width: 12),
                                  Text(
                                    loc.settingsLogout, 
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold, 
                                      color: textColor.withValues(alpha: 0.6),
                                      fontSize: 16,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ).animate().fadeIn(delay: 800.ms),
                        
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
          loading: () => const _ProfileSkeleton(),
          error: (e, s) => Center(child: Text(e.toString(), style: theme.textTheme.bodyMedium)),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Text(
            title.toUpperCase(),
            style: GoogleFonts.inter(
              color: isDark ? Colors.white.withValues(alpha: 0.4) : Colors.black26,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.5,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Divider(color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05), thickness: 1)),
        ],
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _ProfileTile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.accentColor.withValues(alpha: 0.6), size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    color: isDark ? Colors.white.withValues(alpha: 0.3) : Colors.black38,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: theme.textTheme.titleMedium?.copyWith(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? textColor;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon, 
    required this.title, 
    this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final color = textColor ?? theme.colorScheme.onSurface;
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: AppTheme.accentColor, size: 22),
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.w500, color: color),
      ),
      trailing: Icon(Icons.chevron_right, color: isDark ? Colors.white24 : Colors.black26, size: 20),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
    );
  }
}

class _ProfileSkeleton extends StatelessWidget {
  const _ProfileSkeleton();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 100, 24, 120),
      child: Column(
        children: [
          _Sk(h: 120, w: 120, r: 60, isDark: isDark),
          const SizedBox(height: 48),
          _Sk(h: 40, w: 200, isDark: isDark),
          const SizedBox(height: 12),
          _Sk(h: 16, w: 140, isDark: isDark),
          const SizedBox(height: 60),
          _Sk(h: 200, w: double.infinity, r: 24, isDark: isDark),
          const SizedBox(height: 24),
          _Sk(h: 150, w: double.infinity, r: 24, isDark: isDark),
        ],
      ),
    );
  }
}

class _Sk extends StatelessWidget {
  final double h, w, r;
  final bool isDark;
  const _Sk({required this.h, required this.w, this.r = 8, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: h,
      width: w,
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(r),
      ),
    ).animate(onPlay: (c) => c.repeat(reverse: true))
     .shimmer(duration: 1500.ms, color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.black.withValues(alpha: 0.02));
  }
}
