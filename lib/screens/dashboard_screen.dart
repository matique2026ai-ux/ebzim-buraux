import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ebzim_app/core/localization/l10n/app_localizations.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/services/user_profile_service.dart';
import 'package:ebzim_app/core/common_widgets/ebzim_app_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:ebzim_app/core/services/auth_service.dart';
import 'package:ebzim_app/core/widgets/ebzim_background.dart';
import 'package:ebzim_app/widgets/digital_id_card.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ebzim_app/core/services/membership_service.dart';
import 'package:ebzim_app/widgets/stats_strip.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Design tokens for the dashboard surface layer
// ─────────────────────────────────────────────────────────────────────────────
const Color _kGold = AppTheme.accentColor;

Color _cardBg(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? const Color(0x0CFFFFFF) : Colors.white.withValues(alpha: 0.4);
Color _cardBorder(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? const Color(0x22FFFFFF) : Colors.black.withValues(alpha: 0.05);
Color _cardBgStrong(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? const Color(0x12FFFFFF) : Colors.white.withValues(alpha: 0.7);
Color _textPrimary(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xFF1A1C1A);
Color _textSecondary(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? const Color(0xCCFFFFFF) : Colors.black87;
Color _textMuted(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? const Color(0x73FFFFFF) : Colors.black54;

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  String _getLocalizedLevel(UserProfile user, String lang) {
    return user.role.getLabel(lang);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);
    final userAsync = ref.watch(currentUserProvider);
    final membershipStatusAsync = ref.watch(membershipStatusProvider);
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    if (authState.isInitializing) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        extendBodyBehindAppBar: true,
        appBar: const EbzimAppBar(backgroundColor: Colors.transparent, color: _kGold),
        body: EbzimBackground(child: _DashboardSkeleton()),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: EbzimAppBar(
        backgroundColor: Colors.transparent,
        color: _kGold,
        leading: null,
        actions: [
          userAsync.when(
            data: (user) {
              if (user == null) {
                return Padding(
                  padding: const EdgeInsetsDirectional.only(end: 16.0),
                  child: TextButton.icon(
                    onPressed: () => context.push('/login'),
                    icon: const Icon(Icons.login_rounded, color: _kGold, size: 20),
                    label: Text(loc.authAccessButton, style: const TextStyle(color: _kGold, fontWeight: FontWeight.bold)),
                  ),
                );
              }
              final isAdmin = user.role == EbzimRole.admin || user.role == EbzimRole.superAdmin;
              return Row(
                children: [
                  if (isAdmin)
                    Padding(
                      padding: const EdgeInsetsDirectional.only(end: 8.0),
                      child: IconButton(
                        icon: const Icon(Icons.admin_panel_settings_rounded, color: _kGold, size: 24),
                        tooltip: 'لوحة الإدارة',
                        onPressed: () => context.go('/admin'),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 16.0),
                    child: GestureDetector(
                      onTap: () => context.push('/profile/edit'),
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.14),
                        backgroundImage: (user.imageUrl?.isNotEmpty ?? false) && user.imageUrl!.startsWith('http')
                            ? NetworkImage(user.imageUrl!)
                            : null,
                        radius: 19,
                        child: (user.imageUrl?.isEmpty ?? true) || !user.imageUrl!.startsWith('http')
                            ? const Icon(Icons.person_outline_rounded, color: _kGold, size: 20)
                            : null,
                      ),
                    ),
                  ),
                ],
              );
            },
            loading: () => const SizedBox(width: 38),
            error: (e, _) => const SizedBox(width: 38),
          ),
        ],
      ),
      body: EbzimBackground(
        child: userAsync.when(
          data: (user) {
            // Provide a fallback Guest profile if unauthenticated
            final displayUser = user ?? UserProfile(
              id: 'guest',
              firstName: 'Guest',
              lastName: 'User',
              firstNameAr: 'زائر',
              lastNameAr: '',
              email: '',
              phone: '',
              imageUrl: '',
              role: EbzimRole.public,
              status: 'ACTIVE',
            );

            final langCode = Localizations.localeOf(context).languageCode;
            final fullName = displayUser.getName(langCode);
            final firstName = fullName.isNotEmpty ? fullName.split(' ').first : '';
            final isPublic = displayUser.role == EbzimRole.public;
            final isMember = displayUser.role != EbzimRole.public;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(top: 88, bottom: 128),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ── HERO ───────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _HeroSection(
                      user: displayUser,
                      firstName: firstName,
                      fullName: fullName,
                      levelLabel: _getLocalizedLevel(displayUser, langCode),
                      loc: loc,
                      isRtl: isRtl,
                      isPublic: isPublic,
                    ),
                  ),
                  const SizedBox(height: 28),
                  
                  // --- LIVE PLATFORM STATS ---
                  const StatsStrip(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    showDivider: true,
                  ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.05),

                  const SizedBox(height: 28),

                  // ── PROFILE COMPLETION (Professional touch) ───────────────
                  if (user != null) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _ProfileCompletionCard(
                        percentage: (displayUser.profileCompletionPercentage * 100).toInt(),
                        loc: loc,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // ── ACCOUNT ACTIONS GRID ──────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _AccountActionsGrid(loc: loc),
                  ),
                  const SizedBox(height: 32),

                  // ── DIGITAL ID CARD (members only) ──────────────────────────
                  if (isMember) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: DigitalIdCard(user: displayUser).animate().fadeIn().slideY(begin: 0.04),
                    ),
                    const SizedBox(height: 32),
                  ],

                  // ── MEMBERSHIP ENTRY (secondary, bottom) ────────────────────
                  if (isPublic && user != null) ...[
                    const SizedBox(height: 48),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: membershipStatusAsync.when(
                        data: (status) {
                          if (status == 'PENDING' || status == 'SUBMITTED') {
                            return _MembershipPendingTile(loc: loc);
                          } else if (status == 'REJECTED') {
                            return _MembershipRejectedTile(loc: loc);
                          } else {
                            return _MembershipEntryTile(loc: loc);
                          }
                        },
                        loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.accentColor)),
                        error: (_, __) => _MembershipEntryTile(loc: loc),
                      ),
                    ),
                  ] else if (isPublic && user == null) ...[
                    const SizedBox(height: 48),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _MembershipEntryTile(loc: loc),
                    ),
                  ],

                  const SizedBox(height: 24),
                ],
              ),
            );
          },
          loading: () => _DashboardSkeleton(),
          error: (e, _) => Center(
            child: Text(loc.dashErrorData,
                style: const TextStyle(color: Colors.redAccent)),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HERO SECTION
// ─────────────────────────────────────────────────────────────────────────────
class _HeroSection extends StatelessWidget {
  final UserProfile user;
  final String firstName;
  final String levelLabel;
  final AppLocalizations loc;
  final bool isRtl;
  final bool isPublic;

  final String fullName;

  const _HeroSection({
    required this.user,
    required this.firstName,
    required this.fullName,
    required this.levelLabel,
    required this.loc,
    required this.isRtl,
    required this.isPublic,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : theme.colorScheme.onSurface;

    return Column(
      children: [
        // --- CENTERED AVATAR ---
        GestureDetector(
          onTap: () => context.push('/profile/edit'),
          child: Center(
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: _kGold.withValues(alpha: 0.2), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: _kGold.withValues(alpha: 0.08),
                      blurRadius: 30,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: CircleAvatar(
                  radius: 54,
                  backgroundColor: textColor.withValues(alpha: 0.05),
                  backgroundImage: (user.imageUrl?.isNotEmpty ?? false) && user.imageUrl!.startsWith('http')
                      ? NetworkImage(user.imageUrl!)
                      : null,
                  child: (user.imageUrl?.isEmpty ?? true) || !user.imageUrl!.startsWith('http')
                      ? const Icon(Icons.person_rounded, color: _kGold, size: 48)
                      : null,
                ),
              ),
              // Hint for editing
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: _kGold,
                  shape: BoxShape.circle,
                  border: Border.all(color: theme.scaffoldBackgroundColor, width: 3),
                ),
                child: Icon(Icons.camera_alt_rounded, size: 14, color: isDark ? Colors.black : Colors.white),
              ).animate().scale(delay: 400.ms),
            ],
          ),
        ).animate().fadeIn().scale(duration: 400.ms),
      ),

        const SizedBox(height: 24),

        // --- NAME ---
        Text(
          fullName,
          textAlign: TextAlign.center,
          style: GoogleFonts.tajawal(
            color: _textPrimary(context),
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),

        const SizedBox(height: 8),

        // --- MEMBERSHIP ID & LEVEL ---
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _StatusBadge(
              label: levelLabel, 
              isPublic: isPublic, 
              role: user.role,
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _textPrimary(context).withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'ID: ${user.id.substring(user.id.length > 6 ? user.id.length - 6 : 0).toUpperCase()}',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: _textMuted(context),
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 300.ms),

        const SizedBox(height: 16),
        
        // --- LOGICAL NOTE ---
        // --- LOGICAL NOTE ---
        if (isPublic)
          Text(
            'أكمل بياناتك الشخصية للوصول إلى كافة ميزات المنصة',
            style: GoogleFonts.cairo(
              fontSize: 11,
              color: _kGold.withValues(alpha: 0.7),
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn(delay: 400.ms),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STATUS BADGES
// ─────────────────────────────────────────────────────────────────────────────
class _StatusBadge extends StatelessWidget {
  final String label;
  final bool isPublic;
  final EbzimRole role;

  const _StatusBadge({
    required this.label, 
    required this.isPublic,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    final isSuperAdmin = role == EbzimRole.superAdmin;
    final isAdmin = role == EbzimRole.admin;
    
    Color color = isPublic ? _textSecondary(context) : _kGold;
    IconData icon = isPublic ? Icons.person_outline_rounded : Icons.verified_outlined;
    
    if (isSuperAdmin) {
      color = const Color(0xFFD4AF37); // Royal Gold
      icon = Icons.shield_rounded;
    } else if (isAdmin) {
      color = _kGold;
      icon = Icons.admin_panel_settings_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.2), width: isSuperAdmin ? 1.5 : 1.0),
        boxShadow: isSuperAdmin ? [
          BoxShadow(
            color: color.withValues(alpha: 0.05),
            blurRadius: 10,
            spreadRadius: 1,
          )
        ] : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.cairo(
              fontSize: 11,
              fontWeight: isSuperAdmin ? FontWeight.w900 : FontWeight.w700,
              color: color,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActiveBadge extends StatelessWidget {
  final String label;
  const _ActiveBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF4ADE80).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF4ADE80).withValues(alpha: 0.30)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4ADE80).withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              color: Color(0xFF4ADE80),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.playfairDisplay(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF4ADE80),
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}




// ─────────────────────────────────────────────────────────────────────────────
// MEMBERSHIP ENTRY TILE — kept for reference only
// ─────────────────────────────────────────────────────────────────────────────
// (Events section moved to HomeScreen)


// ─────────────────────────────────────────────────────────────────────────────
// MEMBERSHIP ENTRY TILE (secondary, bottom of page)
// ─────────────────────────────────────────────────────────────────────────────
class _MembershipEntryTile extends StatelessWidget {
  final AppLocalizations loc;
  const _MembershipEntryTile({required this.loc});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push('/membership/discover'),
        borderRadius: BorderRadius.circular(20),
        splashColor: _kGold.withValues(alpha: 0.06),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: BoxDecoration(
            color: _cardBg(context),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _kGold.withValues(alpha: 0.20), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _kGold.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.workspace_premium_outlined, color: _kGold, size: 28),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loc.dashMembershipInvite,
                      style: GoogleFonts.cairo(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: _textPrimary(context),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      loc.dashMembershipLearnMore,
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        color: _kGold.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: _kGold, size: 24),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: 500.ms);
  }
}

class _MembershipPendingTile extends StatelessWidget {
  final AppLocalizations loc;
  const _MembershipPendingTile({required this.loc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: _cardBg(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.30), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.hourglass_empty, color: Colors.amber, size: 28),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.dashPendingTitle,
                  style: GoogleFonts.cairo(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: _textPrimary(context),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  loc.dashPendingDesc,
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: _textSecondary(context),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms);
  }
}

class _MembershipRejectedTile extends StatelessWidget {
  final AppLocalizations loc;
  const _MembershipRejectedTile({required this.loc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: _cardBg(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.redAccent.withValues(alpha: 0.30), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.cancel_outlined, color: Colors.redAccent, size: 28),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Text(
                  loc.memStatusRejected,
                  style: GoogleFonts.cairo(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: _textPrimary(context),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // Future: Trigger support or re-apply modal
              },
              icon: const Icon(Icons.support_agent_rounded, size: 18),
              label: const Text('التواصل مع الإدارة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).brightness == Brightness.dark 
                    ? Colors.white.withValues(alpha: 0.1) 
                    : Colors.black.withValues(alpha: 0.05),
                foregroundColor: _textPrimary(context),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms);
  }
}





// ─────────────────────────────────────────────────────────────────────────────
// SKELETON LOADING STATES
// ─────────────────────────────────────────────────────────────────────────────
class _DashboardSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 96, left: 24, right: 24, bottom: 128),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _S(h: 10, w: 90),
          const SizedBox(height: 10),
          _S(h: 30, w: 220),
          const SizedBox(height: 14),
          _S(h: 22, w: 150),
          const SizedBox(height: 28),
          _S(h: 108, w: double.infinity, r: 20),
          const SizedBox(height: 24),
          Row(children: [
            Expanded(child: _S(h: 82, w: double.infinity, r: 16)),
            const SizedBox(width: 10),
            Expanded(child: _S(h: 82, w: double.infinity, r: 16)),
            const SizedBox(width: 10),
            Expanded(child: _S(h: 82, w: double.infinity, r: 16)),
          ]),
          const SizedBox(height: 36),
          _S(h: 20, w: 160),
          const SizedBox(height: 18),
          _S(h: 220, w: double.infinity, r: 16),
        ],
      ),
    );
  }
}



