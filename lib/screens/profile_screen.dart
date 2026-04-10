import 'package:flutter/material.dart';
import 'dart:ui';
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

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final userAsync = ref.watch(currentUserProvider);
    final statusAsync = ref.watch(membershipStatusProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: AppTheme.accentColor),
            onPressed: () => context.push('/settings'),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: AppTheme.accentColor),
            onPressed: () => context.push('/notifications'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: EbzimBackground(
        child: userAsync.when(
          data: (user) {
            final isRtl = Localizations.localeOf(context).languageCode == 'ar';
            final displayName = isRtl ? user.nameAr : user.name;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 80.0),
              child: Column(
                children: [
                  // Avatar Section with Gold Aura
                  Center(
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.accentColor.withValues(alpha: 0.15), 
                                blurRadius: 60, 
                                spreadRadius: 10
                              )
                            ]
                          ),
                          child: CircleAvatar(
                            radius: 75,
                            backgroundColor: Colors.white.withValues(alpha: 0.05),
                            backgroundImage: NetworkImage(user.imageUrl),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.accentColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppTheme.primaryColor, width: 2),
                          ),
                          child: Text(
                            (user.membershipLevel == 'MEMBER' || user.membershipLevel == 'ADMIN')
                              ? loc.dashMemberLevelMember.toUpperCase()
                              : loc.dashMemberLevelPublic.toUpperCase(),
                            style: const TextStyle(
                              color: AppTheme.primaryColor, 
                              fontSize: 10, 
                              fontWeight: FontWeight.bold, 
                              letterSpacing: 1.5
                            ),
                          ),
                        )
                      ],
                    ),
                  ).animate().fadeIn().scale(),

                  const SizedBox(height: 32),

                  // Name Section
                  Text(
                    displayName,
                    style: const TextStyle(
                      fontFamily: 'Aref Ruqaa',
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),

                  const SizedBox(height: 8),

                  statusAsync.when(
                    data: (status) {
                      final label = user.membershipLevel == 'PUBLIC' ? loc.dashAccountStatus : loc.dashboardStatus;
                      final idLabel = user.membershipLevel == 'PUBLIC' ? 'ID' : '№';
                      return Text(
                        '$label: $idLabel-${user.id.substring(user.id.length - 6).toUpperCase()}',
                        style: TextStyle(
                          color: AppTheme.accentColor.withValues(alpha: 0.7), 
                          fontSize: 12, 
                          letterSpacing: 1
                        )
                      );
                    },
                    loading: () => const SizedBox.shrink(),
                    error: (error, stack) => const SizedBox.shrink(),
                  ),

                  const SizedBox(height: 48),

                  // Personal Info Card
                  GlassCard(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionTitle(loc.profilePersonal, Icons.person_outline),
                        const SizedBox(height: 24),
                        _InfoRow(label: loc.regFullName, value: displayName),
                        if (user.membershipLevel != 'PUBLIC' && user.membershipExpiry != null) ...[
                          const Divider(height: 32),
                          _InfoRow(
                            label: loc.profileActiveSince, 
                            value: '${user.membershipExpiry!.year - 1} / ${user.membershipExpiry!.month} / ${user.membershipExpiry!.day}'
                          ),
                        ],
                      ],
                    ),
                  ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.1),

                  const SizedBox(height: 24),

                  // Contact Info Card
                  GlassCard(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionTitle(loc.profileContact, Icons.alternate_email),
                        const SizedBox(height: 24),
                        _InfoRow(label: loc.profileEmail, value: user.email),
                        const Divider(height: 32),
                        _InfoRow(label: loc.profilePhone, value: user.phone),
                      ],
                    ),
                  ).animate().fadeIn(delay: 600.ms).slideX(begin: -0.1),

                  const SizedBox(height: 48),

                  // Logout Button (Heritage Red)
                  Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.heritageRed.withValues(alpha: 0.3)),
                    ),
                    child: TextButton.icon(
                      onPressed: () {
                        ref.read(authProvider.notifier).logout();
                        context.go('/login');
                      },
                      icon: const Icon(Icons.logout, color: AppTheme.heritageRed),
                      label: Text(
                        loc.settingsLogout,
                        style: const TextStyle(
                          color: AppTheme.heritageRed, 
                          fontWeight: FontWeight.bold, 
                          fontSize: 16
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 800.ms),

                  const SizedBox(height: 120),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.accentColor)),
          error: (e, s) => Center(child: Text(e.toString(), style: const TextStyle(color: Colors.white70))),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppTheme.accentColor,
        icon: const Icon(Icons.edit, color: Colors.black),
        label: const Text('تعديل', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _sectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.accentColor, size: 20),
        const SizedBox(width: 8),
        Text(
          title.toUpperCase(), 
          style: const TextStyle(
            color: AppTheme.accentColor, 
            fontSize: 10, 
            fontWeight: FontWeight.bold, 
            letterSpacing: 2
          )
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(), 
          style: TextStyle(
            fontSize: 10, 
            fontWeight: FontWeight.bold, 
            letterSpacing: 1.5, 
            color: Colors.white.withValues(alpha: 0.4)
          )
        ),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
      ],
    );
  }
}
