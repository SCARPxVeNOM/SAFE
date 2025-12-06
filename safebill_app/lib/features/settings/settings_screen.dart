import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/theme_provider.dart';

final localOnlyModeProvider = StateProvider<bool>((ref) => false);
final offlineOcrProvider = StateProvider<bool>((ref) => true);
final graphAugmentationProvider = StateProvider<bool>((ref) => true);

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const routePath = '/settings';
  static const routeName = 'settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localOnly = ref.watch(localOnlyModeProvider);
    final offlineOcr = ref.watch(offlineOcrProvider);
    final graphAugmentation = ref.watch(graphAugmentationProvider);
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Theme'),
            subtitle: Text(themeMode.name.toUpperCase()),
            trailing: DropdownButton<ThemeMode>(
              value: themeMode,
              onChanged: (ThemeMode? newValue) {
                if (newValue != null) {
                  ref.read(themeModeProvider.notifier).setTheme(newValue);
                }
              },
              items: ThemeMode.values.map((ThemeMode mode) {
                return DropdownMenuItem<ThemeMode>(
                  value: mode,
                  child: Text(mode.name.toUpperCase()),
                );
              }).toList(),
            ),
          ),
          const Divider(),
          SwitchListTile(
            value: localOnly,
            onChanged: (value) =>
                ref.read(localOnlyModeProvider.notifier).state = value,
            title: const Text('Local-only vault mode'),
            subtitle: const Text(
              'Stay fully offline; data never leaves this device until you re-enable cloud mode.',
            ),
          ),
          SwitchListTile(
            value: offlineOcr,
            onChanged: (value) =>
                ref.read(offlineOcrProvider.notifier).state = value,
            title: const Text('Offline OCR first'),
            subtitle: const Text(
              'Use on-device ML Kit processing before sending to the backend fallback.',
            ),
          ),
          SwitchListTile(
            value: graphAugmentation,
            onChanged: (value) =>
                ref.read(graphAugmentationProvider.notifier).state = value,
            title: const Text('GraphRAG augmentation'),
            subtitle: const Text(
              'Allow the assistant to traverse the knowledge graph for broader answers.',
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.data_exploration_outlined),
            title: const Text('Export data'),
            subtitle: const Text('Generate an encrypted export of all documents.'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever_outlined),
            title: const Text('Delete account'),
            subtitle: const Text('Trigger GDPR/CPA-compliant deletion workflow.'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
