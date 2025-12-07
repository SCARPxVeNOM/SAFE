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
  console.log('[INGEST] Request received');
  try {
    console.log('[INGEST] Parsing body...');
    const body = schema.parse(req.body);
    console.log('[INGEST] Body parsed:', { userId: body.userId, docId: body.docId, textLength: body.text.length });
    
    // Create chunks immediately
    console.log('[INGEST] Creating chunks...');
    const chunks = chunkText(body.docId, body.text);
    console.log('[INGEST] Chunks created:', chunks.length);
    
    // Return success immediately with chunk count
    console.log('[INGEST] Sending response...');
    res.json({ 
      ok: true, 
      chunks: chunks.length,
      message: 'Document ingestion accepted. Embeddings will be processed asynchronously.'
    });
    console.log('[INGEST] Response sent');
    
    // Process embeddings in background (non-blocking)
    if (chunks.length > 0) {
      console.log('[INGEST] Scheduling background embedding...');
      setImmediate(async () => {
        try {
          await upsertEmbeddings({
            docId: body.docId,
            userId: body.userId,
            chunks,
          });
          console.log('[INGEST] Background embedding completed');
        } catch (error) {
          // Background errors are non-fatal
          console.warn('[INGEST] Background embedding failed (non-fatal):', error);
        }
      });
    }
  } catch (error: any) {
    console.error('[INGEST] Error caught:', error);
    console.error('[INGEST] Error details:', {
      message: error?.message,
      stack: error?.stack,
      name: error?.name,
    });
    next(error);
  }
});


