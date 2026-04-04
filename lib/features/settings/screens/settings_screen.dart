import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../main.dart' show localeProvider;
import '../../auth/services/auth_service.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final locale = ref.watch(localeProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppTheme.primaryColor), onPressed: () => context.pop()),
        title: Text(loc.settingsTitle, style: TextStyle(fontFamily: Theme.of(context).textTheme.headlineMedium?.fontFamily, color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 24)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SettingsSection(
              title: 'Preferences',
              children: [
                ListTile(
                  leading: const Icon(Icons.language, color: AppTheme.primaryColor),
                  title: Text(loc.settingsLang, style: const TextStyle(fontWeight: FontWeight.bold)),
                  trailing: DropdownButton<String>(
                    value: locale.languageCode,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(value: 'en', child: Text('English')),
                      DropdownMenuItem(value: 'ar', child: Text('العربية')),
                      DropdownMenuItem(value: 'fr', child: Text('Français')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        ref.read(localeProvider.notifier).state = Locale(val);
                      }
                    },
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.dark_mode, color: AppTheme.primaryColor),
                  title: Text(loc.settingsTheme, style: const TextStyle(fontWeight: FontWeight.bold)),
                  trailing: Switch(value: false, activeThumbColor: AppTheme.primaryColor, onChanged: (v) {}),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.notifications_active, color: AppTheme.primaryColor),
                  title: Text(loc.settingsNotif, style: const TextStyle(fontWeight: FontWeight.bold)),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 32),
            _SettingsSection(
              title: 'General',
              children: [
                ListTile(
                  leading: const Icon(Icons.security, color: AppTheme.primaryColor),
                  title: Text(loc.settingsPrivacy, style: const TextStyle(fontWeight: FontWeight.bold)),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {},
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.help_outline, color: AppTheme.primaryColor),
                  title: Text(loc.settingsHelp, style: const TextStyle(fontWeight: FontWeight.bold)),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {},
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.info_outline, color: AppTheme.primaryColor),
                  title: Text(loc.settingsAbout, style: const TextStyle(fontWeight: FontWeight.bold)),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 32),
            ListTile(
              leading: Icon(Icons.logout, color: Theme.of(context).colorScheme.error),
              title: Text(loc.settingsLogout, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.error)),
              onTap: () {
                // Clear session and escape to splash
                ref.read(authProvider.notifier).logout();
                context.go('/splash');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2, color: Colors.grey)),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(children: children),
        )
      ],
    );
  }
}
