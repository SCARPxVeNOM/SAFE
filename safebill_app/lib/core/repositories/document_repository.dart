import 'dart:math';

import '../api/api_client.dart';
import '../local/local_document_store.dart';
import '../models/document.dart';

class DocumentRepository {
  DocumentRepository(
    this._apiClient,
    this._localStore,
  );

  final SafeBillApiClient _apiClient;
  final LocalDocumentStore _localStore;

  Future<List<Document>> fetchDocuments({bool refresh = false}) async {
    final localDocs = await _localStore.getAll();
    if (localDocs.isNotEmpty && !refresh) {
      return localDocs;
    }

    // When backend sync is not available yet, seed with deterministic sample.
    if (!refresh) {
      final seeded = _seedDocuments();
      for (final doc in seeded) {
        await _localStore.upsert(doc);
      }
      return seeded;
    }

    return localDocs;
  }

  Future<Document?> getDocument(String docId) => _localStore.get(docId);

  Future<Document> extractAndSave({
    required String userId,
    required String docId,
    required String rawText,
  }) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/extract',
        data: {
          'userId': userId,
          'docId': docId,
          'rawText': rawText,
        },
      );
      final payload = response.data?['document'] as Map<String, dynamic>?;
      if (payload != null) {
        final document = Document.fromJson(payload);
        await _localStore.upsert(document);
        return document;
      }
    } catch (_) {
      // fall back to offline parse
    }

    final fallback = _seedDocuments(limit: 1).first.copyWith(
      title: 'Draft $docId',
      status: 'draft',
    );
    await _localStore.upsert(fallback);
    return fallback;
  }

  List<Document> _seedDocuments({int limit = 3}) {
    final now = DateTime.now();
    final random = Random();
    final docs = List.generate(limit, (index) {
      final purchase = now.subtract(Duration(days: 30 * (index + 1)));
      final warrantyEnd = purchase.add(Duration(days: 365));
      final item = WarrantyItem(
        itemId: 'item_${index + 1}',
        productName: 'Appliance ${index + 1}',
        model: 'Model ${(1000 + index)}',
        invoiceNo: 'INV-${5000 + index}',
        purchaseDate: purchase,
        purchasePrice: (15000 + random.nextInt(20000)).toDouble(),
        warrantyMonths: 12,
        warrantyStart: purchase,
        warrantyEnd: warrantyEnd,
        serialNumber: 'SN${index + 1}',
        serviceCenters: const ['Service Center A', 'Service Center B'],
        extendedWarrantyPurchased: index.isEven,
        notes: 'Standard coverage',
      );

      return Document(
        docId: 'doc_${index + 1}',
        userId: 'local_user',
        title: 'Invoice #${index + 1}',
        items: [item],
        createdAt: purchase,
        updatedAt: now,
        status: 'ready',
        sellerName: 'Retailer ${(index + 1)}',
        ocrConfidence: 0.92,
        isVerified: index.isEven,
      );
    });

    return docs;
  }
}

