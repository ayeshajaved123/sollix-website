import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Centralized typography. Headings use a bold condensed-style font
/// (Oswald) to match the mockup's industrial/corporate look.
/// Body text uses a clean, highly-readable sans (Inter).
class AppTextStyles {
  AppTextStyles._();

  static TextStyle heading({
    double size = 40,
    Color color = AppColors.black,
    FontWeight weight = FontWeight.w700,
  }) =>
      GoogleFonts.oswald(
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: 1.15,
      );

  static TextStyle subheading({
    double size = 18,
    Color color = AppColors.mutedText,
    FontWeight weight = FontWeight.w400,
  }) =>
      GoogleFonts.inter(
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: 1.5,
      );

  static TextStyle body({
    double size = 15,
    Color color = AppColors.mutedText,
    FontWeight weight = FontWeight.w400,
  }) =>
      GoogleFonts.inter(
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: 1.6,
      );

  static TextStyle label({
    double size = 13,
    Color color = AppColors.primaryRed,
    FontWeight weight = FontWeight.w600,
  }) =>
      GoogleFonts.inter(
        fontSize: size,
        fontWeight: weight,
        color: color,
        letterSpacing: 1.2,
      );

  static TextStyle button({
    double size = 14,
    Color color = AppColors.white,
  }) =>
      GoogleFonts.inter(
        fontSize: size,
        fontWeight: FontWeight.w600,
        color: color,
        letterSpacing: 0.5,
      );
}
