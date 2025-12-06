import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router.dart';
import 'theme.dart';
import '../core/providers/theme_provider.dart';

class SafeBillApp extends ConsumerWidget {
  const SafeBillApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'SafeBill',
      routerConfig: router,
      theme: SafeBillTheme.light(),
      darkTheme: SafeBillTheme.dark(),
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
      locale: const Locale('en', 'IN'),
    );
  }
}
