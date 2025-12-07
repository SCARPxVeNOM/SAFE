# Deployment Guide

This guide will help you deploy the SafeBill Next.js app to Vercel.

## Prerequisites

- GitHub account
- Vercel account (sign up at https://vercel.com)
- Git installed on your machine

## Step 1: Push to GitHub

### 1.1 Initialize Git Repository

```bash
cd nextjs-app
git init
git add .
git commit -m "Initial commit: SafeBill Next.js app"
```

### 1.2 Create GitHub Repository

1. Go to https://github.com/new
2. Create a new repository (e.g., `safebill-nextjs`)
3. **Do NOT** initialize with README, .gitignore, or license (we already have these)

### 1.3 Push to GitHub

```bash
# Add your GitHub repository as remote
git remote add origin https://github.com/YOUR_USERNAME/safebill-nextjs.git

# Push to GitHub
git branch -M main
git push -u origin main
```

Replace `YOUR_USERNAME` with your GitHub username.

## Step 2: Deploy to Vercel

### 2.1 Import Project

1. Go to https://vercel.com/new
2. Sign in with your GitHub account
3. Click **"Import Project"**
4. Select your `safebill-nextjs` repository
5. Click **"Import"**

### 2.2 Configure Project

Vercel will auto-detect Next.js. Configure the following:

**Project Settings:**
- **Framework Preset**: Next.js (auto-detected)
- **Root Directory**: `nextjs-app` (if your repo root is the parent directory) or leave blank if `nextjs-app` is the repo root
- **Build Command**: `npm run build` (default)
- **Output Directory**: `.next` (default)
- **Install Command**: `npm install` (default)

### 2.3 Environment Variables

Add these environment variables in Vercel:

1. Go to **Settings** → **Environment Variables**
2. Add the following:

```
NEXT_PUBLIC_API_BASE_URL=https://safe-jptl.onrender.com/api
NEXTAUTH_URL=https://your-app-name.vercel.app
NEXTAUTH_SECRET=your-nextauth-secret-here-generate-a-random-string
GOOGLE_CLIENT_ID=your-google-client-id
GOOGLE_CLIENT_SECRET=your-google-client-secret
```

**Important Notes:**
- `NEXTAUTH_URL` should be your Vercel deployment URL (you can update this after first deployment)
- `NEXTAUTH_SECRET` - Generate a random string: `openssl rand -base64 32`
- `GOOGLE_CLIENT_ID` and `GOOGLE_CLIENT_SECRET` - Get from Google Cloud Console
- Make sure to add these for **Production**, **Preview**, and **Development** environments

### 2.4 Deploy

1. Click **"Deploy"**
2. Wait for the build to complete (usually 2-3 minutes)
3. Your app will be live at `https://your-app-name.vercel.app`

## Step 3: Update Google OAuth Settings

After deployment, update your Google OAuth settings:

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Navigate to **APIs & Services** → **Credentials**
3. Edit your OAuth 2.0 Client ID
4. Add authorized redirect URI:
   ```
   https://your-app-name.vercel.app/api/auth/callback/google
   ```
5. Update `NEXTAUTH_URL` in Vercel to match your actual deployment URL

## Step 4: Verify Deployment

1. Visit your Vercel deployment URL
2. Test the onboarding flow
3. Test authentication
4. Verify API calls are working

## Troubleshooting

### Build Fails

- Check build logs in Vercel dashboard
- Ensure all dependencies are in `package.json`
- Verify TypeScript compilation passes locally: `npm run build`

### Environment Variables Not Working

- Make sure variables are added for the correct environment (Production/Preview/Development)
- Redeploy after adding new environment variables
- Check variable names match exactly (case-sensitive)

### API Calls Failing

- Verify `NEXT_PUBLIC_API_BASE_URL` is set correctly
- Check CORS settings on your backend
- Verify backend is accessible from Vercel

### Authentication Issues

- Verify `NEXTAUTH_URL` matches your actual deployment URL
- Check Google OAuth redirect URI is correct
- Ensure `NEXTAUTH_SECRET` is set

## Continuous Deployment

Vercel automatically deploys:
- **Production**: Every push to `main` branch
- **Preview**: Every push to other branches
- **Development**: Every pull request

## Custom Domain (Optional)

1. Go to **Settings** → **Domains**
2. Add your custom domain
3. Follow DNS configuration instructions
4. Vercel will automatically provision SSL certificate

## Monitoring

- View deployment logs in Vercel dashboard
- Check analytics in **Analytics** tab
- Monitor function execution in **Functions** tab

