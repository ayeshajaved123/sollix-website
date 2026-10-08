import 'package:flutter/material.dart';

class IconMapper {
  IconMapper._();

  static const Map<String, IconData> _icons = {
    'plumbing': Icons.plumbing,
    'water_drop': Icons.water_drop_outlined,
    'cable': Icons.cable,
    'shield': Icons.shield_outlined,
    'fire': Icons.local_fire_department_outlined,
    'cleaning': Icons.cleaning_services_outlined,
    'propane_tank': Icons.propane_tank_outlined,
    'construction': Icons.construction_outlined,
    'water_spray': Icons.water,
    'kitchen': Icons.kitchen_outlined,
    'security': Icons.security_outlined,
    'warning': Icons.warning_amber_outlined,
    'build': Icons.build_outlined,
  };

  static List<String> get names => _icons.keys.toList();

  static IconData iconFor(String name) => _icons[name] ?? Icons.build_outlined;
}
