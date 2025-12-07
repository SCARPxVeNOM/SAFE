import { Router } from 'express';
import { z } from 'zod';
import { store } from '../store/store';
import { extractDocument } from '../services/extraction';
import { scheduleExpiryReminders } from '../services/reminders';
import { HttpError } from '../middleware/errorHandler';

const schema = z.object({
  userId: z.string().min(1),
  docId: z.string().min(1),
  rawText: z.string().min(10),
});

export const extractRouter = Router();

extractRouter.post('/', async (req, res, next) => {
  try {
    const body = schema.parse(req.body);
    const document = await extractDocument(body);
    const remindersArrays = await Promise.all(
      document.items.map((item) =>
        scheduleExpiryReminders({
          userId: body.userId,
          docId: body.docId,
          itemId: item.itemId,
          warrantyEnd: item.warranty_end,
        }),
      ),
    );
    const reminders = remindersArrays.flat();
    res.json({ ok: true, document, reminders });
  } catch (error) {
    next(error);
  }
});

extractRouter.get('/:docId', async (req, res, next) => {
  try {
    const { docId } = z.object({ docId: z.string().min(1) }).parse(req.params);
    const document = await store.getDocument(docId);
    if (!document) {
      throw new HttpError(404, `Document ${docId} not found`);
    }
    res.json({ ok: true, document });
  } catch (error) {
    next(error);
  }
});

