import 'package:flutter/material.dart';

/// Two logo files are used:
///   assets/images/logo.png        → navy/red version, for light backgrounds
///   assets/images/logo_white.png  → white version, for dark backgrounds (footer)
class BrandLogo extends StatelessWidget {
  final double height;
  final bool light;

  const BrandLogo({super.key, this.height = 42, this.light = false});

  static const double _aspectRatio = 1126 / 403;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: height * _aspectRatio,
      child: Image.asset(
        light ? 'assets/images/logo_white.png' : 'assets/images/logo.png',
        fit: BoxFit.contain,
      ),
    );
  }
}

class BrandLogoBlock extends StatelessWidget {
  final bool light;
  const BrandLogoBlock({super.key, this.light = false});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double logoHeight = width >= 1000 ? 48 : 36;
    return BrandLogo(height: logoHeight, light: light);
  }
}
