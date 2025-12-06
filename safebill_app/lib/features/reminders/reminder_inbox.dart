import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/reminder.dart';

final reminderInboxProvider =
    StateNotifierProvider<ReminderInbox, List<Reminder>>(
  (ref) => ReminderInbox(),
);

class ReminderInbox extends StateNotifier<List<Reminder>> {
  ReminderInbox() : super(const []);

  void addAll(List<Reminder> reminders) {
    final merged = [...state];
    for (final reminder in reminders) {
      final index =
          merged.indexWhere((existing) => existing.reminderId == reminder.reminderId);
      if (index >= 0) {
        merged[index] = reminder;
      } else {
        merged.add(reminder);
      }
    }
    state = merged..sort((a, b) => a.triggerAt.compareTo(b.triggerAt));
  }
}

