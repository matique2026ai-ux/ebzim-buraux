import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/report_service.dart';
import 'admin_shared_components.dart';

class ReportsTab extends ConsumerWidget {
  const ReportsTab({super.key});

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
            AdminSharedComponents.buildSectionHeader(
              title: 'إدارة البلاغات المدنية',
              subtitle: 'تتبع ومعالجة بلاغات حماية التراث والمباني الأثرية',
              icon: Icons.assignment_rounded,
            ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),
            const SizedBox(height: 24),
            reportsAsync.when(
              data: (reports) {
                if (reports.isEmpty) {
                  return const AdminSharedComponents.EmptyState(
                    message: 'لا توجد بلاغات حالياً',
                    icon: Icons.flag_outlined,
                  );
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
                      title:
                          report['incidentCategory']?.toString() ?? 'بلاغ عام',
                      description: report['description']?.toString() ?? '',
                      location:
                          report['locationData']?['formattedAddress'] ??
                          'موقع غير محدد',
                      status: report['status']?.toString() ?? 'PENDING',
                      date: DateTime.parse(
                        report['createdAt'] ?? DateTime.now().toIso8601String(),
                      ),
                      onUpdateStatus: (newStatus) async {
                        try {
                          await reportService.updateReportStatus(
                            report['_id'],
                            newStatus,
                          );
                          ref.invalidate(adminReportsProvider);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('✅ تم تحديث حالة البلاغ'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(
                              SnackBar(
                                content: Text('❌ خطأ: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                    ).animate(delay: (i * 80).ms).fadeIn().slideY(begin: 0.05);
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

class _ReportCard extends StatelessWidget {
  final String id;
  final String title;
  final String description;
  final String location;
  final String status;
  final DateTime date;
  final Function(String) onUpdateStatus;

  const _ReportCard({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.status,
    required this.date,
    required this.onUpdateStatus,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(status);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              title,
              style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              DateFormat('dd/MM/yyyy HH:mm').format(date),
              style: const TextStyle(fontSize: 12),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(description, style: GoogleFonts.tajawal(fontSize: 13)),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    location,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 24),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _StatusAction(
                  label: 'قيد المعالجة',
                  onTap: () => onUpdateStatus('PROCESSING'),
                  color: Colors.blue,
                ),
                const SizedBox(width: 8),
                _StatusAction(
                  label: 'تم الحل',
                  onTap: () => onUpdateStatus('RESOLVED'),
                  color: Colors.green,
                ),
                const SizedBox(width: 8),
                _StatusAction(
                  label: 'مرفوض',
                  onTap: () => onUpdateStatus('REJECTED'),
                  color: Colors.red,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return Colors.orange;
      case 'PROCESSING':
        return Colors.blue;
      case 'RESOLVED':
        return Colors.green;
      case 'REJECTED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class _StatusAction extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color color;

  const _StatusAction({
    required this.label,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: color.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: GoogleFonts.tajawal(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }
}
