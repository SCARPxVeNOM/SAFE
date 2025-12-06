import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers/theme_provider.dart';
import 'theme.dart';

/// Reusable theme toggle pill with a quick animated switch between
/// light / dark / system themes. The choice persists via [themeModeProvider].
class ThemeToggleButton extends ConsumerWidget {
  const ThemeToggleButton({super.key});

  static const _modes = [
    ThemeMode.system,
    ThemeMode.light,
    ThemeMode.dark,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    final notifier = ref.read(themeModeProvider.notifier);
    final nextMode = _modes[(_modes.indexOf(mode) + 1) % _modes.length];

    IconData icon;
    String label;
    switch (mode) {
      case ThemeMode.dark:
        icon = Icons.dark_mode_rounded;
        label = 'Dark';
        break;
      case ThemeMode.light:
        icon = Icons.light_mode_rounded;
        label = 'Light';
        break;
      case ThemeMode.system:
        icon = Icons.auto_awesome;
        label = 'System';
        break;
    }

    return Semantics(
      button: true,
      label: 'Switch theme. Current: $label. Next: ${nextMode.name}.',
      child: GestureDetector(
        onTap: () => notifier.setTheme(nextMode),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor.withOpacity(0.8),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: SafeBillTheme.slate200.withOpacity(
                Theme.of(context).brightness == Brightness.dark ? 0.1 : 0.4,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, anim) => ScaleTransition(
                  scale: CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
                  child: child,
                ),
                child: Icon(
                  icon,
                  key: ValueKey(mode),
                  size: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

