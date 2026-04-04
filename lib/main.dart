import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/localization/l10n/app_localizations.dart'; 
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';

void main() {
  runApp(const ProviderScope(child: EbzimApp()));
}

/// A simple provider to hold the current app locale state
final localeProvider = StateProvider<Locale>((ref) => const Locale('ar'));

class EbzimApp extends ConsumerWidget {
  const EbzimApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    
    // Select theme based on language
    final activeTheme = AppTheme.getTheme(currentLocale);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'EBZIM APP',
      theme: activeTheme,
      locale: currentLocale,
      
      // Localization Setup
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar'), // Arabic
        Locale('en'), // English
        Locale('fr'), // French
      ],
      
      routerConfig: appRouter,
    );
  }
}
