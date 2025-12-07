import { Router } from 'express';
import { z } from 'zod';
import axios from 'axios';
import { getEnv } from '../config/env';
import { authenticateToken, type AuthRequest } from '../middleware/auth';
import { HttpError } from '../middleware/errorHandler';
import { logger } from '../utils/logger';

export const notificationsRouter = Router();

const env = getEnv();

const registerSchema = z.object({
  fcmToken: z.string().min(1),
});

const sendSchema = z.object({
  userId: z.string().min(1),
  title: z.string().min(1),
  body: z.string().min(1),
  data: z.record(z.string(), z.any()).optional(),
});

// Store FCM tokens (in production, use database)
const fcmTokens = new Map<string, string>();

// Register FCM token
notificationsRouter.post('/register', authenticateToken, async (req: AuthRequest, res, next) => {
  try {
    const userId = req.userId;
    if (!userId) {
      throw new HttpError(401, 'Unauthorized');
    }

    const { fcmToken } = registerSchema.parse(req.body);
    fcmTokens.set(userId, fcmToken);

    logger.info({ userId }, 'FCM token registered');

    res.json({
      ok: true,
      message: 'FCM token registered successfully',
    });
  } catch (error) {
    next(error);
  }
});

// Send notification (requires FCM server key)
notificationsRouter.post('/send', authenticateToken, async (req: AuthRequest, res, next) => {
  try {
    const { userId, title, body, data } = sendSchema.parse(req.body);

    const fcmToken = fcmTokens.get(userId);
    if (!fcmToken) {
      throw new HttpError(404, 'FCM token not found for user');
    }

    // Get FCM server key from environment
    const fcmServerKey = process.env.FCM_SERVER_KEY;
    if (!fcmServerKey) {
      throw new HttpError(500, 'FCM server key not configured');
    }

    // Send notification via FCM API
    const response = await axios.post(
      'https://fcm.googleapis.com/fcm/send',
      {
        to: fcmToken,
        notification: {
          title,
          body,
        },
        data: data || {},
      },
      {
        headers: {
          'Authorization': `key=${fcmServerKey}`,
          'Content-Type': 'application/json',
        },
      },
    );

    logger.info({ userId, messageId: response.data.message_id }, 'Notification sent');

    res.json({
      ok: true,
      messageId: response.data.message_id,
      message: 'Notification sent successfully',
    });
  } catch (error: any) {
    if (error.response) {
      logger.error({ error: error.response.data }, 'FCM API error');
      throw new HttpError(500, `FCM error: ${error.response.data.error?.message || 'Unknown error'}`);
    }
    next(error);
  }
});

// Get notification status
notificationsRouter.get('/status', authenticateToken, async (req: AuthRequest, res, next) => {
  try {
    const userId = req.userId;
    if (!userId) {
      throw new HttpError(401, 'Unauthorized');
    }

    const hasToken = fcmTokens.has(userId);

    res.json({
      ok: true,
      registered: hasToken,
      message: hasToken ? 'Notifications enabled' : 'No FCM token registered',
    });
  } catch (error) {
    next(error);
  }
});

