import 'package:flutter/material.dart';

class BottomNavItem {
  IconData icon;
  String label;
  VoidCallback? onTap;

  BottomNavItem({
    required this.icon,
    required this.label,
    this.onTap,
  });
}
