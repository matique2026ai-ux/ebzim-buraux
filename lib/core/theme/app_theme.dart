import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  
  // Base Colors
  static const Color primaryColor = Color(0xFF004900);     // Heritage Emerald
  static const Color heritageGreenDeep = Color(0xFF002400); // Deep Forest Green (New)
  static const Color secondaryColor = Color(0xFF685D4A);   // Earthy Bronze
  static const Color accentColor = Color(0xFFC5A059);      // Restrained Gold
  static const Color heritageRed = Color(0xFF9E1F1F);      // Heritage Crimson
  
  static const Color backgroundDark = Color(0xFF020F08);   // Midnight Green
  static const Color surfaceGlass = Color(0x99000000);     // Strong Dark Glass (60% opacity) for high contrast
  static const Color borderGlass = Color(0x1AFFFFFF);      // Muted white border

  /// Unified theme generator based on locale.
  static ThemeData getTheme(Locale locale) {
    final bool isAr = locale.languageCode == 'ar';
    const bool kInherit = true;

    final TextTheme textTheme = TextTheme(
      headlineLarge: GoogleFonts.arefRuqaa(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white, height: 1.2),
      headlineMedium: GoogleFonts.cairo(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
      titleLarge: GoogleFonts.cairo(fontSize: 22, fontWeight: FontWeight.w600, color: accentColor),
      titleMedium: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
      bodyLarge: GoogleFonts.cairo(fontSize: 16, color: Colors.white.withValues(alpha: 0.9)),
      bodyMedium: GoogleFonts.cairo(fontSize: 14, color: Colors.white.withValues(alpha: 0.8)),
      bodySmall: GoogleFonts.cairo(fontSize: 12, color: Colors.white.withValues(alpha: 0.6)),
      labelSmall: GoogleFonts.cairo(fontSize: 10, fontWeight: FontWeight.bold, color: accentColor, letterSpacing: 1.5),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: primaryColor, // Keeping the green base as requested
      textTheme: textTheme,
      fontFamily: isAr ? 'Cairo' : 'Inter',
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        secondary: accentColor,
        error: heritageRed,
        surface: primaryColor.withValues(alpha: 0.5),
        brightness: Brightness.dark,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white).copyWith(inherit: kInherit),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: Colors.black, // Dark text on gold for premium look
          elevation: 8,
          shadowColor: Colors.black45,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.cairo(fontWeight: FontWeight.bold, letterSpacing: 1).copyWith(inherit: kInherit),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: Colors.white.withValues(alpha: 0.1),
        thickness: 1,
      ),
    );
  }

  // Deprecated getters to maintain compatibility during refactor
  static ThemeData get ltrTheme => getTheme(const Locale('en'));
  static ThemeData get rtlTheme => getTheme(const Locale('ar'));
}
