import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/models/chat.dart';
import '../../core/providers.dart';

final chatControllerProvider =
    StateNotifierProvider<ChatController, List<ChatMessage>>(
  ChatController.new,
);

class ChatController extends StateNotifier<List<ChatMessage>> {
  ChatController(this.ref) : super(const []);

  final Ref ref;
  final _uuid = const Uuid();

  Future<void> send(String question) async {
    if (question.isEmpty) return;
    final userMessage = ChatMessage(
      id: _uuid.v4(),
      role: 'user',
      content: question,
      timestamp: DateTime.now(),
    );
    state = [...state, userMessage];

    final response = await ref.read(chatRepositoryProvider).askAssistant(
      userId: 'local_user',
      question: question,
    );
    state = [...state, response];
  }
}

