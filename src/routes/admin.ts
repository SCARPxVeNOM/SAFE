import { Router } from 'express';
import { getAnalytics } from '../services/analytics';

export const adminRouter = Router();

adminRouter.get('/analytics', async (_req, res, next) => {
  try {
    const metrics = await getAnalytics();
    res.json({ ok: true, metrics });
  } catch (error) {
    next(error);
  }
});


