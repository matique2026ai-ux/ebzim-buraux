import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/common_widgets/ebzim_app_bar.dart';
import 'package:ebzim_app/core/services/membership_service.dart';
import 'package:ebzim_app/core/services/report_service.dart';
import 'package:ebzim_app/core/services/financial_service.dart';
import 'package:ebzim_app/core/services/auth_service.dart';
import 'package:ebzim_app/core/services/event_service.dart';
import 'package:ebzim_app/core/services/news_service.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Admin Mission Control — Full Institutional Oversight
// ─────────────────────────────────────────────────────────────────────────────

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F7F4),
        appBar: EbzimAppBar(
          backgroundColor: AppTheme.primaryColor,
          color: Colors.white,
          title: Text(
            'Ebzim Mission Control',
            style: GoogleFonts.inter(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout_rounded, color: Colors.white),
              onPressed: () {
                ref.read(authProvider.notifier).logout();
                context.go('/login');
              },
            ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: AppTheme.accentColor,
            indicatorWeight: 4,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            tabs: [
              Tab(text: 'العضوية'),
              Tab(text: 'البلاغات'),
              Tab(text: 'المساهمات'),
              Tab(text: 'الإعدادات'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _MembershipTab(),
            _ReportsTab(),
            _FinancialsTab(),
            _SettingsTab(),
          ],
        ),
      ),
    );
  }
}

// ── Tab 1: Member Applications ──────────────────────────────────────────────
class _MembershipTab extends ConsumerWidget {
  const _MembershipTab();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingAsync = ref.watch(pendingMembershipsProvider);
    final adminService = ref.read(membershipAdminProvider);

    return _TabWrapper(
      title: 'إدارة الانخراط',
      subtitle: 'مراجعة طلبات الانضمام الجديدة والتحقق من الهوية',
      child: pendingAsync.when(
        data: (requests) => ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 20),
          itemCount: requests.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, i) => _RequestCard(
            title: requests[i].fullName,
            subtitle: DateFormat('yyyy-MM-dd').format(requests[i].submissionDate),
            tag: requests[i].status,
            onApprove: () => adminService.reviewRequest(requests[i].id, 'APPROVED'),
            onReject: () => adminService.reviewRequest(requests[i].id, 'REJECTED'),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

// ── Tab 2: Civic Reports ────────────────────────────────────────────────────
class _ReportsTab extends ConsumerWidget {
  const _ReportsTab();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportsAsync = ref.watch(adminReportsProvider);

    return _TabWrapper(
      title: 'البلاغات المدنية',
      subtitle: 'متابعة بلاغات التخريب أو الإهمال للمواقع التراثية',
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

// ── Tab 3: Financials ───────────────────────────────────────────────────────
class _FinancialsTab extends ConsumerWidget {
  const _FinancialsTab();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contributionsAsync = ref.watch(adminContributionsProvider);
    final finService = ref.read(financialServiceProvider);

    return _TabWrapper(
      title: 'المساهمات المالية',
      subtitle: 'التحقق من وصول اشتراكات العضوية والتبرعات الخاصة بالمشاريع',
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

// ── Tab 4: Settings & Content ───────────────────────────────────────────────
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
      title: 'إعدادات المنصة',
      subtitle: 'التحكم في الرسوم والمحتوى الإخباري والأنشطة',
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            _SettingsCard(
              title: 'الاشتراك السنوي الوطني',
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
              title: 'المحتوى العام',
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.event_note),
                    title: const Text('إدارة الأنشطة'),
                    onTap: () {
                      DefaultTabController.of(context).animateTo(1);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.newspaper),
                    title: const Text('إدارة الأخبار'),
                    onTap: () {
                      DefaultTabController.of(context).animateTo(2);
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

// ─────────────────────────────────────────────────────────────────────────────
// UI Helpers
// ─────────────────────────────────────────────────────────────────────────────

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
import 'package:google_fonts/google_fonts.dart';
