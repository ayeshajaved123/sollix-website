import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/responsive.dart';
import '../widgets/custom_button.dart';

class CtaBannerSection extends StatelessWidget {
  final VoidCallback onTap;
  const CtaBannerSection({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool desktop = Responsive.isDesktop(context);

    final textBlock = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 52,
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.white, width: 1.4),
          ),
          child: const Icon(Icons.call_outlined, color: AppColors.white),
        ),
        const SizedBox(width: 18),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'NEED A FIRE PROTECTION SOLUTION?',
              style: AppTextStyles.body(
                size: desktop ? 18 : 15,
                weight: FontWeight.w700,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Let's build a safer tomorrow together.",
              style: AppTextStyles.body(size: 13, color: AppColors.mutedWhite),
            ),
          ],
        ),
      ],
    );

    return Container(
      width: double.infinity,
      color: AppColors.primaryRed,
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.pagePadding(context),
        vertical: 30,
      ),
      child: desktop
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                textBlock,
                CustomButton(
                  label: 'GET IN TOUCH',
                  onPressed: onTap,
                  color: AppColors.primaryNavy,
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textBlock,
                const SizedBox(height: 20),
                CustomButton(
                  label: 'GET IN TOUCH',
                  onPressed: onTap,
                  color: AppColors.primaryNavy,
                ),
              ],
            ),
    );
  }
}
