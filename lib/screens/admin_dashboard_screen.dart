import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/common_widgets/ebzim_app_bar.dart';
import 'package:ebzim_app/core/services/membership_service.dart';
import 'package:ebzim_app/core/services/auth_service.dart';
import 'package:ebzim_app/core/services/event_service.dart';
import 'package:ebzim_app/core/services/news_service.dart';
import 'package:ebzim_app/core/services/report_service.dart';
import 'package:ebzim_app/core/services/financial_service.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Moved logic to TabBarView children

    return DefaultTabController(
      length: 6,
      child: Scaffold(
        backgroundColor: AppTheme.primaryColor,
        appBar: EbzimAppBar(
          leading: IconButton(
            icon: const Icon(Icons.menu, color: AppTheme.primaryColor),
            onPressed: () => context.push('/settings'),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: AppTheme.primaryColor),
              tooltip: 'DÃ©connexion / ØªØ³Ø¬ÙŠÙ„ Ø§Ù„Ø®Ø±ÙˆØ¬',
              onPressed: () async {
                await ref.read(authProvider.notifier).logout();
                if (context.mounted) context.go('/login');
              },
            ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(icon: Icon(Icons.group_add), text: 'Ø§Ù„Ø¹Ø¶ÙˆÙŠØ©'),
              Tab(icon: Icon(Icons.event), text: 'Ø§Ù„Ø£Ù†Ø´Ø·Ø©'),
              Tab(icon: Icon(Icons.newspaper), text: 'Ø§Ù„Ø£Ø®Ø¨Ø§Ø±'),
              Tab(icon: Icon(Icons.report_problem), text: 'Ø§Ù„Ø¨Ù„Ø§ØºØ§Øª'),
              Tab(icon: Icon(Icons.attach_money), text: 'Ø§Ù„Ù…Ø³Ø§Ù‡Ù…Ø§Øª'),
              Tab(icon: Icon(Icons.settings), text: 'Ø§Ù„Ø¥Ø¹Ø¯Ø§Ø¯Ø§Øª'),
            ],
            labelColor: AppTheme.primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppTheme.primaryColor,
            indicatorWeight: 3,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
        body: const TabBarView(
          children: [
            _MembershipTab(),
            _EventsTab(),
            _NewsTab(),
            _ReportsTab(),
            _FinancialsTab(),
            _SettingsTab(),
          ],
        ),
      ),
    );
  }
}

