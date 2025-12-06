import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../models/reminder.dart';

class ReminderScheduler {
  ReminderScheduler._();

  static final ReminderScheduler instance = ReminderScheduler._();

  FlutterLocalNotificationsPlugin? _plugin;

  void configure(FlutterLocalNotificationsPlugin plugin) {
    _plugin = plugin;
  }

  Future<void> schedule(Reminder reminder) async {
    final plugin = _plugin;
    if (plugin == null) return;

    final tzDateTime = tz.TZDateTime.from(
      reminder.triggerAt,
      tz.local,
    );

    await plugin.zonedSchedule(
      reminder.reminderId.hashCode,
      reminder.title,
      'Warranty ${reminder.triggerType} approaching',
      tzDateTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'safebill_reminders',
          'Warranty reminders',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: reminder.docId,
    );
  }
}

