import { MongoClient, Collection } from 'mongodb';
import { getEnv } from '../config/env';
import { logger } from '../utils/logger';
import {
  ClaimRecord,
  DenialRecord,
  DocumentRecord,
  ReminderConfig,
} from '../types/models';

export class MongoStore {
  private client: MongoClient;
  private documents!: Collection<DocumentRecord>;
  private reminders!: Collection<ReminderConfig>;
  private claims!: Collection<ClaimRecord>;
  private denials!: Collection<DenialRecord>;
  private ready: Promise<void>;

  constructor() {
    const env = getEnv();
    if (!env.MONGODB_URI) {
      throw new Error('MONGODB_URI is required for MongoStore');
    }

    const dbName = env.MONGODB_DB_NAME || 'safebill';
    this.client = new MongoClient(env.MONGODB_URI);
    this.ready = this.init(dbName);
  }

  private async init(dbName: string) {
    await this.client.connect();
    const db = this.client.db(dbName);
    this.documents = db.collection<DocumentRecord>('documents');
    this.reminders = db.collection<ReminderConfig>('reminders');
    this.claims = db.collection<ClaimRecord>('claims');
    this.denials = db.collection<DenialRecord>('denials');

    // helpful indexes
    await Promise.all([
      this.documents.createIndex({ userId: 1, docId: 1 }, { unique: true }),
      this.reminders.createIndex({ userId: 1, reminderId: 1 }, { unique: true }),
      this.claims.createIndex({ claimId: 1 }, { unique: true }),
      this.denials.createIndex({ denialId: 1 }, { unique: true }),
    ]);

    logger.info({ dbName }, 'Connected to MongoDB');
  }

  private async ensureReady() {
    await this.ready;
  }

  async upsertDocument(doc: DocumentRecord) {
    await this.ensureReady();
    const now = new Date().toISOString();
    const existing = await this.documents.findOne({ docId: doc.docId });
    
    const finalDoc = {
      ...doc,
      createdAt: existing?.createdAt ?? doc.createdAt ?? now,
      updatedAt: now,
    };

    await this.documents.updateOne(
      { docId: doc.docId },
      { $set: finalDoc },
      { upsert: true },
    );
    
    return finalDoc;
  }

  async getDocument(docId: string) {
    await this.ensureReady();
    return this.documents.findOne({ docId });
  }

  async listDocuments(userId: string) {
    await this.ensureReady();
    return this.documents.find({ userId }).toArray();
  }

  async upsertReminder(reminder: ReminderConfig) {
    await this.ensureReady();
    await this.reminders.updateOne(
      { reminderId: reminder.reminderId },
      { $set: reminder },
      { upsert: true },
    );
    return reminder;
  }

  async listReminders(userId: string) {
    await this.ensureReady();
    return this.reminders.find({ userId }).toArray();
  }

  async upsertClaim(claim: ClaimRecord) {
    await this.ensureReady();
    await this.claims.updateOne(
      { claimId: claim.claimId },
      { $set: claim },
      { upsert: true },
    );
    return claim;
  }

  async upsertDenial(denial: DenialRecord) {
    await this.ensureReady();
    await this.denials.updateOne(
      { denialId: denial.denialId },
      { $set: denial },
      { upsert: true },
    );
    return denial;
  }

  async getAnalyticsSummary() {
    await this.ensureReady();
    const [documents, reminders, claims, denials] = await Promise.all([
      this.documents.estimatedDocumentCount(),
      this.reminders.estimatedDocumentCount(),
      this.claims.estimatedDocumentCount(),
      this.denials.estimatedDocumentCount(),
    ]);
    return {
      generatedAt: new Date().toISOString(),
      documents,
      reminders,
      claims,
      denials,
    };
  }
}