// â”€â”€ Membership Tab â”€â”€
class _MembershipTab extends ConsumerWidget {
  const _MembershipTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final pendingAsync = ref.watch(pendingMembershipsProvider);
    final adminService = ref.read(membershipAdminProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TabHeader(
            title: 'Ø·Ù„Ø¨Ø§Øª Ø§Ù„Ø¹Ø¶ÙˆÙŠØ©',
            subtitle: 'Ù…Ø±Ø§Ø¬Ø¹Ø© Ø·Ù„Ø¨Ø§Øª Ø§Ù„Ø§Ù†Ø¶Ù…Ø§Ù… Ø§Ù„Ø¬Ø¯ÙŠØ¯Ø© Ù„Ù„Ø¬Ù…Ø¹ÙŠØ©',
            icon: Icons.person_add_alt_1,
          ),
          const SizedBox(height: 24),
          pendingAsync.when(
            data: (requests) => Row(
              children: [
                _StatCard(
                  label: 'Ø§Ù„Ø¥Ø¬Ù…Ø§Ù„ÙŠ',
                  value: '${requests.length}',
                  icon: Icons.analytics,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(width: 12),
                _StatCard(
                  label: 'Ø¨Ø§Ù†ØªØ¸Ø§Ø± Ø§Ù„Ù…Ø±Ø§Ø¬Ø¹Ø©',
                  value: requests.where((r) => r.status == 'SUBMITTED').length.toString(),
                  icon: Icons.hourglass_top,
                  color: const Color(0xFFB45309),
                ),
              ],
            ),
            loading: () => const LinearProgressIndicator(),
            error: (_, index) => const SizedBox(),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ø§Ù„Ø·Ù„Ø¨Ø§Øª Ø§Ù„Ø£Ø®ÙŠØ±Ø©',
                style: theme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () => ref.invalidate(pendingMembershipsProvider),
                icon: const Icon(Icons.refresh, size: 20, color: AppTheme.secondaryColor),
              ),
            ],
          ),
          const SizedBox(height: 16),
          pendingAsync.when(
            data: (requests) {
              if (requests.isEmpty) return _EmptyState(message: 'Ù„Ø§ ØªÙˆØ¬Ø¯ Ø·Ù„Ø¨Ø§Øª Ø¹Ø¶ÙˆÙŠØ© Ø­Ø§Ù„ÙŠØ§Ù‹');
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: requests.length,
                separatorBuilder: (_, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final req = requests[index];
                  return _MembershipRequestCard(
                    request: req,
                    onApprove: () async {
                      await adminService.reviewRequest(req.id, 'APPROVED');
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('âœ… ØªÙ… Ù‚Ø¨ÙˆÙ„ Ø§Ù„Ø·Ù„Ø¨'), backgroundColor: Color(0xFF15803D)),
                        );
                      }
                    },
                    onReject: () async {
                      await adminService.reviewRequest(req.id, 'REJECTED');
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('âŒ ØªÙ… Ø±ÙØ¶ Ø§Ù„Ø·Ù„Ø¨'), backgroundColor: Color(0xFFB91C1C)),
                        );
                      }
                    },
                  );
                },
              );
            },
            loading: () => const Center(child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator())),
            error: (e, _) => _ErrorState(),
          ),
        ],
      ),
    );
  }
}

// â”€â”€ Events Tab â”€â”€
class _EventsTab extends ConsumerWidget {
  const _EventsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final eventsAsync = ref.watch(adminEventsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TabHeader(
            title: 'Ø¥Ø¯Ø§Ø±Ø© Ø§Ù„Ø£Ù†Ø´Ø·Ø©',
            subtitle: 'ØªÙ†Ø¸ÙŠÙ… Ø§Ù„ÙØ¹Ø§Ù„ÙŠØ§Øª ÙˆØ§Ù„ÙˆØ±Ø´Ø§Øª Ø§Ù„Ù…ÙŠØ¯Ø§Ù†ÙŠØ©',
            icon: Icons.event_available,
          ),
          const SizedBox(height: 24),
          eventsAsync.when(
            data: (events) => Row(
              children: [
                _StatCard(
                  label: 'Ø£Ù†Ø´Ø·Ø© Ù…Ø¬Ø¯ÙˆÙ„Ø©',
                  value: '${events.length}',
                  icon: Icons.calendar_month,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(width: 12),
                _StatCard(
                  label: 'ÙØ¹Ø§Ù„ÙŠØ§Øª Ù…Ù…ÙŠØ²Ø©',
                  value: events.where((e) => e.isFeatured).length.toString(),
                  icon: Icons.star_border,
                  color: const Color(0xFFB45309),
                ),
              ],
            ),
            loading: () => const LinearProgressIndicator(),
            error: (_, index) => const SizedBox(),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ù‚Ø§Ø¦Ù…Ø© Ø§Ù„Ø£Ù†Ø´Ø·Ø©',
                style: theme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () => context.push('/admin/events/create'),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Ù†Ø´Ø§Ø· Ø¬Ø¯ÙŠØ¯'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          eventsAsync.when(
            data: (events) {
              if (events.isEmpty) return _EmptyState(message: 'Ù„Ø§ ØªÙˆØ¬Ø¯ Ø£Ù†Ø´Ø·Ø© Ø­Ø§Ù„ÙŠØ§Ù‹');
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: events.length,
                separatorBuilder: (_, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final event = events[index];
                  return _AdminEventCard(event: event);
                },
              );
            },
            loading: () => const Center(child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator())),
            error: (e, _) => _ErrorState(),
          ),
        ],
      ),
    );
  }
}

