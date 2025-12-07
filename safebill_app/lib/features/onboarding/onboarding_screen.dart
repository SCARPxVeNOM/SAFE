import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../auth/landing_screen.dart';
import 'onboarding_controller.dart';
import '../../app/theme.dart';
import '../../app/theme_toggle.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  static const routePath = '/onboarding';
  static const routeName = 'onboarding';

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    ref.listen(onboardingControllerProvider, (previous, next) {
      if (next is AsyncData<bool> && next.value) {
        context.go(LandingScreen.routePath);
      }
    });

    return Scaffold(
      backgroundColor: SafeBillTheme.slate900,
      body: Stack(
        children: [
          // Background Gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(49, 46, 129, 0.4), // indigo900/40
                    SafeBillTheme.slate900,
                    SafeBillTheme.slate900,
                  ],
                ),
              ),
            ),
          ),

          // Animated Aura
          Positioned(
            top: MediaQuery.of(context).size.height * 0.1,
            left: MediaQuery.of(context).size.width * 0.5 - 150,
            child:
                Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        color: SafeBillTheme.indigo500.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(150),
                        boxShadow: [
                          BoxShadow(
                            color: SafeBillTheme.indigo500.withOpacity(0.2),
                            blurRadius: 80,
                            spreadRadius: 20,
                          ),
                        ],
                      ),
                    )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .scale(
                      begin: const Offset(0.8, 0.8),
                      end: const Offset(1.2, 1.2),
                      duration: 3.seconds,
                      curve: Curves.easeInOut,
                    )
                    .fadeIn(duration: 1.seconds),
          ),

          // Main Content
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: const [ThemeToggleButton()],
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 320,
                              child: Center(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    _TiltedCard(angle: 0.05),
                                    _TiltedCard(angle: -0.05),
                                    _HeroCard()
                                        .animate()
                                        .scale(
                                          duration: 600.ms,
                                          curve: Curves.easeOutBack,
                                        )
                                        .fadeIn(duration: 600.ms),
                                  ],
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _Badge().animate().slideX(begin: -0.2).fadeIn(),
                                const SizedBox(height: 24),
                                _Title()
                                    .animate(delay: 200.ms)
                                    .slideY(begin: 0.2)
                                    .fadeIn(),
                                const SizedBox(height: 24),
                                Text(
                                  'SafeBill organizes your messy bills. Our AI extracts warranty terms, reminds you of expiry, and helps fight denied claims.',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: SafeBillTheme.slate400,
                                        height: 1.5,
                                      ),
                                ).animate(delay: 400.ms).fadeIn(),
                                const SizedBox(height: 32),
                                _Checklist().animate(delay: 600.ms).fadeIn(),
                              ],
                            ),
                            const Spacer(),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  ref
                                      .read(onboardingControllerProvider.notifier)
                                      .complete();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: SafeBillTheme.slate950,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Start Scanning Free',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(LucideIcons.arrowRight, size: 18),
                                  ],
                                ),
                              ),
                            ).animate(delay: 800.ms).slideY(begin: 1).fadeIn(),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TiltedCard extends StatelessWidget {
  final double angle;
  const _TiltedCard({required this.angle});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: Container(
        width: 280,
        height: 280,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withOpacity(0.05)),
          borderRadius: BorderRadius.circular(24),
          color: Colors.white.withOpacity(0.05),
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: 280,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [SafeBillTheme.slate800, SafeBillTheme.slate950],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                ),
                itemBuilder: (c, i) => Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  LucideIcons.scanLine,
                  size: 80,
                  color: SafeBillTheme.indigo500.withOpacity(0.9),
                ),
                const SizedBox(height: 16),
                Container(
                  width: 160,
                  height: 6,
                  decoration: BoxDecoration(
                    color: SafeBillTheme.slate700.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Stack(
                    children: [
                      Container(
                            width: 100,
                            decoration: BoxDecoration(
                              color: SafeBillTheme.indigo500,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          )
                          .animate(onPlay: (c) => c.repeat())
                          .shimmer(duration: 1.5.seconds),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Processing Invoice...',
                  style: GoogleFonts.jetBrainsMono(
                    color: SafeBillTheme.indigo500.withOpacity(0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: _FloatingTag(
              icon: LucideIcons.checkCircle2,
              text: 'Date Found',
              color: SafeBillTheme.emerald500,
            ).animate(delay: 1.seconds).scale(),
          ),
          Positioned(
            bottom: 24,
            left: 24,
            child: _FloatingTag(
              icon: LucideIcons.brainCircuit,
              text: 'OpenAI Analysis',
              color: Colors.blue,
            ).animate(delay: 1.5.seconds).scale(),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: SafeBillTheme.indigo500.withOpacity(0.1),
        border: Border.all(color: SafeBillTheme.indigo500.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LucideIcons.sparkles,
            size: 12,
            color: SafeBillTheme.indigo500.withOpacity(0.8),
          ),
          const SizedBox(width: 6),
          Text(
            'AI-POWERED PROTECTION',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: SafeBillTheme.indigo500.withOpacity(0.8),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.displaySmall?.copyWith(
          color: Colors.white,
          height: 1.1,
          fontWeight: FontWeight.w600,
          fontSize: 32,
        ),
        children: [
          const TextSpan(text: 'Never lose a\n'),
          TextSpan(
            text: 'warranty claim',
            style: TextStyle(
              foreground: Paint()
                ..shader = const LinearGradient(
                  colors: [Color(0xFF818CF8), Color(0xFF93C5FD)],
                ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
            ),
          ),
          const TextSpan(text: ' again.'),
        ],
      ),
    );
  }
}

class _Checklist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _ChecklistItem(text: 'Auto-scan bills & warranties'),
        SizedBox(height: 12),
        _ChecklistItem(text: 'Get alerted before expiry'),
        SizedBox(height: 12),
        _ChecklistItem(text: 'Legal guidance for rejected claims'),
      ],
    );
  }
}

class _ChecklistItem extends StatelessWidget {
  final String text;
  const _ChecklistItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: SafeBillTheme.emerald500.withOpacity(0.2),
            border: Border.all(
              color: SafeBillTheme.emerald500.withOpacity(0.2),
            ),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            LucideIcons.check,
            size: 12,
            color: SafeBillTheme.emerald500,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: SafeBillTheme.slate300),
        ),
      ],
    );
  }
}

class _FloatingTag extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _FloatingTag({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color.withOpacity(0.8)),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              color: color.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
