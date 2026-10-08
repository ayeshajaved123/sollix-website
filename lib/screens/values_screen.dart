import 'package:flutter/material.dart';
import '../widgets/page_scaffold.dart';
import '../widgets/sub_page_header.dart';
import '../sections/stats_section.dart';

class ValuesScreen extends StatelessWidget {
  const ValuesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PageScaffold(
      child: Column(
        children: [
          SubPageHeader(
            title: 'OUR VALUES',
            subtitle:
                'The numbers behind our commitment to safety and quality.',
          ),
          StatsSection(),
        ],
      ),
    );
  }
}
