import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/document.dart';
import '../../core/providers.dart';

final documentProvider =
    FutureProvider.family<Document?, String>((ref, docId) async {
  final repository = ref.watch(documentRepositoryProvider);
  return repository.getDocument(docId);
});

