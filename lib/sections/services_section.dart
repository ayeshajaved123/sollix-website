import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/responsive.dart';
import '../widgets/custom_button.dart';
import '../widgets/section_header.dart';
import '../widgets/icon_mapper.dart';
import '../models/service_model.dart';
import '../services/firestore_service.dart';

class ServicesSection extends StatelessWidget {
  final VoidCallback? onViewAll;
  const ServicesSection({super.key, this.onViewAll});

  @override
  Widget build(BuildContext context) {
    final bool desktop = Responsive.isDesktop(context);
    final firestoreService = FirestoreService();

    final intro = Expanded(
      flex: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(eyebrow: 'WHAT WE DO', title: 'OUR SERVICES'),
          const SizedBox(height: 16),
          Text(
            'We provide comprehensive fire protection and life safety '
            'solutions for all types of projects.',
            style: AppTextStyles.body(),
          ),
          if (onViewAll != null) ...[
            const SizedBox(height: 24),
            CustomButton(label: 'VIEW ALL SERVICES', onPressed: onViewAll!),
          ],
        ],
      ),
    );

    final list = Expanded(
      flex: 8,
      child: StreamBuilder<List<ServiceModel>>(
        stream: firestoreService.watchServices(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text('Could not load services right now.',
                  style: AppTextStyles.body(color: AppColors.primaryRed)),
            );
          }
          final services = snapshot.data ?? [];
          if (services.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text('Services coming soon.', style: AppTextStyles.body()),
            );
          }

          final left = <ServiceModel>[];
          final right = <ServiceModel>[];
          for (int i = 0; i < services.length; i++) {
            (i.isEven ? left : right).add(services[i]);
          }

          return desktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _ServiceColumn(items: left)),
                    const SizedBox(width: 20),
                    Expanded(child: _ServiceColumn(items: right)),
                  ],
                )
              : Column(
                  children: [
                    _ServiceColumn(items: left),
                    const SizedBox(height: 16),
                    _ServiceColumn(items: right),
                  ],
                );
        },
      ),
    );

    return Container(
      color: AppColors.white,
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.pagePadding(context),
        vertical: 60,
      ),
      child: desktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [intro, const SizedBox(width: 40), list],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                intro,
                const SizedBox(height: 30),
                list,
              ],
            ),
    );
  }
}

class _ServiceColumn extends StatelessWidget {
  final List<ServiceModel> items;
  const _ServiceColumn({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items
          .map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _ServiceRow(item: item),
              ))
          .toList(),
    );
  }
}

class _ServiceRow extends StatefulWidget {
  final ServiceModel item;
  const _ServiceRow({required this.item});

  @override
  State<_ServiceRow> createState() => _ServiceRowState();
}

class _ServiceRowState extends State<_ServiceRow> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _hovering ? AppColors.lightGrey : Colors.transparent,
          border: Border.all(color: AppColors.borderGrey),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primaryRed,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(IconMapper.iconFor(widget.item.icon),
                  color: AppColors.white, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                widget.item.title,
                style: AppTextStyles.body(
                  size: 13,
                  weight: FontWeight.w700,
                  color: AppColors.primaryNavy,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
