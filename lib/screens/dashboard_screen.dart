import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ebzim_app/core/localization/l10n/app_localizations.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/services/event_service.dart';
import 'package:ebzim_app/widgets/event_card.dart';
import 'package:ebzim_app/core/services/user_profile_service.dart';
import 'package:ebzim_app/core/common_widgets/ebzim_app_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:ebzim_app/core/services/auth_service.dart';
import 'package:ebzim_app/core/widgets/ebzim_background.dart';
import 'package:ebzim_app/widgets/digital_id_card.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Design tokens for the dashboard surface layer
// ─────────────────────────────────────────────────────────────────────────────
Color get _kGold => AppTheme.accentColor;

Color _cardBg(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? const Color(0x0CFFFFFF) : Colors.white.withValues(alpha: 0.4);
Color _cardBorder(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? const Color(0x22FFFFFF) : Colors.black.withValues(alpha: 0.05);
Color _cardBgStrong(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? const Color(0x12FFFFFF) : Colors.white.withValues(alpha: 0.7);
Color _textPrimary(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xFF1A1C1A);
Color _textSecondary(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? const Color(0xCCFFFFFF) : Colors.black87;
Color _textMuted(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? const Color(0x73FFFFFF) : Colors.black54;

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  String _getLocalizedLevel(UserProfile user, AppLocalizations loc) {
    switch (user.membershipLevel.toUpperCase()) {
      case 'PUBLIC': return loc.dashMemberLevelPublic;
      case 'MEMBER': return loc.dashMemberLevelMember;
      default: return user.membershipLevel;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);
    final userAsync = ref.watch(currentUserProvider);
    final upcomingEvents = ref.watch(upcomingEventsProvider);
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
        leading: IconButton(
          icon: const Icon(Icons.tune_outlined, color: _kGold, size: 22),
          onPressed: () => context.push('/settings'),
          tooltip: loc.settingsTitle,
        ),
        actions: [
          userAsync.when(
            data: (user) {
              final isAdmin = user.membershipLevel == 'ADMIN' || user.membershipLevel == 'SUPER_ADMIN';
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
                      onTap: () => context.push('/profile'),
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.14),
                        backgroundImage: user.imageUrl.startsWith('http')
                            ? NetworkImage(user.imageUrl)
                            : null,
                        radius: 19,
                        child: !user.imageUrl.startsWith('http')
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
            final langCode = Localizations.localeOf(context).languageCode;
            final fullName = user.getName(langCode);
            final firstName = fullName.isNotEmpty ? fullName.split(' ').first : '';
            final isPublic = user.membershipLevel == 'PUBLIC';
            final isMember = ['MEMBER', 'ADMIN', 'AUTHORITY', 'SUPER_ADMIN']
                .contains(user.membershipLevel.toUpperCase());

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(top: 88, bottom: 128),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── HERO ───────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _HeroSection(
                      user: user,
                      firstName: firstName,
                      levelLabel: _getLocalizedLevel(user, loc),
                      loc: loc,
                      isRtl: isRtl,
                      isPublic: isPublic,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ── PLATFORM INTRO CARD or MEMBER CARD ─────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: isMember
                        ? DigitalIdCard(user: user).animate().fadeIn().slideY(begin: 0.04)
                        : _PublicPlatformCard(loc: loc),
                  ),
                  const SizedBox(height: 32),

                  // ── QUICK ACTIONS ──────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _QuickActionsRow(loc: loc, isPublic: isPublic),
                  ),
                  const SizedBox(height: 48),

                  // ── EVENTS SECTION ─────────────────────────────────────
                  _EventsSection(upcomingEvents: upcomingEvents, loc: loc),

                  // ── MEMBERSHIP ENTRY (secondary, bottom) ────────────────────
                  if (isPublic) ...[
                    const SizedBox(height: 48),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _MembershipEntryTile(loc: loc),
                    ),
                  ],

                  // ── INSTITUTIONAL FEATURES SECTION ──────────────
                  const SizedBox(height: 48),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _InstitutionalSection(loc: loc),
                  ),
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

  const _HeroSection({
    required this.user,
    required this.firstName,
    required this.levelLabel,
    required this.loc,
    required this.isRtl,
    required this.isPublic,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Eyebrow label
        Row(
          children: [
            Container(
              width: 36,
              height: 3,
              decoration: BoxDecoration(
                color: _kGold,
                borderRadius: BorderRadius.circular(2),
              ),
              margin: const EdgeInsetsDirectional.only(end: 12),
            ),
            Text(
              loc.welcome.toUpperCase(),
              style: GoogleFonts.inter(
                color: _kGold,
                fontSize: 11,
                letterSpacing: 4.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ).animate().fadeIn(delay: 50.ms),

        const SizedBox(height: 14),

        // Main welcome name
        Text(
          firstName.isNotEmpty
              ? loc.dashboardWelcome(firstName)
              : loc.dashboardWelcomePublic,
          style: GoogleFonts.tajawal(
            color: _textPrimary(context),
            fontSize: 34,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ).animate().fadeIn(delay: 100.ms).slideX(
              begin: isRtl ? 0.04 : -0.04,
              curve: Curves.easeOut,
            ),

        const SizedBox(height: 16),

        // Status badge row
        Row(
          children: [
            _StatusBadge(label: levelLabel, isPublic: isPublic),
            if (isPublic) ...[
              const SizedBox(width: 8),
              _ActiveBadge(label: loc.dashStatusActive),
            ],
          ],
        ).animate().fadeIn(delay: 180.ms).scale(
              begin: const Offset(0.96, 0.96),
              curve: Curves.easeOut,
            ),

        if (isPublic) ...[
          const SizedBox(height: 12),
          Text(
            loc.dashAccountNote,
            style: GoogleFonts.cairo(
              fontSize: 10.5,
              color: _textMuted(context),
              fontStyle: FontStyle.italic,
              height: 1.5,
            ),
          ).animate().fadeIn(delay: 250.ms),
        ],
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
  const _StatusBadge({required this.label, required this.isPublic});

  @override
  Widget build(BuildContext context) {
    final color = isPublic ? _textSecondary(context) : _kGold;
    final icon = isPublic ? Icons.person_outline_rounded : Icons.verified_outlined;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.2)),
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
              fontWeight: FontWeight.w700,
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
            style: GoogleFonts.inter(
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
// PUBLIC PLATFORM INTRO CARD
// ─────────────────────────────────────────────────────────────────────────────
class _PublicPlatformCard extends StatelessWidget {
  final AppLocalizations loc;
  const _PublicPlatformCard({required this.loc});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _cardBgStrong(context),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _cardBorder(context), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card header with gold left rule
          Container(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: _cardBorder(context)),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 28,
                  margin: const EdgeInsetsDirectional.only(end: 16),
                  decoration: BoxDecoration(
                    color: _kGold,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Expanded(
                  child: Text(
                    loc.dashPublicIntroTitle,
                    style: GoogleFonts.tajawal(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: _textPrimary(context),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _kGold.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.explore_outlined, color: _kGold, size: 22),
                ),
              ],
            ),
          ),

          // Card body
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.dashPublicIntroDesc,
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: _textSecondary(context),
                    height: 1.65,
                  ),
                ),
                const SizedBox(height: 22),
                Container(height: 1, color: _cardBorder(context)),
                const SizedBox(height: 18),
                _PillarRow(icon: Icons.palette_outlined, label: loc.dashPillar1),
                const SizedBox(height: 12),
                _PillarRow(icon: Icons.account_balance_outlined, label: loc.dashPillar2),
                const SizedBox(height: 12),
                _PillarRow(icon: Icons.people_outline_rounded, label: loc.dashPillar3),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.04, curve: Curves.easeOut);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PILLAR ROW — association thematic pillars inside the intro card
// ─────────────────────────────────────────────────────────────────────────────
class _PillarRow extends StatelessWidget {
  final IconData icon;
  final String label;
  const _PillarRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: _kGold.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: _kGold.withValues(alpha: 0.85), size: 15),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: 13,
            color: _textSecondary(context),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// QUICK ACTIONS ROW
// ─────────────────────────────────────────────────────────────────────────────
class _QuickActionsRow extends StatelessWidget {
  final AppLocalizations loc;
  final bool isPublic;
  const _QuickActionsRow({required this.loc, required this.isPublic});

  @override
  Widget build(BuildContext context) {
    final actions = [
      _ActionDef(Icons.person_outline_rounded, loc.dashQuickProfile, () => context.push('/profile')),
      _ActionDef(Icons.event_note_rounded, loc.dashboardQuickReg, () => context.go('/activities')),
      _ActionDef(Icons.info_outline_rounded, loc.dashQuickAbout, () => context.push('/about')),
    ];

    return Row(
      children: actions.asMap().entries.map((e) {
        final isLast = e.key == actions.length - 1;
        return Expanded(
          child: Padding(
            padding: EdgeInsetsDirectional.only(end: isLast ? 0 : 10),
            child: _QuickActionTile(def: e.value),
          ),
        );
      }).toList(),
    ).animate().fadeIn(delay: 280.ms);
  }
}

class _ActionDef {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ActionDef(this.icon, this.label, this.onTap);
}

class _QuickActionTile extends StatelessWidget {
  final _ActionDef def;
  const _QuickActionTile({required this.def});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: def.onTap,
        borderRadius: BorderRadius.circular(20),
        splashColor: _kGold.withValues(alpha: 0.08),
        highlightColor: _kGold.withValues(alpha: 0.04),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 10),
          decoration: BoxDecoration(
            color: _cardBg(context),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _cardBorder(context), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _kGold.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: _kGold.withValues(alpha: 0.10),
                    width: 1,
                  ),
                ),
                child: Icon(def.icon, color: _kGold, size: 24),
              ),
              const SizedBox(height: 14),
              Text(
                def.label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: _textPrimary(context),
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// EVENTS SECTION
// ─────────────────────────────────────────────────────────────────────────────
class _EventsSection extends StatelessWidget {
  final AsyncValue<List<ActivityEvent>> upcomingEvents;
  final AppLocalizations loc;
  const _EventsSection({required this.upcomingEvents, required this.loc});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.dashboardUpcoming,
                    style: GoogleFonts.tajawal(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _textPrimary(context),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(height: 2, width: 40, color: _kGold.withValues(alpha: 0.6)),
                ],
              ),
              GestureDetector(
                onTap: () => context.go('/activities'),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      loc.dashViewAll,
                      style: GoogleFonts.cairo(
                        color: _kGold,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 3),
                    const Icon(Icons.chevron_right_rounded, color: _kGold, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // Events list
        upcomingEvents.when(
          data: (events) => events.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _EmptyEventsPlaceholder(loc: loc),
                )
              : SizedBox(
                  height: 265,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: events.take(4).length,
                    separatorBuilder: (_, i2) => const SizedBox(width: 14),
                    itemBuilder: (_, i) => EventCard(
                      event: events[i],
                      onTap: () => context.push('/event/${events[i].id}'),
                    ),
                  ),
                ),
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: _EventsSkeleton(),
          ),
          error: (e, _) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _EmptyEventsPlaceholder(loc: loc),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 380.ms);
  }
}

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

// ─────────────────────────────────────────────────────────────────────────────
// INSTITUTIONAL SECTION — Heritage Projects + Civic Report
// ─────────────────────────────────────────────────────────────────────────────
class _InstitutionalSection extends StatelessWidget {
  final AppLocalizations loc;
  const _InstitutionalSection({required this.loc});

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          children: [
            Container(
              width: 36, height: 3,
              decoration: BoxDecoration(color: _kGold, borderRadius: BorderRadius.circular(2)),
              margin: const EdgeInsetsDirectional.only(end: 12),
            ),
            Text(
              (isAr ? 'ابزيم تعمل • مشاريع ميدانية' : 'Ebzim en action • Projets terrain').toUpperCase(),
              style: GoogleFonts.inter(
                color: _kGold,
                fontSize: 10,
                letterSpacing: 3,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ).animate().fadeIn(delay: 520.ms),
        const SizedBox(height: 18),

        // Heritage Projects Card
        _InstitutionalCard(
          icon: Icons.apartment_outlined,
          iconColor: const Color(0xFFD4AF37),
          tag: isAr ? 'شراكة • وزارة المجاهدين • اليونسكو' : 'Partenariat • Min. Moudjahidines • UNESCO',
          title: isAr ? 'مشاريع الذاكرة والتراث' : 'Projets Mémoriels et Patrimoniaux',
          subtitle: isAr
              ? 'ترميم الثكنة العسكرية • شراكة المتحف الوطني • شبكة اليونسكو'
              : 'Restauration caserne militaire • Partenariat Musée National • Réseau UNESCO',
          buttonLabel: isAr ? 'استعراض المشاريع' : 'Voir les projets',
          buttonIcon: Icons.arrow_outward_rounded,
          isDark: isDark,
          delay: 550,
          onTap: () => context.push('/heritage'),
        ),
        const SizedBox(height: 14),

        // Digital Library Card
        _InstitutionalCard(
          icon: Icons.auto_stories_outlined,
          iconColor: const Color(0xFF8B5CF6),
          tag: isAr ? 'معرفة • أرشيف • بحوث' : 'Savoir • Archives • Recherche',
          title: isAr ? 'المكتبة الرقمية' : 'Bibliothèque Numérique',
          subtitle: isAr
              ? 'أرشيف الثكنة، بحوث علم الآثار، تقارير المواطنة...'
              : 'Archives Caserne, recherche archéologique, rapports citoyenneté...',
          buttonLabel: isAr ? 'تصفح المكتبة' : 'Explorer la bibliothèque',
          buttonIcon: Icons.library_books_outlined,
          isDark: isDark,
          delay: 600,
          onTap: () => context.push('/library'),
        ),
        const SizedBox(height: 14),

        // Contributions Card
        _InstitutionalCard(
          icon: Icons.volunteer_activism_outlined,
          iconColor: const Color(0xFFE11D48),
          tag: isAr ? 'دعم • اشتراك • مساهمة' : 'Soutien • Adhésion • Appui',
          title: isAr ? 'المساهمات والاشتراكات' : 'Contributions & Adhésions',
          subtitle: isAr
              ? 'تجديد العضوية السنوية، دعم مشاريع الترميم...'
              : 'Renouvellement annuel, soutien aux projets de restauration...',
          buttonLabel: isAr ? 'المساهمة الآن' : 'Contribuer maintenant',
          buttonIcon: Icons.favorite_border_rounded,
          isDark: isDark,
          delay: 650,
          onTap: () => context.push('/contributions'),
        ),
        const SizedBox(height: 14),

        // Civic Report Card
        _InstitutionalCard(
          icon: Icons.shield_outlined,
          iconColor: const Color(0xFF22C55E),
          tag: isAr ? 'مجتمع مدني • إبلاغ مدني' : 'Société civile • Signalement civique',
          title: isAr ? 'بلّغ عن انتهاك' : 'Signaler une violation',
          subtitle: isAr
              ? 'تراث عمراني، سرقة أثرية، تشويه الفضاء العام…'
              : 'Patrimoine urbain, vol archéologique, dégradation de l\'espace public…',
          buttonLabel: isAr ? 'إرسال بلاغ' : 'Envoyer un signalement',
          buttonIcon: Icons.send_rounded,
          isDark: isDark,
          delay: 640,
          onTap: () => context.push('/report'),
        ),
      ],
    );
  }
}

class _InstitutionalCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String tag;
  final String title;
  final String subtitle;
  final String buttonLabel;
  final IconData buttonIcon;
  final bool isDark;
  final int delay;
  final VoidCallback onTap;

  const _InstitutionalCard({
    required this.icon,
    required this.iconColor,
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.buttonIcon,
    required this.isDark,
    required this.delay,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        splashColor: iconColor.withValues(alpha: 0.06),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _cardBgStrong(context),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? iconColor.withValues(alpha: 0.15) : iconColor.withValues(alpha: 0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: isDark ? 0.1 : 0.08),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: iconColor, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tag,
                      style: GoogleFonts.inter(
                        color: iconColor.withValues(alpha: 0.8),
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: GoogleFonts.tajawal(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: _textPrimary(context),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.cairo(
                        fontSize: 11,
                        color: _textMuted(context),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          buttonLabel,
                          style: GoogleFonts.cairo(
                            color: iconColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(buttonIcon, color: iconColor, size: 14),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: delay)).slideY(begin: 0.05);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// EMPTY EVENTS PLACEHOLDER
// ─────────────────────────────────────────────────────────────────────────────
class _EmptyEventsPlaceholder extends StatelessWidget {
  final AppLocalizations loc;
  const _EmptyEventsPlaceholder({required this.loc});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _cardBg(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder(context)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy_outlined,
              color: _textMuted(context), size: 18),
          const SizedBox(width: 10),
          Text(
            loc.dashNoEvents,
            style: GoogleFonts.cairo(
              color: _textMuted(context),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
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

class _EventsSkeleton extends StatelessWidget {
  const _EventsSkeleton();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Row(children: [
        Expanded(child: _S(h: 200, w: double.infinity, r: 16)),
        const SizedBox(width: 14),
        Expanded(child: _S(h: 200, w: double.infinity, r: 16)),
      ]),
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
