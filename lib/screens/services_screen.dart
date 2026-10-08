import 'package:flutter/material.dart';
import '../widgets/page_scaffold.dart';
import '../widgets/sub_page_header.dart';
import '../sections/services_section.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PageScaffold(
      child: Column(
        children: [
          SubPageHeader(
            title: 'OUR SERVICES',
            subtitle:
                'Complete fire protection installation & maintenance solutions.',
          ),
          ServicesSection(),
        ],
      ),
    );
  }
}
