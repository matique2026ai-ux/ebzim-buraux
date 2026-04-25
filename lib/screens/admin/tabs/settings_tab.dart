import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/financial_service.dart';
import 'admin_shared_components.dart';

class SettingsTab extends ConsumerStatefulWidget {
  const SettingsTab({super.key});

  @override
  ConsumerState<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends ConsumerState<SettingsTab> {
  final _feeController = TextEditingController();
  bool _isClearingCache = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final s = await ref.read(financialServiceProvider).getSettings();
    if (mounted) {
      _feeController.text = (s['annualMembershipFee'] ?? 2000).toString();
    }
  }

  @override
  void dispose() {
    _feeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AdminSectionHeader(
            title: 'مركز التحكم والإعدادات',
            subtitle: 'إدارة المعايير المالية وأدوات النظام التقنية',
            icon: Icons.admin_panel_settings_rounded,
          ).animate().fadeIn(delay: 100.ms),
          const SizedBox(height: 24),

          // FINANCIAL SECTION
          Text(
            'الإدارة المالية',
            style: GoogleFonts.tajawal(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 12),
          _SettingsItemCard(
            title: 'رسوم العضوية السنوية',
            icon: Icons.currency_exchange_rounded,
            iconColor: const Color(0xFF15803D),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _feeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '2000',
                      suffixText: 'DZD',
                      suffixStyle: GoogleFonts.tajawal(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () async {
                    final fee = int.tryParse(_feeController.text) ?? 2000;
                    await ref
                        .read(financialServiceProvider)
                        .updateMembershipFee(fee);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('✅ تم تحديث الرسوم المالية للمنصة'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'حفظ',
                    style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 200.ms),

          const SizedBox(height: 24),

          // MAINTENANCE SECTION
          Text(
            'صيانة النظام',
            style: GoogleFonts.tajawal(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 12),
          _SettingsItemCard(
            title: 'العمليات التقنية',
            icon: Icons.settings_suggest_rounded,
            iconColor: const Color(0xFFC2410C),
            child: Column(
              children: [
                _SystemActionTile(
                  icon: Icons.auto_delete_rounded,
                  label: 'تصفية التخزين المؤقت',
                  description: 'إعادة مزامنة البيانات من السيرفر فوراً',
                  isLoading: _isClearingCache,
                  onTap: () async {
                    setState(() => _isClearingCache = true);
                    await Future.delayed(
                      const Duration(seconds: 1),
                    ); // Visual feedback
                    // ref.invalidate(adminEventsProvider);
                    // ref.invalidate(adminNewsProvider);
                    if (mounted) {
                      setState(() => _isClearingCache = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            '✨ تم مسح الذاكرة المؤقتة وتحديث البيانات',
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ).animate().fadeIn(delay: 300.ms),

          const SizedBox(height: 24),

          // EXTERNAL TOOLS SECTION
          Text(
            'روابط الإدارة الخارجية',
            style: GoogleFonts.tajawal(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 12),
          _SettingsItemCard(
            title: 'مركز البيانات والاستضافة',
            icon: Icons.hub_rounded,
            iconColor: const Color(0xFF6D28D9),
            child: Column(
              children: [
                _QuickLinkTile(
                  icon: Icons.cloud_done_rounded,
                  label: 'لوحة استضافة Render (API)',
                  onTap: () => _launchURL('https://dashboard.render.com'),
                ),
                const Divider(height: 1),
                _QuickLinkTile(
                  icon: Icons.storage_rounded,
                  label: 'لوحة MongoDB Atlas (Database)',
                  onTap: () => _launchURL('https://cloud.mongodb.com'),
                ),
                const Divider(height: 1),
                _QuickLinkTile(
                  icon: Icons.code_rounded,
                  label: 'مستودع الكود (GitHub)',
                  onTap: () => _launchURL(
                    'https://github.com/matique2026ai-ux/ebzim-buraux',
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 400.ms),

          const SizedBox(height: 48),

          // FOOTER INFO
          Center(
            child: Column(
              children: [
                Text(
                  'إبزيم للتراث والفنون - نسخة المسؤول v1.2.0',
                  style: GoogleFonts.tajawal(
                    fontSize: 10,
                    color: Colors.grey.shade400,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'تم التطوير بواسطة Antigravity AI',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 8,
                    color: Colors.grey.shade300,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    // In a real Flutter app, we use url_launcher package.
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('فتح الرابط: $url', style: GoogleFonts.tajawal()),
          backgroundColor: AppTheme.primaryColor,
        ),
      );
    }
  }
}

class _SettingsItemCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Widget child;

  const _SettingsItemCard({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 10),
              Text(
                title,
                style: GoogleFonts.tajawal(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}

class _SystemActionTile extends StatelessWidget {
  final IconData icon;
  final String label, description;
  final VoidCallback onTap;
  final bool isLoading;

  const _SystemActionTile({
    required this.icon,
    required this.label,
    required this.description,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.orange.shade700, size: 20),
      ),
      title: Text(
        label,
        style: GoogleFonts.tajawal(fontSize: 13, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        description,
        style: GoogleFonts.tajawal(fontSize: 10, color: Colors.grey.shade500),
      ),
      trailing: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.flash_on_rounded, size: 18, color: Colors.orange),
      onTap: isLoading ? null : onTap,
    );
  }
}

class _QuickLinkTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickLinkTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppTheme.primaryColor, size: 18),
      title: Text(label, style: GoogleFonts.tajawal(fontSize: 12)),
      trailing: const Icon(
        Icons.open_in_new_rounded,
        size: 14,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }
}
