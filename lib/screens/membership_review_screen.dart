import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/services/membership_service.dart';
import 'package:ebzim_app/core/common_widgets/glass_card.dart';
import 'package:intl/intl.dart';

class MembershipReviewScreen extends ConsumerWidget {
  const MembershipReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsync = ref.watch(pendingMembershipsProvider);

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        title: const Text(
          'طلبات الانضمام - المكتب التنفيذي',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: requestsAsync.when(
        data: (requests) {
          if (requests.isEmpty) {
            return const Center(child: Text('لا توجد طلبات حالياً'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  request.fullName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                                Text(
                                  DateFormat(
                                    'yyyy-MM-dd HH:mm',
                                  ).format(request.submissionDate),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _StatusBadge(status: request.status),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 8),
                      Text(
                        'الدوافع: ${request.data['motivation'] ?? 'بدون'}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _ReviewAction(
                              label: 'قبول',
                              color: Colors.green,
                              onPressed: () => _handleReview(
                                context,
                                ref,
                                request.id,
                                'APPROVED',
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _ReviewAction(
                              label: 'معلومات',
                              color: Colors.orange,
                              onPressed: () => _handleReview(
                                context,
                                ref,
                                request.id,
                                'NEEDS_INFO',
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _ReviewAction(
                              label: 'رفض',
                              color: Colors.red,
                              onPressed: () => _handleReview(
                                context,
                                ref,
                                request.id,
                                'REJECTED',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Future<void> _handleReview(
    BuildContext context,
    WidgetRef ref,
    String id,
    String status,
  ) async {
    try {
      await ref.read(membershipAdminProvider).reviewRequest(id, status);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تحديث حالة الطلب بنجاح')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('خطأ: $e')));
      }
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    switch (status) {
      case 'SUBMITTED':
      case 'UNDER_REVIEW':
        color = AppTheme.primaryColor;
        label = 'قيد المراجعة';
        break;
      case 'NEEDS_INFO':
        color = Colors.orange;
        label = 'معلومات مطلوبة';
        break;
      case 'APPROVED':
        color = Colors.green;
        label = 'تم قبول الطلب';
        break;
      case 'REJECTED':
        color = Colors.red;
        label = 'تم رفض الطلب';
        break;
      default:
        color = Colors.grey;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _ReviewAction extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _ReviewAction({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}
