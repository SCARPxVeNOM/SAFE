# SafeBill Next.js App

A modern Next.js web application for managing warranties and claims, migrated from the Flutter mobile app.

## Features

- ✅ **Onboarding Screen** - Beautiful welcome screen with hero animation
- ✅ **Authentication** - Consumer/Merchant login with Google OAuth support
- ✅ **Locker Dashboard** - Main consumer dashboard with:
  - Quick scan invoice action
  - Active warranties and asset value stats
  - Category filters (Gadgets, Appliances, Vehicle, Others)
  - Expiring soon list
  - Bottom navigation
- ✅ **Merchant Dashboard** - For merchants to assign bills to consumers
- ✅ **Scan Screen** - Upload and process invoices with AI extraction
- ✅ **Document Detail** - View detailed warranty information
- ✅ **Chat Assistant** - AI-powered chat for warranty questions
- ✅ **Reminders** - View and manage warranty expiry reminders
- ✅ **Claim Wizard** - Generate claim letters for denied warranties
- ✅ **Settings** - Theme toggle, local-only mode, OCR preferences

## Tech Stack

- **Next.js 14** - React framework with App Router
- **TypeScript** - Type-safe development
- **Tailwind CSS** - Utility-first styling
- **Zustand** - Lightweight state management
- **Axios** - HTTP client for API calls
- **Lucide React** - Icon library
- **date-fns** - Date formatting

## Getting Started

### Prerequisites

- Node.js 18+ and npm/yarn
- Backend API running at `https://safe-jptl.onrender.com/api`

### Local Development

1. Install dependencies:
```bash
cd nextjs-app
npm install
```

2. Create `.env.local` file:
```bash
cp .env.local.example .env.local
```

3. Update `.env.local` with your configuration:
```env
NEXT_PUBLIC_API_BASE_URL=https://safe-jptl.onrender.com/api
NEXTAUTH_URL=http://localhost:3000
NEXTAUTH_SECRET=your-nextauth-secret-here
GOOGLE_CLIENT_ID=your-google-client-id
GOOGLE_CLIENT_SECRET=your-google-client-secret
```

4. Run the development server:
```bash
npm run dev
```

5. Open [http://localhost:3000](http://localhost:3000) in your browser.

### Deployment

#### Quick Deploy to Vercel

1. **Push to GitHub** (see `GITHUB_SETUP.md`):
   ```bash
   git remote add origin https://github.com/YOUR_USERNAME/safebill-nextjs.git
   git branch -M main
   git push -u origin main
   ```

2. **Deploy to Vercel**:
   - Go to [vercel.com/new](https://vercel.com/new)
   - Import your GitHub repository
   - Add environment variables (see `DEPLOYMENT.md`)
   - Click Deploy

For detailed instructions, see:
- `QUICK_DEPLOY.md` - Fast deployment guide
- `GITHUB_SETUP.md` - GitHub setup
- `DEPLOYMENT.md` - Complete deployment guide

## Project Structure

```
nextjs-app/
├── app/                    # Next.js App Router pages
│   ├── page.tsx           # Home/Onboarding
│   ├── landing/           # Landing/Auth page
│   ├── locker/            # Consumer dashboard
│   ├── merchant-dashboard/# Merchant dashboard
│   ├── scan/              # Scan invoice page
│   ├── chat/              # AI chat assistant
│   ├── reminders/         # Reminders list
│   ├── claims/            # Claim wizard
│   ├── settings/          # Settings page
│   └── document/[id]/     # Document detail page
├── components/            # React components
├── lib/                   # Utilities and stores
│   ├── api-client.ts      # API client
│   ├── types.ts           # TypeScript types
│   └── store/             # Zustand stores
└── public/                # Static assets
```

## Backend Integration

The app connects to the backend API at `https://safe-jptl.onrender.com/api`. All API calls are made through the `apiClient` utility in `lib/api-client.ts`.

### API Endpoints Used

- `POST /auth/google` - Google OAuth authentication
- `GET /documents` - Fetch user documents
- `GET /documents/:id` - Get document details
- `POST /ingest` - Upload and process invoice
- `POST /extract` - Extract warranty data from text
- `POST /chat` - Chat with AI assistant
- `GET /reminders` - Get user reminders

## Features Comparison with Flutter App

All features from the Flutter app have been retained:

| Feature | Flutter | Next.js | Status |
|---------|---------|---------|--------|
| Onboarding | ✅ | ✅ | Complete |
| Auth (Consumer/Merchant) | ✅ | ✅ | Complete |
| Google OAuth | ✅ | ✅ | Complete |
| Locker Dashboard | ✅ | ✅ | Complete |
| Scan Invoice | ✅ | ✅ | Complete |
| Document Detail | ✅ | ✅ | Complete |
| AI Chat | ✅ | ✅ | Complete |
| Reminders | ✅ | ✅ | Complete |
| Claim Wizard | ✅ | ✅ | Complete |
| Settings | ✅ | ✅ | Complete |
| Theme Toggle | ✅ | ✅ | Complete |
| Bottom Navigation | ✅ | ✅ | Complete |

## Development

### Build for Production

```bash
npm run build
npm start
```

### Linting

```bash
npm run lint
```

## Environment Variables

- `NEXT_PUBLIC_API_BASE_URL` - Backend API base URL
- `NEXTAUTH_URL` - Your app URL (for OAuth callbacks)
- `NEXTAUTH_SECRET` - Secret for NextAuth.js
- `GOOGLE_CLIENT_ID` - Google OAuth client ID
- `GOOGLE_CLIENT_SECRET` - Google OAuth client secret

## Notes

- The app uses localStorage for client-side state persistence
- Authentication tokens are stored in localStorage
- Theme preferences are persisted across sessions
- The app is fully responsive and works on mobile, tablet, and desktop

## License

MIT

