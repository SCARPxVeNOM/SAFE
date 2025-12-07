import { createServer } from './server';
import { getEnv } from './config/env';
import { logger } from './utils/logger';

const bootstrap = async () => {
  const env = getEnv();
  const app = createServer();

  // Render sets PORT environment variable automatically
  const port = process.env.PORT ? Number.parseInt(process.env.PORT, 10) : env.PORT;
  const host = process.env.HOST || '0.0.0.0';

  app.listen(port, host, () => {
    logger.info(
      { port, host, env: env.NODE_ENV },
      'SafeBill API server started',
    );
  });
};

void bootstrap();


