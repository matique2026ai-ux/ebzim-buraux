import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../models/membership_request.dart';
import '../../../providers/membership_admin_provider.dart';
import '../../../theme/app_theme.dart';
import '../../../services/membership_export_service.dart';
import 'admin_shared_components.dart';

class MembershipTab extends ConsumerWidget {
  const MembershipTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(membershipAdminProvider);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminHeader(
            title: 'طلبات الانضمام',
            subtitle: 'إدارة ومراجعة طلبات العضوية الجديدة',
            actions: [
              ExportButton(
                onPressed: () async {
                  final success = await MembershipExportService.exportToExcel(state.requests);
                  if (context.mounted) {
                    if (success) {
                      AdminSharedComponents.showSuccess(context, 'تم تصدير الملف بنجاح');
                    } else {
                      AdminSharedComponents.showError(context, 'فشل في تصدير الملف');
                    }
                  }
                },
                label: 'تصدير Excel',
              ),
            ],
          ),
          const SizedBox(height: 32),
          if (state.isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (state.error != null)
            Expanded(child: AdminErrorState(message: state.error!))
          else if (state.requests.isEmpty)
            const Expanded(child: AdminEmptyState(message: 'لا توجد طلبات انضمام حالياً'))
          else
            Expanded(
              child: ListView.builder(
                itemCount: state.requests.length,
                itemBuilder: (context, index) {
                  return MembershipRequestCard(request: state.requests[index]);
                },
              ),
            ),
        ],
      ),
    );
  }
}

class MembershipRequestCard extends StatelessWidget {
  final MembershipRequest request;

  const MembershipRequestCard({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(request.status);

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
                      request.email,
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  StatusBadge(status: request.status.name, color: statusColor),
                  const SizedBox(height: 8),
                  Text(
                    DateFormat('yyyy-MM-dd').format(request.createdAt),
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

  Color _getStatusColor(MembershipStatus status) {
    switch (status) {
      case MembershipStatus.pending:
        return Colors.orange;
      case MembershipStatus.approved:
        return Colors.green;
      case MembershipStatus.rejected:
        return Colors.red;
    }
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

  Future<void> _updateStatus(MembershipStatus status) async {
    setState(() => _isProcessing = true);
    try {
      await ref.read(membershipAdminProvider.notifier).updateRequestStatus(widget.request.id, status);
      if (mounted) {
        Navigator.pop(context);
        AdminSharedComponents.showSuccess(
          context,
          status == MembershipStatus.approved ? 'تم قبول الطلب بنجاح' : 'تم رفض الطلب',
        );
      }
    } catch (e) {
      if (mounted) {
        AdminSharedComponents.showError(context, 'فشل في تحديث الحالة: $e');
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
            _buildDetailRow('البريد الإلكتروني', widget.request.email),
            _buildDetailRow('رقم الهاتف', widget.request.phoneNumber),
            _buildDetailRow('الجنسية', widget.request.nationality),
            _buildDetailRow('الحي/المنطقة', widget.request.district),
            _buildDetailRow('تاريخ التقديم', DateFormat('yyyy-MM-dd HH:mm').format(widget.request.createdAt)),
            const SizedBox(height: 32),
            if (widget.request.status == MembershipStatus.pending)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isProcessing ? null : () => _updateStatus(MembershipStatus.rejected),
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
                      onPressed: _isProcessing ? null : () => _updateStatus(MembershipStatus.approved),
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
                child: StatusBadge(
                  status: widget.request.status == MembershipStatus.approved ? 'تم القبول' : 'مرفوض',
                  color: widget.request.status == MembershipStatus.approved ? Colors.green : Colors.red,
                ),
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
