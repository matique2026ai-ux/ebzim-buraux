import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/news_service.dart';
import '../../../core/models/news_post.dart';
import 'admin_shared_components.dart';

class NewsTab extends ConsumerWidget {
  const NewsTab({super.key});

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
            AdminSharedComponents.buildSectionHeader(
              title: 'إدارة الأخبار',
              subtitle: 'نشر المستجدات والشراكات الرسمية',
              icon: Icons.newspaper_rounded,
            ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),
            const SizedBox(height: 20),
            newsAsync.when(
              data: (allPosts) {
                final posts = allPosts.where((p) => p.isInstitutionalNews).toList();
                return Row(
                  children: [
                    AdminSharedComponents.buildStatCard(
                      label: 'إجمالي المقالات',
                      value: '${posts.length}',
                      icon: Icons.article_outlined,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF052011), Color(0xFF1A6B3A)],
                      ),
                    ),
                    const SizedBox(width: 12),
                    AdminSharedComponents.buildStatCard(
                      label: 'مقالات مثبتة',
                      value: posts.where((p) => p.isPinned).length.toString(),
                      icon: Icons.push_pin_rounded,
                      gradient: const LinearGradient(
                        colors: [AppTheme.heritageOrange, Color(0xFFD35400)],
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 200.ms);
              },
              loading: () => const AdminSharedComponents.LoadingShimmer(),
              error: (_, __) => const SizedBox(),
            ),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'آخر المنشورات',
                  style: GoogleFonts.tajawal(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF052011),
                  ),
                ),
                GestureDetector(
                  onTap: () => context.push('/admin/news/create'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF052011), Color(0xFF1A6B3A)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.post_add_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'خبر جديد',
                          style: GoogleFonts.tajawal(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            newsAsync.when(
              data: (posts) {
                const newsCategories = {
                  'ANNOUNCEMENT',
                  'PARTNERSHIP',
                  'EVENT_REPORT',
                };
                final newsPosts = posts
                    .where(
                      (p) =>
                          newsCategories.contains(
                            p.category?.toUpperCase() ?? '',
                          ) ||
                          p.category == null,
                    )
                    .toList();
                if (newsPosts.isEmpty) {
                  return const AdminSharedComponents.EmptyState(
                    message: 'لا توجد أخبار حالياً — انشر أول خبر!',
                    icon: Icons.newspaper_rounded,
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: newsPosts.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return _AdminNewsCard(post: newsPosts[index])
                        .animate(delay: (index * 80).ms)
                        .fadeIn()
                        .slideY(begin: 0.05);
                  },
                );
              },
              loading: () => const AdminSharedComponents.LoadingShimmer(),
              error: (e, _) => AdminSharedComponents.ErrorState(error: e.toString()),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _AdminNewsCard extends StatelessWidget {
  final NewsPost post;
  const _AdminNewsCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            post.imageUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 60,
              height: 60,
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              child: const Icon(Icons.newspaper_rounded, color: AppTheme.primaryColor),
            ),
          ),
        ),
        title: Text(
          post.titleAr,
          style: GoogleFonts.tajawal(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: const Color(0xFF052011),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              DateFormat('dd MMMM yyyy', 'ar').format(post.publishedAt),
              style: GoogleFonts.tajawal(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_left_rounded, color: Colors.grey),
        onTap: () => context.push('/admin/news/create', extra: post),
      ),
    );
  }
}
