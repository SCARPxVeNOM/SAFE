import { Router } from 'express';
import { z } from 'zod';
import { scheduleExpiryReminders } from '../services/reminders';
import { store, generateId } from '../store/inMemoryStore';
import type { ReminderConfig } from '../types/models';

const scheduleSchema = z.object({
  userId: z.string().min(1),
  docId: z.string().min(1),
  itemId: z.string().optional(),
  triggerAt: z.string().datetime().optional(),
  triggerType: z.enum(['expiry', 'followup', 'custom']).default('expiry'),
  warrantyEnd: z.string().datetime().optional(),
});

export const remindersRouter = Router();

remindersRouter.post('/schedule', (req, res, next) => {
  try {
    const body = scheduleSchema.parse(req.body);
    if (body.triggerType === 'expiry') {
      const reminders = scheduleExpiryReminders({
        userId: body.userId,
        docId: body.docId,
        ...(body.itemId ? { itemId: body.itemId } : {}),
        warrantyEnd: body.warrantyEnd ?? body.triggerAt ?? null,
      });
      res.json({ ok: true, reminders });
      return;
    }
    const reminder: ReminderConfig = {
      reminderId: generateId('rem'),
      userId: body.userId,
      docId: body.docId,
      ...(body.itemId ? { itemId: body.itemId } : {}),
      triggerType: body.triggerType,
      triggerAt: body.triggerAt ?? new Date().toISOString(),
      deliveryChannels: ['local'],
      status: 'scheduled',
    };
    store.upsertReminder(reminder);
    res.json({ ok: true, reminders: [reminder] });
  } catch (error) {
    next(error);
  }
});

remindersRouter.get('/:userId', (req, res, next) => {
  try {
    const { userId } = z.object({ userId: z.string().min(1) }).parse(
      req.params,
    );
    const reminders = store.listReminders(userId);
    res.json({ ok: true, reminders });
  } catch (error) {
    next(error);
  }
});

