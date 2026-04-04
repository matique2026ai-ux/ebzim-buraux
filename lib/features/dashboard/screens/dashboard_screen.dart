import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../events/services/event_service.dart';
import '../../events/widgets/event_card.dart';
import '../../profile/services/user_profile_service.dart';
import '../../../core/common_widgets/ebzim_app_bar.dart';

import 'package:go_router/go_router.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final userAsync = ref.watch(currentUserProvider);
    final upcomingEvents = ref.watch(upcomingEventsProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: EbzimAppBar(
        leading: IconButton(icon: const Icon(Icons.menu, color: AppTheme.primaryColor), onPressed: () => context.push('/settings')),
        actions: [
          userAsync.when(
            data: (user) => Padding(
              padding: const EdgeInsetsDirectional.only(end: 16.0),
              child: CircleAvatar(backgroundImage: NetworkImage(user.imageUrl), radius: 18),
            ),
            loading: () => const SizedBox(),
            error: (_,_) => const SizedBox(),
          )
        ],
      ),
      body: userAsync.when(
        data: (user) {
          final firstName = user.getName(Localizations.localeOf(context).languageCode).split(' ').first;
          final theme = Theme.of(context);
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(loc.dashboardWelcomeBack.toUpperCase(), style: theme.textTheme.labelSmall?.copyWith(color: AppTheme.secondaryColor, letterSpacing: 2)),
                        const SizedBox(height: 4),
                        Text('${loc.dashboardWelcome},\n$firstName', style: theme.textTheme.headlineLarge?.copyWith(color: AppTheme.primaryColor, height: 1.1)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: AppTheme.secondaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: AppTheme.secondaryColor.withValues(alpha: 0.2))),
                      child: Text(user.membershipLevel.toUpperCase(), style: theme.textTheme.labelSmall?.copyWith(fontSize: 8, color: AppTheme.secondaryColor)),
                    )
                  ],
                ),
                const SizedBox(height: 32),
                
                // Status Card
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [AppTheme.primaryColor, AppTheme.accentColor], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [BoxShadow(color: AppTheme.primaryColor.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(loc.dashboardStatus.toUpperCase(), style: theme.textTheme.labelSmall?.copyWith(color: Colors.white.withValues(alpha: 0.6), letterSpacing: 2)),
                              const SizedBox(height: 4),
                              Text(user.membershipStatus, style: theme.textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withValues(alpha: 0.2))),
                            child: const Icon(Icons.verified, color: AppTheme.secondaryColor),
                          )
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Divider(color: Colors.white24),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(loc.dashboardValidUntil.toUpperCase(), style: theme.textTheme.labelSmall?.copyWith(color: Colors.white.withValues(alpha: 0.5))),
                              Text('12 Dec 2024', style: theme.textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.military_tech, color: Colors.white70, size: 16),
                              const SizedBox(width: 4),
                              Text('"Preserving heritage"', style: theme.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic, color: Colors.white70)),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                
                // Quick Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _QuickActionTile(
                      icon: Icons.payments, 
                      label: loc.dashboardQuickPay,
                      onTap: () => context.push('/membership/apply'),
                    ),
                    _QuickActionTile(
                      icon: Icons.badge, 
                      label: loc.dashboardQuickCard,
                      onTap: () => context.go('/profile'), // Stub to profile for ID card view
                    ),
                    _QuickActionTile(
                      icon: Icons.event_available, 
                      label: loc.dashboardQuickReg,
                      onTap: () => context.go('/activities'),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                
                // Progress
                InkWell(
                  onTap: () => context.go('/profile'),
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.grey.shade200)),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 50, height: 50,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CircularProgressIndicator(value: user.profileCompletionPercentage / 100, backgroundColor: Colors.grey.shade200, color: AppTheme.secondaryColor, strokeWidth: 4),
                              Center(child: Text('${user.profileCompletionPercentage}%', style: theme.textTheme.labelSmall?.copyWith(fontSize: 10, color: AppTheme.primaryColor))),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(loc.dashboardProgress, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                              const SizedBox(height: 4),
                              Text('2 ${loc.dashboardProgressDesc}', style: theme.textTheme.bodySmall?.copyWith(color: AppTheme.textDark.withValues(alpha: 0.7))),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                
                // Upcoming Activities
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(loc.dashboardUpcoming, style: theme.textTheme.headlineMedium?.copyWith(color: AppTheme.primaryColor)),
                    GestureDetector(
                      onTap: () => context.go('/activities'),
                      child: Text(loc.viewAll, style: theme.textTheme.labelSmall?.copyWith(color: AppTheme.secondaryColor, letterSpacing: 1.5)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                upcomingEvents.when(
                  data: (events) => SizedBox(
                    height: 280,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: events.take(3).length,
                      separatorBuilder: (context, index) => const SizedBox(width: 16),
                      itemBuilder: (context, index) => EventCard(
                        event: events[index], 
                        onTap: () => context.push('/event/${events[index].id}'),
                      ),
                    ),
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_,_) => const SizedBox(),
                ),
                const SizedBox(height: 80),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text(e.toString())), 
      ),
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionTile({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.grey.shade200)),
          child: Column(
            children: [
              Container(decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]), padding: const EdgeInsets.all(12), child: Icon(icon, color: AppTheme.primaryColor)),
              const SizedBox(height: 16),
              Text(label.toUpperCase(), style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 9, color: AppTheme.primaryColor.withValues(alpha: 0.8))),
            ],
          ),
        ),
      ),
    );
  }
}
