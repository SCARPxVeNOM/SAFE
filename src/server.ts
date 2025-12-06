import cors from 'cors';
import express from 'express';
import helmet from 'helmet';
import { getEnv } from './config/env';
import { errorHandler, notFoundHandler } from './middleware/errorHandler';
import { router } from './routes';

export const createServer = () => {
  const env = getEnv();
  const app = express();

  app.use(helmet());
  app.use(
    cors({
      origin: env.NODE_ENV === 'development' ? '*' : undefined,
      credentials: true,
    }),
  );
  app.use(express.json({ limit: '4mb' }));
  app.use(express.urlencoded({ extended: true }));

  app.get('/health', (_req, res) => {
    res.json({
      ok: true,
      service: 'SafeBill API',
      env: env.NODE_ENV,
      timestamp: new Date().toISOString(),
    });
  });

  app.use('/api', router);
  app.use(notFoundHandler);
  app.use(errorHandler);

  return app;
};


