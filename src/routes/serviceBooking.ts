import { Router } from 'express';
import { z } from 'zod';
import { authenticateToken, type AuthRequest } from '../middleware/auth';
import { HttpError } from '../middleware/errorHandler';
import { logger } from '../utils/logger';

export const serviceBookingRouter = Router();

const bookingSchema = z.object({
  userId: z.string().min(1),
  docId: z.string().min(1),
  serviceCenterId: z.string().min(1),
  preferredDate: z.string(),
  preferredTime: z.string().optional(),
  contactPhone: z.string().optional(),
});

// Book service appointment
serviceBookingRouter.post('/book', authenticateToken, async (req: AuthRequest, res, next) => {
  try {
    const userId = req.userId;
    if (!userId) {
      throw new HttpError(401, 'Unauthorized');
    }

    const bookingData = bookingSchema.parse({ ...req.body, userId });

    // Placeholder for service center API integration
    // In production, this would call external service center APIs
    logger.info({ bookingData }, 'Service booking requested');

    // Mock booking response
    const bookingId = `booking_${Date.now()}`;
    
    res.json({
      ok: true,
      bookingId,
      status: 'pending',
      message: 'Booking request submitted. You will receive confirmation shortly.',
      bookingData,
    });
  } catch (error) {
    next(error);
  }
});

// Get booking status
serviceBookingRouter.get('/:bookingId', authenticateToken, async (req: AuthRequest, res, next) => {
  try {
    const { bookingId } = req.params;
    
    // Placeholder - would fetch from database
    res.json({
      ok: true,
      bookingId,
      status: 'pending',
    });
  } catch (error) {
    next(error);
  }
});

