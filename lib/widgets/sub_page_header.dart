import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/responsive.dart';

/// Solid navy banner shown at the top of every standalone page — gives
/// each page a clear identity, like a real multi-page website.
class SubPageHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const SubPageHeader({super.key, required this.title, this.subtitle = ''});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.primaryNavy,
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.pagePadding(context),
        vertical: 50,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: AppTextStyles.heading(size: 34, color: AppColors.white)),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(subtitle,
                style:
                    AppTextStyles.body(size: 14, color: AppColors.mutedWhite)),
          ],
          const SizedBox(height: 10),
          Container(width: 46, height: 3, color: AppColors.primaryRed),
        ],
      ),
    );
  }
}
