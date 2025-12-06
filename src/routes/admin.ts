import { Router } from 'express';
import { getAnalytics } from '../services/analytics';

export const adminRouter = Router();

adminRouter.get('/analytics', (_req, res) => {
  res.json({ ok: true, metrics: getAnalytics() });
});


