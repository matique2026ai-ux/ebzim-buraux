import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/services/membership_service.dart';
import 'package:ebzim_app/core/services/auth_service.dart';
import 'package:ebzim_app/core/services/event_service.dart';
import 'package:ebzim_app/core/services/news_service.dart';
import 'package:ebzim_app/core/services/report_service.dart';
import 'package:ebzim_app/core/services/financial_service.dart';
import 'package:ebzim_app/core/services/cms_content_service.dart';
import 'package:ebzim_app/core/models/cms_models.dart';
import 'package:ebzim_app/screens/admin_cms_manage_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ADMIN DASHBOARD SCREEN
// ─────────────────────────────────────────────────────────────────────────────
class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6F9),
        body: NestedScrollView(
          headerSliverBuilder: (_, __) => [
            SliverAppBar(
              expandedHeight: 140,
              floating: false,
              pinned: true,
              backgroundColor: AppTheme.primaryColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                onPressed: () => context.go('/dashboard'),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout_rounded, color: Colors.white70),
                  tooltip: 'تسجيل الخروج',
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('تسجيل الخروج'),
                        content: const Text('هل تريد الخروج من لوحة الإدارة؟'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('إلغاء')),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            child: const Text('خروج'),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      await ref.read(authProvider.notifier).logout();
                      if (context.mounted) context.go('/login');
                    }
                  },
                ),
                const SizedBox(width: 8),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF052011), Color(0xFF0A3D21), Color(0xFF1A6B3A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 60),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () => context.go('/dashboard'),
                            behavior: HitTestBehavior.opaque,
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: AppTheme.accentColor.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.5)),
                                  ),
                                  child: const Icon(Icons.admin_panel_settings_rounded, color: AppTheme.accentColor, size: 24),
                                ),
                                const SizedBox(width: 14),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'لوحة الإدارة',
                                      style: GoogleFonts.tajawal(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'جمعية إبزيم للتراث والفنون',
                                      style: GoogleFonts.tajawal(
                                        fontSize: 12,
                                        color: Colors.white.withValues(alpha: 0.6),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(54),
                child: Container(
                  color: AppTheme.primaryColor,
                  child: TabBar(
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    indicatorColor: AppTheme.accentColor,
                    indicatorWeight: 3,
                    indicatorSize: TabBarIndicatorSize.label,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white54,
                    labelStyle: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 12),
                    unselectedLabelStyle: GoogleFonts.tajawal(fontSize: 12),
                    tabs: const [
                      Tab(icon: Icon(Icons.group_add_rounded, size: 18), text: 'العضوية'),
                      Tab(icon: Icon(Icons.dashboard_customize_rounded, size: 18), text: 'المحتوى'),
                      Tab(icon: Icon(Icons.event_rounded, size: 18), text: 'الأنشطة'),
                      Tab(icon: Icon(Icons.newspaper_rounded, size: 18), text: 'الأخبار'),
                      Tab(icon: Icon(Icons.flag_rounded, size: 18), text: 'البلاغات'),
                      Tab(icon: Icon(Icons.account_balance_wallet_rounded, size: 18), text: 'المساهمات'),
                      Tab(icon: Icon(Icons.settings_rounded, size: 18), text: 'الإعدادات'),
                    ],
                  ),
                ),
              ),
            ),
          ],
          body: const TabBarView(
            children: [
              _MembershipTab(),
              _CMSTab(),
              _EventsTab(),
              _NewsTab(),
              _ReportsTab(),
              _FinancialsTab(),
              _SettingsTab(),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 1: MEMBERSHIP
// ─────────────────────────────────────────────────────────────────────────────
class _MembershipTab extends ConsumerWidget {
  const _MembershipTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingAsync = ref.watch(pendingMembershipsProvider);
    final adminService = ref.read(membershipAdminProvider);

    return RefreshIndicator(
      color: AppTheme.primaryColor,
      onRefresh: () async => ref.invalidate(pendingMembershipsProvider),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(
              title: 'طلبات العضوية',
              subtitle: 'مراجعة طلبات الانضمام الجديدة للجمعية',
              icon: Icons.person_add_alt_1_rounded,
            ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),
            const SizedBox(height: 20),
            pendingAsync.when(
              data: (requests) => Row(
                children: [
                  _StatCard(
                    label: 'إجمالي الطلبات',
                    value: '${requests.length}',
                    icon: Icons.analytics_rounded,
                    gradient: const LinearGradient(colors: [Color(0xFF052011), Color(0xFF1A6B3A)]),
                  ),
                  const SizedBox(width: 12),
                  _StatCard(
                    label: 'بانتظار المراجعة',
                    value: requests.where((r) => r.status == 'SUBMITTED').length.toString(),
                    icon: Icons.hourglass_top_rounded,
                    gradient: const LinearGradient(colors: [Color(0xFFB45309), Color(0xFFD97706)]),
                  ),
                ],
              ).animate().fadeIn(delay: 200.ms),
              loading: () => const _LoadingShimmer(),
              error: (_, __) => const SizedBox(),
            ),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'الطلبات الأخيرة',
                  style: GoogleFonts.tajawal(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
                GestureDetector(
                  onTap: () => ref.invalidate(pendingMembershipsProvider),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.refresh_rounded, size: 18, color: AppTheme.primaryColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            pendingAsync.when(
              data: (requests) {
                if (requests.isEmpty) {
                  return const _EmptyState(
                    message: 'لا توجد طلبات عضوية حالياً',
                    icon: Icons.inbox_rounded,
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: requests.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final req = requests[index];
                    return _MembershipRequestCard(
                      request: req,
                      onApprove: () async {
                        await adminService.reviewRequest(req.id, 'APPROVED');
                        ref.invalidate(pendingMembershipsProvider);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            _successSnack('✅ تم قبول الطلب بنجاح'),
                          );
                        }
                      },
                      onReject: () async {
                        await adminService.reviewRequest(req.id, 'REJECTED');
                        ref.invalidate(pendingMembershipsProvider);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            _errorSnack('❌ تم رفض الطلب'),
                          );
                        }
                      },
                    ).animate(delay: (index * 80).ms).fadeIn().slideY(begin: 0.05);
                  },
                );
              },
              loading: () => const _LoadingShimmer(),
              error: (e, _) => _ErrorState(error: e.toString()),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 2: EVENTS
// ─────────────────────────────────────────────────────────────────────────────
class _EventsTab extends ConsumerWidget {
  const _EventsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(adminEventsProvider);

    return RefreshIndicator(
      color: AppTheme.primaryColor,
      onRefresh: () async => ref.invalidate(adminEventsProvider),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(
              title: 'إدارة الأنشطة',
              subtitle: 'تنظيم الفعاليات والورشات الميدانية',
              icon: Icons.event_available_rounded,
            ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),
            const SizedBox(height: 20),
            eventsAsync.when(
              data: (events) => Row(
                children: [
                  _StatCard(
                    label: 'أنشطة مجدولة',
                    value: '${events.length}',
                    icon: Icons.calendar_month_rounded,
                    gradient: const LinearGradient(colors: [Color(0xFF052011), Color(0xFF1A6B3A)]),
                  ),
                  const SizedBox(width: 12),
                  _StatCard(
                    label: 'فعاليات مميزة',
                    value: events.where((e) => e.isFeatured).length.toString(),
                    icon: Icons.star_rounded,
                    gradient: const LinearGradient(colors: [Color(0xFFD4AF37), Color(0xFFB8960C)]),
                  ),
                ],
              ).animate().fadeIn(delay: 200.ms),
              loading: () => const _LoadingShimmer(),
              error: (_, __) => const SizedBox(),
            ),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'قائمة الأنشطة',
                  style: GoogleFonts.tajawal(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF1A1A2E)),
                ),
                GestureDetector(
                  onTap: () => context.push('/admin/events/create'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF052011), Color(0xFF1A6B3A)]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.add_rounded, color: Colors.white, size: 16),
                        const SizedBox(width: 6),
                        Text('نشاط جديد', style: GoogleFonts.tajawal(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            eventsAsync.when(
              data: (events) {
                if (events.isEmpty) {
                  return const _EmptyState(message: 'لا توجد أنشطة حالياً — أضف نشاطاً جديداً!', icon: Icons.event_busy_rounded);
                }
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: events.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return _AdminEventCard(event: events[index])
                        .animate(delay: (index * 80).ms)
                        .fadeIn()
                        .slideY(begin: 0.05);
                  },
                );
              },
              loading: () => const _LoadingShimmer(),
              error: (e, _) => _ErrorState(error: e.toString()),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 3: NEWS
// ─────────────────────────────────────────────────────────────────────────────
class _NewsTab extends ConsumerWidget {
  const _NewsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsAsync = ref.watch(adminNewsProvider);

    return RefreshIndicator(
      color: AppTheme.primaryColor,
      onRefresh: () async => ref.invalidate(adminNewsProvider),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(
              title: 'إدارة الأخبار',
              subtitle: 'نشر المستجدات والشراكات الرسمية',
              icon: Icons.newspaper_rounded,
            ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),
            const SizedBox(height: 20),
            newsAsync.when(
              data: (posts) => Row(
                children: [
                  _StatCard(
                    label: 'إجمالي المقالات',
                    value: '${posts.length}',
                    icon: Icons.article_outlined,
                    gradient: const LinearGradient(colors: [Color(0xFF052011), Color(0xFF1A6B3A)]),
                  ),
                  const SizedBox(width: 12),
                  _StatCard(
                    label: 'مقالات مثبتة',
                    value: posts.where((p) => p.isPinned).length.toString(),
                    icon: Icons.push_pin_rounded,
                    gradient: const LinearGradient(colors: [Color(0xFF6D28D9), Color(0xFF7C3AED)]),
                  ),
                ],
              ).animate().fadeIn(delay: 200.ms),
              loading: () => const _LoadingShimmer(),
              error: (_, __) => const SizedBox(),
            ),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'آخر المنشورات',
                  style: GoogleFonts.tajawal(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF1A1A2E)),
                ),
                GestureDetector(
                  onTap: () => context.push('/admin/news/create'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF052011), Color(0xFF1A6B3A)]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.post_add_rounded, color: Colors.white, size: 16),
                        const SizedBox(width: 6),
                        Text('خبر جديد', style: GoogleFonts.tajawal(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            newsAsync.when(
              data: (posts) {
                if (posts.isEmpty) {
                  return const _EmptyState(message: 'لا توجد أخبار حالياً — انشر أول خبر!', icon: Icons.newspaper_rounded);
                }
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: posts.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return _AdminNewsCard(post: posts[index])
                        .animate(delay: (index * 80).ms)
                        .fadeIn()
                        .slideY(begin: 0.05);
                  },
                );
              },
              loading: () => const _LoadingShimmer(),
              error: (e, _) => _ErrorState(error: e.toString()),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 4: REPORTS
// ─────────────────────────────────────────────────────────────────────────────
class _ReportsTab extends ConsumerWidget {
  const _ReportsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportsAsync = ref.watch(adminReportsProvider);

    return RefreshIndicator(
      color: AppTheme.primaryColor,
      onRefresh: () async => ref.invalidate(adminReportsProvider),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(
              title: 'البلاغات المدنية',
              subtitle: 'متابعة بلاغات التخريب أو الإهمال للمواقع التراثية',
              icon: Icons.flag_rounded,
            ).animate().fadeIn(delay: 100.ms),
            const SizedBox(height: 24),
            reportsAsync.when(
              data: (reports) {
                if (reports.isEmpty) {
                  return const _EmptyState(message: 'لا توجد بلاغات حالياً', icon: Icons.flag_outlined);
                }
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: reports.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) => _ReportCard(
                    title: reports[i]['incidentCategory']?.toString() ?? 'بلاغ عام',
                    description: reports[i]['description']?.toString() ?? '',
                    status: reports[i]['status']?.toString() ?? 'PENDING',
                  ).animate(delay: (i * 80).ms).fadeIn().slideY(begin: 0.05),
                );
              },
              loading: () => const _LoadingShimmer(),
              error: (e, _) => _ErrorState(error: e.toString()),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 5: FINANCIALS
// ─────────────────────────────────────────────────────────────────────────────
class _FinancialsTab extends ConsumerWidget {
  const _FinancialsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contributionsAsync = ref.watch(adminContributionsProvider);
    final finService = ref.read(financialServiceProvider);

    return RefreshIndicator(
      color: AppTheme.primaryColor,
      onRefresh: () async => ref.invalidate(adminContributionsProvider),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(
              title: 'المساهمات المالية',
              subtitle: 'التحقق من وصول اشتراكات العضوية والتبرعات',
              icon: Icons.account_balance_wallet_rounded,
            ).animate().fadeIn(delay: 100.ms),
            const SizedBox(height: 24),
            contributionsAsync.when(
              data: (items) {
                if (items.isEmpty) {
                  return const _EmptyState(message: 'لا توجد مساهمات حالياً', icon: Icons.payments_outlined);
                }
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) => _ContributionCard(
                    amount: '${items[i]['amount']} DZD',
                    type: items[i]['type']?.toString() ?? '',
                    status: items[i]['status']?.toString() ?? 'PENDING',
                    onApprove: () async {
                      await finService.reviewContribution(items[i]['_id'], 'VERIFIED');
                      ref.invalidate(adminContributionsProvider);
                      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(_successSnack('✅ تم التحقق من المساهمة'));
                    },
                    onReject: () async {
                      await finService.reviewContribution(items[i]['_id'], 'REJECTED');
                      ref.invalidate(adminContributionsProvider);
                      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(_errorSnack('❌ تم رفض المساهمة'));
                    },
                  ).animate(delay: (i * 80).ms).fadeIn().slideY(begin: 0.05),
                );
              },
              loading: () => const _LoadingShimmer(),
              error: (e, _) => _ErrorState(error: e.toString()),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 6: SETTINGS
// ─────────────────────────────────────────────────────────────────────────────
// ─────────────────────────────────────────────────────────────────────────────
// TAB 6: CMS MANAGEMENT
// ─────────────────────────────────────────────────────────────────────────────
class _CMSTab extends ConsumerWidget {
  const _CMSTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final slidesAsync = ref.watch(heroSlidesProvider);
    final partnersAsync = ref.watch(partnersProvider);
    final leadershipAsync = ref.watch(leadershipProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            title: 'إدارة المحتوى (CMS)',
            subtitle: 'التحكم في الشاشة الرئيسية والشركاء والهيكل التنظيمي',
            icon: Icons.dashboard_customize_rounded,
          ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),
          const SizedBox(height: 24),

          // Hero Management Card
          _CMSManagementCard(
            title: 'شريط الواجهة (Hero Carousel)',
            description: 'تغيير صور العرض والنصوص الترويجية في الصفحة الرئيسية',
            icon: Icons.view_carousel_rounded,
            color: const Color(0xFF6366F1),
            count: slidesAsync.when(data: (d) => '${d.length} شرائح', loading: () => '...', error: (_, __) => '0'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminCmsManageScreen(type: CMSManageType.hero))),
          ),
          const SizedBox(height: 16),

          // Partners Management Card
          _CMSManagementCard(
            title: 'الشركاء والمؤسسات',
            description: 'إضافة وتعديل ملفات الشركاء والاتفاقيات الاستراتيجية',
            icon: Icons.handshake_rounded,
            color: const Color(0xFF10B981),
            count: partnersAsync.when(data: (d) => '${d.length} شركاء', loading: () => '...', error: (_, __) => '0'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminCmsManageScreen(type: CMSManageType.partner))),
          ),
          const SizedBox(height: 16),

          // Leadership Management Card
          _CMSManagementCard(
            title: 'المكتب التنفيذي',
            description: 'إدارة أعضاء مكتب الجمعية وتحديث بياناتهم وصورهم',
            icon: Icons.account_box_rounded,
            color: const Color(0xFFF59E0B),
            count: leadershipAsync.when(data: (d) => '${d.length} أعضاء', loading: () => '...', error: (_, __) => '0'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminCmsManageScreen(type: CMSManageType.leadership))),
          ),

          const SizedBox(height: 32),
          _GlassInfoCard(
            title: 'تنبيه أمني',
            message: 'جميع التغييرات هنا تظهر مباشرة لجميع مستخدمي التطبيق. يرجى التأكد من جودة الصور ودقة النصوص قبل الحفظ.',
            icon: Icons.security_rounded,
          ),
        ],
      ),
    );
  }
}

