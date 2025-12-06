# SafeBill - AI-Powered Warranty & Guarantee Manager

SafeBill is a comprehensive hybrid local/cloud platform designed for Indian consumers to scan, store, and manage invoices, warranties, and denial letters. The system combines on-device OCR with AI-powered document extraction, intelligent reminders, and a RAG-powered assistant to help users track and act on their warranties and claims.

## 🎯 Features

### Core Capabilities
- **Document Scanning & Upload**: Capture invoices and warranty documents via camera or PDF upload with automatic processing
- **Automated Data Extraction**: Hybrid parser combining regex patterns with OpenAI for semantic extraction of warranty details
- **Digital Locker**: Secure encrypted storage for original documents, OCR text, and structured metadata
- **Smart Reminders**: Multi-channel reminder system (local notifications + push) for warranty expiry and claim follow-ups
- **AI Assistant**: RAG + GraphRAG powered chat assistant for answering questions about warranties and claims
- **Claim Assistance**: Guided wizard for generating claim letters, analyzing denials, and suggesting appeals
- **Privacy First**: Local-only mode option, PII redaction, and full data export/delete capabilities

### Key Value Propositions
- ✅ **Proof Retention**: Never lose important warranty documents
- ⏰ **Time-bound Action**: Never miss warranty expiration dates
- 🤖 **AI Guidance**: Get expert help with claims and denials
- 🔒 **Compliance & Privacy**: Indian data locality, encryption, and GDPR-compliant workflows

## 🏗️ Architecture

### Tech Stack

#### Backend (Node.js/TypeScript)
- **Runtime**: Node.js 20+ with TypeScript 5.9
- **Framework**: Express 5.x
- **AI/ML**: OpenAI API (GPT-4.1-mini, text-embedding-3-small)
- **Vector Database**: Pinecone
- **Graph Database**: Neo4j (for GraphRAG)
- **Authentication**: Firebase Auth
- **Storage**: Firebase Storage (with AES-256 encryption)
- **Database**: Firestore
- **Validation**: Zod
- **Logging**: Pino
- **Security**: Helmet, CORS

#### Mobile App (Flutter)
- **Framework**: Flutter 3.10+, Dart 3.10
- **State Management**: Riverpod
- **Routing**: GoRouter
- **Local Storage**: SQLite (sqflite)
- **OCR**: Google ML Kit Text Recognition
- **Notifications**: flutter_local_notifications
- **HTTP Client**: Dio
- **UI**: Material Design with custom theme, Google Fonts, Lucide Icons

### System Components

```
┌─────────────────┐
│  Flutter App    │
│  (iOS/Android)  │
└────────┬────────┘
         │
         ├─ On-device OCR (ML Kit)
         ├─ Local SQLite Cache
         └─ Local Notifications
         │
         ▼
┌─────────────────┐
│  Express API    │
│  (Node.js/TS)   │
└────────┬────────┘
         │
         ├─ /api/extract     (Invoice parsing)
         ├─ /api/ingest      (Vector embedding)
         ├─ /api/chat        (RAG assistant)
         ├─ /api/reminders   (Reminder scheduling)
         ├─ /api/claims      (Claim generation)
         ├─ /api/denials     (Denial analysis)
         └─ /api/admin       (Analytics dashboard)
         │
         ▼
┌─────────────────────────────────────┐
│  Firebase    │  OpenAI  │  Pinecone │
│  Firestore   │  API     │  Vector   │
│  Storage     │          │  DB       │
│  Auth        │          │           │
└─────────────────────────────────────┘
```

## 🚀 Getting Started

### Prerequisites

- **Node.js**: 20.x or higher
- **npm**: 9.x or higher
- **Flutter**: 3.10 or higher
- **Dart**: 3.10 or higher

