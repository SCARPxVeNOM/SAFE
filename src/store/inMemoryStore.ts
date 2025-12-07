import { randomUUID } from 'crypto';
import {
  ClaimRecord,
  DenialRecord,
  DocumentRecord,
  ReminderConfig,
} from '../types/models';

export class InMemoryStore {
  private documents = new Map<string, DocumentRecord>();
  private reminders = new Map<string, ReminderConfig>();
  private claims = new Map<string, ClaimRecord>();
  private denials = new Map<string, DenialRecord>();

  async upsertDocument(doc: DocumentRecord) {
    const now = new Date().toISOString();
    const existing = this.documents.get(doc.docId);
    const next: DocumentRecord = {
      ...doc,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
    };
    this.documents.set(doc.docId, next);
    return next;
  }

  async getDocument(docId: string) {
    return this.documents.get(docId);
  }

  async listDocuments(userId: string) {
    return Array.from(this.documents.values()).filter(
      (doc) => doc.userId === userId,
    );
  }

  async upsertReminder(reminder: ReminderConfig) {
    this.reminders.set(reminder.reminderId, reminder);
    return reminder;
  }

  async listReminders(userId: string) {
    return Array.from(this.reminders.values()).filter(
      (reminder) => reminder.userId === userId,
    );
  }

  async upsertClaim(claim: ClaimRecord) {
    this.claims.set(claim.claimId, claim);
    return claim;
  }

  async upsertDenial(denial: DenialRecord) {
    this.denials.set(denial.denialId, denial);
    return denial;
  }

  async getAnalyticsSummary() {
    const now = new Date().toISOString();
    return {
      generatedAt: now,
      documents: this.documents.size,
      reminders: this.reminders.size,
      claims: this.claims.size,
      denials: this.denials.size,
    };
  }
}

export const store = new InMemoryStore();

export const generateId = (prefix: string) => `${prefix}_${randomUUID()}`;


