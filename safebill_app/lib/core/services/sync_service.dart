import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_client.dart';
import '../config.dart';
import '../local/local_document_store.dart';
import '../models/document.dart';
import '../../app/theme.dart';

class SyncService {
  SyncService({required this.apiClient, required this.localStore});

  final SafeBillApiClient apiClient;
  final LocalDocumentStore localStore;
  bool _isSyncing = false;

  static const String _syncQueueKey = 'sync_queue';
  static const String _lastSyncKey = 'last_sync';

  /// Check connectivity and sync pending items
  Future<SyncResult> syncPendingItems() async {
    if (_isSyncing) {
      return SyncResult(
        success: false,
        message: 'Sync already in progress',
      );
    }

    _isSyncing = true;
    try {
      final connectivity = await Connectivity().checkConnectivity();
      if (connectivity == ConnectivityResult.none) {
        return SyncResult(
          success: false,
          message: 'No internet connection',
        );
      }

      final prefs = await SharedPreferences.getInstance();
      final queueJson = prefs.getString(_syncQueueKey) ?? '[]';
      final queue = List<String>.from(
        (prefs.getStringList(_syncQueueKey) ?? [])
      );

      if (queue.isEmpty) {
        return SyncResult(
          success: true,
          message: 'No items to sync',
          syncedCount: 0,
        );
      }

      int syncedCount = 0;
      final failedItems = <String>[];

      for (final docId in queue) {
        try {
          final doc = await localStore.get(docId);
          if (doc != null) {
            // Sync document
            await apiClient.post('/documents', data: doc.toJson());
            
            // Sync ingestion if needed
            if (doc.rawText.isNotEmpty) {
              await apiClient.post('/ingest', data: {
                'userId': doc.userId,
                'docId': doc.docId,
                'text': doc.rawText,
              });
            }
            
            syncedCount++;
            queue.remove(docId);
          }
        } catch (e) {
          failedItems.add(docId);
        }
      }

      // Update queue
      await prefs.setStringList(_syncQueueKey, queue);
      await prefs.setString(_lastSyncKey, DateTime.now().toIso8601String());

      return SyncResult(
        success: failedItems.isEmpty,
        message: failedItems.isEmpty
            ? 'Synced $syncedCount items'
            : 'Synced $syncedCount items, ${failedItems.length} failed',
        syncedCount: syncedCount,
        failedCount: failedItems.length,
      );
    } finally {
      _isSyncing = false;
    }
  }

  /// Add item to sync queue
  Future<void> queueForSync(String docId) async {
    final prefs = await SharedPreferences.getInstance();
    final queue = prefs.getStringList(_syncQueueKey) ?? [];
    if (!queue.contains(docId)) {
      queue.add(docId);
      await prefs.setStringList(_syncQueueKey, queue);
    }
  }

  /// Get sync status
  Future<SyncStatus> getSyncStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final queue = prefs.getStringList(_syncQueueKey) ?? [];
    final lastSyncStr = prefs.getString(_lastSyncKey);
    
    return SyncStatus(
      pendingCount: queue.length,
      lastSync: lastSyncStr != null ? DateTime.parse(lastSyncStr) : null,
    );
  }
}

class SyncResult {
  SyncResult({
    required this.success,
    required this.message,
    this.syncedCount = 0,
    this.failedCount = 0,
  });

  final bool success;
  final String message;
  final int syncedCount;
  final int failedCount;
}

class SyncStatus {
  SyncStatus({
    required this.pendingCount,
    this.lastSync,
  });

  final int pendingCount;
  final DateTime? lastSync;
}

