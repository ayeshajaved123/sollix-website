import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/responsive.dart';
import '../widgets/scroll_reveal.dart';

class _FeatureData {
  final IconData icon;
  final String title;
  final String desc;
  const _FeatureData(this.icon, this.title, this.desc);
}

const _features = [
  _FeatureData(Icons.verified_user_outlined, 'DCD Compliant',
      'All systems installed as per Dubai Civil Defense standards.'),
  _FeatureData(Icons.groups_outlined, 'Expert Team',
      'Certified engineers & technicians with years of industry experience.'),
  _FeatureData(Icons.settings_suggest_outlined, 'Quality Assured',
      'Top-quality materials, advanced tools & approved installation techniques.'),
  _FeatureData(Icons.access_time_outlined, 'On-Time Delivery',
      'Committed to completing projects on time and within budget.'),
  _FeatureData(Icons.handshake_outlined, 'Client Satisfaction',
      'We build trust through reliable service and long-term relationships.'),
];

class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final bool desktop = Responsive.isDesktop(context);
    final bool tablet = Responsive.isTablet(context);
    final int columns = desktop ? 5 : (tablet ? 3 : 1);

    return Container(
      color: AppColors.white,
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.pagePadding(context),
        vertical: 40,
      ),
      child: Wrap(
        spacing: 24,
        runSpacing: 28,
        children: _features.asMap().entries.map((entry) {
          final index = entry.key;
          final f = entry.value;
          final width =
              (MediaQuery.of(context).size.width - (Responsive.pagePadding(context) * 2) - (24 * (columns - 1))) /
                  columns;
          return SizedBox(
            width: width.clamp(180, 400),
            child: ScrollReveal(
              delay: Duration(milliseconds: 80 * index),
              child: _FeatureItem(data: f),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final _FeatureData data;
  const _FeatureItem({required this.data});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 46,
          height: 46,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primaryRed, width: 1.4),
          ),
          child: Icon(data.icon, color: AppColors.primaryRed, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.title,
                style: AppTextStyles.body(
                  size: 13.5,
                  weight: FontWeight.w700,
                  color: AppColors.primaryNavy,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                data.desc,
                style: AppTextStyles.body(size: 12.5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
