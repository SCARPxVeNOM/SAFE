import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/document.dart';
import '../locker/locker_controller.dart';

class ClaimWizardScreen extends ConsumerStatefulWidget {
  const ClaimWizardScreen({super.key});

  static const routePath = '/claims';
  static const routeName = 'claims';

  @override
  ConsumerState<ClaimWizardScreen> createState() => _ClaimWizardScreenState();
}

class _ClaimWizardScreenState extends ConsumerState<ClaimWizardScreen> {
  final _issueController = TextEditingController();
  Document? _selectedDocument;
  String? _draft;

  @override
  void dispose() {
    _issueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final documentsAsync = ref.watch(lockerControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Claim Wizard'),
      ),
      body: documentsAsync.when(
        data: (documents) => _buildForm(context, documents),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildForm(BuildContext context, List<Document> documents) {
    _selectedDocument ??= documents.isNotEmpty ? documents.first : null;

    if (_selectedDocument == null) {
      return const Center(child: Text('Add a document first.'));
    }

    final document = _selectedDocument!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<Document>(
            initialValue: document,
            items: documents
                .map(
                  (doc) => DropdownMenuItem(
                    value: doc,
                    child: Text(doc.title),
                  ),
                )
                .toList(),
            onChanged: (value) => setState(() {
              _selectedDocument = value;
              _draft = null;
            }),
            decoration: const InputDecoration(
              labelText: 'Document',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _issueController,
            minLines: 3,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'Issue description',
              hintText: 'Describe the defect or support experience',
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => _generateDraft(document),
            icon: const Icon(Icons.auto_fix_high_outlined),
            label: const Text('Generate claim letter'),
          ),
          const SizedBox(height: 24),
          if (_draft != null) ...[
            Text(
              'Draft email',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                _draft!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _generateDraft(Document document) {
    final item = document.primaryItem;
    final issue = _issueController.text.trim().isEmpty
        ? 'Device stopped working unexpectedly'
        : _issueController.text.trim();

    final letter = '''
To,
${document.sellerName ?? 'Seller'},

Subject: Warranty claim for ${item.productName ?? 'the product'} (Invoice ${item.invoiceNo ?? document.docId})

I purchased the product on ${item.purchaseDate?.toLocal().toIso8601String().split('T').first ?? 'unknown date'} and the warranty is valid through ${item.formattedWarrantyEnd}.

Issue summary:
- $issue

Request:
- Arrange inspection/service at the earliest.
- Provide written acknowledgement as per Consumer Protection Act 2019.

Attached: invoice, warranty card, images/videos evidencing the defect.

Regards,
SafeBill user
''';

    setState(() => _draft = letter);
  }
}

