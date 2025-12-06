import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../document_detail/document_detail_screen.dart';
import 'scan_controller.dart';

class ScanScreen extends ConsumerWidget {
  const ScanScreen({super.key});

  static const routePath = '/scan';
  static const routeName = 'scan';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scanState = ref.watch(scanControllerProvider);

    ref.listen(scanControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (document) {
          if (document != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Extraction complete')),
            );
            context.go(
              DocumentDetailScreen.routePath.replaceFirst(':id', document.docId),
            );
          }
        },
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Invoice'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Use your device camera to capture an invoice.\n'
                    'SafeBill will auto-crop, extract text, and fill the metadata for review.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: scanState.isLoading
                  ? null
                  : () => ref.read(scanControllerProvider.notifier).scanInvoice(),
              icon: const Icon(Icons.camera_alt_outlined),
              label: Text(
                scanState.isLoading ? 'Scanning...' : 'Start Scan',
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Tip: You can switch to PDF upload or offline OCR from Settings > Capture preferences.',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