### Backend Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd SAFE
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Configure environment variables**
   
   Create a `.env` file in the root directory:
   ```env
   NODE_ENV=development
   PORT=8080
   
   # OpenAI (Required)
   OPENAI_API_KEY=sk-...
   
   # Pinecone (Optional - for vector storage)
   PINECONE_API_KEY=...
   PINECONE_INDEX=safebill-index
   
   # Neo4j (Optional - for GraphRAG)
   GRAPH_DB_URI=neo4j+s://...
   GRAPH_DB_USER=neo4j
   GRAPH_DB_PASSWORD=...
   
   # Firebase (Optional - for auth/storage)
   FIREBASE_PROJECT_ID=...
   FIREBASE_CLIENT_EMAIL=...
   FIREBASE_PRIVATE_KEY=...
   
   # Settings
   DEFAULT_REMINDER_OFFSETS=30,7,3,1
   LOCAL_ONLY_MODE=false
   ```

4. **Build the project**
   ```bash
   npm run build
   ```

5. **Run in development mode**
   ```bash
   npm run dev
   ```

6. **Run in production mode**
   ```bash
   npm start
   ```

The API server will start on `http://localhost:8080`

### Flutter App Setup

1. **Navigate to the Flutter app directory**
   ```bash
   cd safebill_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure API endpoint**
   
   Update `lib/core/api/api_client.dart` with your backend URL

4. **Run the app**
   ```bash
   # iOS
   flutter run -d ios
   
   # Android
   flutter run -d android
   
   # Web (development)
   flutter run -d chrome
   ```

5. **Build for production**
   ```bash
   # Android APK
   flutter build apk --release
   
   # iOS (requires Xcode)
   flutter build ios --release
   ```

## 📁 Project Structure

### Backend Structure
```
src/
├── clients/          # External service clients
│   ├── firebaseAdmin.ts
│   └── openaiClient.ts
├── config/           # Configuration
│   └── env.ts        # Environment validation
├── middleware/       # Express middleware
│   └── errorHandler.ts
├── routes/           # API endpoints
│   ├── admin.ts      # Analytics & admin
│   ├── chat.ts       # RAG assistant
│   ├── claims.ts     # Claim generation
│   ├── denials.ts    # Denial analysis
│   ├── extract.ts    # Document extraction
│   ├── ingest.ts     # Vector ingestion
│   ├── reminders.ts  # Reminder scheduling
│   └── index.ts      # Route aggregator
├── services/         # Business logic
│   ├── analytics.ts  # Metrics & analytics
│   ├── chat.ts       # RAG chat service
│   ├── chunker.ts    # Text chunking
│   ├── claims.ts     # Claim generation
│   ├── denials.ts    # Denial classification
│   ├── embeddings.ts # Vector embeddings
│   ├── extraction.ts # Document parsing
│   ├── graph.ts      # GraphRAG operations
│   ├── parser.ts     # Deterministic parsing
│   └── reminders.ts  # Reminder logic
├── store/            # Data storage
│   └── inMemoryStore.ts
├── types/            # TypeScript types
│   └── models.ts     # Core data models
├── utils/            # Utilities
│   ├── dates.ts      # Date helpers
│   └── logger.ts     # Pino logger
├── index.ts          # Entry point
└── server.ts         # Express app setup
```

### Flutter App Structure
```
safebill_app/lib/
├── app/                    # App configuration
│   ├── router.dart         # GoRouter setup
│   ├── theme.dart          # Theme configuration
│   └── safebill_app.dart   # Root widget
├── core/                   # Core functionality
│   ├── api/
│   │   └── api_client.dart
│   ├── local/
│   │   ├── local_document_store.dart
│   │   └── reminder_scheduler.dart
│   ├── models/
│   │   ├── chat.dart
│   │   ├── document.dart
│   │   └── reminder.dart
│   ├── providers/
│   │   └── theme_provider.dart
│   └── repositories/
│       ├── chat_repository.dart
│       ├── document_repository.dart
│       └── reminder_repository.dart
├── features/               # Feature modules
│   ├── chat/              # AI assistant
│   ├── claims/            # Claim wizard
│   ├── document_detail/   # Document viewer
│   ├── locker/            # Digital locker
│   ├── onboarding/        # First-time user flow
│   ├── reminders/         # Reminder management
│   ├── scan/              # Document scanning
│   └── settings/          # User settings
├── bootstrap.dart         # App initialization
└── main.dart              # App entry point
```

## 🔌 API Endpoints

### Health Check
```
GET /health
```

### Extract Invoice Data
```
POST /api/extract
Content-Type: application/json

