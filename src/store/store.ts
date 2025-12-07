import { getEnv } from '../config/env';
import { logger } from '../utils/logger';
import { InMemoryStore, generateId } from './inMemoryStore';
import { MongoStore } from './mongoStore';

const env = getEnv();

const initStore = () => {
  if (env.MONGODB_URI) {
    try {
      logger.info('Using MongoDB store');
      return new MongoStore();
    } catch (error) {
      logger.error({ error }, 'Failed to init MongoDB store, falling back to memory');
    }
  }

  logger.warn('MONGODB not configured; using in-memory store');
  return new InMemoryStore();
};

export const store = initStore();
export { generateId };


