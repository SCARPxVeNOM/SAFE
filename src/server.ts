import cors from 'cors';
import express from 'express';
import helmet from 'helmet';
import passport from 'passport';
import { getEnv } from './config/env';
import { errorHandler, notFoundHandler } from './middleware/errorHandler';
import { router } from './routes';
import './routes/auth'; // Initialize passport strategies

export const createServer = () => {
  const env = getEnv();
  const app = express();

  app.use(helmet());
  app.use(
    cors({
      origin: env.NODE_ENV === 'development' ? '*' : true, // Allow all origins in production for mobile apps
      credentials: true,
    }),
  );
  app.use(express.json({ limit: '4mb' }));
  app.use(express.urlencoded({ extended: true }));
  
  // Initialize Passport
  app.use(passport.initialize());

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


