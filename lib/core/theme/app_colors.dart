import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette - Black, Gold, White
  static const Color primaryBlack = Color(0xFF0A0A0A);
  static const Color primaryBlackLight = Color(0xFF1A1A1A);
  static const Color primaryBlackLighter = Color(0xFF2A2A2A);
  static const Color cardBlack = Color(0xFF121212);
  
  static const Color primaryGold = Color(0xFFD4AF37); // Metallic Gold
  static const Color goldLight = Color(0xFFE8C765);
  static const Color goldDark = Color(0xFFB8962E);
  static const Color goldAccent = Color(0xFFF4E4BC);
  
  static const Color primaryWhite = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFF8F6F0);
  static const Color lightGrey = Color(0xFFE5E5E5);
  static const Color mediumGrey = Color(0xFF9E9E9E);
  static const Color darkGrey = Color(0xFF616161);

  // Semantic
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFEF5350);
  static const Color background = primaryBlack;
  static const Color surface = primaryBlackLight;

  // Gradients
  static const LinearGradient goldGradient = LinearGradient(
    colors: [goldDark, primaryGold, goldLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient blackGradient = LinearGradient(
    colors: [primaryBlack, primaryBlackLight],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1E1E1E), Color(0xFF121212)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
