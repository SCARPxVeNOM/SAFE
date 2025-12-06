import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'theme.dart';
import '../features/scan/scan_screen.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          navigationShell,
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _FloatingNavBar(
              currentIndex: navigationShell.currentIndex,
              onTap: _goBranch,
              isDark: isDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool isDark;

  const _FloatingNavBar({
    required this.currentIndex,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: (isDark ? SafeBillTheme.slate900 : Colors.white).withOpacity(0.9),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.1) : SafeBillTheme.slate200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NavItem(
            icon: LucideIcons.layoutGrid,
            label: 'Locker',
            isActive: currentIndex == 0,
            isDark: isDark,
            onTap: () => onTap(0),
          ),
          _NavItem(
            icon: LucideIcons.messageSquare,
            label: 'Chat',
            isActive: currentIndex == 1,
            isDark: isDark,
            onTap: () => onTap(1),
          ),
          
          // FAB for Scan
          GestureDetector(
            onTap: () => context.push(ScanScreen.routePath),
            child: Container(
              padding: const EdgeInsets.all(14),
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: isDark ? SafeBillTheme.indigo500 : SafeBillTheme.slate900,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (isDark ? SafeBillTheme.indigo500 : SafeBillTheme.slate900)
                        .withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(LucideIcons.scan, color: Colors.white, size: 24),
            ),
          ),
          
          _NavItem(
            icon: LucideIcons.bell,
            label: 'Alerts',
            isActive: currentIndex == 2,
            isDark: isDark,
            onTap: () => onTap(2),
          ),
          _NavItem(
            icon: LucideIcons.user,
            label: 'Settings',
            isActive: currentIndex == 3,
            isDark: isDark,
            onTap: () => onTap(3),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isDark;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive 
      ? (isDark ? Colors.white : SafeBillTheme.slate900)
      : (isDark ? SafeBillTheme.slate500 : SafeBillTheme.slate400);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

