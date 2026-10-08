import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/responsive.dart';
import '../widgets/custom_button.dart';
import '../widgets/section_header.dart';
import '../widgets/scroll_reveal.dart';
import '../models/project_model.dart';
import '../services/firestore_service.dart';

class ProjectsSection extends StatelessWidget {
  final VoidCallback? onViewAll;
  const ProjectsSection({super.key, this.onViewAll});

  @override
  Widget build(BuildContext context) {
    final bool desktop = Responsive.isDesktop(context);
    final firestoreService = FirestoreService();

    final intro = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SectionHeader(
            eyebrow: 'OUR PROJECTS', title: 'PROJECTS WE\'RE PROUD OF'),
        const SizedBox(height: 16),
        Text(
          'We have successfully delivered a wide range of projects across '
          'residential, commercial, industrial and infrastructure sectors.',
          style: AppTextStyles.body(),
        ),
        if (onViewAll != null) ...[
          const SizedBox(height: 20),
          CustomButton(label: 'VIEW ALL PROJECTS', onPressed: onViewAll!),
        ],
      ],
    );

    final cardsGrid = StreamBuilder<List<ProjectModel>>(
      stream: firestoreService.watchProjects(),
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
            child: Text(
              'Could not load projects right now.',
              style: AppTextStyles.body(color: AppColors.primaryRed),
            ),
          );
        }
        final projects = snapshot.data ?? [];
        if (projects.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text('Projects coming soon.', style: AppTextStyles.body()),
          );
        }

        return LayoutBuilder(builder: (context, constraints) {
          final int columns =
              desktop ? 4 : (constraints.maxWidth > 500 ? 2 : 1);
          final gap = 16.0;
          final cardWidth =
              (constraints.maxWidth - gap * (columns - 1)) / columns;
          return Wrap(
            spacing: gap,
            runSpacing: gap,
            children: projects.asMap().entries.map((entry) {
              final index = entry.key;
              final project = entry.value;
              return SizedBox(
                width: cardWidth,
                child: ScrollReveal(
                  delay: Duration(milliseconds: 90 * index),
                  child: _ProjectCard(project: project),
                ),
              );
            }).toList(),
          );
        });
      },
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
              children: [
                Expanded(flex: 3, child: intro),
                const SizedBox(width: 40),
                Expanded(flex: 7, child: cardsGrid),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                intro,
                const SizedBox(height: 30),
                cardsGrid,
              ],
            ),
    );
  }
}

class _ProjectCard extends StatefulWidget {
  final ProjectModel project;
  const _ProjectCard({required this.project});

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedScale(
        scale: _hovering ? 1.03 : 1.0,
        duration: const Duration(milliseconds: 180),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Stack(
            children: [
              AspectRatio(
                aspectRatio: 0.82,
                child: Image.network(
                  widget.project.imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: AppColors.lightGrey,
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColors.lightGrey,
                    child: const Icon(Icons.image_not_supported_outlined,
                        color: AppColors.mutedText),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  color: AppColors.primaryNavy,
                  child: Text(
                    widget.project.title,
                    style: AppTextStyles.body(
                      size: 12,
                      weight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
