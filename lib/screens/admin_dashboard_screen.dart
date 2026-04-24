import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ebzim_app/core/common_widgets/ebzim_logo.dart';
import 'package:ebzim_app/core/services/admin_user_service.dart';
import 'package:ebzim_app/core/services/user_profile_service.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:ebzim_app/core/services/web_helper.dart';
import 'package:ebzim_app/core/common_widgets/ebzim_project_timeline.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/services/auth_service.dart';
import 'package:ebzim_app/core/services/event_service.dart';
import 'package:ebzim_app/core/services/news_service.dart';
import 'package:ebzim_app/core/services/report_service.dart';
import 'package:ebzim_app/core/services/financial_service.dart';
import 'package:ebzim_app/core/services/cms_content_service.dart';
import 'package:ebzim_app/screens/admin/tabs/membership_tab.dart';
import 'package:ebzim_app/screens/admin/tabs/users_tab.dart';
import 'package:ebzim_app/screens/admin/tabs/cms_tab.dart';
import 'package:ebzim_app/screens/admin/tabs/events_tab.dart';
import 'package:ebzim_app/screens/admin/tabs/news_tab.dart';
import 'package:ebzim_app/screens/admin/tabs/projects_tab.dart';
import 'package:ebzim_app/screens/admin/tabs/reports_tab.dart';
import 'package:ebzim_app/screens/admin/tabs/financials_tab.dart';
import 'package:ebzim_app/screens/admin/tabs/settings_tab.dart';


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

    final userAsync = ref.watch(currentUserProvider);
    final user = userAsync.value;
    final isSuperAdmin = user?.role == EbzimRole.superAdmin;


    final List<Map<String, dynamic>> allTabs = [
      {
        'icon': Icons.group_add_rounded,
        'text': 'العضوية',
        'view': MembershipTab(),
      },
      {
        'icon': Icons.people_alt_rounded,
        'text': 'المستخدمون',
        'view': UsersTab(),
      },
      {
        'icon': Icons.dashboard_customize_rounded,
        'text': 'المحتوى',
        'view': CMSTab(),
      },
      {
        'icon': Icons.event_rounded,
        'text': 'الأنشطة',
        'view': EventsTab(),
      },
      {
        'icon': Icons.newspaper_rounded,
        'text': 'الأخبار',
        'view': NewsTab(),
      },
      {
        'icon': Icons.architecture_rounded,
        'text': 'المشاريع',
        'view': ProjectsTab(),
      },
      {
        'icon': Icons.flag_rounded,
        'text': 'البلاغات',
        'view': ReportsTab(),
      },
      if (isSuperAdmin) ...[
        {
          'icon': Icons.account_balance_wallet_rounded,
          'text': 'المساهمات',
          'view': FinancialsTab(),
        },
        {
          'icon': Icons.settings_rounded,
          'text': 'الإعدادات',
          'view': SettingsTab(),
        },
      ],
    ];

    return DefaultTabController(
      length: allTabs.length,
      child: Scaffold(
        backgroundColor: const Color(0xFFE2E9E5), // Sovereign Sage
        body: NestedScrollView(
          headerSliverBuilder: (_, _) => [
            SliverAppBar(
              expandedHeight: 320, // Increased to fix content overflow
              floating: false,
              pinned: true,
              backgroundColor: AppTheme.primaryColor,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 20,
                ),
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
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('إلغاء'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
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
                      colors: [Color(0xFF010A08), Color(0xFF052011)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 800),
                      padding: const EdgeInsets.only(
                        top: 40,
                        bottom: 40,
                        left: 24,
                        right: 24,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const EbzimLogo(size: 40, isEngraved: true),
                          const SizedBox(height: 12),
                          // Breadcrumb-style indicator
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'الرئيسية'.toUpperCase(),
                                style: GoogleFonts.playfairDisplay(
                                  color: Colors.white.withValues(alpha: 0.5),
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                child: Icon(
                                  Icons.chevron_left_rounded,
                                  size: 10,
                                  color: Colors.white.withValues(alpha: 0.3),
                                ),
                              ),
                              Text(
                                (isSuperAdmin
                                        ? 'إشراف المشرف العام'
                                        : 'إدارة النظام')
                                    .toUpperCase(),
                                style: GoogleFonts.playfairDisplay(
                                  color: AppTheme.accentColor.withValues(alpha: 0.8),
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Bold centered title
                          Text(
                            isSuperAdmin
                                ? 'لوحة السيادة والتحكم [V1.2]'
                                : 'لوحة الإدارة الشاملة [V1.2]',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.tajawal(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF4ADE80),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFF4ADE80),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  isSuperAdmin
                                      ? 'أهلاً بك يا مشرف النظام. جميع الصلاحيات مفعلة.'
                                      : 'المركز الرئيسي للتحكم والعمليات',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.tajawal(
                                    fontSize: 11,
                                    color: Colors.white.withValues(alpha: 0.8),
                                    fontWeight: FontWeight.w500,
                                  ),
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
                    labelStyle: GoogleFonts.tajawal(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    unselectedLabelStyle: GoogleFonts.tajawal(fontSize: 12),
                    tabs: allTabs
                        .map(
                          (t) => Tab(
                            icon: Icon(t['icon'], size: 18),
                            text: t['text'],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ],
          body: TabBarView(
            children: allTabs.map((t) => t['view'] as Widget).toList(),
          ),
        ),
      ),
    );
  }
}

