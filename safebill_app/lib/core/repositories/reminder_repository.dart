import 'package:uuid/uuid.dart';

import '../api/api_client.dart';
import '../local/reminder_scheduler.dart';
import '../models/reminder.dart';

class ReminderRepository {
  ReminderRepository(this._apiClient);

  final SafeBillApiClient _apiClient;
  final _uuid = const Uuid();

  Future<List<Reminder>> scheduleExpiryReminders({
    required String userId,
    required String docId,
    required DateTime warrantyEnd,
  }) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/reminders/schedule',
        data: {
          'userId': userId,
          'docId': docId,
          'warrantyEnd': warrantyEnd.toIso8601String(),
          'triggerType': 'expiry',
        },
      );
      final remindersPayload = response.data?['reminders'] as List<dynamic>?;
      if (remindersPayload != null) {
        final reminders = remindersPayload
            .map((json) => Reminder.fromJson(json as Map<String, dynamic>))
            .toList();
        for (final reminder in reminders) {
          await ReminderScheduler.instance.schedule(reminder);
        }
        return reminders;
      }
    } catch (_) {
      // offline fallback below
    }

    final fallback = Reminder(
      reminderId: _uuid.v4(),
      docId: docId,
      title: 'Warranty expiry',
      triggerAt: warrantyEnd.subtract(const Duration(days: 7)),
      triggerType: 'expiry',
      deliveryChannels: const ['local'],
      status: 'scheduled',
    );
    await ReminderScheduler.instance.schedule(fallback);
    return [fallback];
  }
}

