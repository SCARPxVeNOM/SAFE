import { Router } from 'express';
import { z } from 'zod';
import { createClaim } from '../services/claims';
import { store } from '../store/inMemoryStore';
import { HttpError } from '../middleware/errorHandler';

const schema = z.object({
  userId: z.string().min(1),
  docId: z.string().min(1),
  itemId: z.string().min(1),
  issueDescription: z.string().min(10),
});

export const claimsRouter = Router();

claimsRouter.post('/generate', (req, res, next) => {
  try {
    const body = schema.parse(req.body);
    const document = store.getDocument(body.docId);
    if (!document) {
      throw new HttpError(404, 'Document not found');
    }
    const item =
      document.items.find((candidate) => candidate.itemId === body.itemId) ??
      null;
    if (!item) {
      throw new HttpError(404, 'Warranty item not found');
    }
    const claim = createClaim({
      userId: body.userId,
      document,
      item,
      issueDescription: body.issueDescription,
    });
    res.json({ ok: true, claim });
  } catch (error) {
    next(error);
  }
});