class _CMSManagementCard extends StatelessWidget {
  final String title;
  final String description;
  final String count;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _CMSManagementCard({
    required this.title,
    required this.description,
    required this.count,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.tajawal(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              count,
                              style: TextStyle(
                                color: color,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: GoogleFonts.tajawal(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.chevron_left_rounded, color: Colors.grey.shade300),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassInfoCard extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  const _GlassInfoCard({required this.title, required this.message, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryColor, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.tajawal(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  message,
                  style: GoogleFonts.tajawal(
                    fontSize: 11,
                    color: AppTheme.primaryColor.withValues(alpha: 0.7),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
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
      if (mounted) _feeController.text = (s['annualMembershipFee'] ?? 2000).toString();
    });
  }

  @override
  void dispose() {
    _feeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            title: 'إعدادات المنصة',
            subtitle: 'التحكم في الرسوم والمحتوى الإخباري والأنشطة',
            icon: Icons.settings_rounded,
          ).animate().fadeIn(delay: 100.ms),
          const SizedBox(height: 24),

          // Fee settings card
          _SettingsItemCard(
            title: 'الاشتراك السنوي الوطني',
            icon: Icons.payments_rounded,
            iconColor: const Color(0xFF15803D),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _feeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      suffixText: 'DZD',
                      suffixStyle: GoogleFonts.tajawal(fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () async {
                    final fee = int.tryParse(_feeController.text) ?? 2000;
                    await ref.read(financialServiceProvider).updateMembershipFee(fee);
                    if (mounted) ScaffoldMessenger.of(context).showSnackBar(_successSnack('✅ تم حفظ الرسوم'));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('حفظ'),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 200.ms),

          const SizedBox(height: 16),

          // Quick links card
          _SettingsItemCard(
            title: 'روابط سريعة',
            icon: Icons.link_rounded,
            iconColor: const Color(0xFF6D28D9),
            child: Column(
              children: [
                _QuickLinkTile(
                  icon: Icons.event_note_rounded,
                  label: 'إنشاء نشاط جديد',
                  onTap: () => context.push('/admin/events/create'),
                ),
                const Divider(height: 1),
                _QuickLinkTile(
                  icon: Icons.post_add_rounded,
                  label: 'نشر خبر جديد',
                  onTap: () => context.push('/admin/news/create'),
                ),
                const Divider(height: 1),
                _QuickLinkTile(
                  icon: Icons.people_rounded,
                  label: 'طلبات العضوية',
                  onTap: () => DefaultTabController.of(context).animateTo(0),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 300.ms),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PREMIUM ADMIN EVENT CARD — with PopupMenu
// ─────────────────────────────────────────────────────────────────────────────
class _AdminEventCard extends ConsumerWidget {
  final ActivityEvent event;
  const _AdminEventCard({required this.event});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(topRight: Radius.circular(18), bottomRight: Radius.circular(18)),
            child: Image.network(
              event.imageUrl,
              width: 80, height: 80,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 80, height: 80,
                color: AppTheme.primaryColor.withValues(alpha: 0.08),
                child: const Icon(Icons.event_rounded, color: AppTheme.primaryColor, size: 32),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: InkWell(
              onTap: () => context.push('/admin/events/create', extra: event),
              borderRadius: const BorderRadius.only(topRight: Radius.circular(18), bottomRight: Radius.circular(18)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.titleAr,
                      style: GoogleFonts.tajawal(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: const Color(0xFF1A1A2E),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_rounded, size: 12, color: AppTheme.secondaryColor),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('dd MMM yyyy', 'ar').format(event.date),
                          style: GoogleFonts.tajawal(fontSize: 11, color: AppTheme.secondaryColor),
                        ),
                        if (event.isFeatured) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.accentColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text('مميّزة', style: GoogleFonts.tajawal(fontSize: 9, color: AppTheme.accentColor, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded, color: Color(0xFF94A3B8), size: 22),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 8,
            onSelected: (value) async {
              if (value == 'edit') {
                context.push('/admin/events/create', extra: event);
              } else if (value == 'delete') {
                final confirmed = await _confirmDelete(context, 'حذف النشاط', event.titleAr);
                if (confirmed == true) {
                  await ref.read(eventServiceProvider).deleteEvent(event.id);
                  ref.invalidate(adminEventsProvider);
                  ref.invalidate(upcomingEventsProvider);
                  if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(_errorSnack('🗑️ تم حذف النشاط'));
                }
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'edit',
                child: Row(children: [
                  Icon(Icons.edit_outlined, size: 18, color: AppTheme.primaryColor),
                  const SizedBox(width: 10),
                  Text('تعديل', style: GoogleFonts.tajawal(fontWeight: FontWeight.w600)),
                ]),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(children: [
                  const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.red),
                  const SizedBox(width: 10),
                  Text('حذف', style: GoogleFonts.tajawal(fontWeight: FontWeight.w600, color: Colors.red)),
                ]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PREMIUM ADMIN NEWS CARD — with PopupMenu
// ─────────────────────────────────────────────────────────────────────────────
class _AdminNewsCard extends ConsumerWidget {
  final NewsPost post;
  const _AdminNewsCard({required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              post.isPinned ? Icons.push_pin_rounded : Icons.article_rounded,
              color: AppTheme.primaryColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: InkWell(
              onTap: () => context.push('/admin/news/create', extra: post),
              borderRadius: BorderRadius.circular(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.titleAr,
                    style: GoogleFonts.tajawal(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: const Color(0xFF1A1A2E),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _categoryLabel(post.category),
                      style: GoogleFonts.tajawal(fontSize: 10, color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded, color: Color(0xFF94A3B8), size: 22),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 8,
            onSelected: (value) async {
              if (value == 'edit') {
                context.push('/admin/news/create', extra: post);
              } else if (value == 'delete') {
                final confirmed = await _confirmDelete(context, 'حذف الخبر', post.titleAr);
                if (confirmed == true) {
                  await ref.read(newsServiceProvider).deletePost(post.id);
                  ref.invalidate(adminNewsProvider);
                  ref.invalidate(newsProvider);
                  if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(_errorSnack('🗑️ تم حذف الخبر'));
                }
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'edit',
                child: Row(children: [
                  Icon(Icons.edit_outlined, size: 18, color: AppTheme.primaryColor),
                  const SizedBox(width: 10),
                  Text('تعديل', style: GoogleFonts.tajawal(fontWeight: FontWeight.w600)),
                ]),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(children: [
                  const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.red),
                  const SizedBox(width: 10),
                  Text('حذف', style: GoogleFonts.tajawal(fontWeight: FontWeight.w600, color: Colors.red)),
                ]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _categoryLabel(String cat) {
    const map = {
      'ANNOUNCEMENT': 'إعلان',
      'PARTNERSHIP': 'شراكة رسمية',
      'EVENT_REPORT': 'تقرير نشاط',
    };
    return map[cat] ?? 'عام';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MEMBERSHIP REQUEST CARD
// ─────────────────────────────────────────────────────────────────────────────
class _MembershipRequestCard extends StatelessWidget {
  final MembershipRequest request;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const _MembershipRequestCard({
    required this.request,
    required this.onApprove,
    required this.onReject,
  });

  Color _statusColor(String s) {
    if (s == 'APPROVED') return const Color(0xFF15803D);
    if (s == 'REJECTED') return const Color(0xFFB91C1C);
    return const Color(0xFFB45309);
  }

  String _statusLabel(String s) {
    if (s == 'APPROVED') return 'مقبول';
    if (s == 'REJECTED') return 'مرفوض';
    return 'قيد الدراسة';
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(request.status);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46, height: 46,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF052011), Color(0xFF1A6B3A)]),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    request.fullName.isNotEmpty ? request.fullName[0] : 'م',
                    style: GoogleFonts.tajawal(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.fullName,
                      style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 14, color: const Color(0xFF1A1A2E)),
                    ),
                    Text(
                      '${request.submissionDate.day}/${request.submissionDate.month}/${request.submissionDate.year}',
                      style: GoogleFonts.tajawal(fontSize: 11, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  _statusLabel(request.status),
                  style: GoogleFonts.tajawal(fontSize: 11, color: statusColor, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          if (request.status == 'SUBMITTED') ...[
            const SizedBox(height: 16),
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onReject,
                    icon: const Icon(Icons.close_rounded, size: 16),
                    label: Text('رفض', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFB91C1C),
                      side: const BorderSide(color: Color(0xFFB91C1C)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onApprove,
                    icon: const Icon(Icons.check_rounded, size: 16),
                    label: Text('قبول', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF15803D),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
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

// ─────────────────────────────────────────────────────────────────────────────
// REPORT CARD
// ─────────────────────────────────────────────────────────────────────────────
class _ReportCard extends StatelessWidget {
  final String title, description, status;
  const _ReportCard({required this.title, required this.description, required this.status});

  @override
  Widget build(BuildContext context) {
    final isResolved = status == 'RESOLVED';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Row(
        children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(
              color: isResolved ? const Color(0xFF15803D).withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isResolved ? Icons.check_circle_rounded : Icons.flag_rounded,
              color: isResolved ? const Color(0xFF15803D) : Colors.red,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 13)),
                if (description.isNotEmpty)
                  Text(description, style: GoogleFonts.tajawal(fontSize: 11, color: Colors.grey.shade500), maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isResolved ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              isResolved ? 'محلول' : 'معلّق',
              style: GoogleFonts.tajawal(fontSize: 10, fontWeight: FontWeight.bold, color: isResolved ? const Color(0xFF15803D) : Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CONTRIBUTION CARD
// ─────────────────────────────────────────────────────────────────────────────
class _ContributionCard extends StatelessWidget {
  final String amount, type, status;
  final VoidCallback onApprove, onReject;
  const _ContributionCard({required this.amount, required this.type, required this.status, required this.onApprove, required this.onReject});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 46, height: 46,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF6D28D9), Color(0xFF7C3AED)]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.payments_rounded, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(amount, style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 16, color: const Color(0xFF6D28D9))),
                    Text(type, style: GoogleFonts.tajawal(fontSize: 11, color: Colors.grey.shade500)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: status == 'VERIFIED' ? const Color(0xFFDCFCE7) : const Color(0xFFFFF7ED),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  status == 'VERIFIED' ? 'مُتحقق' : 'انتظار',
                  style: GoogleFonts.tajawal(fontSize: 10, fontWeight: FontWeight.bold, color: status == 'VERIFIED' ? const Color(0xFF15803D) : const Color(0xFFB45309)),
                ),
              ),
            ],
          ),
          if (status == 'PENDING') ...[
            const SizedBox(height: 14),
            const Divider(height: 1),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onReject,
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.red, side: const BorderSide(color: Colors.red), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    child: Text('رفض', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onApprove,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF15803D), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    child: Text('تحقق', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
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

// ─────────────────────────────────────────────────────────────────────────────
// SHARED UI WIDGETS
// ─────────────────────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title, subtitle;
  final IconData icon;
  const _SectionHeader({required this.title, required this.subtitle, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF052011), Color(0xFF1A6B3A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.tajawal(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF1A1A2E))),
              Text(subtitle, style: GoogleFonts.tajawal(fontSize: 11, color: Colors.grey.shade500)),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Gradient gradient;
  const _StatCard({required this.label, required this.value, required this.icon, required this.gradient});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 12, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white.withValues(alpha: 0.8), size: 22),
            const SizedBox(height: 12),
            Text(
              value,
              style: GoogleFonts.tajawal(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white, height: 1),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.tajawal(fontSize: 10, color: Colors.white.withValues(alpha: 0.75), letterSpacing: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;
  final IconData icon;
  const _EmptyState({required this.message, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 56, color: const Color(0xFFCBD5E1)),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: GoogleFonts.tajawal(color: const Color(0xFF94A3B8), fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String error;
  const _ErrorState({required this.error});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: Color(0xFFB91C1C), size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'تعذّر الاتصال بالخادم. تأكد من تشغيل NestJS.\n$error',
              style: GoogleFonts.tajawal(color: const Color(0xFFB91C1C), fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingShimmer extends StatelessWidget {
  const _LoadingShimmer();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        3,
        (i) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(16),
            ),
          ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1200.ms, color: Colors.white.withValues(alpha: 0.6)),
        ),
      ),
    );
  }
}

class _SettingsItemCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Widget child;
  const _SettingsItemCard({required this.title, required this.icon, required this.iconColor, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Text(title, style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 14, color: const Color(0xFF1A1A2E))),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _QuickLinkTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickLinkTile({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppTheme.primaryColor, size: 20),
      title: Text(label, style: GoogleFonts.tajawal(fontSize: 13, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFFCBD5E1)),
      onTap: onTap,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HELPERS
// ─────────────────────────────────────────────────────────────────────────────
SnackBar _successSnack(String msg) => SnackBar(
  content: Text(msg, style: GoogleFonts.tajawal()),
  backgroundColor: const Color(0xFF15803D),
  behavior: SnackBarBehavior.floating,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  margin: const EdgeInsets.all(12),
);

SnackBar _errorSnack(String msg) => SnackBar(
  content: Text(msg, style: GoogleFonts.tajawal()),
  backgroundColor: const Color(0xFFB91C1C),
  behavior: SnackBarBehavior.floating,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  margin: const EdgeInsets.all(12),
);

Future<bool?> _confirmDelete(BuildContext context, String title, String name) {
  return showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      title: Row(children: [
        const Icon(Icons.warning_amber_rounded, color: Colors.deepOrange),
        const SizedBox(width: 8),
        Text(title, style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
      ]),
      content: Text('هل تريد حذف "$name" نهائياً؟ لا يمكن التراجع.', style: GoogleFonts.tajawal()),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text('إلغاء', style: GoogleFonts.tajawal()),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          child: Text('حذف نهائياً', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
        ),
      ],
    ),
  );
}
