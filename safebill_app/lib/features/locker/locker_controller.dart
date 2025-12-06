import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/document.dart';
import '../../core/providers.dart';

final lockerControllerProvider =
    AsyncNotifierProvider<LockerController, List<Document>>(
  LockerController.new,
);

class LockerController extends AsyncNotifier<List<Document>> {
  @override
  Future<List<Document>> build() {
    final repository = ref.read(documentRepositoryProvider);
    return repository.fetchDocuments();
  }

  Future<void> refresh() async {
    final repository = ref.read(documentRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => repository.fetchDocuments(refresh: true),
    );
  }
}

