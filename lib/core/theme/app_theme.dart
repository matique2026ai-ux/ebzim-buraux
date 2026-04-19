import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  
  // ── EMERALD NOCTURNE IDENTITY (Official Milestone April 2026) ──────
  // DO NOT ALTER: These tokens define the institutional visual prestige.
  // Contact Design Lead before introducing any neutral greys or standard blacks.
  
  // ── Brand Colors ─────────────────────────────────────────────────────────
  static const Color primaryColor   = Color(0xFF052011);     // Deep Emerald / Midnight
  static const Color accentColor    = Color(0xFFC5A059);     // Premium Antique Gold
  static const Color heritageRed    = Color(0xFF9E1F1F);     // Heritage Crimson
  static const Color secondaryColor = Color(0xFF685D4A);     // Earthy Bronze
  static const Color heritageOrange = Color(0xFFE67E22);     // Professional Heritage Orange

  // ── Dark mode surfaces ────────────────────────────────────────────────────
  static const Color backgroundDark = Color(0xFF010A08);     // Midnight Forest Obsidian
  static const Color borderGlass    = Color(0x4DFFFFFF);     // More Visible Glass Border (30%)

  // ── Light mode tokens — Sovereign Sage & Aged Parchment (Museum Grade) ──
  static const Color _lightBg       = Color(0xFFE2E9E5);    // Sovereign Sage (Definite colored feel, NOT white)
  static const Color _lightSurface  = Color(0xFFD4DFD9);    // Deeper Mint-Sage for structure
  static const Color _lightCard     = Color(0xFFFFFFFF);    // Pure White Cards (Pops against Sovereign Sage)
  static const Color _lightBorder   = Color(0xFFC5D4CD);    // Muted Sage Border
  static const Color _lightText     = Color(0xFF012411);    // Midnight Forest (Extreme contrast)
  static const Color _lightSubtext  = Color(0xFF3E5A4D);    // Institutional Moss

  /// Unified theme generator based on locale and mode.
  static ThemeData getTheme(Locale locale, ThemeMode mode) {
    final bool isAr = locale.languageCode == 'ar';
    final bool isDark = mode == ThemeMode.dark;
    const bool kInherit = true;

    final Color scaffoldBg = isDark ? backgroundDark : _lightBg;
    final Color textColor  = isDark ? Colors.white    : _lightText;

    final TextTheme textTheme = TextTheme(
      headlineLarge: GoogleFonts.tajawal(fontSize: 40, fontWeight: FontWeight.bold,   color: isDark ? Colors.white : _lightText,             height: 1.2),
      headlineMedium:GoogleFonts.tajawal(fontSize: 28, fontWeight: FontWeight.bold,   color: isDark ? Colors.white : _lightText),
      titleLarge:    GoogleFonts.tajawal(fontSize: 22, fontWeight: FontWeight.w600,   color: isDark ? accentColor : primaryColor),
      titleMedium:   GoogleFonts.tajawal(fontSize: 18, fontWeight: FontWeight.w600,   color: isDark ? Colors.white : _lightText),
      bodyLarge:     GoogleFonts.cairo(fontSize: 16,                                color: isDark ? Colors.white.withOpacity(0.9) : _lightText.withOpacity(0.9)),
      bodyMedium:    GoogleFonts.cairo(fontSize: 14,                                color: isDark ? Colors.white.withOpacity(0.8) : _lightSubtext),
      bodySmall:     GoogleFonts.cairo(fontSize: 12,                                color: isDark ? Colors.white.withOpacity(0.5) : _lightSubtext.withOpacity(0.75)),
      labelSmall:    GoogleFonts.cairo(fontSize: 10, fontWeight: FontWeight.bold,   color: isDark ? accentColor : accentColor, letterSpacing: 1.5),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: scaffoldBg,
      textTheme: textTheme,
      fontFamily: isAr ? GoogleFonts.tajawal().fontFamily : 'Inter',

      colorScheme: ColorScheme(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: isDark ? accentColor : primaryColor,
        onPrimary: Colors.white,
        primaryContainer: isDark ? primaryColor.withOpacity(0.3) : const Color(0xFFD6EDD9),
        onPrimaryContainer: isDark ? Colors.white : primaryColor,
        secondary: isDark ? accentColor : const Color(0xFF5A7A5E),
        onSecondary: Colors.white,
        secondaryContainer: isDark ? accentColor.withOpacity(0.2) : const Color(0xFFE8F0E9),
        onSecondaryContainer: isDark ? Colors.white : primaryColor,
        error: heritageRed,
        onError: Colors.white,
        surface: isDark ? const Color(0xFF0A140F) : _lightSurface,
        onSurface: textColor,
        surfaceContainerHighest: isDark ? Colors.white10 : const Color(0xFFE8E2D8),
        outlineVariant: isDark ? Colors.white12 : _lightBorder,
        outline: isDark ? Colors.white24 : _lightBorder,
        inverseSurface: isDark ? Colors.white : primaryColor,
        onInverseSurface: isDark ? primaryColor : Colors.white,
        inversePrimary: isDark ? primaryColor : accentColor,
        shadow: Colors.black.withOpacity(0.12),
        scrim: Colors.black.withOpacity(0.35),
        primaryFixed: isDark ? const Color(0xFF0A2B1A) : const Color(0xFFDFF2E5),
        onPrimaryFixed: isDark ? Colors.white : primaryColor,
        tertiaryFixed: isDark ? accentColor.withOpacity(0.1) : const Color(0xFFF5EDD4),
        onTertiaryFixed: isDark ? Colors.white : const Color(0xFF6E5A1E),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? Colors.transparent : _lightBg.withOpacity(0.92),
        foregroundColor: isDark ? Colors.white : _lightText,
        elevation: 0,
        shadowColor: isDark ? Colors.transparent : Colors.black.withOpacity(0.05),
        centerTitle: true,
        titleTextStyle: GoogleFonts.tajawal(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : _lightText,
        ).copyWith(inherit: kInherit),
        iconTheme: IconThemeData(color: isDark ? Colors.white : _lightText),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark ? backgroundDark : _lightCard,
        selectedItemColor: isDark ? accentColor : primaryColor,
        unselectedItemColor: isDark ? Colors.white38 : _lightSubtext.withOpacity(0.5),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? accentColor : primaryColor,
          foregroundColor: Colors.white,
          elevation: isDark ? 0 : 2,
          shadowColor: isDark ? Colors.transparent : primaryColor.withOpacity(0.25),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
        color: isDark ? const Color(0xFF061A12).withOpacity(0.6) : _lightCard,
        elevation: isDark ? 0 : 3,
        shadowColor: isDark ? Colors.transparent : Colors.black.withOpacity(0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: isDark ? borderGlass : _lightBorder.withOpacity(0.7),
            width: 0.8,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? Colors.white.withOpacity(0.04) : const Color(0xFFEDE7DB),
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
          color: isDark ? Colors.white30 : _lightSubtext.withOpacity(0.5),
        ),
        labelStyle: TextStyle(
          color: isDark ? Colors.white54 : _lightSubtext,
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFE8E2D5),
        selectedColor: isDark ? accentColor.withOpacity(0.2) : primaryColor.withOpacity(0.12),
        side: BorderSide(color: isDark ? Colors.white12 : _lightBorder),
        labelStyle: GoogleFonts.cairo(
          color: isDark ? Colors.white70 : _lightText,
          fontSize: 12,
        ),
      ),

      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return isDark ? accentColor : primaryColor;
          }
          return Colors.transparent;
        }),
        side: BorderSide(color: isDark ? Colors.white38 : _lightSubtext, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
  }

  // Backward compatibility
  static ThemeData get ltrTheme => getTheme(const Locale('en'), ThemeMode.dark);
  static ThemeData get rtlTheme => getTheme(const Locale('ar'), ThemeMode.dark);
}
