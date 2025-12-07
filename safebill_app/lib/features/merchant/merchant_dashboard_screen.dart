import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../app/theme.dart';
import '../../app/theme_toggle.dart';
import '../../app/widgets/bouncing_button.dart';
import '../auth/landing_screen.dart';

class MerchantDashboardScreen extends ConsumerWidget {
  const MerchantDashboardScreen({super.key});

  static const routePath = '/merchant-dashboard';
  static const routeName = 'merchant-dashboard';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
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
                        ],
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
                backgroundBlendMode: BlendMode.screen,
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  children: [
                    // Header
                    _buildHeader(context, isDark),
                    
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildActionCard(context, isDark),
                            const SizedBox(height: 32),
                            _buildRecentActivity(context, isDark),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
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
                  'M',
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
                    'Merchant Dashboard',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? SafeBillTheme.slate400
                          : SafeBillTheme.slate500,
                    ),
                  ),
                  Text(
                    'TechStore Inc.',
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
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? SafeBillTheme.slate900 : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? SafeBillTheme.slate800 : SafeBillTheme.slate200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: SafeBillTheme.indigo500.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  LucideIcons.fileSpreadsheet,
                  color: SafeBillTheme.indigo500,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Assign Bill to Consumer',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : SafeBillTheme.slate900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Consumer ID',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDark ? SafeBillTheme.slate300 : SafeBillTheme.slate700,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: isDark ? SafeBillTheme.slate950 : SafeBillTheme.slate50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? SafeBillTheme.slate800 : SafeBillTheme.slate200,
              ),
            ),
            child: TextField(
              style: TextStyle(
                color: isDark ? Colors.white : SafeBillTheme.slate900,
              ),
              decoration: InputDecoration(
                hintText: 'Enter Consumer ID',
                hintStyle: TextStyle(
                  color: isDark ? SafeBillTheme.slate600 : SafeBillTheme.slate400,
                ),
                prefixIcon: Icon(
                  LucideIcons.user,
                  color: isDark ? SafeBillTheme.slate500 : SafeBillTheme.slate400,
                  size: 20,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: BouncingButton(
                  onTap: () {
                    // Mock Upload
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: isDark ? SafeBillTheme.slate800 : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark
                            ? SafeBillTheme.slate700
                            : SafeBillTheme.slate200,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.upload,
                          size: 20,
                          color: isDark ? Colors.white : SafeBillTheme.slate700,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Upload Bill',
                          style: TextStyle(
                            color: isDark ? Colors.white : SafeBillTheme.slate700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: BouncingButton(
                  onTap: () {
                    // Mock Generate
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          SafeBillTheme.indigo500,
                          SafeBillTheme.indigo600
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: SafeBillTheme.indigo500.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          LucideIcons.plus,
                          size: 20,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Generate Bill',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : SafeBillTheme.slate900,
          ),
        ),
        const SizedBox(height: 16),
        _buildActivityItem(
          context,
          isDark,
          'MacBook Pro M3',
          'Consumer: Rahul Sharma',
          'Just now',
          true,
        ),
        _buildActivityItem(
          context,
          isDark,
          'Sony Bravia 55"',
          'Consumer: Priya Singh',
          '2h ago',
          true,
        ),
        _buildActivityItem(
          context,
          isDark,
          'Dyson Airwrap',
          'Consumer: Amit Patel',
          '5h ago',
          false,
        ),
      ],
    );
  }

  Widget _buildActivityItem(
    BuildContext context,
    bool isDark,
    String title,
    String subtitle,
    String time,
    bool isUploaded,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? SafeBillTheme.slate900 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? SafeBillTheme.slate800 : SafeBillTheme.slate200,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isUploaded
                  ? SafeBillTheme.emerald500.withOpacity(0.1)
                  : SafeBillTheme.amber500.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isUploaded ? LucideIcons.checkCircle : LucideIcons.clock,
              color: isUploaded
                  ? SafeBillTheme.emerald500
                  : SafeBillTheme.amber500,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : SafeBillTheme.slate900,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? SafeBillTheme.slate400
                        : SafeBillTheme.slate500,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? SafeBillTheme.slate500 : SafeBillTheme.slate400,
            ),
          ),
        ],
      ),
    );
  }
}


