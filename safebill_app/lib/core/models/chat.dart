class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
    this.sources = const [],
  });

  final String id;
  final String role;
  final String content;
  final DateTime timestamp;
  final List<ChatSource> sources;

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: json['id'] as String,
        role: json['role'] as String,
        content: json['content'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
        sources: (json['sources'] as List<dynamic>? ?? const [])
            .map((s) => ChatSource.fromJson(s as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'role': role,
        'content': content,
        'timestamp': timestamp.toIso8601String(),
        'sources': sources.map((s) => s.toJson()).toList(),
      };
}

class ChatSource {
  const ChatSource({
    required this.docId,
    required this.chunk,
    required this.score,
  });

  final String docId;
  final String chunk;
  final double score;

  factory ChatSource.fromJson(Map<String, dynamic> json) => ChatSource(
        docId: json['docId'] as String,
        chunk: json['chunk'] as String,
        score: (json['score'] as num?)?.toDouble() ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'docId': docId,
        'chunk': chunk,
        'score': score,
      };
}

