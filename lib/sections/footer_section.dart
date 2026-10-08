import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/responsive.dart';
import '../widgets/brand_logo.dart';
import '../utils/nav_utils.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  static const _quickLinks = [
    {'label': 'Home', 'route': '/'},
    {'label': 'About Us', 'route': '/about'},
    {'label': 'Services', 'route': '/services'},
    {'label': 'Projects', 'route': '/projects'},
    {'label': 'Our Values', 'route': '/values'},
    {'label': 'Contact Us', 'route': '/contact'},
  ];

  @override
  Widget build(BuildContext context) {
    final bool desktop = Responsive.isDesktop(context);

    final about = Expanded(
      flex: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BrandLogoBlock(light: true),
          const SizedBox(height: 14),
          Text(
            'Providing reliable firefighting installation and maintenance '
            'services across Dubai & UAE. Your safety is our priority.',
            style: AppTextStyles.body(size: 12.5, color: AppColors.mutedWhite),
          ),
          const SizedBox(height: 16),
          Row(
            children: const [
              _SocialIcon(Icons.facebook),
              SizedBox(width: 10),
              _SocialIcon(Icons.business_center_outlined),
              SizedBox(width: 10),
              _SocialIcon(Icons.camera_alt_outlined),
              SizedBox(width: 10),
              _SocialIcon(Icons.alternate_email),
            ],
          ),
        ],
      ),
    );

    final quickLinks = Expanded(
      flex: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('QUICK LINKS',
              style: AppTextStyles.body(
                  size: 13, weight: FontWeight.w700, color: AppColors.white)),
          const SizedBox(height: 14),
          ..._quickLinks.map((item) => _FooterLink(
                label: item['label']!,
                onTap: () => goToPage(context, item['route']!),
              )),
        ],
      ),
    );

    final services = Expanded(
      flex: 2,
      child: _FooterColumn(
        title: 'OUR SERVICES',
        items: const [
          'Fire Pump Systems',
          'Sprinkler Systems',
          'Fire Hose Reel Systems',
          'Fire Alarm Systems',
          'Foam Systems',
          'Maintenance Services'
        ],
      ),
    );

    final contact = Expanded(
      flex: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('CONTACT US',
              style: AppTextStyles.body(
                  size: 13, weight: FontWeight.w700, color: AppColors.white)),
          const SizedBox(height: 14),
          const _ContactRow(Icons.phone_outlined, '+971 50 123 4567'),
          const SizedBox(height: 10),
          const _ContactRow(Icons.email_outlined, 'info@sollix.ae'),
          const SizedBox(height: 10),
          const _ContactRow(
              Icons.location_on_outlined, 'Dubai, United Arab Emirates'),
        ],
      ),
    );

    return Column(
      children: [
        Container(
          width: double.infinity,
          color: AppColors.darkNavy,
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.pagePadding(context),
            vertical: 50,
          ),
          child: desktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    about,
                    const SizedBox(width: 30),
                    quickLinks,
                    const SizedBox(width: 30),
                    services,
                    const SizedBox(width: 30),
                    contact,
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    about,
                    const SizedBox(height: 30),
                    quickLinks,
                    const SizedBox(height: 30),
                    services,
                    const SizedBox(height: 30),
                    contact,
                  ],
                ),
        ),
        Container(
          width: double.infinity,
          color: AppColors.primaryRed,
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          child: Text(
            '© ${DateTime.now().year} SOLLIX Electromechanical Services LLC. All Rights Reserved.',
            style: AppTextStyles.body(size: 12, color: AppColors.white),
          ),
        ),
      ],
    );
  }
}

class _FooterLink extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _FooterLink({required this.label, required this.onTap});

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 9),
          child: Row(
            children: [
              Icon(Icons.chevron_right,
                  size: 14,
                  color: _hovering ? AppColors.white : AppColors.primaryRed),
              const SizedBox(width: 4),
              Text(widget.label,
                  style: AppTextStyles.body(
                      size: 12.5,
                      color:
                          _hovering ? AppColors.white : AppColors.mutedWhite)),
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterColumn extends StatelessWidget {
  final String title;
  final List<String> items;
  const _FooterColumn({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: AppTextStyles.body(
                size: 13, weight: FontWeight.w700, color: AppColors.white)),
        const SizedBox(height: 14),
        ...items.map((i) => Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: Row(
                children: [
                  const Icon(Icons.chevron_right,
                      size: 14, color: AppColors.primaryRed),
                  const SizedBox(width: 4),
                  Text(i,
                      style: AppTextStyles.body(
                          size: 12.5, color: AppColors.mutedWhite)),
                ],
              ),
            )),
      ],
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _ContactRow(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.primaryRed),
        const SizedBox(width: 10),
        Expanded(
          child: Text(text,
              style:
                  AppTextStyles.body(size: 12.5, color: AppColors.mutedWhite)),
        ),
      ],
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;
  const _SocialIcon(this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.mutedWhite, width: 1),
      ),
      child: Icon(icon, size: 14, color: AppColors.white),
    );
  }
}
