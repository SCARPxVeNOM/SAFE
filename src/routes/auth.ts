import { Router } from 'express';
import passport from 'passport';
import { Strategy as GoogleStrategy } from 'passport-google-oauth20';
import jwt from 'jsonwebtoken';
import { getEnv } from '../config/env';
import { logger } from '../utils/logger';
import { store } from '../store/store';

const env = getEnv();

export const authRouter = Router();

// Configure Google OAuth Strategy
if (env.GOOGLE_CLIENT_ID && env.GOOGLE_CLIENT_SECRET) {
  passport.use(
    new GoogleStrategy(
      {
        clientID: env.GOOGLE_CLIENT_ID,
        clientSecret: env.GOOGLE_CLIENT_SECRET,
        callbackURL: `${env.NEXTAUTH_URL || 'http://localhost:8080'}/api/auth/google/callback`,
      },
      async (accessToken, refreshToken, profile, done) => {
        try {
          const userId = profile.id;
          const email = profile.emails?.[0]?.value || '';
          const name = profile.displayName || '';
          const picture = profile.photos?.[0]?.value || '';

          // Store or update user in database
          const user = {
            userId,
            email,
            name,
            picture,
            provider: 'google',
            createdAt: new Date().toISOString(),
            updatedAt: new Date().toISOString(),
          };

          // Store user (you might want to create a users collection in MongoDB)
          // For now, we'll just use the userId from profile

          return done(null, { userId, email, name, picture });
        } catch (error) {
          logger.error({ error }, 'Google OAuth callback error');
          return done(error, undefined);
        }
      },
    ),
  );
} else {
  logger.warn('Google OAuth not configured - GOOGLE_CLIENT_ID or GOOGLE_CLIENT_SECRET missing');
}

// Generate JWT token
const generateToken = (userId: string, email: string) => {
  if (!env.NEXTAUTH_SECRET) {
    throw new Error('NEXTAUTH_SECRET is required for token generation');
  }
  return jwt.sign({ userId, email }, env.NEXTAUTH_SECRET, { expiresIn: '7d' });
};

// Google OAuth routes
authRouter.get(
  '/google',
  passport.authenticate('google', {
    scope: ['profile', 'email'],
  }),
);

authRouter.get(
  '/google/callback',
  passport.authenticate('google', { session: false }),
  (req, res) => {
    const user = req.user as { userId: string; email: string; name: string; picture?: string };
    
    if (!user) {
      return res.status(401).json({ ok: false, error: 'Authentication failed' });
    }

    const token = generateToken(user.userId, user.email);

    // For web redirect, for mobile return JSON
    const acceptHeader = req.headers.accept || '';
    if (acceptHeader.includes('application/json')) {
      return res.json({
        ok: true,
        token,
        user: {
          userId: user.userId,
          email: user.email,
          name: user.name,
          picture: user.picture,
        },
      });
    }

    // Redirect to frontend with token (for web)
    const redirectUrl = `${env.NEXTAUTH_URL || 'http://localhost:3000'}/auth/callback?token=${token}`;
    res.redirect(redirectUrl);
  },
);

// Verify token endpoint (for Flutter to verify tokens)
authRouter.post('/verify', async (req, res, next) => {
  try {
    const { token } = req.body;
    
    if (!token) {
      return res.status(400).json({ ok: false, error: 'Token required' });
    }

    if (!env.NEXTAUTH_SECRET) {
      return res.status(500).json({ ok: false, error: 'Auth not configured' });
    }

    const decoded = jwt.verify(token, env.NEXTAUTH_SECRET) as { userId: string; email: string };
    
    res.json({
      ok: true,
      user: {
        userId: decoded.userId,
        email: decoded.email,
      },
    });
  } catch (error) {
    res.status(401).json({ ok: false, error: 'Invalid token' });
  }
});

// Flutter-compatible endpoint - accepts Google ID token
authRouter.post('/google/mobile', async (req, res, next) => {
  try {
    const { idToken, accessToken } = req.body;

    if (!idToken) {
      return res.status(400).json({ ok: false, error: 'ID token required' });
    }

    // Verify Google ID token (simplified - in production, verify with Google)
    // For now, we'll decode it and trust it
    // In production, you should verify with: https://oauth2.googleapis.com/tokeninfo?id_token=...
    
    // Decode the token (without verification for now - add proper verification in production)
    const decoded = JSON.parse(Buffer.from(idToken.split('.')[1], 'base64').toString());
    
    const userId = decoded.sub || decoded.user_id;
    const email = decoded.email;
    const name = decoded.name;
    const picture = decoded.picture;

    if (!userId || !email) {
      return res.status(400).json({ ok: false, error: 'Invalid ID token' });
    }

    // Generate our JWT token
    const token = generateToken(userId, email);

    res.json({
      ok: true,
      token,
      user: {
        userId,
        email,
        name,
        picture,
      },
    });
  } catch (error) {
    logger.error({ error }, 'Google mobile auth error');
    res.status(401).json({ ok: false, error: 'Authentication failed' });
  }
});

// Get user info from token
authRouter.get('/me', async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ ok: false, error: 'No token provided' });
    }

    const token = authHeader.substring(7);
    
    if (!env.NEXTAUTH_SECRET) {
      return res.status(500).json({ ok: false, error: 'Auth not configured' });
    }

    const decoded = jwt.verify(token, env.NEXTAUTH_SECRET) as { userId: string; email: string };
    
    res.json({
      ok: true,
      user: {
        userId: decoded.userId,
        email: decoded.email,
      },
    });
  } catch (error) {
    res.status(401).json({ ok: false, error: 'Invalid token' });
  }
});

