import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ebzim_app/core/services/membership_service.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/services/membership_export_service.dart';
import 'admin_shared_components.dart';

class MembershipTab extends ConsumerWidget {
  const MembershipTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(pendingMembershipsProvider);

    return RefreshIndicator(
      color: AppTheme.primaryColor,
      onRefresh: () async => ref.invalidate(pendingMembershipsProvider),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AdminSectionHeader(
              title: 'طلبات الانضمام',
              subtitle: 'إدارة ومراجعة طلبات العضوية الجديدة',
              icon: Icons.person_add_alt_1_rounded,
            ),
            const SizedBox(height: 24),
            stateAsync.when(
              data: (requests) => Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AdminExportButton(
                        isLoading: false,
                        onPressed: () => MembershipExportService.exportToExcel(requests),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (requests.isEmpty)
                    const AdminEmptyState(
                      message: 'لا توجد طلبات انضمام حالياً',
                      icon: Icons.person_off_rounded,
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: requests.length,
                      itemBuilder: (context, index) {
                        return MembershipRequestCard(request: requests[index]);
                      },
                    ),
                ],
              ),
              loading: () => const AdminLoadingShimmer(),
              error: (e, _) => AdminErrorState(error: e.toString()),
            ),
          ],
        ),
      ),
    );
  }

}

class MembershipRequestCard extends StatelessWidget {
  final MembershipRequest request;

  const MembershipRequestCard({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: () => _showDetailsDialog(context),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person_outline, color: AppTheme.primaryColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.fullName,
                      style: GoogleFonts.tajawal(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      request.data['email'] ?? 'No Email',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AdminStatusBadge(status: request.status),
                  const SizedBox(height: 8),
                  Text(
                    DateFormat('yyyy-MM-dd').format(request.submissionDate),
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => MembershipRequestDetailsDialog(request: request),
    );
  }
}

class MembershipRequestDetailsDialog extends ConsumerStatefulWidget {
  final MembershipRequest request;

  const MembershipRequestDetailsDialog({super.key, required this.request});

  @override
  ConsumerState<MembershipRequestDetailsDialog> createState() => _DetailsDialogState();
}

class _DetailsDialogState extends ConsumerState<MembershipRequestDetailsDialog> {
  bool _isProcessing = false;

  Future<void> _updateStatus(String status) async {
    setState(() => _isProcessing = true);
    try {
      await ref.read(membershipAdminProvider).reviewRequest(widget.request.id, status, userId: widget.request.userId);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          adminSuccessSnack(status == 'APPROVED' ? 'تم قبول الطلب بنجاح' : 'تم تحديث حالة الطلب'),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(adminErrorSnack('فشل في تحديث الحالة: $e'));
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.request.data;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'تفاصيل الطلب',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const Divider(height: 32),
            _buildDetailRow('الاسم الكامل', widget.request.fullName),
            _buildDetailRow('البريد الإلكتروني', data['email'] ?? 'N/A'),
            _buildDetailRow('رقم الهاتف', data['phone'] ?? 'N/A'),
            _buildDetailRow('الجنس', data['gender'] ?? 'N/A'),
            _buildDetailRow('تاريخ التقديم', DateFormat('yyyy-MM-dd HH:mm').format(widget.request.submissionDate)),
            const SizedBox(height: 32),
            if (widget.request.status == 'SUBMITTED' || widget.request.status == 'UNDER_REVIEW')
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isProcessing ? null : () => _updateStatus('REJECTED'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('رفض الطلب'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isProcessing ? null : () => _updateStatus('APPROVED'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B4332),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isProcessing
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Text('قبول الطلب'),
                    ),
                  ),
                ],
              )
            else
              Center(
                child: AdminStatusBadge(status: widget.request.status),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
