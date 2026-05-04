import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PureWhiteTheme {
  // Premium Color Palette
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardFill = Color(0xFFFAFAFA);
  static const Color divider = Color(0xFFF0F0F0);
  
  // Accents
  static const Color tarbiyaGold = Color(0xFFD4AF37);
  static const Color deepIndigo = Color(0xFF1A1F71);
  static const Color successGreen = Color(0xFF00C853);
  
  static const double borderRadius = 32.0;

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.light(
        surface: background,
        primary: deepIndigo,
        secondary: tarbiyaGold,
        onSurface: deepIndigo,
      ),
      dividerTheme: const DividerThemeData(
        color: divider,
        thickness: 1.0,
        space: 1.0,
      ),
      textTheme: GoogleFonts.outfitTextTheme().copyWith(
        displayLarge: GoogleFonts.outfit(
          fontWeight: FontWeight.bold,
          color: deepIndigo,
          letterSpacing: -0.5,
        ),
        headlineMedium: GoogleFonts.outfit(
          fontWeight: FontWeight.bold,
          color: deepIndigo,
        ),
        bodyLarge: GoogleFonts.inter(
          fontWeight: FontWeight.normal,
          color: deepIndigo.withValues(alpha: 0.8),
        ),
        bodyMedium: GoogleFonts.inter(
          fontWeight: FontWeight.normal,
          color: deepIndigo.withValues(alpha: 0.6),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: deepIndigo,
          foregroundColor: Colors.white,
          elevation: 0, // DISABLED shadows
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0, // DISABLED shadows
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: const BorderSide(color: divider, width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        foregroundColor: deepIndigo,
      ),
    );
  }
}
