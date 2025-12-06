import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../app/theme.dart';
import '../../app/theme_toggle.dart';
import '../../app/widgets/bouncing_button.dart';
import '../locker/locker_screen.dart';
import '../merchant/merchant_dashboard_screen.dart';

enum UserType { consumer, merchant }

final userTypeProvider = StateProvider<UserType>((ref) => UserType.consumer);

class LandingScreen extends ConsumerWidget {
  const LandingScreen({super.key});

  static const routePath = '/landing';
  static const routeName = 'landing';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userType = ref.watch(userTypeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // Ambient background
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          SafeBillTheme.slate950,
                          SafeBillTheme.slate900,
                          const Color(0xFF1E1B4B), // indigo950
                        ]
                      : [
                          SafeBillTheme.slate50,
                          Colors.white,
                          SafeBillTheme.indigo200.withOpacity(0.2),
                        ],
                ),
              ),
            ),
          ),
          // Animated Blur Orb
          Positioned(
            top: -150,
            right: -150,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                color: isDark
                    ? SafeBillTheme.indigo500.withOpacity(0.15)
                    : SafeBillTheme.indigo500.withOpacity(0.1),
                borderRadius: BorderRadius.circular(250),
                boxShadow: [
                  BoxShadow(
                    color: SafeBillTheme.indigo500.withOpacity(0.2),
                    blurRadius: 100,
                    spreadRadius: 20,
                  ),
                ],
              ),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scale(
                  duration: 4.seconds,
                  begin: const Offset(0.9, 0.9),
                  end: const Offset(1.1, 1.1),
                )
                .fadeIn(duration: 1.seconds),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Top Bar with Theme Toggle
                    Align(
                      alignment: Alignment.topRight,
                      child: const ThemeToggleButton(),
                    ),
                    const SizedBox(height: 40),

                    // Logo / Brand
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isDark
                              ? [SafeBillTheme.indigo600, SafeBillTheme.indigo500]
                              : [SafeBillTheme.indigo500, SafeBillTheme.indigo600],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: SafeBillTheme.indigo500.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        LucideIcons.shieldCheck,
                        size: 40,
                        color: Colors.white,
                      ),
                    )
                        .animate()
                        .scale(duration: 600.ms, curve: Curves.easeOutBack)
                        .fadeIn(),
                    const SizedBox(height: 24),
                    Text(
                      'Welcome to SafeBill',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : SafeBillTheme.slate900,
                          ),
                    ).animate().fadeIn().slideY(begin: 0.2, end: 0),
                    const SizedBox(height: 8),
                    Text(
                      'Manage your warranties and claims securely.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isDark
                                ? SafeBillTheme.slate400
                                : SafeBillTheme.slate500,
                          ),
                    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
                    const SizedBox(height: 40),

                    // Login Card
                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(maxWidth: 400),
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: isDark
                            ? SafeBillTheme.slate900.withOpacity(0.8)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                          color: isDark
                              ? SafeBillTheme.slate700.withOpacity(0.5)
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Toggle Consumer / Merchant
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? SafeBillTheme.slate950
                                  : SafeBillTheme.slate100,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                _buildToggleItem(
                                  context,
                                  ref,
                                  type: UserType.consumer,
                                  label: 'Consumer',
                                  isSelected: userType == UserType.consumer,
                                ),
                                _buildToggleItem(
                                  context,
                                  ref,
                                  type: UserType.merchant,
                                  label: 'Merchant',
                                  isSelected: userType == UserType.merchant,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Inputs
                          _buildTextField(
                            context,
                            label: userType == UserType.consumer
                                ? 'Consumer ID'
                                : 'Merchant ID',
                            icon: LucideIcons.user,
                            isDark: isDark,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            context,
                            label: 'Password',
                            icon: LucideIcons.lock,
                            isDark: isDark,
                            obscureText: true,
                          ),
                          const SizedBox(height: 24),

                          // Login Button
                          BouncingButton(
                            onTap: () {
                              final userType = ref.read(userTypeProvider);
                              if (userType == UserType.consumer) {
                                context.go(LockerScreen.routePath);
                              } else {
                                context.go(MerchantDashboardScreen.routePath);
                              }
                            },
                            child: Container(
                              width: double.infinity,
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
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Divider
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: isDark
                                      ? SafeBillTheme.slate700
                                      : SafeBillTheme.slate200,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'OR',
                                  style: TextStyle(
                                    color: isDark
                                        ? SafeBillTheme.slate500
                                        : SafeBillTheme.slate400,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: isDark
                                      ? SafeBillTheme.slate700
                                      : SafeBillTheme.slate200,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Google Auth
                          BouncingButton(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? SafeBillTheme.slate800
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isDark
                                      ? SafeBillTheme.slate700
                                      : SafeBillTheme.slate200,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Mock Google Icon (just a circle/icon for now)
                                  const Icon(
                                    LucideIcons.chrome, // Placeholder
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Continue with Google',
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.white
                                          : SafeBillTheme.slate700,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0),

                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            color: isDark
                                ? SafeBillTheme.slate400
                                : SafeBillTheme.slate600,
                          ),
                        ),
                        BouncingButton(
                          onTap: () {},
                          child: const Text(
                            'Sign up',
                            style: TextStyle(
                              color: SafeBillTheme.indigo500,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ).animate().fadeIn(delay: 600.ms),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleItem(
    BuildContext context,
    WidgetRef ref, {
    required UserType type,
    required String label,
    required bool isSelected,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => ref.read(userTypeProvider.notifier).state = type,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).scaffoldBackgroundColor
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? Theme.of(context).colorScheme.onSurface
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required String label,
    required IconData icon,
    required bool isDark,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
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
            obscureText: obscureText,
            style: TextStyle(
              color: isDark ? Colors.white : SafeBillTheme.slate900,
            ),
            decoration: InputDecoration(
              hintText: 'Enter your ${label.toLowerCase()}',
              hintStyle: TextStyle(
                color: isDark ? SafeBillTheme.slate600 : SafeBillTheme.slate400,
              ),
              prefixIcon: Icon(
                icon,
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
      ],
    );
  }
}
