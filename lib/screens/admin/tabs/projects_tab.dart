import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/news_service.dart';
import '../../../core/models/news_post.dart';
import 'package:ebzim_app/core/common_widgets/ebzim_project_timeline.dart';
import 'admin_shared_components.dart';

class ProjectsTab extends ConsumerWidget {
  const ProjectsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsAsync = ref.watch(adminNewsProvider);

    return RefreshIndicator(
      color: AppTheme.primaryColor,
      onRefresh: () async => ref.invalidate(adminNewsProvider),
      child: newsAsync.when(
        data: (allPosts) {
          final projects = allPosts.where((p) => p.contentType == 'PROJECT' || p.isFieldProject).toList();
          final avgProgress = projects.isEmpty
              ? 0
              : (projects
                            .map((p) => (p.progressPercentage))
                            .reduce((a, b) => a + b) /
                        projects.length *
                        100)
                    .toInt();

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AdminSectionHeader(
                  title: 'إدارة الأنشطة والبرامج الجمعوية',
                  subtitle: 'إدارة مبادرات الجمعية الولائية وتقارير الإنجاز الميداني',
                  icon: Icons.architecture_rounded,
                ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),
                const SizedBox(height: 20),
                Row(
                  children: [
                    AdminStatCard(
                      label: 'مشاريع ميدانية',
                      value: '${projects.length}',
                      icon: Icons.construction_rounded,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0369A1), Color(0xFF0EA5E9)],
                      ),
                    ),
                    const SizedBox(width: 12),
                    AdminStatCard(
                      label: 'نسبة الإنجاز العام',
                      value: '$avgProgress%',
                      icon: Icons.trending_up_rounded,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF15803D), Color(0xFF22C55E)],
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 200.ms),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'قائمة المشاريع والتقدم',
                      style: GoogleFonts.tajawal(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF052011),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.push(
                        '/admin/projects/create',
                        extra: {'initialCategory': 'RESTORATION'},
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF0369A1), Color(0xFF0EA5E9)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.add_task_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'مشروع جديد',
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
                if (projects.isEmpty)
                  const AdminEmptyState(
                    message: 'لا توجد مشاريع مسجلة بعد',
                    icon: Icons.architecture_rounded,
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: projects.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final post = projects[index];
                      return _AdminProjectCard(post: post)
                          .animate(delay: (index * 80).ms)
                          .fadeIn()
                          .slideY(begin: 0.05);
                    },
                  ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
        loading: () => const AdminLoadingShimmer(),
        error: (e, _) => AdminErrorState(error: e.toString()),
      ),
    );
  }
}

class _AdminProjectCard extends ConsumerStatefulWidget {
  final NewsPost post;
  const _AdminProjectCard({required this.post});

  @override
  ConsumerState<_AdminProjectCard> createState() => _AdminProjectCardState();
}

class _AdminProjectCardState extends ConsumerState<_AdminProjectCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: widget.post.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => Container(
                    color: Colors.grey.shade100,
                    child: const Icon(Icons.image_not_supported_outlined),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.post.titleAr,
                      style: GoogleFonts.tajawal(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: widget.post.progressPercentage,
                      backgroundColor: Colors.blue.shade50,
                      color: Colors.blue.shade600,
                      minHeight: 4,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          'تقدم المشروع: ${(widget.post.progressPercentage * 100).toInt()}%',
                          style: GoogleFonts.tajawal(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'تحديث: ${DateFormat('yyyy/MM/dd').format(widget.post.publishedAt)}',
                          style: GoogleFonts.tajawal(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.edit_note_rounded,
                      color: Colors.blue,
                    ),
                    onPressed: () => context.push(
                      '/admin/projects/create',
                      extra: widget.post,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.redAccent,
                    ),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('حذف المشروع'),
                          content: Text(
                            'هل أنت متأكد من حذف مشروع "${widget.post.titleAr}" نهائياً؟',
                          ),
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
                              child: const Text('حذف نهائي'),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        try {
                          await ref
                              .read(newsServiceProvider)
                              .deletePost(widget.post.id);
                          ref.invalidate(adminNewsProvider);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('✅ تم حذف المشروع بنجاح'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('❌ فشل الحذف: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      _isExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: Colors.grey,
                    ),
                    onPressed: () => setState(() => _isExpanded = !_isExpanded),
                  ),
                ],
              ),
            ],
          ),
          if (_isExpanded) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(
                  0xFF0F1A0F,
                ), // Dark background for the timeline to make it pop
                borderRadius: BorderRadius.circular(14),
              ),
              child: EbzimProjectTimeline(
                milestones: widget.post.milestones,
                lang: 'ar',
              ),
            ),
          ],
        ],
      ),
    );
  }
}
