import { createServer } from './server';
import { getEnv } from './config/env';
import { logger } from './utils/logger';

const bootstrap = async () => {
  const env = getEnv();
  const app = createServer();

  app.listen(env.PORT, () => {
    logger.info(
      { port: env.PORT, env: env.NODE_ENV },
      'SafeBill API server started',
    );
  });
};

void bootstrap();


