import { Router } from 'express';
import { z } from 'zod';
import { analyzeDenial } from '../services/denials';

const schema = z.object({
  claimId: z.string().min(1),
  rawText: z.string().min(20),
});

export const denialRouter = Router();

denialRouter.post('/analyze', (req, res, next) => {
  try {
    const body = schema.parse(req.body);
    const denial = analyzeDenial(body);
    res.json({ ok: true, denial });
  } catch (error) {
    next(error);
  }
});


