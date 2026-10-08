import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../sections/navbar_section.dart';
import '../sections/footer_section.dart';

/// Shared shell for every page: Navbar (top) + scrollable content + Footer.
/// Only ONE place assembles navbar+footer — every route reuses this.
class PageScaffold extends StatelessWidget {
  final Widget child;
  const PageScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          const NavbarSection(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  child,
                  const FooterSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