// â”€â”€ News Tab â”€â”€
class _NewsTab extends ConsumerWidget {
  const _NewsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final newsAsync = ref.watch(adminNewsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TabHeader(
            title: 'Ø¥Ø¯Ø§Ø±Ø© Ø§Ù„Ø£Ø®Ø¨Ø§Ø±',
            subtitle: 'Ù†Ø´Ø± Ø§Ù„Ù…Ø³ØªØ¬Ø¯Ø§Øª ÙˆØ§Ù„Ø´Ø±Ø§ÙƒØ§Øª Ø§Ù„Ø±Ø³Ù…ÙŠØ©',
            icon: Icons.newspaper,
          ),
          const SizedBox(height: 24),
          newsAsync.when(
            data: (posts) => Row(
              children: [
                _StatCard(
                  label: 'Ø¥Ø¬Ù…Ø§Ù„ÙŠ Ø§Ù„Ù…Ù‚Ø§Ù„Ø§Øª',
                  value: '${posts.length}',
                  icon: Icons.article_outlined,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(width: 12),
                _StatCard(
                  label: 'Ù…Ù‚Ø§Ù„Ø§Øª Ù…Ø«Ø¨ØªØ©',
                  value: posts.where((p) => p.isPinned).length.toString(),
                  icon: Icons.push_pin_outlined,
                  color: const Color(0xFFB45309),
                ),
              ],
            ),
            loading: () => const LinearProgressIndicator(),
            error: (_, index) => const SizedBox(),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ø¢Ø®Ø± Ø§Ù„Ù…Ù†Ø´ÙˆØ±Ø§Øª',
                style: theme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () => context.push('/admin/news/create'),
                icon: const Icon(Icons.post_add, size: 16),
                label: const Text('Ø®Ø¨Ø± Ø¬Ø¯ÙŠØ¯'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          newsAsync.when(
            data: (posts) {
              if (posts.isEmpty) return _EmptyState(message: 'Ù„Ø§ ØªÙˆØ¬Ø¯ Ø£Ø®Ø¨Ø§Ø± Ø­Ø§Ù„ÙŠØ§Ù‹');
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: posts.length,
                separatorBuilder: (_, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return _AdminNewsCard(post: post);
                },
              );
            },
            loading: () => const Center(child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator())),
            error: (e, _) => _ErrorState(),
          ),
        ],
      ),
    );
  }
}

// â”€â”€ Shared UI Components â”€â”€

class _TabHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _TabHeader({required this.title, required this.subtitle, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: AppTheme.primaryColor, size: 28),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
            ),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600),
            ),
          ],
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;
  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(Icons.inbox_outlined, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(message, style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          Icon(Icons.error_outline, color: Color(0xFFB91C1C)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'ØªØ¹Ø°Ù‘Ø± Ø§Ù„Ø§ØªØµØ§Ù„ Ø¨Ø§Ù„Ø®Ø§Ø¯Ù…. ØªØ£ÙƒØ¯ Ù…Ù† ØªØ´ØºÙŠÙ„ NestJS.',
              style: TextStyle(color: Color(0xFFB91C1C), fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminEventCard extends StatelessWidget {
  final ActivityEvent event;
  const _AdminEventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(event.imageUrl, width: 60, height: 60, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => Container(width: 60, height: 60, color: Colors.grey.shade200)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.titleAr, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                const SizedBox(height: 4),
                Text(DateFormat('dd MMMM yyyy', 'ar').format(event.date), style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
              ],
            ),
          ),
          const Icon(Icons.edit_outlined, color: AppTheme.secondaryColor, size: 20),
        ],
      ),
    );
  }
}

