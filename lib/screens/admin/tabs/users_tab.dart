import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ebzim_app/core/services/admin_user_service.dart';
import 'package:ebzim_app/core/services/user_profile_service.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'admin_shared_components.dart';
import 'package:excel/excel.dart' hide Border;
import 'dart:typed_data';
import 'package:ebzim_app/core/services/web_helper.dart';

class UsersTab extends ConsumerStatefulWidget {
  const UsersTab({super.key});

  @override
  ConsumerState<UsersTab> createState() => _UsersTabState();
}

class _UsersTabState extends ConsumerState<UsersTab> {
  String _searchQuery = '';
  bool _isExporting = false;

  Future<void> _exportUsersToExcel(List<UserProfile> users) async {
    setState(() => _isExporting = true);
    try {
      final excel = Excel.createExcel();
      const String sheetName = 'Ebzim Users Export';
      final sheet = excel[sheetName];
      excel.delete('Sheet1');

      final headers = [
        'Name',
        'Name (AR)',
        'Email',
        'Phone',
        'Role',
        'Status',
        'Expiry Date',
        'Registration Date',
      ];
      for (int i = 0; i < headers.length; i++) {
        var cell = sheet.cell(
          CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0),
        );
        cell.value = TextCellValue(headers[i]);
      }

      for (int row = 0; row < users.length; row++) {
        final u = users[row];
        final rowIndex = row + 1;

        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex)).value = TextCellValue(u.getName('en'));
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex)).value = TextCellValue(u.getName('ar'));
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex)).value = TextCellValue(u.email);
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex)).value = TextCellValue(u.phoneNumber ?? '');
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex)).value = TextCellValue(u.role.name);
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rowIndex)).value = TextCellValue(u.status);
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: rowIndex)).value = TextCellValue(u.expiryDate != null ? DateFormat('yyyy-MM-dd').format(u.expiryDate!) : '');
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: rowIndex)).value = TextCellValue(DateFormat('yyyy-MM-dd').format(u.createdAt));
      }

      final bytes = excel.encode();
      if (bytes != null) {
        final fileName = 'Ebzim_Users_${DateFormat('yyyyMMdd_HHmm').format(DateTime.now())}.xlsx';
        WebHelper.downloadFile(Uint8List.fromList(bytes), fileName);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(adminSuccessSnack('تم استخراج البيانات بنجاح'));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(adminErrorSnack('فشل استخراج البيانات: $e'));
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(allUsersProvider);

    return usersAsync.when(
      loading: () => const AdminLoadingShimmer(),
      error: (e, _) => AdminErrorState(error: e.toString()),
      data: (users) {
        final filtered = users.where((u) {
          final query = _searchQuery.toLowerCase();
          return u.email.toLowerCase().contains(query) ||
              u.getName('ar').toLowerCase().contains(query) ||
              u.getName('en').toLowerCase().contains(query);
        }).toList();

        final activeUsers = users.where((u) => u.status.toUpperCase() == 'ACTIVE').length;
        final pendingUsers = users.where((u) => u.status.toUpperCase() == 'PENDING').length;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AdminSectionHeader(
                    title: 'إدارة المستخدمين',
                    subtitle: 'التحكم في الحسابات والأدوار والصلاحيات',
                    icon: Icons.people_alt_rounded,
                  ),
                  AdminExportButton(
                    isLoading: _isExporting,
                    onPressed: () => _exportUsersToExcel(users),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  AdminStatCard(
                    label: 'إجمالي المستخدمين',
                    value: users.length.toString(),
                    icon: Icons.group_rounded,
                    gradient: const LinearGradient(colors: [Color(0xFF052011), Color(0xFF1B4332)]),
                  ),
                  const SizedBox(width: 16),
                  AdminStatCard(
                    label: 'حسابات نشطة',
                    value: activeUsers.toString(),
                    icon: Icons.check_circle_rounded,
                    gradient: const LinearGradient(colors: [Color(0xFF15803D), Color(0xFF22C55E)]),
                  ),
                  const SizedBox(width: 16),
                  AdminStatCard(
                    label: 'طلبات معلقة',
                    value: pendingUsers.toString(),
                    icon: Icons.hourglass_empty_rounded,
                    gradient: const LinearGradient(colors: [Color(0xFFB45309), Color(0xFFF59E0B)]),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: TextField(
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: const InputDecoration(
                    hintText: 'البحث عن مستخدم بالاسم أو البريد...',
                    border: InputBorder.none,
                    icon: Icon(Icons.search_rounded, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (filtered.isEmpty)
                const AdminEmptyState(message: 'لم يتم العثور على مستخدمين', icon: Icons.person_off_rounded)
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) => _UserListItem(user: filtered[index]),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _UserListItem extends ConsumerWidget {
  final UserProfile user;
  const _UserListItem({required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
            child: Text(
              user.getName('ar').isNotEmpty ? user.getName('ar')[0] : 'U',
              style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.getName('ar'),
                  style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  user.email,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          AdminStatusBadge(status: user.status),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, color: Colors.grey),
            onPressed: () => _showUserActions(context, ref),
          ),
        ],
      ),
    );
  }

  void _showUserActions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
          ListTile(
            leading: const Icon(Icons.edit_note_rounded, color: Colors.blue),
            title: const Text('تعديل البيانات'),
            onTap: () {
              Navigator.pop(context);
              // Implementation for edit
            },
          ),
          ListTile(
            leading: Icon(
              user.status.toUpperCase() == 'ACTIVE' ? Icons.block_flipped : Icons.check_circle_outline_rounded,
              color: user.status.toUpperCase() == 'ACTIVE' ? Colors.orange : Colors.green,
            ),
            title: Text(user.status.toUpperCase() == 'ACTIVE' ? 'تعطيل الحساب' : 'تنشيط الحساب'),
            onTap: () async {
              Navigator.pop(context);
              final newStatus = user.status.toUpperCase() == 'ACTIVE' ? 'INACTIVE' : 'ACTIVE';
              await ref.read(adminUserServiceProvider).updateUserStatus(user.id, newStatus);
              ref.invalidate(allUsersProvider);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.delete_forever_rounded, color: Colors.red),
            title: const Text('حذف المستخدم نهائياً'),
            onTap: () async {
              Navigator.pop(context);
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('تأكيد الحذف'),
                  content: const Text('هل أنت متأكد من حذف هذا المستخدم؟ لا يمكن التراجع عن هذا الإجراء.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('إلغاء')),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text('حذف'),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                await ref.read(adminUserServiceProvider).deleteUser(user.id);
                ref.invalidate(allUsersProvider);
              }
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