{
  "userId": "user_123",
  "docId": "doc_abc",
  "rawText": "<OCR text from invoice>"
}

Response:
{
  "ok": true,
  "parsed": {
    "product_name": "RealPhone X2",
    "model": "X2-256",
    "purchase_date": "2025-11-10",
    "purchase_price": 23999,
    "warranty_months": 12,
    "warranty_start": "2025-11-10",
    "warranty_end": "2026-11-09",
    ...
  }
}
```

### Ingest Document for RAG
```
POST /api/ingest
Content-Type: application/json

{
  "userId": "user_123",
  "docId": "doc_abc",
  "text": "<full document text>"
}
```

### Chat with AI Assistant
```
POST /api/chat
Content-Type: application/json

{
  "userId": "user_123",
  "question": "When does my phone warranty expire?"
}

Response:
{
  "ok": true,
  "answer": "Your RealPhone X2 warranty ends on 2026-11-09...",
  "sources": [
    {
      "docId": "doc_abc",
      "chunk": "doc_abc_chunk_0",
      "score": 0.82,
      "textSnippet": "..."
    }
  ]
}
```

### Schedule Reminders
```
POST /api/reminders/schedule
```

### Generate Claim Documents
```
POST /api/claims/generate
```

### Analyze Denial Letters
```
POST /api/denials/analyze
```

### Admin Analytics
```
GET /api/admin/analytics
```

## 🔐 Security & Privacy

### Encryption
- **At Rest**: AES-256 encryption for all stored documents
- **In Transit**: TLS 1.3 with HSTS enforcement
- **Field-level**: Sensitive Firestore fields encrypted separately

### Privacy Features
- **Local-only Mode**: Complete offline operation with no network transmission
- **PII Redaction**: Automatic masking of phone numbers, GSTIN before embedding
- **Data Locality**: Option to pin data to Indian regions (asia-south1)
- **Data Rights**: Self-service export and delete workflows
- **Consent Management**: Granular consent flags per feature

### Authentication
- Firebase Authentication
- OIDC support for enterprise integration
- Service account-based access for Cloud Functions

## 📊 Data Models

### Document Record
```typescript
interface DocumentRecord {
  docId: string;
  userId: string;
  title?: string;
  rawText: string;
  items: WarrantyItem[];
  ocrConfidence?: number;
  parserVersion?: string;
  status?: 'draft' | 'ready' | 'needs_review';
  encryptedMediaPath?: string;
  createdAt: string;
  updatedAt: string;
}
```

### Warranty Item
```typescript
interface WarrantyItem {
  itemId: string;
  product_name: string | null;
  model: string | null;
  invoice_no: string | null;
  purchase_date: string | null;
  purchase_price: number | null;
  gstin: string | null;
  seller_name: string | null;
  warranty_months: number | null;
  warranty_start: string | null;
  warranty_end: string | null;
  warranty_conditions: WarrantyCondition[] | null;
  extended_warranty_purchased: boolean | null;
  service_centers: string[] | null;
  serial_no: string | null;
  return_window_days: number | null;
  warranty_notes?: string | null;
}
```

### Reminder Config
```typescript
interface ReminderConfig {
  reminderId: string;
  userId: string;
  docId: string;
  itemId?: string;
  triggerType: 'expiry' | 'followup' | 'custom';
  triggerAt: string;
  deliveryChannels: Array<'local' | 'push' | 'email'>;
  status: 'scheduled' | 'sent' | 'snoozed';
  lastAttempt?: string;
  snoozeUntil?: string;
}
```

## 🧪 Testing

### Backend Tests
```bash
# Run unit tests
npm test

