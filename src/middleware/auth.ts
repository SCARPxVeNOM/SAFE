import type { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import { getEnv } from '../config/env';
import { HttpError } from './errorHandler';

const env = getEnv();

export interface AuthRequest extends Request {
  userId?: string;
  userEmail?: string;
}

export const authenticateToken = (
  req: AuthRequest,
  res: Response,
  next: NextFunction,
) => {
  const authHeader = req.headers.authorization;
  const token = authHeader && authHeader.startsWith('Bearer ') 
    ? authHeader.substring(7) 
    : null;

  if (!token) {
    throw new HttpError(401, 'Authentication required');
  }

  if (!env.NEXTAUTH_SECRET) {
    throw new HttpError(500, 'Authentication not configured');
  }

  try {
    const decoded = jwt.verify(token, env.NEXTAUTH_SECRET) as {
      userId: string;
      email: string;
    };
    
    req.userId = decoded.userId;
    req.userEmail = decoded.email;
    next();
  } catch (error) {
    throw new HttpError(401, 'Invalid or expired token');
  }
};

// Optional auth - doesn't throw if no token, but sets userId if valid
export const optionalAuth = (
  req: AuthRequest,
  res: Response,
  next: NextFunction,
) => {
  const authHeader = req.headers.authorization;
  const token = authHeader && authHeader.startsWith('Bearer ') 
    ? authHeader.substring(7) 
    : null;

  if (!token || !env.NEXTAUTH_SECRET) {
    return next();
  }

  try {
    const decoded = jwt.verify(token, env.NEXTAUTH_SECRET) as {
      userId: string;
      email: string;
    };
    
    req.userId = decoded.userId;
    req.userEmail = decoded.email;
  } catch (error) {
    // Ignore invalid tokens in optional auth
  }
  
  next();
};

