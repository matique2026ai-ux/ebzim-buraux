import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  
  // ── Brand Colors ─────────────────────────────────────────────────────────
  static const Color primaryColor   = Color(0xFF004900);     // Heritage Emerald
  static const Color accentColor    = Color(0xFFC5A059);     // Restrained Gold
  static const Color heritageRed    = Color(0xFF9E1F1F);     // Heritage Crimson
  static const Color secondaryColor = Color(0xFF685D4A);     // Earthy Bronze

  // ── Dark mode surfaces ────────────────────────────────────────────────────
  static const Color backgroundDark = Color(0xFF020F08);     // Midnight Green
  static const Color borderGlass    = Color(0x1AFFFFFF);     // Muted white border

  // ── Light mode tokens ─────────────────────────────────────────────────────
  // NOT plain white. Warm parchment / aged ivory system.
  static const Color _lightBg       = Color(0xFFF3EFE6);    // Warm Parchment
  static const Color _lightSurface  = Color(0xFFFAF7F2);    // Ivory Card
  static const Color _lightCard     = Color(0xFFFEFCF8);    // Off-white card
  static const Color _lightBorder   = Color(0xFFE3D9C8);    // Warm sand border
  static const Color _lightText     = Color(0xFF1A2E1E);    // Deep forest text
  static const Color _lightSubtext  = Color(0xFF5A6E5E);    // Muted sage

  /// Unified theme generator based on locale and mode.
  static ThemeData getTheme(Locale locale, ThemeMode mode) {
    final bool isAr = locale.languageCode == 'ar';
    final bool isDark = mode == ThemeMode.dark;
    const bool kInherit = true;

    final Color scaffoldBg = isDark ? backgroundDark : _lightBg;
    final Color textColor  = isDark ? Colors.white    : _lightText;

    final TextTheme textTheme = TextTheme(
      headlineLarge: GoogleFonts.tajawal(fontSize: 40, fontWeight: FontWeight.bold,   color: textColor,                                       height: 1.2),
      headlineMedium:GoogleFonts.tajawal(fontSize: 28, fontWeight: FontWeight.bold,   color: textColor),
      titleLarge:    GoogleFonts.tajawal(fontSize: 22, fontWeight: FontWeight.w600,   color: isDark ? accentColor : primaryColor),
      titleMedium:   GoogleFonts.tajawal(fontSize: 18, fontWeight: FontWeight.w600,   color: textColor),
      bodyLarge:     GoogleFonts.tajawal(fontSize: 16,                                color: textColor.withValues(alpha: 0.9)),
      bodyMedium:    GoogleFonts.tajawal(fontSize: 14,                                color: isDark ? textColor.withValues(alpha: 0.8) : _lightSubtext),
      bodySmall:     GoogleFonts.tajawal(fontSize: 12,                                color: isDark ? textColor.withValues(alpha: 0.5) : _lightSubtext.withValues(alpha: 0.7)),
      labelSmall:    GoogleFonts.tajawal(fontSize: 10, fontWeight: FontWeight.bold,   color: isDark ? accentColor : accentColor.withValues(alpha: 0.85), letterSpacing: 1.5),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: scaffoldBg,
      textTheme: textTheme,
      fontFamily: isAr ? GoogleFonts.tajawal().fontFamily : 'Inter',

      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        secondary: accentColor,
        error: heritageRed,
        surface: isDark ? const Color(0xFF0A140F) : _lightSurface,
        onSurface: textColor,
        brightness: isDark ? Brightness.dark : Brightness.light,
      ).copyWith(
        // Manually override warm light palette entries ColorScheme misses
        surfaceContainerHighest: isDark ? Colors.white10 : const Color(0xFFEDE6D8),
        outlineVariant: isDark ? Colors.white12 : _lightBorder,
        primaryContainer: isDark ? primaryColor.withValues(alpha: 0.3) : const Color(0xFFDFF2E5),
        onPrimary: Colors.white,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: textColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.tajawal(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: textColor,
        ).copyWith(inherit: kInherit),
        iconTheme: IconThemeData(color: textColor),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark ? backgroundDark : _lightCard,
        selectedItemColor: isDark ? accentColor : primaryColor,
        unselectedItemColor: isDark ? Colors.white38 : _lightSubtext.withValues(alpha: 0.5),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? accentColor : primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.tajawal(
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ).copyWith(inherit: kInherit),
        ),
      ),

      dividerTheme: DividerThemeData(
        color: isDark ? Colors.white10 : _lightBorder,
        thickness: 1,
      ),

      cardTheme: CardThemeData(
        color: isDark ? const Color(0xFF0A140F) : _lightCard,
        elevation: isDark ? 0 : 1,
        shadowColor: isDark ? Colors.transparent : Colors.black.withValues(alpha: 0.06),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isDark ? borderGlass : _lightBorder,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFF0EBE0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: isDark ? Colors.white12 : _lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: isDark ? Colors.white12 : _lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: isDark ? accentColor : primaryColor, width: 1.5),
        ),
        hintStyle: TextStyle(
          color: isDark ? Colors.white30 : _lightSubtext.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  // Backward compatibility
  static ThemeData get ltrTheme => getTheme(const Locale('en'), ThemeMode.dark);
  static ThemeData get rtlTheme => getTheme(const Locale('ar'), ThemeMode.dark);
}
