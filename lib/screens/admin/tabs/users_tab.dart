import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ebzim_app/core/services/admin_user_service.dart';
import 'package:ebzim_app/core/services/user_profile_service.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'admin_shared_components.dart' hide Excel;
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
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex)).value = TextCellValue(u.phone ?? '');
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex)).value = TextCellValue(u.role.name);
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rowIndex)).value = TextCellValue(u.status);
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: rowIndex)).value = TextCellValue(u.membershipExpiry != null ? DateFormat('yyyy-MM-dd').format(u.membershipExpiry!) : '');
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: rowIndex)).value = TextCellValue(u.createdAt != null ? DateFormat('yyyy-MM-dd').format(u.createdAt!) : '');
      }

      final bytes = excel.encode();
      if (bytes != null) {
        final fileName = 'Ebzim_Users_${DateFormat('yyyyMMdd_HHmm').format(DateTime.now())}.xlsx';
        triggerWebDownloadBytes(Uint8List.fromList(bytes), fileName);
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

        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: const AdminSectionHeader(
                    title: 'إدارة المستخدمين',
                    subtitle: 'التحكم في الحسابات والأدوار والصلاحيات',
                    icon: Icons.people_alt_rounded,
                  ),
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
                decoration: const InputDecoration(
                  hintText: 'البحث باسم المستخدم أو البريد الإلكتروني...',
                  border: InputBorder.none,
                  icon: Icon(Icons.search_rounded),
                ),
                onChanged: (v) => setState(() => _searchQuery = v),
              ),
            ),
            const SizedBox(height: 24),
            if (filtered.isEmpty)
              const Center(child: Padding(
                padding: EdgeInsets.all(40),
                child: Text('لا يوجد مستخدمون لعرضهم', style: TextStyle(color: Colors.grey)),
              ))
            else
              ...filtered.map((u) => _UserListItem(user: u)),
          ],
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
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade100),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: user.role.getBadgeColor().withOpacity(0.1),
          child: Text(
            user.firstName.isNotEmpty ? user.firstName[0].toUpperCase() : '?',
            style: TextStyle(color: user.role.getBadgeColor(), fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          user.getName('ar'),
          style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(user.email, style: const TextStyle(fontSize: 12)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: user.role.getBadgeColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                user.getInstitutionalTitle('ar'),
                style: TextStyle(
                  color: user.role.getBadgeColor(),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            if (user.role != EbzimRole.superAdmin && user.email.toLowerCase() != 'matique2025@gmail.com')
              IconButton(
                icon: const Icon(Icons.more_vert_rounded),
                onPressed: () => _showUserActions(context, ref),
              )
            else
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Icon(Icons.shield_rounded, color: Color(0xFFD4AF37), size: 20),
              ),
          ],
        ),
      ),
    );
  }

  void _showUserActions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: const Text('تعديل الرتبة'),
            onTap: () {
              Navigator.pop(context);
              // Implement role change
            },
          ),
          ListTile(
            leading: Icon(
              user.status == 'ACTIVE' ? Icons.block_flipped : Icons.check_circle_outline,
              color: user.status == 'ACTIVE' ? Colors.red : Colors.green,
            ),
            title: Text(user.status == 'ACTIVE' ? 'تجميد الحساب' : 'تفعيل الحساب'),
            onTap: () async {
              Navigator.pop(context);
              try {
                await ref.read(adminUserServiceProvider).updateUserStatus(
                  user.id,
                  user.status == 'ACTIVE' ? 'INACTIVE' : 'ACTIVE',
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(adminSuccessSnack('تم تحديث حالة الحساب'));
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(adminErrorSnack('فشل التحديث: $e'));
                }
              }
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.delete_outline, color: Colors.red),
            title: const Text('حذف الحساب نهائياً', style: TextStyle(color: Colors.red)),
            onTap: () async {
              Navigator.pop(context);
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('حذف حساب'),
                  content: const Text('هل أنت متأكد من حذف هذا الحساب نهائياً؟ لا يمكن التراجع.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('إلغاء')),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('حذف', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                try {
                  await ref.read(adminUserServiceProvider).deleteUser(user.id);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(adminSuccessSnack('تم حذف الحساب بنجاح'));
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(adminErrorSnack('فشل الحذف: $e'));
                  }
                }
              }
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
