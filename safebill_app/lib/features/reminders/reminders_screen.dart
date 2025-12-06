import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'reminder_inbox.dart';

class RemindersScreen extends ConsumerWidget {
  const RemindersScreen({super.key});

  static const routePath = '/reminders';
  static const routeName = 'reminders';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminders = ref.watch(reminderInboxProvider);
    final formatter = DateFormat.yMMMd().add_jm();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminders'),
      ),
      body: reminders.isEmpty
          ? const _EmptyReminders()
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final reminder = reminders[index];
                return ListTile(
                  leading: Icon(
                    reminder.triggerType == 'expiry'
                        ? Icons.timer_outlined
                        : Icons.notifications_active_outlined,
                  ),
                  title: Text(reminder.title),
                  subtitle: Text(formatter.format(reminder.triggerAt)),
                  trailing: Text(reminder.status),
                );
              },
              separatorBuilder: (_, __) => const Divider(),
              itemCount: reminders.length,
            ),
    );
  }
}

class _EmptyReminders extends StatelessWidget {
  const _EmptyReminders();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.alarm_off_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'No reminders yet',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Schedule reminders from a document to receive push + local alerts before warranties expire.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

