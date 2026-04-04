import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  
  // Base Colors
  static const Color primaryColor = Color(0xFF005B41);     // Emerald green
  static const Color secondaryColor = Color(0xFFE8F1EB);   // Light green bg
  static const Color accentColor = Color(0xFFD4AF37);      // Gold accent
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF1E1E1E);
  static const Color textLight = Color(0xFFFFFFFF);

  // Heritage Palette (Premium Arabic Identity)
  static const Color heritageGreenDeep = Color(0xFF001A00);    // Shadowed Pine
  static const Color heritageGreenEmerald = Color(0xFF003311); // Dark Emerald
  static const Color premiumParchment = Color(0xFFFDFAF0);     // Warm Ivory
  static const Color restrainedGold = Color(0xFFC5A059);       // Bronze Gold
  static const Color heritageRed = Color(0xFF9E4A44);          // Refined Muted Rust (Error)

  /// Unified theme generator based on locale to ensure matching structure and inherit values.
  static ThemeData getTheme(Locale locale) {
    final bool isAr = locale.languageCode == 'ar';
    
    // 1. Text Style Synchronization (ensuring same 'inherit' status)
    const bool kInherit = true;

    final TextTheme textTheme = TextTheme(
      headlineLarge: isAr 
        ? GoogleFonts.alexandria(fontSize: 32, fontWeight: FontWeight.bold, color: textDark).copyWith(inherit: kInherit)
        : GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.bold, color: textDark).copyWith(inherit: kInherit),
      headlineMedium: isAr 
        ? GoogleFonts.alexandria(fontSize: 24, fontWeight: FontWeight.bold, color: textDark).copyWith(inherit: kInherit)
        : GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: textDark).copyWith(inherit: kInherit),
      titleLarge: isAr 
        ? GoogleFonts.alexandria(fontSize: 20, fontWeight: FontWeight.w600, color: textDark).copyWith(inherit: kInherit)
        : GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600, color: textDark).copyWith(inherit: kInherit),
      titleMedium: isAr 
        ? GoogleFonts.alexandria(fontSize: 16, fontWeight: FontWeight.w600, color: textDark).copyWith(inherit: kInherit)
        : GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: textDark).copyWith(inherit: kInherit),
      bodyLarge: isAr 
        ? GoogleFonts.ibmPlexSansArabic(fontSize: 16, color: textDark).copyWith(inherit: kInherit)
        : GoogleFonts.ibmPlexSans(fontSize: 16, color: textDark).copyWith(inherit: kInherit),
      bodyMedium: isAr 
        ? GoogleFonts.ibmPlexSansArabic(fontSize: 14, color: textDark).copyWith(inherit: kInherit)
        : GoogleFonts.ibmPlexSans(fontSize: 14, color: textDark).copyWith(inherit: kInherit),
      labelSmall: isAr 
        ? GoogleFonts.ibmPlexSansArabic(fontSize: 10, fontWeight: FontWeight.bold, color: textDark).copyWith(inherit: kInherit)
        : GoogleFonts.ibmPlexSans(fontSize: 10, fontWeight: FontWeight.bold, color: textDark).copyWith(inherit: kInherit),
    );

    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundLight,
      textTheme: textTheme,
      fontFamily: isAr ? GoogleFonts.ibmPlexSansArabic().fontFamily : GoogleFonts.ibmPlexSans().fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        secondary: secondaryColor,
        error: heritageRed, // Defined explicitly for the entire app
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: textLight,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: isAr 
          ? GoogleFonts.alexandria(fontSize: 18, fontWeight: FontWeight.bold, color: textLight).copyWith(inherit: kInherit)
          : GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: textLight).copyWith(inherit: kInherit),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: textLight,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
          ),
          textStyle: isAr 
            ? GoogleFonts.ibmPlexSansArabic(fontWeight: FontWeight.bold, letterSpacing: 1.5).copyWith(inherit: kInherit)
            : GoogleFonts.ibmPlexSans(fontWeight: FontWeight.bold, letterSpacing: 1.5).copyWith(inherit: kInherit),
        ),
      ),
    );
  }

  // Deprecated getters to maintain compatibility during refactor
  static ThemeData get ltrTheme => getTheme(const Locale('en'));
  static ThemeData get rtlTheme => getTheme(const Locale('ar'));
}
