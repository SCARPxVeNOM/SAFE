import admin from 'firebase-admin';
import { getEnv } from '../config/env';
import { logger } from '../utils/logger';

const env = getEnv();

if (
  !admin.apps.length &&
  env.FIREBASE_PROJECT_ID &&
  env.FIREBASE_CLIENT_EMAIL &&
  env.FIREBASE_PRIVATE_KEY
) {
  admin.initializeApp({
    credential: admin.credential.cert({
      projectId: env.FIREBASE_PROJECT_ID,
      clientEmail: env.FIREBASE_CLIENT_EMAIL,
      privateKey: env.FIREBASE_PRIVATE_KEY.replace(/\\n/g, '\n'),
    }),
  });
  logger.info('Firebase initialized');
}

export const firestore = admin.apps.length ? admin.firestore() : null;
export const storage: admin.storage.Storage | null = admin.apps.length
  ? admin.storage()
  : null;

