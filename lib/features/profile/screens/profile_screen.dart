import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../services/user_profile_service.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: AppTheme.primaryColor),
            onPressed: () => context.push('/settings'),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: AppTheme.primaryColor),
            onPressed: () => context.push('/notifications'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: userAsync.when(
        data: (user) {
          final isRtl = Localizations.localeOf(context).languageCode == 'ar';
          final displayName = isRtl ? user.nameAr : user.name;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Column(
              children: [
                // Avatar
                Center(
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: AppTheme.primaryColor.withValues(alpha: 0.2), blurRadius: 30, spreadRadius: 5)
                          ]
                        ),
                        child: CircleAvatar(
                          radius: 70,
                          backgroundImage: NetworkImage(user.imageUrl),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Text(loc.ebzimBadge, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2)),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Name & Rank
                Text(displayName, style: TextStyle(fontFamily: Theme.of(context).textTheme.headlineMedium?.fontFamily, fontSize: 32, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(user.membershipLevel.toUpperCase(), style: const TextStyle(color: AppTheme.secondaryColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2)),
                    const SizedBox(width: 8),
                    const CircleAvatar(radius: 3, backgroundColor: Colors.grey),
                    const SizedBox(width: 8),
                    Text('${loc.profileActiveSince} ${user.membershipExpiry.year - 3}', style: const TextStyle(color: Colors.grey, fontSize: 12, fontStyle: FontStyle.italic)),
                  ],
                ),
                const SizedBox(height: 48),

                // Personal Info Card
                _ProfileSectionCard(
                  title: loc.profilePersonal,
                  icon: Icons.person,
                  children: [
                    _InfoRow(label: 'Full Name', value: displayName),
                    const Divider(height: 32, color: Colors.black12),
                    const _InfoRow(label: 'Date of Birth', value: 'May 14, 1978'),
                  ],
                ),
                const SizedBox(height: 24),

                // Contact Details Card
                _ProfileSectionCard(
                  title: loc.profileContact,
                  icon: Icons.alternate_email,
                  children: [
                    _InfoRow(label: loc.profileEmail, value: user.email),
                    const Divider(height: 32, color: Colors.black12),
                    _InfoRow(label: loc.profilePhone, value: user.phone),
                  ],
                ),
                const SizedBox(height: 24),

                // Participation History
                _ProfileSectionCard(
                  title: loc.profileHistory,
                  icon: Icons.history_edu,
                  children: [
                    _HistoryRow(title: 'Heritage Gala 2025', date: 'Jan 12, 2025', badge: 'Attended', icon: Icons.theater_comedy),
                    const Divider(height: 32, color: Colors.black12),
                    _HistoryRow(title: 'Calligraphy Masterclass', date: 'Nov 20, 2024', badge: 'Moderator', icon: Icons.edit_note, isHighlight: true),
                  ],
                ),
                const SizedBox(height: 120), // Padding for Shell FAB/Nav
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e,s) => Center(child: Text(e.toString())), 
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppTheme.primaryColor,
        icon: const Icon(Icons.edit, color: Colors.white),
        label: Text(loc.profileEdit, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class _ProfileSectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _ProfileSectionCard({required this.title, required this.icon, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.secondaryColor, size: 20),
              const SizedBox(width: 8),
              Text(title.toUpperCase(), style: const TextStyle(color: AppTheme.secondaryColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2)),
            ],
          ),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
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
        Text(label.toUpperCase(), style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 2, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
      ],
    );
  }
}

class _HistoryRow extends StatelessWidget {
  final String title;
  final String date;
  final String badge;
  final IconData icon;
  final bool isHighlight;

  const _HistoryRow({required this.title, required this.date, required this.badge, required this.icon, this.isHighlight = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: AppTheme.primaryColor.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(16)),
          child: Icon(icon, color: AppTheme.primaryColor),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
              Text(date.toUpperCase(), style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Colors.grey)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isHighlight ? AppTheme.primaryColor.withValues(alpha: 0.1) : AppTheme.secondaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(badge.toUpperCase(), style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: isHighlight ? AppTheme.primaryColor : AppTheme.secondaryColor)),
        )
      ],
    );
  }
}
