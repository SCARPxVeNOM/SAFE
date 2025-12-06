import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api/api_client.dart';
import 'local/local_document_store.dart';
import 'repositories/chat_repository.dart';
import 'repositories/document_repository.dart';
import 'repositories/reminder_repository.dart';

final apiClientProvider = Provider<SafeBillApiClient>(
  (ref) => SafeBillApiClient(),
);

final documentRepositoryProvider = Provider<DocumentRepository>(
  (ref) => DocumentRepository(
    ref.read(apiClientProvider),
    LocalDocumentStore.instance,
  ),
);

final chatRepositoryProvider = Provider<ChatRepository>(
  (ref) => ChatRepository(ref.read(apiClientProvider)),
);

final reminderRepositoryProvider = Provider<ReminderRepository>(
  (ref) => ReminderRepository(ref.read(apiClientProvider)),
);