class _AdminNewsCard extends StatelessWidget {
  final NewsPost post;
  const _AdminNewsCard({required this.post});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(post.isPinned ? Icons.push_pin : Icons.article, color: AppTheme.primaryColor.withValues(alpha: 0.5), size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(post.titleAr, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: AppTheme.primaryColor), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(post.category, style: TextStyle(fontSize: 10, color: AppTheme.secondaryColor, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const Icon(Icons.more_vert, color: Colors.grey, size: 20),
        ],
      ),
    );
  }
}

// â”€â”€ Stat Card Widget â”€â”€
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: color, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.grey.shade600, fontSize: 9),
            ),
          ],
        ),
      ),
    );
  }
}

// â”€â”€ Membership Request Card â”€â”€
class _MembershipRequestCard extends StatelessWidget {
  final MembershipRequest request;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const _MembershipRequestCard({
    required this.request,
    required this.onApprove,
    required this.onReject,
  });

  Color _statusColor(String status) {
    switch (status) {
      case 'APPROVED': return const Color(0xFF15803D);
      case 'REJECTED': return const Color(0xFFB91C1C);
      default: return const Color(0xFFB45309);
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'APPROVED': return 'Ù…Ù‚Ø¨ÙˆÙ„';
      case 'REJECTED': return 'Ù…Ø±ÙÙˆØ¶';
      default: return 'Ù‚ÙŠØ¯ Ø§Ù„Ø¯Ø±Ø§Ø³Ø©';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _statusColor(request.status);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                child: const Icon(Icons.person, color: AppTheme.primaryColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.fullName,
                      style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor),
                    ),
                    Text(
                      '${request.submissionDate.day}/${request.submissionDate.month}/${request.submissionDate.year}',
                      style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _statusLabel(request.status),
                  style: theme.textTheme.labelSmall?.copyWith(
                      color: statusColor, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          if (request.status == 'SUBMITTED') ...[
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onReject,
                    icon: const Icon(Icons.close, size: 16),
                    label: const Text('Ø±ÙØ¶'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFB91C1C),
                      side: const BorderSide(color: Color(0xFFB91C1C)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onApprove,
                    icon: const Icon(Icons.check, size: 16),
                    label: const Text('Ù‚Ø¨ÙˆÙ„'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF15803D),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
class _ReportsTab extends ConsumerWidget {
  const _ReportsTab();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportsAsync = ref.watch(adminReportsProvider);

    return _TabWrapper(
      title: 'Ø§Ù„Ø¨Ù„Ø§ØºØ§Øª Ø§Ù„Ù…Ø¯Ù†ÙŠØ©',
      subtitle: 'Ù…ØªØ§Ø¨Ø¹Ø© Ø¨Ù„Ø§ØºØ§Øª Ø§Ù„ØªØ®Ø±ÙŠØ¨ Ø£Ùˆ Ø§Ù„Ø¥Ù‡Ù…Ø§Ù„ Ù„Ù„Ù…ÙˆØ§Ù‚Ø¹ Ø§Ù„ØªØ±Ø§Ø«ÙŠØ©',
      child: reportsAsync.when(
        data: (reports) => ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 20),
          itemCount: reports.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, i) => _RequestCard(
            title: reports[i]['incidentCategory'] ?? 'Report',
            subtitle: reports[i]['description'] ?? '',
            tag: reports[i]['status'] ?? 'PENDING',
            color: Colors.green,
            onApprove: null, // Logic to "Mark as Resolved" could go here
            onReject: null,
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

// â”€â”€ Tab 3: Financials â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _FinancialsTab extends ConsumerWidget {
  const _FinancialsTab();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contributionsAsync = ref.watch(adminContributionsProvider);
    final finService = ref.read(financialServiceProvider);

    return _TabWrapper(
      title: 'Ø§Ù„Ù…Ø³Ø§Ù‡Ù…Ø§Øª Ø§Ù„Ù…Ø§Ù„ÙŠØ©',
      subtitle: 'Ø§Ù„ØªØ­Ù‚Ù‚ Ù…Ù† ÙˆØµÙˆÙ„ Ø§Ø´ØªØ±Ø§ÙƒØ§Øª Ø§Ù„Ø¹Ø¶ÙˆÙŠØ© ÙˆØ§Ù„ØªØ¨Ø±Ø¹Ø§Øª Ø§Ù„Ø®Ø§ØµØ© Ø¨Ø§Ù„Ù…Ø´Ø§Ø±ÙŠØ¹',
      child: contributionsAsync.when(
        data: (items) => ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 20),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, i) => _RequestCard(
                title: '${items[i]['amount']} DZD',
                subtitle: items[i]['type'],
                tag: items[i]['status'],
                color: Colors.deepPurple,
                onApprove: () => finService.reviewContribution(items[i]['_id'], 'VERIFIED'),
                onReject: () => finService.reviewContribution(items[i]['_id'], 'REJECTED'),
              ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
class _SettingsTab extends ConsumerStatefulWidget {
  const _SettingsTab();
  @override
  ConsumerState<_SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends ConsumerState<_SettingsTab> {
  final _feeController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    ref.read(financialServiceProvider).getSettings().then((s) {
      _feeController.text = (s['annualMembershipFee'] ?? 2000).toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _TabWrapper(
      title: 'Ø¥Ø¹Ø¯Ø§Ø¯Ø§Øª Ø§Ù„Ù…Ù†ØµØ©',
      subtitle: 'Ø§Ù„ØªØ­ÙƒÙ… ÙÙŠ Ø§Ù„Ø±Ø³ÙˆÙ… ÙˆØ§Ù„Ù…Ø­ØªÙˆÙ‰ Ø§Ù„Ø¥Ø®Ø¨Ø§Ø±ÙŠ ÙˆØ§Ù„Ø£Ù†Ø´Ø·Ø©',
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            _SettingsCard(
              title: 'Ø§Ù„Ø§Ø´ØªØ±Ø§Ùƒ Ø§Ù„Ø³Ù†ÙˆÙŠ Ø§Ù„ÙˆØ·Ù†ÙŠ',
              child: Row(
                children: [
                  Expanded(child: TextField(controller: _feeController, keyboardType: TextInputType.number)),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      final fee = int.tryParse(_feeController.text) ?? 2000;
                      ref.read(financialServiceProvider).updateMembershipFee(fee);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fee Updated')));
                    },
                    child: const Text('Update'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _SettingsCard(
              title: 'Ø§Ù„Ù…Ø­ØªÙˆÙ‰ Ø§Ù„Ø¹Ø§Ù…',
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.event_note),
                    title: const Text('Ø¥Ø¯Ø§Ø±Ø© Ø§Ù„Ø£Ù†Ø´Ø·Ø©'),
                    onTap: () {
                      context.push('/admin/events/create');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.newspaper),
                    title: const Text('Ø¥Ø¯Ø§Ø±Ø© Ø§Ù„Ø£Ø®Ø¨Ø§Ø±'),
                    onTap: () {
                      context.push('/admin/news/create');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class _SettingsCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _SettingsCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _TabWrapper extends StatelessWidget {
  final String title, subtitle;
  final Widget child;
  const _TabWrapper({required this.title, required this.subtitle, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.tajawal(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
              Text(subtitle, style: GoogleFonts.tajawal(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
        Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 24), child: child)),
      ],
    );
  }
}

class _RequestCard extends StatelessWidget {
  final String title, subtitle, tag;
  final VoidCallback? onApprove, onReject;
  final Color color;

  const _RequestCard({
    required this.title, 
    required this.subtitle, 
    required this.tag, 
    this.onApprove, 
    this.onReject,
    this.color = AppTheme.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: Text(tag, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color))),
            ],
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          if (onApprove != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: OutlinedButton(onPressed: onApprove, child: const Text('Approve'))),
                const SizedBox(width: 8),
                Expanded(child: OutlinedButton(onPressed: onReject, child: const Text('Reject'))),
              ],
            ),
          ]
        ],
      ),
    );
  }
}



