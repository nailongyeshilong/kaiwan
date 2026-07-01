import 'package:flutter/material.dart';

enum AppDestination {
  home(
    path: '/',
    label: '首页',
    icon: Icons.home_rounded,
    selectedIcon: Icons.home,
  ),
  gameLibrary(
    path: '/game-library',
    label: '游戏库',
    icon: Icons.sports_esports_outlined,
    selectedIcon: Icons.sports_esports,
  ),
  history(
    path: '/history',
    label: '记录',
    icon: Icons.receipt_long_outlined,
    selectedIcon: Icons.receipt_long,
  ),
  settings(
    path: '/settings',
    label: '设置',
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings,
  );

  const AppDestination({
    required this.path,
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String path;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
}
