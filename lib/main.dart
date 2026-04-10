import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ebzim_app/core/localization/l10n/app_localizations.dart'; 
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/router/app_router.dart';
import 'package:ebzim_app/core/providers/locale_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: EbzimApp()));
}

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
