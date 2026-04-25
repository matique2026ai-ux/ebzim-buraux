import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ebzim_app/core/localization/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/providers/locale_provider.dart';
import 'package:ebzim_app/core/providers/theme_provider.dart';
import 'package:ebzim_app/core/services/auth_service.dart';
import 'package:ebzim_app/core/widgets/ebzim_background.dart';
import 'package:ebzim_app/core/common_widgets/glass_card.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:ebzim_app/core/common_widgets/ebzim_sliver_app_bar.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: EbzimBackground(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const EbzimSliverAppBar(),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 140, 24, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SettingsSection(
                      title: loc.settingsTitle,
                      children: [
                        ListTile(
                          leading: const Icon(
                            Icons.language_rounded,
                            color: AppTheme.accentColor,
                            size: 22,
                          ),
                          title: Text(
                            loc.settingsLang,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontSize: 16,
                            ),
                          ),
                          trailing: DropdownButton<String>(
                            value: locale.languageCode,
                            dropdownColor: isDark
                                ? AppTheme.primaryColor.withValues(alpha: 0.95)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            underline: const SizedBox(),
                            style: const TextStyle(
                              color: AppTheme.accentColor,
                              fontWeight: FontWeight.bold,
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'en',
                                child: Text('English'),
                              ),
                              DropdownMenuItem(
                                value: 'ar',
                                child: Text('العربية'),
                              ),
                              DropdownMenuItem(
                                value: 'fr',
                                child: Text('Français'),
                              ),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                ref
                                    .read(localeProvider.notifier)
                                    .setLocale(Locale(val));
                              }
                            },
                          ),
                        ),
                        const Divider(indent: 56),
                        ListTile(
                          leading: const Icon(
                            Icons.palette_outlined,
                            color: AppTheme.accentColor,
                            size: 22,
                          ),
                          title: Text(
                            loc.settingsTheme,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontSize: 16,
                            ),
                          ),
                          trailing: Switch.adaptive(
                            value: isDark,
                            activeTrackColor: AppTheme.accentColor,
                            onChanged: (v) {
                              ref.read(themeProvider.notifier).toggleTheme();
                            },
                          ),
                        ),
                        const Divider(indent: 56),
                        ListTile(
                          leading: const Icon(
                            Icons.notifications_none_rounded,
                            color: AppTheme.accentColor,
                            size: 22,
                          ),
                          title: Text(
                            loc.settingsNotif,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontSize: 16,
                            ),
                          ),
                          trailing: Icon(
                            Icons.chevron_right_rounded,
                            color: isDark ? Colors.white24 : Colors.black26,
                          ),
                          onTap: () => context.push('/notifications'),
                        ),
                      ],
                    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.05),

                    const SizedBox(height: 32),

                    _SettingsSection(
                      title: loc.settingsAbout,
                      children: [
                        ListTile(
                          leading: const Icon(
                            Icons.verified_user_outlined,
                            color: AppTheme.accentColor,
                            size: 22,
                          ),
                          title: Text(
                            loc.settingsPrivacy,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontSize: 16,
                            ),
                          ),
                          trailing: Icon(
                            Icons.open_in_new_rounded,
                            color: isDark ? Colors.white24 : Colors.black26,
                            size: 18,
                          ),
                          onTap: () => context.push('/auth/privacy'),
                        ),
                        const Divider(indent: 56),
                        ListTile(
                          leading: const Icon(
                            Icons.help_outline_rounded,
                            color: AppTheme.accentColor,
                            size: 22,
                          ),
                          title: Text(
                            loc.settingsHelp,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontSize: 16,
                            ),
                          ),
                          trailing: Icon(
                            Icons.chevron_right_rounded,
                            color: isDark ? Colors.white24 : Colors.black26,
                          ),
                          onTap: () => context.push('/support'),
                        ),
                        const Divider(indent: 56),
                        ListTile(
                          leading: const Icon(
                            Icons.auto_awesome_outlined,
                            color: AppTheme.accentColor,
                            size: 22,
                          ),
                          title: Text(
                            loc.settingsAbout,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontSize: 16,
                            ),
                          ),
                          trailing: Icon(
                            Icons.chevron_right_rounded,
                            color: isDark ? Colors.white24 : Colors.black26,
                          ),
                          onTap: () => context.push('/about'),
                        ),
                      ],
                    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.05),

                    const SizedBox(height: 56),

                    // --- REFINED LOGOUT ---
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          ref.read(authProvider.notifier).logout();
                          context.go('/splash');
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: GlassCard(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 24,
                          ),
                          border: Border.all(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.05)
                                : Colors.black.withValues(alpha: 0.05),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.logout_rounded,
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.5)
                                    : Colors.black.withValues(alpha: 0.5),
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                loc.settingsLogout,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.7)
                                      : Colors.black.withValues(alpha: 0.7),
                                  fontSize: 16,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ).animate().fadeIn(delay: 600.ms),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
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
        ),
      ],
    );
  }
}
