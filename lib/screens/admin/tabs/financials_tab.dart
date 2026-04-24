import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/financial_service.dart';
import 'admin_shared_components.dart';

class FinancialsTab extends ConsumerWidget {
  const FinancialsTab({super.key});

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
            const AdminSectionHeader(
              title: 'المساهمات المالية',
              subtitle: 'التحقق من وصول اشتراكات العضوية والتبرعات',
              icon: Icons.account_balance_wallet_rounded,
            ).animate().fadeIn(delay: 100.ms),
            const SizedBox(height: 24),
            contributionsAsync.when(
              data: (items) {
                if (items.isEmpty) {
                  return const AdminEmptyState(
                    message: 'لا توجد مساهمات حالياً',
                    icon: Icons.payments_outlined,
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final item = items[i];
                    final user = item['user'] is Map ? item['user'] : {};
                    final project = item['project'] is Map
                        ? item['project']
                        : {};

                    return _ContributionCard(
                      amount: '${item['amount']} DZD',
                      type: item['type']?.toString() ?? '',
                      status: item['status']?.toString() ?? 'PENDING',
                      userName:
                          user['name'] ?? user['email'] ?? 'مستخدم غير معروف',
                      projectName:
                          project['title']?['ar'] ??
                          project['title']?['fr'] ??
                          '',
                      proofUrl: item['proofUrl']?.toString(),
                      onApprove: () async {
                        await finService.reviewContribution(
                          item['_id'],
                          'VERIFIED',
                        );
                        ref.invalidate(adminContributionsProvider);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('✅ تم التحقق من المساهمة'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },
                      onReject: () async {
                        await finService.reviewContribution(
                          item['_id'],
                          'REJECTED',
                        );
                        ref.invalidate(adminContributionsProvider);
                        if (context.mounted) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(
                            const SnackBar(
                              content: Text('❌ تم رفض المساهمة'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                    ).animate(delay: (i * 80).ms).fadeIn().slideY(begin: 0.05);
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

class _ContributionCard extends StatelessWidget {
  final String amount;
  final String type;
  final String status;
  final String userName;
  final String projectName;
  final String? proofUrl;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const _ContributionCard({
    required this.amount,
    required this.type,
    required this.status,
    required this.userName,
    required this.projectName,
    this.proofUrl,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final isPending = status == 'PENDING';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                amount,
                style: GoogleFonts.tajawal(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppTheme.primaryColor,
                ),
              ),
              _buildStatusBadge(status),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'من: $userName',
            style: GoogleFonts.tajawal(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          if (projectName.isNotEmpty)
            Text(
              'المشروع: $projectName',
              style: GoogleFonts.tajawal(fontSize: 12, color: Colors.grey),
            ),
          Text(
            'النوع: $type',
            style: GoogleFonts.tajawal(fontSize: 12, color: Colors.grey),
          ),
          if (proofUrl != null) ...[
            const SizedBox(height: 12),
            InkWell(
              onTap: () {
                // Logic to view proof image
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.image_search_rounded, size: 16, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('عرض إثبات الدفع', style: TextStyle(fontSize: 11, color: Colors.blue)),
                  ],
                ),
              ),
            ),
          ],
          if (isPending) ...[
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onApprove,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      elevation: 0,
                    ),
                    child: const Text('تأكيد الوصل'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: onReject,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    child: const Text('رفض'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color = Colors.grey;
    String label = status;

    if (status == 'PENDING') {
      color = Colors.orange;
      label = 'قيد المراجعة';
    } else if (status == 'VERIFIED' || status == 'APPROVED') {
      color = Colors.green;
      label = 'مؤكد';
    } else if (status == 'REJECTED') {
      color = Colors.red;
      label = 'مرفوض';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }
}
