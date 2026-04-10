import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/common_widgets/ebzim_app_bar.dart';
import 'package:ebzim_app/core/services/membership_service.dart';
import 'package:ebzim_app/core/services/auth_service.dart';
import 'package:ebzim_app/core/services/event_service.dart';
import 'package:ebzim_app/core/services/news_service.dart';
import 'package:intl/intl.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Moved logic to TabBarView children

    return DefaultTabController(
      length: 3,
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
              tooltip: 'Déconnexion / تسجيل الخروج',
              onPressed: () async {
                await ref.read(authProvider.notifier).logout();
                if (context.mounted) context.go('/login');
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.group_add), text: 'العضوية'),
              Tab(icon: Icon(Icons.event), text: 'الأنشطة'),
              Tab(icon: Icon(Icons.newspaper), text: 'الأخبار'),
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
          ],
        ),
      ),
    );
  }
}

// ── Membership Tab ──
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
            title: 'طلبات العضوية',
            subtitle: 'مراجعة طلبات الانضمام الجديدة للجمعية',
            icon: Icons.person_add_alt_1,
          ),
          const SizedBox(height: 24),
          pendingAsync.when(
            data: (requests) => Row(
              children: [
                _StatCard(
                  label: 'الإجمالي',
                  value: '${requests.length}',
                  icon: Icons.analytics,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(width: 12),
                _StatCard(
                  label: 'بانتظار المراجعة',
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
                'الطلبات الأخيرة',
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
              if (requests.isEmpty) return _EmptyState(message: 'لا توجد طلبات عضوية حالياً');
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
                          const SnackBar(content: Text('✅ تم قبول الطلب'), backgroundColor: Color(0xFF15803D)),
                        );
                      }
                    },
                    onReject: () async {
                      await adminService.reviewRequest(req.id, 'REJECTED');
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('❌ تم رفض الطلب'), backgroundColor: Color(0xFFB91C1C)),
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

// ── Events Tab ──
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
            title: 'إدارة الأنشطة',
            subtitle: 'تنظيم الفعاليات والورشات الميدانية',
            icon: Icons.event_available,
          ),
          const SizedBox(height: 24),
          eventsAsync.when(
            data: (events) => Row(
              children: [
                _StatCard(
                  label: 'أنشطة مجدولة',
                  value: '${events.length}',
                  icon: Icons.calendar_month,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(width: 12),
                _StatCard(
                  label: 'فعاليات مميزة',
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
                'قائمة الأنشطة',
                style: theme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () {}, // Add event logic
                icon: const Icon(Icons.add, size: 16),
                label: const Text('نشاط جديد'),
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
              if (events.isEmpty) return _EmptyState(message: 'لا توجد أنشطة حالياً');
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

// ── News Tab ──
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
            title: 'إدارة الأخبار',
            subtitle: 'نشر المستجدات والشراكات الرسمية',
            icon: Icons.newspaper,
          ),
          const SizedBox(height: 24),
          newsAsync.when(
            data: (posts) => Row(
              children: [
                _StatCard(
                  label: 'إجمالي المقالات',
                  value: '${posts.length}',
                  icon: Icons.article_outlined,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(width: 12),
                _StatCard(
                  label: 'مقالات مثبتة',
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
                'آخر المنشورات',
                style: theme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () {}, // Add news logic
                icon: const Icon(Icons.post_add, size: 16),
                label: const Text('خبر جديد'),
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
              if (posts.isEmpty) return _EmptyState(message: 'لا توجد أخبار حالياً');
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

// ── Shared UI Components ──

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
              'تعذّر الاتصال بالخادم. تأكد من تشغيل NestJS.',
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

// ── Stat Card Widget ──
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

// ── Membership Request Card ──
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
      case 'APPROVED': return 'مقبول';
      case 'REJECTED': return 'مرفوض';
      default: return 'قيد الدراسة';
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
                    label: const Text('رفض'),
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
                    label: const Text('قبول'),
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
