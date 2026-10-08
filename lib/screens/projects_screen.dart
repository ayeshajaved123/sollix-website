import 'package:flutter/material.dart';
import '../widgets/page_scaffold.dart';
import '../widgets/sub_page_header.dart';
import '../sections/projects_section.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PageScaffold(
      child: Column(
        children: [
          SubPageHeader(
            title: 'OUR PROJECTS',
            subtitle:
                'A selection of the work we\'ve delivered across the UAE.',
          ),
          ProjectsSection(),
        ],
      ),
    );
  }
}
