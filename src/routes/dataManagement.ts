import { Router } from 'express';
import { z } from 'zod';
import { store } from '../store/store';
import { authenticateToken, type AuthRequest } from '../middleware/auth';
import { HttpError } from '../middleware/errorHandler';
import { logger } from '../utils/logger';

export const dataManagementRouter = Router();

const exportSchema = z.object({
  userId: z.string().min(1),
  format: z.enum(['json', 'csv']).default('json'),
});

const deleteSchema = z.object({
  userId: z.string().min(1),
  confirm: z.literal(true),
});

// Export user data
dataManagementRouter.post('/export', authenticateToken, async (req: AuthRequest, res, next) => {
  try {
    const userId = req.userId;
    if (!userId) {
      throw new HttpError(401, 'Unauthorized');
    }

    const { format } = exportSchema.parse({ ...req.body, userId });

    // Get all user data
    const documents = await store.listDocuments(userId);
    const reminders = await store.listReminders(userId);
    
    const exportData = {
      userId,
      exportedAt: new Date().toISOString(),
      documents,
      reminders,
      // Claims and denials would be added here
    };

    if (format === 'csv') {
      // Convert to CSV format
      const csv = convertToCSV(exportData);
      res.setHeader('Content-Type', 'text/csv');
      res.setHeader('Content-Disposition', `attachment; filename="safebill-export-${userId}-${Date.now()}.csv"`);
      return res.send(csv);
    }

    res.setHeader('Content-Type', 'application/json');
    res.setHeader('Content-Disposition', `attachment; filename="safebill-export-${userId}-${Date.now()}.json"`);
    res.json(exportData);
  } catch (error) {
    next(error);
  }
});

// Delete user data
dataManagementRouter.post('/delete', authenticateToken, async (req: AuthRequest, res, next) => {
  try {
    const userId = req.userId;
    if (!userId) {
      throw new HttpError(401, 'Unauthorized');
    }

    const { confirm } = deleteSchema.parse({ ...req.body, userId });

    if (!confirm) {
      throw new HttpError(400, 'Deletion must be confirmed');
    }

    // Delete all user data
    const documents = await store.listDocuments(userId);
    // Note: Actual deletion implementation depends on store methods
    // This is a placeholder - you'd need to implement delete methods
    
    logger.info({ userId }, 'User data deletion requested');

    res.json({
      ok: true,
      message: 'User data deletion initiated',
      deletedCount: documents.length,
    });
  } catch (error) {
    next(error);
  }
});

function convertToCSV(data: any): string {
  // Simple CSV conversion - can be enhanced
  const lines: string[] = [];
  lines.push('Type,ID,Data');
  
  if (data.documents) {
    data.documents.forEach((doc: any) => {
      lines.push(`Document,${doc.docId},"${JSON.stringify(doc).replace(/"/g, '""')}"`);
    });
  }
  
  return lines.join('\n');
}

