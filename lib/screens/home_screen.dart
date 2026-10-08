import 'package:flutter/material.dart';
import '../widgets/page_scaffold.dart';
import '../widgets/scroll_reveal.dart';
import '../sections/hero_section.dart';
import '../sections/features_section.dart';
import '../sections/services_section.dart';
import '../sections/stats_section.dart';
import '../sections/projects_section.dart';
import '../sections/cta_banner_section.dart';
import '../utils/nav_utils.dart';

/// Home page — the ONLY page showing a full overview (hero, features,
/// services, stats, projects, CTA). Every other nav item opens its OWN
/// dedicated page. Contact form is intentionally NOT here — only reachable
/// via "Get a Quote" / "Contact Us" buttons, which navigate to /contact.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      child: Column(
        children: [
          ScrollReveal(
            slideOffset: 0,
            child: HeroSection(
              onServicesTap: () => goToPage(context, '/services'),
              onContactTap: () => goToPage(context, '/contact'),
            ),
          ),
          const ScrollReveal(child: FeaturesSection()),
          ScrollReveal(
            child: ServicesSection(
              onViewAll: () => goToPage(context, '/services'),
            ),
          ),
          const ScrollReveal(child: StatsSection()),
          ScrollReveal(
            child: ProjectsSection(
              onViewAll: () => goToPage(context, '/projects'),
            ),
          ),
          ScrollReveal(
            child: CtaBannerSection(onTap: () => goToPage(context, '/contact')),
          ),
        ],
      ),
    );
  }
}
