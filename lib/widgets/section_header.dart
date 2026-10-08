import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Small red eyebrow label + big bold heading + short red underline.
/// Used at the top of Services / Projects / etc. sections.
class SectionHeader extends StatelessWidget {
  final String eyebrow;
  final String title;
  final CrossAxisAlignment align;

  const SectionHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    this.align = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(eyebrow, style: AppTextStyles.label()),
        const SizedBox(height: 8),
        Text(
          title,
          style: AppTextStyles.heading(size: 32, color: AppColors.primaryNavy),
        ),
        const SizedBox(height: 10),
        Container(width: 50, height: 3, color: AppColors.primaryRed),
      ],
    );
  }
}
