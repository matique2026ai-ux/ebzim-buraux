import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ebzim_app/core/localization/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/providers/locale_provider.dart';
import 'package:ebzim_app/core/services/auth_service.dart';
import 'package:ebzim_app/core/widgets/ebzim_background.dart';
import 'package:ebzim_app/core/common_widgets/glass_card.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final locale = ref.watch(localeProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.accentColor), 
          onPressed: () => context.pop(),
        ),
        title: Text(
          loc.settingsTitle, 
          style: const TextStyle(
            fontFamily: 'Aref Ruqaa', 
            color: AppTheme.accentColor, 
            fontWeight: FontWeight.bold, 
            fontSize: 28,
          ),
        ),
      ),
      body: EbzimBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 120, 24, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SettingsSection(
                title: loc.dashboardWelcomeBack, // Reusing key for section label
                children: [
                  ListTile(
                    leading: const Icon(Icons.language, color: AppTheme.accentColor),
                    title: Text(loc.settingsLang, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    trailing: DropdownButton<String>(
                      value: locale.languageCode,
                      dropdownColor: AppTheme.primaryColor,
                      underline: const SizedBox(),
                      style: const TextStyle(color: AppTheme.accentColor, fontWeight: FontWeight.bold),
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
                    leading: const Icon(Icons.dark_mode, color: AppTheme.accentColor),
                    title: Text(loc.settingsTheme, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    trailing: Switch(
                      value: true, 
                      activeColor: AppTheme.accentColor,
                      onChanged: (v) {},
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.notifications_active, color: AppTheme.accentColor),
                    title: Text(loc.settingsNotif, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    trailing: const Icon(Icons.chevron_right, color: AppTheme.accentColor),
                    onTap: () => context.push('/notifications'),
                  ),
                ],
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
              
              const SizedBox(height: 32),
              
              _SettingsSection(
                title: loc.settingsAbout,
                children: [
                  ListTile(
                    leading: const Icon(Icons.security, color: AppTheme.accentColor),
                    title: Text(loc.settingsPrivacy, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    trailing: const Icon(Icons.chevron_right, color: AppTheme.accentColor),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.help_center, color: AppTheme.accentColor),
                    title: Text(loc.settingsHelp, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    trailing: const Icon(Icons.chevron_right, color: AppTheme.accentColor),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.info, color: AppTheme.accentColor),
                    title: Text(loc.settingsAbout, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    trailing: const Icon(Icons.chevron_right, color: AppTheme.accentColor),
                    onTap: () => context.push('/about'),
                  ),
                ],
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),

              const SizedBox(height: 48),

              // Logout Button with Heritage Red
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.heritageRed.withValues(alpha: 0.3)),
                ),
                child: ListTile(
                  leading: const Icon(Icons.logout, color: AppTheme.heritageRed),
                  title: Text(
                    loc.settingsLogout, 
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.heritageRed),
                  ),
                  onTap: () {
                    ref.read(authProvider.notifier).logout();
                    context.go('/splash');
                  },
                ),
              ).animate().fadeIn(delay: 600.ms),
            ],
          ),
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title.toUpperCase(), 
            style: const TextStyle(
              fontSize: 10, 
              fontWeight: FontWeight.bold, 
              letterSpacing: 2, 
              color: AppTheme.accentColor,
            ),
          ),
        ),
        GlassCard(
          padding: EdgeInsets.zero,
          child: Column(children: children),
        )
      ],
    );
  }
}
