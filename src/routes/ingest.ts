import { Router } from 'express';
import { z } from 'zod';
import { chunkText } from '../services/chunker';
import { upsertEmbeddings } from '../services/embeddings';

const schema = z.object({
  userId: z.string().min(1),
  docId: z.string().min(1),
  text: z.string().min(20),
});

export const ingestRouter = Router();

ingestRouter.post('/', async (req, res, next) => {
  try {
    const body = schema.parse(req.body);
    const chunks = chunkText(body.docId, body.text);
    const vectors = await upsertEmbeddings({
      docId: body.docId,
      userId: body.userId,
      chunks,
    });
    res.json({ ok: true, chunks: chunks.length, vectors });
  } catch (error) {
    next(error);
  }
});


