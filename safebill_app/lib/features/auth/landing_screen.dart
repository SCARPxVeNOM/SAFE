import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../app/theme.dart';
import '../../app/theme_toggle.dart';
import '../../app/widgets/bouncing_button.dart';
import '../../core/providers/auth_provider.dart';
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
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final isDesktop = width >= 1200;
                  final isTablet = width >= 900 && width < 1200;
                  final isMobile = width < 900;
                  final showHeroSide = isDesktop;
                  final showHeroStacked = isTablet;
                  final cardPadding = isMobile
                      ? 20.0
                      : isTablet
                          ? 28.0
                          : 32.0;
                  final horizontalPadding = isMobile ? 16.0 : 24.0;
                  final logoSize = isMobile ? 64.0 : 80.0;
                  final heroHeight = isMobile ? 220.0 : 320.0;
                  final maxContentWidth = isDesktop ? 1200.0 : 1000.0;

                  final formContent = ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: const ThemeToggleButton(),
                        ),
                        SizedBox(height: isMobile ? 24 : 32),
                        Container(
                          width: logoSize,
                          height: logoSize,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isDark
                                  ? [
                                      SafeBillTheme.indigo600,
                                      SafeBillTheme.indigo500
                                    ]
                                  : [
                                      SafeBillTheme.indigo500,
                                      SafeBillTheme.indigo600
                                    ],
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
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: isMobile ? 26 : null,
                                color: isDark
                                    ? Colors.white
                                    : SafeBillTheme.slate900,
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
                        )
                            .animate()
                            .fadeIn(delay: 200.ms)
                            .slideY(begin: 0.2, end: 0),
                        SizedBox(height: isMobile ? 24 : 32),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(cardPadding),
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
                              const SizedBox(height: 24),
                              _buildTextField(
                                context,
                                label: userType == UserType.consumer
                                    ? 'Consumer ID'
                                    : 'Merchant ID',
                                icon: LucideIcons.user,
                                isDark: isDark,
                              ),
                              const SizedBox(height: 12),
                              _buildTextField(
                                context,
                                label: 'Password',
                                icon: LucideIcons.lock,
                                isDark: isDark,
                                obscureText: true,
                              ),
                              const SizedBox(height: 20),
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
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
                                        color: SafeBillTheme.indigo500
                                            .withOpacity(0.3),
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
                              const SizedBox(height: 20),
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
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
                              const SizedBox(height: 20),
                              BouncingButton(
                                onTap: () async {
                                  final authNotifier = ref.read(authStateProvider.notifier);
                                  await authNotifier.signInWithGoogle();
                                  
                                  // Check if sign in was successful
                                  final authState = ref.read(authStateProvider);
                                  if (authState.isAuthenticated) {
                                    final userType = ref.read(userTypeProvider);
                                    if (userType == UserType.consumer) {
                                      context.go(LockerScreen.routePath);
                                    } else {
                                      context.go(MerchantDashboardScreen.routePath);
                                    }
                                  } else if (authState.error != null) {
                                    // Show error message
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(authState.error ?? 'Sign in failed'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16),
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
                                      const Icon(
                                        LucideIcons.chrome,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        ref.watch(authStateProvider).isLoading
                                            ? 'Signing in...'
                                            : 'Continue with Google',
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
                        const SizedBox(height: 20),
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
                  );

                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: 24,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: maxContentWidth),
                        child: IntrinsicHeight(
                          child: showHeroSide
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.only(right: isDesktop ? 32 : 24),
                                        child: _HeroIllustration(isDark: isDark),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: formContent,
                                    ),
                                  ],
                                )
                              : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (showHeroStacked) ...[
                                      SizedBox(
                                        height: heroHeight,
                                        child: _HeroIllustration(isDark: isDark),
                                      ),
                                      const SizedBox(height: 24),
                                    ],
                                    formContent,
                                  ],
                                ),
                        ),
                      ),
                    ),
                  );
            },
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

class _HeroIllustration extends StatelessWidget {
  const _HeroIllustration({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  SafeBillTheme.slate900.withOpacity(0.6),
                  SafeBillTheme.indigo600.withOpacity(0.3),
                ]
              : [
                  Colors.white.withOpacity(0.9),
                  SafeBillTheme.indigo200.withOpacity(0.3),
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'img/hero_image.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.45),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms).slideX(begin: -0.05, end: 0);
  }
}
