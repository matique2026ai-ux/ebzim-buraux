import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ebzim_app/core/localization/l10n/app_localizations.dart'; 
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/router/app_router.dart';
import 'package:ebzim_app/core/providers/locale_provider.dart';
import 'package:ebzim_app/core/providers/theme_provider.dart';
import 'package:ebzim_app/core/widgets/network_aware_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: EbzimApp()));
}

class EbzimApp extends ConsumerWidget {
  const EbzimApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeProvider);
    
    // Select theme based on language and set both globally required defaults
    final lightTheme = AppTheme.getTheme(currentLocale, ThemeMode.light);
    final darkTheme = AppTheme.getTheme(currentLocale, ThemeMode.dark);

    return NetworkAwareApp(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Ebzim',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: themeMode,
        locale: currentLocale,
        
        // Localization Setup
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ar', 'DZ'), // Arabic (Algeria) - for Latin numbers
          Locale('ar'),      // Generic Arabic
          Locale('en'),      // English
          Locale('fr'),      // French
        ],
        
        routerConfig: ref.watch(appRouterProvider),
      ),
    );
  }
}
