import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ebzim_app/core/services/admin_user_service.dart';
import 'package:ebzim_app/core/services/user_profile_service.dart';
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
    // Reactive Auth Guard: Redirect to login if session is lost/expired
    final auth = ref.watch(authProvider);
    if (!auth.isAuthenticated && !auth.isInitializing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.go('/login');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return DefaultTabController(
      length: 8,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6F9),
        body: NestedScrollView(
          headerSliverBuilder: (_, __) => [
            SliverAppBar(
              expandedHeight: 165,
              floating: false,
              pinned: true,
              backgroundColor: AppTheme.primaryColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                onPressed: () => context.go('/dashboard'),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.home_rounded, color: Colors.white70),
                  tooltip: 'العودة للموقع',
                  onPressed: () => context.go('/home'),
                ),
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
                      colors: [Color(0xFF03140A), Color(0xFF052011)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center, // Centered horizontally
                        children: [
                          const SizedBox(height: 52), // Space for AppBar leading/actions
                          // Breadcrumb-style indicator (Centered)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'الرئيسية'.toUpperCase(),
                                style: GoogleFonts.inter(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Icon(Icons.chevron_left_rounded, size: 10, color: Colors.white.withValues(alpha: 0.2)),
                              ),
                              Text(
                                'إدارة النظام'.toUpperCase(),
                                style: GoogleFonts.inter(
                                  color: AppTheme.accentColor.withValues(alpha: 0.6),
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          // Smaller, centered bold title
                          Text(
                            'لوحة الإدارة الشاملة',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.tajawal(
                              fontSize: 22, // Decreased from 28 to 22
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 5,
                                height: 5,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF4ADE80),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'المركز الرئيسي للتحكم والعمليات',
                                style: GoogleFonts.tajawal(
                                  fontSize: 10,
                                  color: Colors.white.withValues(alpha: 0.35),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
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
                      Tab(icon: Icon(Icons.people_alt_rounded, size: 18), text: 'المستخدمون'),
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
              _UsersTab(),
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
// TAB 2: REGISTERED USERS
// ─────────────────────────────────────────────────────────────────────────────
class _UsersTab extends ConsumerWidget {
  const _UsersTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(allUsersProvider);

    return RefreshIndicator(
      color: AppTheme.primaryColor,
      onRefresh: () async => ref.invalidate(allUsersProvider),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(
              title: 'إدارة المسجلين',
              subtitle: 'التحكم الكامل في حسابات المستخدمين، الحالة، والصلاحيات',
              icon: Icons.people_alt_rounded,
            ).animate().fadeIn(delay: 100.ms),
            const SizedBox(height: 24),
            
            usersAsync.when(
              data: (users) => Column(
                children: users.map((user) => _UserCard(user: user)).toList(),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error loading users: $e')),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

class _UserCard extends ConsumerWidget {
  final UserProfile user;
  const _UserCard({required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBanned = user.status == 'BANNED';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 50, height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.1), width: 2),
          ),
          child: ClipOval(
            child: user.imageUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: user.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => const CircularProgressIndicator(),
                    errorWidget: (_, __, ___) => const Icon(Icons.person, color: AppTheme.primaryColor),
                  )
                : const Icon(Icons.person, color: AppTheme.primaryColor),
          ),
        ),
        title: Text(
          user.name,
          style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.email, style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade600)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isBanned ? Colors.red.withValues(alpha: 0.1) : Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                user.status ?? 'ACTIVE',
                style: GoogleFonts.tajawal(
                  fontSize: 10, 
                  fontWeight: FontWeight.bold, 
                  color: isBanned ? Colors.red : Colors.green,
                ),
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (val) async {
            if (val == 'ban') {
              await ref.read(adminUserServiceProvider).updateUserStatus(user.id, isBanned ? 'ACTIVE' : 'BANNED');
              ref.invalidate(allUsersProvider);
            } else if (val == 'delete') {
              final confirm = await _confirmDelete(context, 'حذف المستخدم', user.name);
              if (confirm == true) {
                await ref.read(adminUserServiceProvider).deleteUser(user.id);
                ref.invalidate(allUsersProvider);
              }
            }
          },
          itemBuilder: (_) => [
            PopupMenuItem(
              value: 'ban',
              child: Row(
                children: [
                  Icon(isBanned ? Icons.check_circle_outline : Icons.block_flipped, size: 18, color: isBanned ? Colors.green : Colors.orange),
                  const SizedBox(width: 8),
                  Text(isBanned ? 'تفعيل الحساب' : 'حظر الحساب', style: GoogleFonts.tajawal()),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                  const SizedBox(width: 8),
                  Text('حذف الحساب', style: GoogleFonts.tajawal(color: Colors.red)),
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
              title: 'مركز العضوية',
              subtitle: 'إدارة الطلبات، الإحصائيات، ومراقبة نمو الجمعية',
              icon: Icons.group_add_rounded,
            ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),
            const SizedBox(height: 20),
            
            // --- Custom Visual Analytics Section ---
            pendingAsync.when(
              data: (requests) {
                final total = requests.length;
                final approved = requests.where((r) => r.status == 'APPROVED').length;
                final pending = requests.where((r) => r.status == 'SUBMITTED').length;
                final ratio = total > 0 ? (approved / total) : 0.0;
                
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 15, offset: const Offset(0, 5)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.analytics_outlined, size: 18, color: AppTheme.primaryColor.withValues(alpha: 0.5)),
                          const SizedBox(width: 8),
                          Text(
                            'نبض النظام (System Pulse)',
                            style: GoogleFonts.tajawal(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                          ),
                          const Spacer(),
                          Text(
                            'معدل القبول: ${(ratio * 100).toStringAsFixed(0)}%',
                            style: GoogleFonts.tajawal(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF15803D)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Custom Progress Indicator
                      Stack(
                        children: [
                          Container(
                            height: 8,
                            width: double.infinity,
                            decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(4)),
                          ),
                          FractionallySizedBox(
                            widthFactor: ratio,
                            child: Container(
                              height: 8,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(colors: [Color(0xFF052011), Color(0xFF1A6B3A)]),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _MiniMetric(label: 'الإجمالي', value: '$total', color: AppTheme.primaryColor),
                          _MiniMetric(label: 'مقبول', value: '$approved', color: const Color(0xFF15803D)),
                          _MiniMetric(label: 'قيد الانتظار', value: '$pending', color: const Color(0xFFB45309)),
                        ],
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 200.ms).scale(begin: const Offset(0.95, 0.95));
              },
              loading: () => const SizedBox(height: 120),
              error: (_, __) => const SizedBox(),
            ),
            const SizedBox(height: 24),
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
                    gradient: const LinearGradient(colors: [AppTheme.heritageOrange, Color(0xFFD35400)]),
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
    final reportService = ref.read(reportServiceProvider);

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
              title: 'إدارة البلاغات المدنية',
              subtitle: 'تتبع ومعالجة بلاغات حماية التراث والمباني الأثرية',
              icon: Icons.assignment_rounded,
            ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),
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
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, i) {
                    final report = reports[i];
                    return _ReportCard(
                      id: report['_id'],
                      title: report['incidentCategory']?.toString() ?? 'بلاغ عام',
                      description: report['description']?.toString() ?? '',
                      location: report['locationData']?['formattedAddress'] ?? 'موقع غير محدد',
                      status: report['status']?.toString() ?? 'PENDING',
                      date: DateTime.parse(report['createdAt'] ?? DateTime.now().toIso8601String()),
                      onUpdateStatus: (newStatus) async {
                        try {
                          await reportService.updateReportStatus(report['_id'], newStatus);
                          ref.invalidate(adminReportsProvider);
                          if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(_successSnack('✅ تم تحديث حالة البلاغ'));
                        } catch (e) {
                          if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(_errorSnack('❌ خطأ: $e'));
                        }
                      },
                    ).animate(delay: (i * 80).ms).fadeIn().slideY(begin: 0.05);
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
            onTap: () => context.push('/admin/cms/hero'),
          ),
          const SizedBox(height: 16),

          // Partners Management Card
          _CMSManagementCard(
            title: 'الشركاء والمؤسسات',
            description: 'إضافة وتعديل ملفات الشركاء والاتفاقيات الاستراتيجية',
            icon: Icons.handshake_rounded,
            color: const Color(0xFF10B981),
            count: partnersAsync.when(data: (d) => '${d.length} شركاء', loading: () => '...', error: (_, __) => '0'),
            onTap: () => context.push('/admin/cms/partner'),
          ),
          const SizedBox(height: 16),

          // Leadership Management Card
          _CMSManagementCard(
            title: 'المكتب التنفيذي',
            description: 'إدارة أعضاء مكتب الجمعية وتحديث بياناتهم وصورهم',
            icon: Icons.account_box_rounded,
            color: const Color(0xFFF59E0B),
            count: leadershipAsync.when(data: (d) => '${d.length} أعضاء', loading: () => '...', error: (_, __) => '0'),
            onTap: () => context.push('/admin/cms/leadership'),
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
  bool _isClearingCache = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final s = await ref.read(financialServiceProvider).getSettings();
    if (mounted) _feeController.text = (s['annualMembershipFee'] ?? 2000).toString();
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
            title: 'مركز التحكم والإعدادات',
            subtitle: 'إدارة المعايير المالية وأدوات النظام التقنية',
            icon: Icons.admin_panel_settings_rounded,
          ).animate().fadeIn(delay: 100.ms),
          const SizedBox(height: 24),

          // FINANCIAL SECTION
          Text('الإدارة المالية', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey.shade600)),
          const SizedBox(height: 12),
          _SettingsItemCard(
            title: 'رسوم العضوية السنوية',
            icon: Icons.currency_exchange_rounded,
            iconColor: const Color(0xFF15803D),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _feeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '2000',
                      suffixText: 'DZD',
                      suffixStyle: GoogleFonts.tajawal(fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () async {
                    final fee = int.tryParse(_feeController.text) ?? 2000;
                    await ref.read(financialServiceProvider).updateMembershipFee(fee);
                    if (mounted) ScaffoldMessenger.of(context).showSnackBar(_successSnack('✅ تم تحديث الرسوم المالية للمنصة'));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('حفظ', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 200.ms),

          const SizedBox(height: 24),

          // MAINTENANCE SECTION
          Text('صيانة النظام', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey.shade600)),
          const SizedBox(height: 12),
          _SettingsItemCard(
            title: 'العمليات التقنية',
            icon: Icons.settings_suggest_rounded,
            iconColor: const Color(0xFFC2410C),
            child: Column(
              children: [
                _SystemActionTile(
                  icon: Icons.auto_delete_rounded,
                  label: 'تصفية التخزين المؤقت',
                  description: 'إعادة مزامنة البيانات من السيرفر فوراً',
                  isLoading: _isClearingCache,
                  onTap: () async {
                    setState(() => _isClearingCache = true);
                    await Future.delayed(const Duration(seconds: 1)); // Visual feedback
                    ref.invalidate(adminEventsProvider);
                    ref.invalidate(adminNewsProvider);
                    ref.invalidate(pendingMembershipsProvider);
                    if (mounted) {
                      setState(() => _isClearingCache = false);
                      ScaffoldMessenger.of(context).showSnackBar(_successSnack('✨ تم مسح الذاكرة المؤقتة وتحديث البيانات'));
                    }
                  },
                ),
              ],
            ),
          ).animate().fadeIn(delay: 300.ms),

          const SizedBox(height: 24),

          // EXTERNAL TOOLS SECTION
          Text('روابط الإدارة الخارجية', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey.shade600)),
          const SizedBox(height: 12),
          _SettingsItemCard(
            title: 'مركز البيانات والاستضافة',
            icon: Icons.hub_rounded,
            iconColor: const Color(0xFF6D28D9),
            child: Column(
              children: [
                _QuickLinkTile(
                  icon: Icons.cloud_done_rounded,
                  label: 'لوحة استضافة Render (API)',
                  onTap: () => _launchURL('https://dashboard.render.com'),
                ),
                const Divider(height: 1),
                _QuickLinkTile(
                  icon: Icons.storage_rounded,
                  label: 'لوحة MongoDB Atlas (Database)',
                  onTap: () => _launchURL('https://cloud.mongodb.com'),
                ),
                const Divider(height: 1),
                _QuickLinkTile(
                  icon: Icons.code_rounded,
                  label: 'مستودع الكود (GitHub)',
                  onTap: () => _launchURL('https://github.com/matique2026ai-ux/ebzim-buraux'),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 400.ms),

          const SizedBox(height: 48),

          // FOOTER INFO
          Center(
            child: Column(
              children: [
                Text(
                  'إبزيم للتراث والفنون - نسخة المسؤول v1.2.0',
                  style: GoogleFonts.tajawal(fontSize: 10, color: Colors.grey.shade400),
                ),
                const SizedBox(height: 4),
                Text(
                  'تم التطوير بواسطة Antigravity AI',
                  style: GoogleFonts.inter(fontSize: 8, color: Colors.grey.shade300, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    // In a real Flutter app, we use url_launcher package.
    // For this environment, we'll show a snackbar with the link.
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('فتح الرابط: $url', style: GoogleFonts.tajawal()),
          action: SnackBarAction(label: 'إغلاق', textColor: Colors.yellow, onPressed: () {}),
          backgroundColor: AppTheme.primaryColor,
        ),
      );
    }
  }
}

class _SystemActionTile extends StatelessWidget {
  final IconData icon;
  final String label, description;
  final VoidCallback onTap;
  final bool isLoading;

  const _SystemActionTile({
    required this.icon,
    required this.label,
    required this.description,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: Colors.orange.shade700, size: 20),
      ),
      title: Text(label, style: GoogleFonts.tajawal(fontSize: 13, fontWeight: FontWeight.bold)),
      subtitle: Text(description, style: GoogleFonts.tajawal(fontSize: 10, color: Colors.grey.shade500)),
      trailing: isLoading 
        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
        : const Icon(Icons.flash_on_rounded, size: 18, color: Colors.orange),
      onTap: isLoading ? null : onTap,
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
              color: post.isPinned 
                  ? AppTheme.heritageOrange.withValues(alpha: 0.1) 
                  : AppTheme.primaryColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: post.isPinned 
                  ? Border.all(color: AppTheme.heritageOrange.withValues(alpha: 0.3)) 
                  : null,
            ),
            child: Icon(
              post.isPinned ? Icons.push_pin_rounded : Icons.article_rounded,
              color: post.isPinned ? AppTheme.heritageOrange : AppTheme.primaryColor,
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
class _MembershipRequestCard extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
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
                    onPressed: () => _showReviewDialog(context, ref),
                    icon: const Icon(Icons.visibility_rounded, size: 16),
                    label: Text('عرض التفاصيل', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 13)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor,
                      side: BorderSide(color: AppTheme.primaryColor.withValues(alpha: 0.5)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onApprove,
                    icon: const Icon(Icons.check_rounded, size: 16),
                    label: Text('قبول سريع', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 13)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF15803D),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
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

  void _showReviewDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => _MembershipDetailsDialog(request: request, onApprove: onApprove, onReject: onReject),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MEMBERSHIP DETAILS DIALOG (PREMIUM VIEW)
// ─────────────────────────────────────────────────────────────────────────────
class _MembershipDetailsDialog extends StatelessWidget {
  final MembershipRequest request;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const _MembershipDetailsDialog({
    required this.request,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final data = request.data;
    final interests = (data['interests'] as List?)?.cast<String>() ?? [];
    final skills = (data['skills'] as List?)?.cast<String>() ?? [];

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with Gradient
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF03140A), Color(0xFF052011)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person_search_rounded, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'مراجعة طلب العضوية',
                          style: GoogleFonts.tajawal(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          request.fullName,
                          style: GoogleFonts.tajawal(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded, color: Colors.white54),
                  ),
                ],
              ),
            ),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('المعلومات الشخصية', Icons.badge_outlined),
                    const SizedBox(height: 12),
                    _buildInfoGrid([
                      _InfoItem(label: 'رقم الهاتف', value: data['phone'] ?? 'غير متوفر', icon: Icons.phone_android_rounded),
                      _InfoItem(label: 'البريد الإلكتروني', value: data['email'] ?? 'غير متوفر', icon: Icons.alternate_email_rounded),
                      _InfoItem(label: 'الجنس', value: data['gender'] == 'MALE' ? 'ذكر' : 'أنثى', icon: Icons.wc_rounded),
                      _InfoItem(label: 'تاريخ الميلاد', value: data['dob']?.toString().split('T')[0] ?? '-', icon: Icons.cake_outlined),
                    ]),
                    
                    const SizedBox(height: 24),
                    _buildSectionTitle('الاهتمامات والمهارات', Icons.psychology_outlined),
                    const SizedBox(height: 12),
                    Text('الاهتمامات:', style: GoogleFonts.tajawal(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                    const SizedBox(height: 8),
                    _buildChips(interests, const Color(0xFF052011)),
                    const SizedBox(height: 16),
                    Text('المهارات والمؤهلات:', style: GoogleFonts.tajawal(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                    const SizedBox(height: 8),
                    _buildChips(skills, const Color(0xFFD4AF37)),

                    const SizedBox(height: 24),
                    _buildSectionTitle('الدافع للانضمام', Icons.edit_note_rounded),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Text(
                        data['motivation'] ?? 'لا يوجد نص توضيحي',
                        style: GoogleFonts.tajawal(fontSize: 13, color: const Color(0xFF475569), height: 1.6),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Actions
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onReject();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red.shade700,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text('رفض الطلب', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onApprove();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF15803D),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text('قبول العضوية', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppTheme.primaryColor.withValues(alpha: 0.6)),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.tajawal(fontSize: 14, fontWeight: FontWeight.w800, color: AppTheme.primaryColor),
        ),
      ],
    );
  }

  Widget _buildInfoGrid(List<Widget> items) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: items.map((e) => SizedBox(width: 130, child: e)).toList(),
    );
  }

  Widget _buildChips(List<String> labels, Color color) {
    if (labels.isEmpty) return Text('لم يتم التحديد', style: GoogleFonts.tajawal(fontSize: 11, color: Colors.grey));
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: labels.map((label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Text(
          label,
          style: GoogleFonts.tajawal(fontSize: 11, color: color, fontWeight: FontWeight.bold),
        ),
      )).toList(),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoItem({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 12, color: Colors.grey),
            const SizedBox(width: 4),
            Text(label, style: GoogleFonts.tajawal(fontSize: 10, color: Colors.grey.shade600)),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.tajawal(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF1A1A2E)),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}


// ─────────────────────────────────────────────────────────────────────────────
// REPORT CARD
// ─────────────────────────────────────────────────────────────────────────────
class _ReportCard extends StatelessWidget {
  final String id, title, description, status, location;
  final DateTime date;
  final Function(String) onUpdateStatus;

  const _ReportCard({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.location,
    required this.date,
    required this.onUpdateStatus,
  });

  Color _statusColor(String s) {
    switch (s.toUpperCase()) {
      case 'RESOLVED': return const Color(0xFF15803D);
      case 'INVESTIGATING': return const Color(0xFF1D4ED8);
      case 'REJECTED': return const Color(0xFFB91C1C);
      default: return const Color(0xFFB45309);
    }
  }

  String _statusLabel(String s) {
    switch (s.toUpperCase()) {
      case 'RESOLVED': return 'تم الحل';
      case 'INVESTIGATING': return 'قيد المراجعة';
      case 'REJECTED': return 'مرفوض';
      default: return 'بلاغ جديد';
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(status);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: statusColor.withValues(alpha: 0.05),
              child: Row(
                children: [
                  Container(
                    width: 8, height: 8,
                    decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _statusLabel(status),
                    style: GoogleFonts.tajawal(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor),
                  ),
                  const Spacer(),
                  Text(
                    '${date.day}/${date.month}/${date.year}',
                    style: GoogleFonts.tajawal(fontSize: 10, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: AppTheme.primaryColor.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.warning_amber_rounded, size: 18, color: AppTheme.primaryColor),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          title,
                          style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 15, color: const Color(0xFF1A1A2E)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 14, color: Color(0xFF64748B)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          style: GoogleFonts.tajawal(fontSize: 11, color: const Color(0xFF64748B)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    description,
                    style: GoogleFonts.tajawal(fontSize: 13, color: const Color(0xFF475569), height: 1.5),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 20),
                  const Divider(height: 1, color: Color(0xFFF1F5F9)),
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Text('تغيير الحالة:', style: GoogleFonts.tajawal(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
                      const Spacer(),
                      _ActionButton(
                        label: 'مراجعة',
                        icon: Icons.search_rounded,
                        color: const Color(0xFF1D4ED8),
                        onPressed: () => onUpdateStatus('INVESTIGATING'),
                        isActive: status == 'INVESTIGATING',
                      ),
                      const SizedBox(width: 8),
                      _ActionButton(
                        label: 'حل',
                        icon: Icons.check_circle_outline_rounded,
                        color: const Color(0xFF15803D),
                        onPressed: () => onUpdateStatus('RESOLVED'),
                        isActive: status == 'RESOLVED',
                      ),
                      const SizedBox(width: 8),
                      _ActionButton(
                        label: 'رفض',
                        icon: Icons.cancel_outlined,
                        color: const Color(0xFFB91C1C),
                        onPressed: () => onUpdateStatus('REJECTED'),
                        isActive: status == 'REJECTED',
                      ),
                    ],
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

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final bool isActive;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isActive ? null : onPressed,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? color : color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: isActive ? Colors.white : color),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.tajawal(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isActive ? Colors.white : color,
              ),
            ),
          ],
        ),
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

class _MiniMetric extends StatelessWidget {
  final String label, value;
  final Color color;

  const _MiniMetric({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.tajawal(fontSize: 10, color: Colors.grey.shade600)),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    );
  }
}
