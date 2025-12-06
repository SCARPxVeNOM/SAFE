import { Router } from 'express';
import { adminRouter } from './admin';
import { chatRouter } from './chat';
import { claimsRouter } from './claims';
import { denialRouter } from './denials';
import { extractRouter } from './extract';
import { ingestRouter } from './ingest';
import { remindersRouter } from './reminders';

export const router = Router();

router.use('/extract', extractRouter);
router.use('/ingest', ingestRouter);
router.use('/chat', chatRouter);
router.use('/reminders', remindersRouter);
router.use('/claims', claimsRouter);
router.use('/denials', denialRouter);
router.use('/admin', adminRouter);


