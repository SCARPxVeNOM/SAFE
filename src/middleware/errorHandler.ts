import type { NextFunction, Request, Response } from 'express';
import { ZodError } from 'zod';
import { logger } from '../utils/logger';

export class HttpError extends Error {
  public statusCode: number;
  public details?: unknown;

  constructor(statusCode: number, message: string, details?: unknown) {
    super(message);
    this.statusCode = statusCode;
    this.details = details;
  }
}

export const notFoundHandler = (
  _req: Request,
  res: Response,
  _next: NextFunction,
) => {
  res.status(404).json({ ok: false, error: 'Not Found' });
};

export const errorHandler = (
  err: Error,
  _req: Request,
  res: Response,
  _next: NextFunction,
) => {
  if (err instanceof HttpError) {
    if (err.statusCode >= 500) {
      logger.error({ err }, 'Unhandled server error');
    }
    res
      .status(err.statusCode)
      .json({ ok: false, error: err.message, details: err.details });
    return;
  }

  if (err instanceof ZodError) {
    res.status(400).json({
      ok: false,
      error: 'Validation failed',
      details: err.flatten(),
    });
    return;
  }

  logger.error({ err }, 'Unexpected error');
  res.status(500).json({ ok: false, error: 'Internal Server Error' });
};


