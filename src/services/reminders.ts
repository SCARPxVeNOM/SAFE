import { generateId, store } from '../store/store';
import type { ReminderConfig } from '../types/models';
import { computeReminderDates } from '../utils/dates';
import { getEnv } from '../config/env';

const env = getEnv();

export const scheduleExpiryReminders = async (params: {
  userId: string;
  docId: string;
  itemId?: string;
  warrantyEnd: string | null;
}) => {
  if (!params.warrantyEnd) return [];
  const baseDate = new Date(params.warrantyEnd);
  const reminderDates = computeReminderDates(baseDate, env.DEFAULT_REMINDER_OFFSETS);
  const reminders: ReminderConfig[] = [];
  for (const triggerDate of reminderDates) {
    const reminder: ReminderConfig = {
      reminderId: generateId('rem'),
      userId: params.userId,
      docId: params.docId,
      ...(params.itemId ? { itemId: params.itemId } : {}),
      triggerType: 'expiry',
      triggerAt: triggerDate.toISOString(),
      deliveryChannels: ['local', 'push'],
      status: 'scheduled',
    };
    await store.upsertReminder(reminder);
    reminders.push(reminder);
  }
  return reminders;
};