# Run with coverage
npm run test:coverage

# Lint code
npm run lint
```

### Flutter Tests
```bash
cd safebill_app

# Run unit tests
flutter test

# Run widget tests
flutter test test/widget_test.dart

# Run integration tests
flutter test integration_test/
```

### Testing Strategy
- **Unit Tests**: Parser suite with 100+ Indian invoice fixtures
- **Integration Tests**: End-to-end flows (scan → extract → store → chat)
- **E2E Tests**: Flutter integration tests with Firebase emulator
- **Model Evaluation**: Labeled test sets for extraction and denial classification accuracy

## 📈 Analytics & Metrics

### Core KPIs
- Extraction accuracy: Target ≥90% for key fields
- Reminder delivery success: Target ≥99%
- DAU/MAU ratio
- 30-day retention rate
- Successful claim recovery percentage

### System Metrics
- Vector DB query latency
- OCR fallback usage rate
- Denial classification accuracy
- Reminder queue backlog

## 🛠️ Development

### Available Scripts (Backend)

- `npm run dev` - Start development server with hot reload
- `npm run build` - Compile TypeScript to JavaScript
- `npm start` - Run production build
- `npm run lint` - Run ESLint
- `npm test` - Run tests

### Available Scripts (Flutter)

- `flutter run` - Run app in debug mode
- `flutter build apk` - Build Android APK
- `flutter build ios` - Build iOS app
- `flutter test` - Run tests
- `flutter analyze` - Static analysis

## 🌍 Deployment

### Backend Deployment Options

1. **Cloud Run** (Recommended)
   - Containerized deployment
   - Auto-scaling
   - Pay-per-use pricing

2. **Firebase Functions**
   - Serverless deployment
   - Integrated with Firebase ecosystem
   - Node.js 20 runtime

3. **Traditional VPS**
   - Self-hosted option
   - Full control
   - Manual scaling

### Mobile App Deployment

1. **Android**: Build APK and upload to Google Play Console
2. **iOS**: Build IPA and upload to App Store Connect
3. **Web**: Deploy to Firebase Hosting or any static host

## 📚 Documentation

Detailed specification available in `docs/safebill_spec.adoc` covering:
- Complete feature list
- System architecture
- Data flow diagrams
- API specifications
- Prompt templates
- GraphRAG strategy
- Privacy & compliance details
- Edge cases & fallbacks
- Testing strategy
- Deployment & operations

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style

- **TypeScript**: Follow project ESLint configuration
- **Dart**: Follow Flutter style guide and use `flutter format`
- **Commits**: Use conventional commits format

## 📝 License

This project is licensed under the MIT License.

## 🐛 Known Issues & Limitations

- Multi-item invoices require manual splitting in some cases
- OCR confidence can be low for thermal receipts or handwritten documents
- Offline RAG has limited context compared to cloud version
- Graph database queries may timeout for large user datasets

## 🗺️ Roadmap

- [ ] Add support for regional Indian languages
- [ ] WhatsApp integration for reminders
- [ ] Service center booking automation
- [ ] Consumer Protection Act 2019 legal citation database
- [ ] Enhanced denial classification with fine-tuned models
- [ ] Multi-tenant support for service centers
- [ ] Advanced analytics dashboard for partners
- [ ] Integration with retailer APIs for automatic warranty registration

## 💡 Support

For issues, questions, or contributions:
- Open an issue on GitHub
- Check existing documentation in `/docs`
- Review the specification document for detailed implementation details

## 🙏 Acknowledgments

- OpenAI for GPT and embedding models
- Firebase for backend infrastructure
- Flutter team for the excellent mobile framework
- Neo4j for graph database capabilities
- Pinecone for vector search

---

**Built with ❤️ for Indian consumers to never lose track of their warranties**

