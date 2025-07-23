import 'package:flutter/material.dart';

class ServiceCategory {
  final String title;
  final IconData? icon;
  final VoidCallback onTap;

  ServiceCategory({
    required this.title,
    this.icon,
    required this.onTap,
  });
}

class ServiceRow {
  final List<Color> gradientColors;
  final List<ServiceCategory> services;

  ServiceRow({
    required this.gradientColors,
    required this.services,
  });
}