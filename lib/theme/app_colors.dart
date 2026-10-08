import 'package:flutter/material.dart';

/// Centralized brand colors for SOLLIX.
/// Keep ALL color references pointing here — never hardcode hex values
/// inside widgets. This makes future re-branding / theming trivial.
class AppColors {
  AppColors._();

  static const Color primaryRed = Color(0xFFE31E24);
  static const Color primaryNavy = Color(0xFF393185);

  static const Color darkNavy = Color(0xFF2A2560); // footer / darker panels
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF1A1A1A);

  static const Color lightGrey = Color(0xFFF6F6F9); // section alt background
  static const Color borderGrey = Color(0xFFE5E5EA);
  static const Color mutedText = Color(0xFF6B6B76);
  static const Color mutedWhite = Color(0xB3FFFFFF); // white @ 70% opacity

  static const Gradient heroOverlay = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryNavy, darkNavy],
  );
}
