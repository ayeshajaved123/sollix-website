import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';
import '../../theme/app_colors.dart';
import 'admin_login_screen.dart';
import 'admin_dashboard_screen.dart';

class AdminGate extends StatelessWidget {
  const AdminGate({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: AppColors.primaryNavy,
            body: Center(
              child: CircularProgressIndicator(color: AppColors.white),
            ),
          );
        }

        final bool loggedIn = snapshot.hasData;
        return loggedIn
            ? const AdminDashboardScreen()
            : const AdminLoginScreen();
      },
    );
  }
}
