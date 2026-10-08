import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/home_screen.dart';
import 'screens/about_screen.dart';
import 'screens/services_screen.dart';
import 'screens/projects_screen.dart';
import 'screens/values_screen.dart';
import 'screens/contact_screen.dart';
import 'screens/admin/admin_gate.dart';
import 'theme/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const SollixApp());
}

class SollixApp extends StatelessWidget {
  const SollixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SOLLIX Electromechanical Services LLC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primaryNavy,
        scaffoldBackgroundColor: AppColors.white,
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/about': (context) => const AboutScreen(),
        '/services': (context) => const ServicesScreen(),
        '/projects': (context) => const ProjectsScreen(),
        '/values': (context) => const ValuesScreen(),
        '/contact': (context) => const ContactScreen(),
        '/admin': (context) => const AdminGate(),
      },
    );
  }
}
