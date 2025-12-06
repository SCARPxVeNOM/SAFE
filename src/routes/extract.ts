import { Router } from 'express';
import { z } from 'zod';
import { store } from '../store/inMemoryStore';
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
    const reminders = document.items.flatMap((item) =>
      scheduleExpiryReminders({
        userId: body.userId,
        docId: body.docId,
        itemId: item.itemId,
        warrantyEnd: item.warranty_end,
      }),
    );
    res.json({ ok: true, document, reminders });
  } catch (error) {
    next(error);
  }
});

extractRouter.get('/:docId', (req, res, next) => {
  try {
    const { docId } = z.object({ docId: z.string().min(1) }).parse(req.params);
    const document = store.getDocument(docId);
    if (!document) {
      throw new HttpError(404, `Document ${docId} not found`);
    }
    res.json({ ok: true, document });
  } catch (error) {
    next(error);
  }
});

