import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../services/auth_service.dart';
import 'manage_projects_screen.dart';
import 'manage_services_screen.dart';
import 'contact_submissions_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        backgroundColor: AppColors.primaryNavy,
        title: Text('SOLLIX Admin',
            style: AppTextStyles.body(
                size: 16, weight: FontWeight.w700, color: AppColors.white)),
        actions: [
          TextButton.icon(
            onPressed: () => authService.signOut(),
            icon: const Icon(Icons.logout, size: 18, color: AppColors.white),
            label: Text('Sign out',
                style: AppTextStyles.body(size: 13, color: AppColors.white)),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dashboard',
                style: AppTextStyles.heading(
                    size: 24, color: AppColors.primaryNavy)),
            const SizedBox(height: 4),
            Text('Manage what appears on the public website.',
                style: AppTextStyles.body()),
            const SizedBox(height: 24),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _DashboardCard(
                  icon: Icons.photo_library_outlined,
                  title: 'Manage Projects',
                  subtitle:
                      'Add, edit, or remove project photos shown on the site.',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ManageProjectsScreen()),
                    );
                  },
                ),
                _DashboardCard(
                  icon: Icons.build_outlined,
                  title: 'Manage Services',
                  subtitle: 'Add, edit, or remove the services list.',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ManageServicesScreen()),
                    );
                  },
                ),
                _DashboardCard(
                  icon: Icons.mail_outline,
                  title: 'Contact Submissions',
                  subtitle: 'View messages sent through the contact form.',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ContactSubmissionsScreen()),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 260,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.borderGrey),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.primaryRed, size: 28),
            const SizedBox(height: 14),
            Text(title,
                style: AppTextStyles.body(
                    size: 15,
                    weight: FontWeight.w700,
                    color: AppColors.primaryNavy)),
            const SizedBox(height: 6),
            Text(subtitle, style: AppTextStyles.body(size: 12.5)),
          ],
        ),
      ),
    );
  }
}
