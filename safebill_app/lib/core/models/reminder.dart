class Reminder {
  const Reminder({
    required this.reminderId,
    required this.docId,
    required this.title,
    required this.triggerAt,
    required this.triggerType,
    required this.deliveryChannels,
    required this.status,
  });

  final String reminderId;
  final String docId;
  final String title;
  final DateTime triggerAt;
  final String triggerType;
  final List<String> deliveryChannels;
  final String status;

  factory Reminder.fromJson(Map<String, dynamic> json) => Reminder(
        reminderId: json['reminderId'] as String,
        docId: json['docId'] as String,
        title: json['title'] as String? ?? 'Warranty reminder',
        triggerAt: DateTime.parse(json['triggerAt'] as String),
        triggerType: json['triggerType'] as String? ?? 'expiry',
        deliveryChannels:
            (json['deliveryChannels'] as List<dynamic>? ?? const [])
                .map((e) => e.toString())
                .toList(),
        status: json['status'] as String? ?? 'scheduled',
      );

  Map<String, dynamic> toJson() => {
        'reminderId': reminderId,
        'docId': docId,
        'title': title,
        'triggerAt': triggerAt.toIso8601String(),
        'triggerType': triggerType,
        'deliveryChannels': deliveryChannels,
        'status': status,
      };
}

