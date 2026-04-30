import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ebzim_app/core/localization/l10n/app_localizations.dart'; 
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/router/app_router.dart';
import 'package:ebzim_app/core/providers/locale_provider.dart';
import 'package:ebzim_app/core/providers/theme_provider.dart';
import 'package:ebzim_app/core/widgets/network_aware_app.dart';

import 'package:ebzim_app/core/services/supabase_service.dart';
import 'package:ebzim_app/core/providers/realtime_provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase for Realtime & Storage enhancements
  try {
    await SupabaseService.initialize();
  } catch (e) {
    debugPrint('Supabase initialization failed: $e');
  }
  
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

    // Listen for Realtime Announcements
    ref.listen(realtimeNotificationProvider, (previous, next) {
      next.whenData((notification) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notification.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(notification.message),
              ],
            ),
            backgroundColor: AppTheme.accentColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            duration: const Duration(seconds: 5),
          ),
        );
      });
    });

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
