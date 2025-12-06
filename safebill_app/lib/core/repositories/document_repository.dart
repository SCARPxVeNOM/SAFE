import '../api/api_client.dart';
import '../local/local_document_store.dart';
import '../models/document.dart';

class DocumentRepository {
  DocumentRepository(
    this._apiClient,
    this._localStore, {
    this.userId = 'local_user',
  });

  final SafeBillApiClient _apiClient;
  final LocalDocumentStore _localStore;
  final String userId;

  Future<List<Document>> fetchDocuments({bool refresh = false}) async {
    if (!refresh) {
      final cached = await _localStore.getAll();
      if (cached.isNotEmpty) return cached;
    }

    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/documents',
        query: {'userId': userId},
      );
      final docsPayload = response.data?['documents'] as List<dynamic>?;
      if (docsPayload != null) {
        final docs = docsPayload
            .map((json) => Document.fromJson(json as Map<String, dynamic>))
            .toList();
        for (final doc in docs) {
          await _localStore.upsert(doc);
        }
        if (docs.isNotEmpty) return docs;
      }
    } catch (_) {
      // fall back to local cache
    }

    return _localStore.getAll();
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
        data: {'userId': userId, 'docId': docId, 'rawText': rawText},
      );
      final payload = response.data?['document'] as Map<String, dynamic>?;
      if (payload != null) {
        final document = Document.fromJson(payload);
        await _localStore.upsert(document);
        return document;
      }
    } catch (_) {
      // fall through
    }

    // If the backend fails, keep the previous cached state (if any).
    final fallback = await _localStore.get(docId);
    if (fallback != null) return fallback;

    throw Exception('Extraction failed and no cached document is available.');
  }
}
