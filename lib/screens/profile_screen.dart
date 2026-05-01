import 'package:ebzim_app/core/common_widgets/login_required_overlay.dart';
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
    
    // Safety check for user profile data
    final UserProfile? userProfile = userAsync.value;
    final isAdmin = userProfile?.role == EbzimRole.admin || userProfile?.role == EbzimRole.superAdmin;

    final textColor = isDark ? Colors.white : theme.colorScheme.onSurface;
    final accentColor = AppTheme.accentColor;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      body: EbzimBackground(
        child: userAsync.when(
          data: (user) {
            if (user == null) {
              return const LoginRequiredOverlay(
                icon: Icons.account_circle_outlined,
              );
            }
            final lang = Localizations.localeOf(context).languageCode;
            final isRtl = lang == 'ar';
            final displayName = user.getName(lang);
            final isPublic = user.role == EbzimRole.public;

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                EbzimSliverAppBar(
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.edit_note_rounded, color: AppTheme.accentColor),
                      onPressed: () => context.push('/profile/edit'),
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                      onPressed: () {
                        ref.read(authProvider.notifier).logout();
                        context.go('/splash');
                      },
                    ),
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
                                  backgroundImage: (user.imageUrl?.startsWith('http') ?? false)
                                      ? NetworkImage(user.imageUrl!) 
                                      : null,
                                  child: !(user.imageUrl?.startsWith('http') ?? false)
                                      ? const Icon(Icons.person, color: AppTheme.accentColor, size: 40)
                                      : null,
                                ),
                              ),
                              Positioned(
                                bottom: -15,
                                child: _RoleBadge(role: user.role),
                              ),
                              // --- HONORARY MEDAL (CUSTOM BADGES) ---
                              if (user.membershipBadge != null && user.membershipBadge != 'NONE')
                                Positioned(
                                  top: -10,
                                  right: -10,
                                  child: _HonoraryMedal(badge: user.membershipBadge!),
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
                                  data: (statusStr) {
                                    return Column(
                                      children: [
                                        Text(
                                          '${user.role.getLabel(Localizations.localeOf(context).languageCode)} • $statusStr',
                                          style: GoogleFonts.cairo(
                                            color: AppTheme.accentColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'رقم العضوية: ${user.id.substring(user.id.length.clamp(0, 6)).toUpperCase()}',
                                          style: GoogleFonts.playfairDisplay(
                                            color: textColor.withValues(alpha: 0.4),
                                            fontSize: 10,
                                            letterSpacing: 1.0,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
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
                                value: (user.phone?.isNotEmpty ?? false) ? user.phone! : '—',
                              ),
                              if (!isPublic) ...[
                                Divider(color: isDark ? Colors.white10 : Colors.black12),
                                _ProfileTile(
                                  icon: Icons.verified_user_outlined,
                                  label: isRtl ? 'صلاحية العضوية لغاية' : 'Membership Valid Until',
                                  value: user.getFormattedExpiry(lang),
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
                                  const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 20),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'تسجيل الخروج من الحساب', 
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold, 
                                      color: Colors.redAccent,
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
            style: GoogleFonts.playfairDisplay(
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

class _RoleBadge extends StatelessWidget {
  final EbzimRole role;
  const _RoleBadge({required this.role});

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    final bgColor = role.getBadgeColor();
    final textColor = role == EbzimRole.superAdmin || role == EbzimRole.admin || role == EbzimRole.authority ? Colors.white : Colors.black87;
    final label = role.getLabel(lang);
    
    IconData? icon;
    switch (role) {
      case EbzimRole.superAdmin: icon = Icons.stars_rounded; break;
      case EbzimRole.admin: icon = Icons.admin_panel_settings_rounded; break;
      case EbzimRole.authority: icon = Icons.account_balance_rounded; break;
      case EbzimRole.member: icon = Icons.verified_rounded; break;
      case EbzimRole.seller: icon = Icons.storefront_rounded; break;
      case EbzimRole.public: icon = Icons.person_outline_rounded; break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: bgColor.withValues(alpha: 0.4), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: textColor),
            const SizedBox(width: 6),
          ],
          Text(
            label.toUpperCase(),
            style: GoogleFonts.tajawal(
              color: textColor,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _HonoraryMedal extends StatelessWidget {
  final String badge;
  const _HonoraryMedal({required this.badge});

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;
    String label;

    switch (badge.toUpperCase()) {
      case 'BRONZE':
        color = const Color(0xFFCD7F32);
        icon = Icons.workspace_premium_rounded;
        label = 'برونزي';
        break;
      case 'SILVER':
        color = const Color(0xFFC0C0C0); // Silver
        icon = Icons.emoji_events_rounded;
        label = 'فضي';
        break;
      case 'GOLD':
        color = const Color(0xFFFFD700);
        icon = Icons.stars_rounded;
        label = 'ذهبي';
        break;
      case 'DIAMOND':
        color = const Color(0xFF00E5FF);
        icon = Icons.diamond_rounded;
        label = 'ماسي';
        break;
      case 'NORMAL':
        color = const Color(0xFFA8A29E);
        icon = Icons.shield_rounded;
        label = 'عادي';
        break;
      case 'PRESIDENT':
        color = const Color(0xFFD4AF37); // Gold
        icon = Icons.gavel_rounded;
        label = 'الرئيس';
        break;
      case 'SECRETARY':
        color = const Color(0xFF052011); // Emerald
        icon = Icons.history_edu_rounded;
        label = 'الكاتب العام';
        break;
      case 'TREASURER':
        color = const Color(0xFF15803D); // Green
        icon = Icons.account_balance_wallet_rounded;
        label = 'أمين المال';
        break;
      case 'VICE_PRESIDENT':
        color = const Color(0xFF0EA5E9); // Blue
        icon = Icons.groups_rounded;
        label = 'نائب الرئيس';
        break;
      default: return const SizedBox();
    }

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 12, spreadRadius: 2),
        ],
        border: Border.all(color: color, width: 2),
      ),
      child: Center(
        child: Icon(icon, color: color, size: 28),
      ),
    );
  }
}
