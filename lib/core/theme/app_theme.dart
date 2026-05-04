import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Color Palette - Modern Playful Enchanted
  static const Color softRose = Color(0xFFFFF0F5); // Background
  static const Color sunsetOrange = Color(0xFFFF7043); // Primary CTA
  static const Color deepViolet = Color(0xFF311B92); // Text and active elements
  static const Color softViolet = Color(0xFFD1C4E9); // Secondary elements/cards
  
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: sunsetOrange,
      scaffoldBackgroundColor: softRose,
      textTheme: GoogleFonts.nunitoTextTheme().apply(
        bodyColor: deepViolet,
        displayColor: deepViolet,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: sunsetOrange,
          foregroundColor: Colors.white,
          textStyle: GoogleFonts.nunito(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 4,
          shadowColor: sunsetOrange.withValues(alpha: 0.5),
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shadowColor: softViolet.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: softViolet, width: 2),
        ),
      ),
    );
  }
}
