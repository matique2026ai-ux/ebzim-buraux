import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/event_service.dart';
import 'admin_shared_components.dart';

class EventsTab extends ConsumerWidget {
  const EventsTab({super.key});

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
            const AdminSectionHeader(
              title: 'إدارة الأنشطة',
              subtitle: 'تنظيم الفعاليات والورشات الميدانية',
              icon: Icons.event_available_rounded,
            ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),
            const SizedBox(height: 20),
            eventsAsync.when(
              data: (events) => Row(
                children: [
                  AdminStatCard(
                    label: 'أنشطة مجدولة',
                    value: '${events.length}',
                    icon: Icons.calendar_month_rounded,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF052011), Color(0xFF1A6B3A)],
                    ),
                  ),
                  const SizedBox(width: 12),
                  AdminStatCard(
                    label: 'فعاليات مميزة',
                    value: events.where((e) => e.isFeatured).length.toString(),
                    icon: Icons.star_rounded,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFD4AF37), Color(0xFFB8960C)],
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 200.ms),
              loading: () => const AdminLoadingShimmer(),
              error: (_, __) => const SizedBox(),
            ),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'قائمة الأنشطة',
                  style: GoogleFonts.tajawal(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF052011),
                  ),
                ),
                GestureDetector(
                  onTap: () => context.push('/admin/events/create'),
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
                          Icons.add_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'نشاط جديد',
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
            eventsAsync.when(
              data: (events) {
                if (events.isEmpty) {
                  return const AdminEmptyState(
                    message: 'لا توجد أنشطة حالياً — أضف نشاطاً جديداً!',
                    icon: Icons.event_busy_rounded,
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: events.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return _AdminEventCard(event: events[index])
                        .animate(delay: (index * 80).ms)
                        .fadeIn()
                        .slideY(begin: 0.05);
                  },
                );
              },
              loading: () => const AdminLoadingShimmer(),
              error: (e, _) => AdminErrorState(error: e.toString()),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

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
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            event.imageUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 60,
              height: 60,
              color: AppTheme.primaryColor.withOpacity(0.1),
              child: const Icon(
                Icons.event_note_rounded,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
        ),
        title: Text(
          event.titleAr,
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
              DateFormat('dd MMMM yyyy', 'ar').format(event.date),
              style: GoogleFonts.tajawal(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(
                Icons.edit_rounded,
                color: Colors.blueGrey,
                size: 20,
              ),
              tooltip: 'تعديل',
              onPressed: () =>
                  context.push('/admin/events/create', extra: event),
            ),
            IconButton(
              icon: const Icon(
                Icons.delete_rounded,
                color: Colors.red,
                size: 20,
              ),
              tooltip: 'حذف',
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text(
                      'حذف النشاط',
                      style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
                    ),
                    content: Text(
                      'هل أنت متأكد من حذف "${event.titleAr}"؟',
                      style: GoogleFonts.tajawal(),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text('إلغاء', style: GoogleFonts.tajawal()),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () => Navigator.pop(context, true),
                        child: Text(
                          'حذف',
                          style: GoogleFonts.tajawal(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
                if (confirm == true && context.mounted) {
                  try {
                    await ref.read(eventServiceProvider).deleteEvent(event.id);
                    ref.invalidate(adminEventsProvider);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'تم حذف النشاط بنجاح',
                            style: GoogleFonts.tajawal(),
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'خطأ في الحذف: $e',
                            style: GoogleFonts.tajawal(),
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                }
              },
            ),
          ],
        ),
        onTap: () => context.push('/admin/events/create', extra: event),
      ),
    );
  }
}
