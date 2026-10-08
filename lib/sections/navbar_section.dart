import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/brand_logo.dart';
import '../widgets/custom_button.dart';
import '../utils/nav_utils.dart';

class NavbarSection extends StatelessWidget {
  const NavbarSection({super.key});

  static const _navItems = [
    {'label': 'HOME', 'route': '/'},
    {'label': 'ABOUT US', 'route': '/about'},
    {'label': 'SERVICES', 'route': '/services'},
    {'label': 'PROJECTS', 'route': '/projects'},
    {'label': 'OUR VALUES', 'route': '/values'},
    {'label': 'CONTACT US', 'route': '/contact'},
  ];

  static const double _fullNavBreakpoint = 1000;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool showFullNav = width >= _fullNavBreakpoint;
    final double horizontalPadding =
        width < 700 ? 20 : (width < 1000 ? 32 : 56);
    final String currentRoute = ModalRoute.of(context)?.settings.name ?? '/';

    return Container(
      color: AppColors.white,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: 18,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const BrandLogoBlock(),
          if (showFullNav) ...[
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _navItems
                    .map((item) => _NavItem(
                          label: item['label']!,
                          active: currentRoute == item['route'],
                          onTap: () => goToPage(context, item['route']!),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(width: 20),
            CustomButton(
              label: 'GET A QUOTE',
              icon: Icons.call,
              onPressed: () => goToPage(context, '/contact'),
            ),
          ] else
            IconButton(
              icon: const Icon(Icons.menu, color: AppColors.primaryNavy),
              onPressed: () => _openMobileMenu(context),
            ),
        ],
      ),
    );
  }

  void _openMobileMenu(BuildContext context) {
    final String currentRoute = ModalRoute.of(context)?.settings.name ?? '/';
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            ..._navItems.map(
              (item) => ListTile(
                title: Text(
                  item['label']!,
                  style: AppTextStyles.body(
                    size: 16,
                    weight: currentRoute == item['route']
                        ? FontWeight.w700
                        : FontWeight.w400,
                    color: currentRoute == item['route']
                        ? AppColors.primaryRed
                        : AppColors.black,
                  ),
                ),
                onTap: () {
                  Navigator.pop(sheetContext);
                  goToPage(context, item['route']!);
                },
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.onTap,
    this.active = false,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final bool highlighted = widget.active || _hovering;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: AppTextStyles.body(
                  size: 13,
                  weight: FontWeight.w600,
                  color: highlighted ? AppColors.primaryRed : AppColors.black,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                height: 2,
                width: highlighted ? 16 : 0,
                color: AppColors.primaryRed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
