import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../app/theme.dart';
import '../../app/theme_toggle.dart';
import '../../app/widgets/bouncing_button.dart';
import '../../core/models/document.dart';
import '../auth/landing_screen.dart';
import '../chat/chat_screen.dart';
import '../document_detail/document_detail_screen.dart';
import '../scan/scan_screen.dart';
import '../settings/settings_screen.dart';
import 'locker_controller.dart';

class LockerScreen extends ConsumerWidget {
  const LockerScreen({super.key});

  static const routePath = '/locker';
  static const routeName = 'locker';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lockerState = ref.watch(lockerControllerProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      // Gradient background handled by Container in Stack
      body: Stack(
        children: [
          // Ambient Background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: isDark
                      ? [
                          SafeBillTheme.indigo500.withOpacity(0.1),
                          SafeBillTheme.slate950,
                          SafeBillTheme.slate950,
                        ]
                      : [
                          SafeBillTheme.slate50,
                          SafeBillTheme.slate50,
                          SafeBillTheme.slate50,
                        ], // Simplified for light
                ),
              ),
            ),
          ),
          // Blur Orb
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                color: isDark
                    ? SafeBillTheme.indigo500.withOpacity(0.1)
                    : Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(200),
                backgroundBlendMode: BlendMode.screen, // or standard
              ),
              // Apply blur via BackdropFilter or just generic blur
            ),
          ),

          // Main Content
          SafeArea(
            bottom: false,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  children: [
                    // Header & Content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(
                          bottom: 100,
                        ), // Space for Nav
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeader(context, isDark),
                            _buildScanAction(context, isDark),
                            _buildQuickStats(context, isDark),
                            _buildCategories(context, isDark),
                            _buildExpiringSoon(context, isDark, lockerState),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Navigation
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: _BottomNavBar(isDark: isDark),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [SafeBillTheme.indigo600, SafeBillTheme.slate800]
                        : [SafeBillTheme.slate800, Colors.black],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  'SB',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? SafeBillTheme.slate400
                          : SafeBillTheme.slate500,
                    ),
                  ),
                  Text(
                    'Rahul Sharma',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : SafeBillTheme.slate900,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              const ThemeToggleButton(),
              const SizedBox(width: 12),
              BouncingButton(
                onTap: () => context.go(LandingScreen.routePath),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark ? SafeBillTheme.slate800 : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark
                          ? SafeBillTheme.slate700
                          : SafeBillTheme.slate200,
                    ),
                  ),
                  child: Icon(
                    LucideIcons.logOut,
                    size: 20,
                    color: isDark
                        ? SafeBillTheme.slate300
                        : SafeBillTheme.slate600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              BouncingButton(
                onTap: () {
                  // TODO: Navigate to notifications
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark ? SafeBillTheme.slate800 : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark
                          ? SafeBillTheme.slate700
                          : SafeBillTheme.slate200,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Icon(
                        LucideIcons.bell,
                        size: 20,
                        color: isDark
                            ? SafeBillTheme.slate300
                            : SafeBillTheme.slate600,
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: SafeBillTheme.rose500,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark
                                  ? SafeBillTheme.slate800
                                  : Colors.white,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScanAction(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: BouncingButton(
        onTap: () => context.push(ScanScreen.routePath),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? SafeBillTheme.slate950 : SafeBillTheme.slate900,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark ? SafeBillTheme.slate800 : Colors.transparent,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? SafeBillTheme.slate950.withOpacity(0.5)
                    : SafeBillTheme.slate200,
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Decor
              Positioned(
                top: -20,
                right: -20,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: SafeBillTheme.indigo500.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Scan Invoice',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'AI auto-extracts warranty details',
                        style: TextStyle(
                          color: SafeBillTheme.slate400,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      LucideIcons.scanLine,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              isDark: isDark,
              icon: LucideIcons.shieldCheck,
              iconColor: SafeBillTheme.emerald500,
              label: 'Active',
              value: '12',
              subValue: 'Active Warranties',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              isDark: isDark,
              icon: LucideIcons.wallet,
              iconColor: SafeBillTheme.indigo500,
              label: null,
              value: '₹2.4L',
              subValue: 'Asset Value',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories(BuildContext context, bool isDark) {
    final categories = [
      {'icon': LucideIcons.smartphone, 'label': 'Gadgets'},
      {'icon': LucideIcons.tv, 'label': 'Appliances'},
      {'icon': LucideIcons.car, 'label': 'Vehicle'},
      {'icon': LucideIcons.watch, 'label': 'Others'},
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Digital Locker',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : SafeBillTheme.slate900,
                ),
              ),
              BouncingButton(
                onTap: () {
                  // Typically this might filter the locker or go to a list view
                },
                child: Text(
                  'View all',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? SafeBillTheme.indigo500
                        : SafeBillTheme.indigo600,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final cat = categories[index];
              return BouncingButton(
                onTap: () {
                  // Filter by category
                },
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: isDark ? SafeBillTheme.slate800 : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark
                              ? SafeBillTheme.slate700
                              : SafeBillTheme.slate200,
                        ),
                        boxShadow: [
                          if (!isDark)
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 5,
                            ),
                        ],
                      ),
                      child: Icon(
                        cat['icon'] as IconData,
                        size: 24,
                        color: isDark
                            ? SafeBillTheme.slate300
                            : SafeBillTheme.slate600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      cat['label'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? SafeBillTheme.slate400
                            : SafeBillTheme.slate600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildExpiringSoon(
    BuildContext context,
    bool isDark,
    AsyncValue<List<Document>> lockerState,
  ) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Expiring Soon',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : SafeBillTheme.slate900,
            ),
          ),
          const SizedBox(height: 12),
          lockerState.when(
            data: (documents) {
              if (documents.isEmpty) {
                return const Text("No documents yet.");
              }
              return Column(
                children: documents
                    .take(3)
                    .map<Widget>(
                      (doc) => _ExpiringItem(
                        isDark: isDark,
                        document: doc,
                        onTap: () => context.push(
                          DocumentDetailScreen.routePath.replaceFirst(
                            ':id',
                            doc.docId,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text("Error: $e"),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final Color iconColor;
  final String? label;
  final String value;
  final String subValue;

  const _StatCard({
    required this.isDark,
    required this.icon,
    required this.iconColor,
    this.label,
    required this.value,
    required this.subValue,
  });

  @override
  Widget build(BuildContext context) {
    return BouncingButton(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? SafeBillTheme.slate800 : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? SafeBillTheme.slate700 : SafeBillTheme.slate200,
          ),
          boxShadow: [
            if (!isDark)
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, size: 20, color: iconColor),
                if (label != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      label!,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: iconColor,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : SafeBillTheme.slate900,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subValue,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isDark ? SafeBillTheme.slate400 : SafeBillTheme.slate500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpiringItem extends StatelessWidget {
  final bool isDark;
  final Document document;
  final VoidCallback onTap;

  const _ExpiringItem({
    required this.isDark,
    required this.document,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final item = document.primaryItem;
    final now = DateTime.now();
    final end = item.warrantyEnd;
    final start = item.warrantyStart;

    final daysLeft = end != null ? end.difference(now).inDays : 999;
    double progress = 0.0;

    if (start != null && end != null) {
      final totalDays = end.difference(start).inDays;
      if (totalDays > 0) {
        final elapsed = now.difference(start).inDays;
        progress = (elapsed / totalDays).clamp(0.0, 1.0);
      }
    }

    return BouncingButton(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? SafeBillTheme.slate800 : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? SafeBillTheme.slate700 : SafeBillTheme.slate200,
          ),
          boxShadow: [
            if (!isDark)
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isDark ? SafeBillTheme.slate700 : SafeBillTheme.slate100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                LucideIcons.laptop,
                size: 24,
              ), // Mock icon, should be from category
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.productName ?? document.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : SafeBillTheme.slate900,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: SafeBillTheme.rose500.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$daysLeft Days left',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: SafeBillTheme.rose500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: isDark
                          ? SafeBillTheme.slate700
                          : SafeBillTheme.slate100,
                      valueColor: const AlwaysStoppedAnimation(
                        SafeBillTheme.rose500,
                      ),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final bool isDark;

  const _BottomNavBar({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: (isDark ? SafeBillTheme.slate900 : Colors.white).withOpacity(
          0.9,
        ),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.1)
              : SafeBillTheme.slate200,
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
            label: 'Home',
            isActive: true,
            isDark: isDark,
            onTap: () {
              // Already on home/locker
            },
          ),
          _NavItem(
            icon: LucideIcons.folderLock,
            label: 'Locker',
            isActive: false,
            isDark: isDark,
            onTap: () {
              // Refresh or same
            },
          ),
          BouncingButton(
            onTap: () => context.push(ScanScreen.routePath),
            child: Container(
              padding: const EdgeInsets.all(14),
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: isDark
                    ? SafeBillTheme.indigo500
                    : SafeBillTheme.slate900,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color:
                        (isDark
                                ? SafeBillTheme.indigo500
                                : SafeBillTheme.slate900)
                            .withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(
                LucideIcons.scan,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          _NavItem(
            icon: LucideIcons.messageSquare,
            label: 'Ask AI',
            isActive: false,
            isDark: isDark,
            onTap: () => context.push(ChatScreen.routePath),
          ),
          _NavItem(
            icon: LucideIcons.user,
            label: 'Profile',
            isActive: false,
            isDark: isDark,
            onTap: () => context.push(SettingsScreen.routePath),
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
  final VoidCallback? onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.isDark,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive
        ? (isDark ? Colors.white : SafeBillTheme.slate900)
        : (isDark ? SafeBillTheme.slate500 : SafeBillTheme.slate400);

    return BouncingButton(
      onTap: onTap,
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
    );
  }
}
