import 'package:flutter/material.dart';
import '../widgets/page_scaffold.dart';
import '../widgets/sub_page_header.dart';
import '../sections/features_section.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PageScaffold(
      child: Column(
        children: [
          SubPageHeader(
            title: 'ABOUT US',
            subtitle:
                'Why clients across Dubai & UAE trust SOLLIX for fire safety.',
          ),
          FeaturesSection(),
        ],
      ),
    );
  }
}
