import { Router } from 'express';
import { adminRouter } from './admin';
import { authRouter } from './auth';
import { chatRouter } from './chat';
import { claimsRouter } from './claims';
import { dataManagementRouter } from './dataManagement';
import { denialRouter } from './denials';
import { extractRouter } from './extract';
import { ingestRouter } from './ingest';
import { notificationsRouter } from './notifications';
import { remindersRouter } from './reminders';
import { documentsRouter } from './documents';
import { serviceBookingRouter } from './serviceBooking';

export const router = Router();

router.use('/auth', authRouter);
router.use('/extract', extractRouter);
router.use('/ingest', ingestRouter);
router.use('/chat', chatRouter);
router.use('/reminders', remindersRouter);
router.use('/claims', claimsRouter);
router.use('/denials', denialRouter);
router.use('/admin', adminRouter);
router.use('/documents', documentsRouter);
router.use('/data', dataManagementRouter);
router.use('/service-booking', serviceBookingRouter);
router.use('/notifications', notificationsRouter);
