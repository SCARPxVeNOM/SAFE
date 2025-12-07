# Quick Deployment Guide

## 🚀 Fast Track to Deploy

### 1. Push to GitHub (5 minutes)

```powershell
# You're already in the nextjs-app directory with git initialized
# Just add the remote and push:

# Step 1: Create a new repository on GitHub
# Go to: https://github.com/new
# Name it: safebill-nextjs
# Don't initialize with README

# Step 2: Add remote (replace YOUR_USERNAME)
git remote add origin https://github.com/YOUR_USERNAME/safebill-nextjs.git

# Step 3: Push to GitHub
git branch -M main
git push -u origin main
```

### 2. Deploy to Vercel (5 minutes)

1. **Go to Vercel**: https://vercel.com/new
2. **Sign in** with GitHub
3. **Import** your `safebill-nextjs` repository
4. **Configure**:
   - Framework: Next.js (auto-detected)
   - Root Directory: Leave blank (or `nextjs-app` if repo root is parent)
5. **Add Environment Variables**:
   ```
   NEXT_PUBLIC_API_BASE_URL=https://safe-jptl.onrender.com/api
   NEXTAUTH_URL=https://your-app.vercel.app (update after first deploy)
   NEXTAUTH_SECRET=generate-random-string-here
   GOOGLE_CLIENT_ID=your-google-client-id
   GOOGLE_CLIENT_SECRET=your-google-client-secret
   ```
6. **Click Deploy** 🎉

### 3. Update Settings After First Deploy

1. Copy your Vercel URL (e.g., `https://safebill-nextjs.vercel.app`)
2. Update `NEXTAUTH_URL` in Vercel environment variables
3. Update Google OAuth redirect URI to: `https://your-app.vercel.app/api/auth/callback/google`

## ✅ Done!

Your app is now live at: `https://your-app.vercel.app`

---

## 📝 Detailed Instructions

For more detailed instructions, see:
- `GITHUB_SETUP.md` - GitHub setup guide
- `DEPLOYMENT.md` - Complete deployment guide

