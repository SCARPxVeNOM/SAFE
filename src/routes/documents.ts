import { Router } from 'express';
import { z } from 'zod';
import { store } from '../store/inMemoryStore';

const listQuery = z.object({
  userId: z.string().min(1),
});

export const documentsRouter = Router();

// GET /api/documents?userId=u_123
documentsRouter.get('/', (req, res, next) => {
  try {
    const { userId } = listQuery.parse(req.query);
    const documents = store.listDocuments(userId);
    res.json({ ok: true, documents });
  } catch (error) {
    next(error);
  }
});

// GET /api/documents/:docId
documentsRouter.get('/:docId', (req, res, next) => {
  try {
    const { docId } = z.object({ docId: z.string().min(1) }).parse(req.params);
    const document = store.getDocument(docId);
    if (!document) {
      res.status(404).json({ ok: false, error: 'Document not found' });
      return;
    }
    res.json({ ok: true, document });
  } catch (error) {
    next(error);
  }
});

