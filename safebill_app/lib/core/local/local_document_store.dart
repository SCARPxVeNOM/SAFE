import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/document.dart';

class LocalDocumentStore {
  LocalDocumentStore._();

  static final LocalDocumentStore instance = LocalDocumentStore._();

  Database? _db;
  final Map<String, String> _memoryStore = {};

  bool get _useMemoryStore => kIsWeb;

  Future<void> init() async {
    if (_useMemoryStore) {
      _memoryStore.clear();
      return;
    }

    final dir = await getApplicationDocumentsDirectory();
    final dbPath = p.join(dir.path, 'safebill.db');
    _db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          '''
          CREATE TABLE documents(
            docId TEXT PRIMARY KEY,
            payload TEXT NOT NULL
          )
          ''',
        );
      },
    );
  }

  Database get _database {
    final database = _db;
    if (database == null) {
      throw StateError('LocalDocumentStore not initialized');
    }
    return database;
  }

  Future<void> upsert(Document document) async {
    if (_useMemoryStore) {
      _memoryStore[document.docId] = document.toJsonString();
      return;
    }

    await _database.insert(
      'documents',
      {
        'docId': document.docId,
        'payload': document.toJsonString(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Document?> get(String docId) async {
    if (_useMemoryStore) {
      final payload = _memoryStore[docId];
      return payload != null ? Document.fromJsonString(payload) : null;
    }

    final result = await _database.query(
      'documents',
      where: 'docId = ?',
      whereArgs: [docId],
      limit: 1,
    );
    if (result.isEmpty) return null;
    return Document.fromJsonString(result.first['payload'] as String);
  }

  Future<List<Document>> getAll() async {
    if (_useMemoryStore) {
      return _memoryStore.values
          .map(Document.fromJsonString)
          .toList(growable: false);
    }

    final rows = await _database.query('documents');
    return rows
        .map((row) => Document.fromJsonString(row['payload'] as String))
        .toList();
  }
}

