import 'package:uuid/uuid.dart';

import '../api/api_client.dart';
import '../models/chat.dart';

class ChatRepository {
  ChatRepository(this._apiClient);

  final SafeBillApiClient _apiClient;
  final _uuid = const Uuid();

  Future<ChatMessage> askAssistant({
    required String userId,
    required String question,
  }) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/chat',
        data: {
          'userId': userId,
          'question': question,
        },
      );
      final payload = response.data;
      if (payload != null && payload['ok'] == true) {
        return ChatMessage(
          id: _uuid.v4(),
          role: 'assistant',
          content: payload['answer'] as String? ??
              'I could not locate the requested details.',
          timestamp: DateTime.now(),
          sources: (payload['sources'] as List<dynamic>? ?? const [])
              .map((source) =>
                  ChatSource.fromJson(source as Map<String, dynamic>))
              .toList(),
        );
      }
    } catch (_) {
      // fall through to offline fallback
    }

    return ChatMessage(
      id: _uuid.v4(),
      role: 'assistant',
      content:
          'I could not reach the SafeBill server. Please try again when you have connectivity.',
      timestamp: DateTime.now(),
      sources: const [],
    );
  }
}

