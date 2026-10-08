import 'package:flutter/material.dart';

/// Central navigation helper for ALL top-level page switches (navbar links,
/// hero/CTA buttons, "view all" buttons, footer quick links).
/// Uses pushNamedAndRemoveUntil so the navigation stack never grows no
/// matter how many times the user bounces between pages — this is what
/// prevents back-button confusion / stacked duplicate pages.
void goToPage(BuildContext context, String route) {
  final currentRoute = ModalRoute.of(context)?.settings.name;
  if (currentRoute == route) return;
  Navigator.of(context).pushNamedAndRemoveUntil(route, (r) => false);
}
