import 'package:flutter/widgets.dart';

/// Simple, dependency-free responsive helper.
/// Three breakpoints only — mobile / tablet / desktop — kept intentionally
/// minimal so the rest of the app stays easy to reason about.
class Responsive {
  Responsive._();

  static const double mobileMax = 700;
  static const double tabletMax = 1100;
  static const double maxContentWidth = 1200;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileMax;

  static bool isTablet(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return w >= mobileMax && w < tabletMax;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletMax;

  /// Horizontal page padding — smaller on mobile, generous on desktop.
  static double pagePadding(BuildContext context) {
    if (isMobile(context)) return 20;
    if (isTablet(context)) return 40;
    return 80;
  }
}
