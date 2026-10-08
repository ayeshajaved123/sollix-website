import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/responsive.dart';
import '../widgets/custom_button.dart';

// Shared shape proportions — used by BOTH the painter (to draw the navy
// shape) and the text constraint (so text never spills past the edge).
// The shape is a sharp chevron ">" — NOT a curve — that points right,
// out into the photo, with the vertex sitting a bit above center.
const double _kTopFrac = 0.46; // navy edge x-position at top (y=0)
const double _kPeakFrac = 0.60; // vertex x-position — pokes out into photo
const double _kPeakYFrac = 0.40; // vertex vertical position (0=top, 1=bottom)
const double _kBottomFrac = 0.52; // navy edge x-position at bottom (y=height)

class HeroSection extends StatelessWidget {
  final VoidCallback onServicesTap;
  final VoidCallback onContactTap;

  const HeroSection({
    super.key,
    required this.onServicesTap,
    required this.onContactTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool desktop = Responsive.isDesktop(context);
    final double heroHeight = desktop ? 520 : 620;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double horizontalPadding = Responsive.pagePadding(context);

    const double narrowestFrac =
        _kTopFrac < _kBottomFrac ? _kTopFrac : _kBottomFrac;
    final double safeTextWidth =
        screenWidth * narrowestFrac - horizontalPadding - 24;

    final textContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          text: TextSpan(
            style: AppTextStyles.heading(
                size: desktop ? 42 : 28, color: AppColors.white),
            children: const [
              TextSpan(text: 'PROTECTING LIVES.\nSECURING '),
              TextSpan(
                text: 'FUTURES.',
                style: TextStyle(color: AppColors.primaryRed),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Expert in Firefighting Installation & Maintenance Services '
          'Across Dubai & UAE',
          style: AppTextStyles.subheading(
              size: desktop ? 16 : 15, color: AppColors.white),
        ),
        const SizedBox(height: 10),
        Container(width: 46, height: 3, color: AppColors.primaryRed),
        const SizedBox(height: 16),
        Text(
          'We deliver high-quality, reliable, and compliant fire '
          'protection solutions tailored to your needs.',
          style: AppTextStyles.body(size: 13.5, color: AppColors.mutedWhite),
        ),
        const SizedBox(height: 26),
        Wrap(
          spacing: 14,
          runSpacing: 12,
          children: [
            CustomButton(label: 'OUR SERVICES', onPressed: onServicesTap),
            CustomButton(
              label: 'CONTACT US',
              type: ButtonStyleType.outlined,
              onPressed: onContactTap,
            ),
          ],
        ),
      ],
    );

    return SizedBox(
      width: double.infinity,
      height: heroHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/hero_facility.jpg',
            fit: BoxFit.cover,
          ),
          Positioned.fill(
            child: CustomPaint(
              painter: desktop ? _ChevronNavyPainter() : _FullNavyPainter(),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: desktop ? 50 : 40,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: desktop ? safeTextWidth : double.infinity,
                ),
                child: textContent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Desktop: translucent navy panel with a sharp chevron (">") right edge —
/// two straight lines meeting at a vertex that points out into the photo.
class _ChevronNavyPainter extends CustomPainter {
  Path _shapePath(Size size, double offset) {
    final double topX = size.width * _kTopFrac + offset;
    final double peakX = size.width * _kPeakFrac + offset;
    final double peakY = size.height * _kPeakYFrac;
    final double bottomX = size.width * _kBottomFrac + offset;

    return Path()
      ..moveTo(0, 0)
      ..lineTo(topX, 0)
      ..lineTo(peakX, peakY)
      ..lineTo(bottomX, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      _shapePath(size, 0),
      Paint()..color = AppColors.primaryNavy.withValues(alpha: 0.90),
    );

    canvas.drawPath(
      _shapePath(size, 10),
      Paint()
        ..color = AppColors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeJoin = StrokeJoin.miter,
    );

    canvas.drawPath(
      _shapePath(size, 20),
      Paint()
        ..color = AppColors.primaryRed
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeJoin = StrokeJoin.miter,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Mobile: simple full-width translucent navy wash.
class _FullNavyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = AppColors.primaryNavy.withValues(alpha: 0.88),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