class _S extends StatelessWidget {
  final double h, w, r;
  const _S({required this.h, required this.w, this.r = 8});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: h,
      width: w,
      decoration: BoxDecoration(
        color: _cardBg(context),
        borderRadius: BorderRadius.circular(r),
      ),
    ).animate(onPlay: (c) => c.repeat(reverse: true))
     .shimmer(
       duration: 1400.ms,
       color: Colors.white.withValues(alpha: 0.03),
     );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PROFILE COMPLETION CARD
// ─────────────────────────────────────────────────────────────────────────────
class _ProfileCompletionCard extends StatelessWidget {
  final int percentage;
  final AppLocalizations loc;
  const _ProfileCompletionCard({required this.percentage, required this.loc});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/profile/edit'),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              _cardBg(context),
              _kGold.withValues(alpha: 0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: _kGold.withValues(alpha: 0.15), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: _kGold.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.auto_awesome_rounded, color: _kGold, size: 18),
                const SizedBox(width: 10),
                Text(
                  'جاهزية الملف الشخصي', 
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: _textPrimary(context),
                  ),
                ),
                const Spacer(),
                Text(
                  '$percentage%',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: _kGold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Stack(
              children: [
                Container(
                  height: 10,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: _kGold.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeOutCubic,
                  height: 10,
                  width: (MediaQuery.of(context).size.width - 96) * (percentage / 100),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [_kGold, Color(0xFFFFA000)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: _kGold.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                if (percentage >= 100)
                  const Icon(Icons.verified_user_rounded, color: Colors.greenAccent, size: 14),
                if (percentage >= 100) const SizedBox(width: 6),
                Text(
                  percentage >= 100 
                    ? 'ملفك الشخصي مكتمل وموثق بنجاح' 
                    : 'أكمل بياناتك للحصول على هوية رقمية معتمدة',
                  style: GoogleFonts.cairo(
                    fontSize: 11,
                    color: percentage >= 100 ? Colors.greenAccent : _textMuted(context),
                    fontWeight: percentage >= 100 ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.05),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ACCOUNT ACTIONS GRID
// ─────────────────────────────────────────────────────────────────────────────
class _AccountActionsGrid extends StatelessWidget {
  final AppLocalizations loc;
  const _AccountActionsGrid({required this.loc});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 0.95,
      children: [
        _ActionItem(
          icon: Icons.edit_note_rounded,
          label: loc.profileEdit,
          onTap: () => context.push('/profile/edit'),
        ),
        _ActionItem(
          icon: Icons.support_agent_rounded,
          label: loc.supportContactTitle,
          onTap: () {
            // Support logic
          },
        ),
        _ActionItem(
          icon: Icons.settings_outlined,
          label: loc.settingsTitle,
          onTap: () => context.push('/settings'),
        ),
      ],
    ).animate().fadeIn(delay: 300.ms);
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ActionItem({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: _cardBg(context),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _cardBorder(context), width: 1.2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: _kGold, size: 22),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: _textSecondary(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

