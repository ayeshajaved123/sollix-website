import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/responsive.dart';

class _StatData {
  final IconData icon;
  final String value;
  final String label;
  const _StatData(this.icon, this.value, this.label);
}

const _stats = [
  _StatData(Icons.shield_outlined, '100%', 'DCD COMPLIANT\nSOLUTIONS'),
  _StatData(Icons.groups_outlined, '50+', 'SUCCESSFUL\nPROJECTS'),
  _StatData(Icons.engineering_outlined, '15+', 'YEARS OF COMBINED\nEXPERIENCE'),
  _StatData(Icons.access_time_filled_outlined, '24/7', 'SUPPORT & MAINTENANCE\nSERVICES'),
];

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final bool desktop = Responsive.isDesktop(context);

    return Container(
      width: double.infinity,
      color: AppColors.primaryNavy,
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.pagePadding(context),
        vertical: 46,
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        runSpacing: 30,
        children: _stats
            .map((s) => SizedBox(
                  width: desktop ? 220 : 160,
                  child: _StatItem(data: s),
                ))
            .toList(),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final _StatData data;
  const _StatItem({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(data.icon, color: AppColors.white, size: 30),
        const SizedBox(height: 12),
        Text(
          data.value,
          style: AppTextStyles.heading(size: 34, color: AppColors.primaryRed),
        ),
        const SizedBox(height: 8),
        Text(
          data.label,
          textAlign: TextAlign.center,
          style: AppTextStyles.body(
            size: 12.5,
            weight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
      ],
    );
  }
}
