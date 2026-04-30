import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/providers/realtime_provider.dart';
import 'admin_shared_components.dart';

class AlertsTab extends ConsumerStatefulWidget {
  const AlertsTab({super.key});

  @override
  ConsumerState<AlertsTab> createState() => _AlertsTabState();
}

class _AlertsTabState extends ConsumerState<AlertsTab> {
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSending = ref.watch(announcementProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AdminSectionHeader(
            title: 'مركز التنبيهات العاجلة',
            subtitle: 'إرسال إشعارات فورية تظهر لجميع مستخدمي التطبيق الآن عبر Supabase Realtime',
            icon: Icons.bolt_rounded,
          ),
          const SizedBox(height: 32),
          
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: AppTheme.accentColor.withOpacity(0.2)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'إنشاء إعلان جديد',
                    style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'عنوان التنبيه',
                      hintText: 'مثال: تحديث هام، عطل فني، خبر عاجل...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _messageController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'نص الرسالة',
                      hintText: 'اكتب تفاصيل الإعلان هنا...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: isSending ? null : () async {
                        if (_titleController.text.isEmpty || _messageController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('يرجى ملء جميع الحقول')),
                          );
                          return;
                        }
                        
                        await ref.read(announcementProvider.notifier).sendAnnouncement(
                          _titleController.text,
                          _messageController.text,
                        );
                        
                        if (mounted) {
                          _titleController.clear();
                          _messageController.clear();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('تم إرسال التنبيه بنجاح لجميع المستخدمين!')),
                          );
                        }
                      },
                      icon: isSending 
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.send_rounded),
                      label: Text(isSending ? 'جاري الإرسال...' : 'بث التنبيه للجميع'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded, color: Colors.amber),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'هذه الميزة تستخدم تقنية Supabase Broadcast. تظهر الرسالة فقط للمستخدمين المتواجدين داخل التطبيق في هذه اللحظة.',
                    style: GoogleFonts.tajawal(fontSize: 12, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
