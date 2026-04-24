import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/cms_content_service.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/models/user_profile.dart';
import 'admin_shared_components.dart';

class CMSTab extends ConsumerWidget {
  const CMSTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // isSuperAdmin check is already handled in the service/UI navigation if needed,
    // but here we just show the options.
    
    final slidesAsync = ref.watch(heroSlidesProvider);
    final onboardingAsync = ref.watch(onboardingSlidesProvider);
    final partnersAsync = ref.watch(partnersProvider);
    final leadershipAsync = ref.watch(leadershipProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AdminSectionHeader(
            title: 'إدارة المحتوى (CMS)',
            subtitle: 'التحكم في الشاشة الرئيسية والشركاء والهيكل التنظيمي',
            icon: Icons.dashboard_customize_rounded,
          ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),
          const SizedBox(height: 24),

          _CMSManagementCard(
            title: 'شريط الواجهة (Hero Carousel)',
            description: 'تغيير صور العرض والنصوص الترويجية في الصفحة الرئيسية',
            icon: Icons.view_carousel_rounded,
            color: const Color(0xFF6366F1),
            count: slidesAsync.when(
              data: (d) => '${d.length} شرائح',
              loading: () => '...',
              error: (_, __) => '0',
            ),
            onTap: () => context.go('/admin/cms/hero'),
          ),
          const SizedBox(height: 16),

          _CMSManagementCard(
            title: 'شاشة الترحيب (Onboarding)',
            description: 'التحكم في الصور والنصوص التي تظهر للمستخدم الجديد',
            icon: Icons.door_front_door_rounded,
            color: const Color(0xFF8B5CF6),
            count: onboardingAsync.when(
              data: (d) => '${d.length} شرائح',
              loading: () => '...',
              error: (_, __) => '0',
            ),
            onTap: () => context.go('/admin/cms/onboarding'),
          ),
          const SizedBox(height: 16),

          _CMSManagementCard(
            title: 'الشركاء والمؤسسات',
            description: 'إضافة وتعديل ملفات الشركاء والاتفاقيات الاستراتيجية',
            icon: Icons.handshake_rounded,
            color: const Color(0xFF10B981),
            count: partnersAsync.when(
              data: (d) => '${d.length} شركاء',
              loading: () => '...',
              error: (_, __) => '0',
            ),
            onTap: () => context.go('/admin/cms/partner'),
          ),
          const SizedBox(height: 16),

          _CMSManagementCard(
            title: 'المكتب التنفيذي',
            description: 'إدارة أعضاء مكتب الجمعية وتحديث بياناتهم وصورهم',
            icon: Icons.account_box_rounded,
            color: const Color(0xFFF59E0B),
            count: leadershipAsync.when(
              data: (d) => '${d.length} أعضاء',
              loading: () => '...',
              error: (_, __) => '0',
            ),
            onTap: () => context.go('/admin/cms/leadership'),
          ),

          const SizedBox(height: 32),
          const AdminGlassInfoCard(
            title: 'تنبيه أمني',
            message:
                'جميع التغييرات هنا تظهر مباشرة لجميع مستخدمي التطبيق. يرجى التأكد من جودة الصور ودقة النصوص قبل الحفظ.',
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
            color: Colors.black.withValues(alpha: 0.1),
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
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
