export type WarrantyCondition = {
  text: string;
  critical?: boolean;
};

export interface WarrantyItem {
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
  expiryBadgeColor?: string;
}

export interface DocumentRecord {
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

export interface ReminderConfig {
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

export interface ClaimRecord {
  claimId: string;
  userId: string;
  docId: string;
  itemId: string;
  stage: 'draft' | 'submitted' | 'appeal';
  denialReason?: string;
  generatedArtifacts?: {
    type: 'email' | 'pdf' | 'whatsapp';
    path?: string;
    body: string;
  }[];
  history: Array<{
    status: string;
    note?: string;
    at: string;
  }>;
}

export interface DenialRecord {
  denialId: string;
  claimId: string;
  rawText: string;
  classification: string;
  suggestedNextSteps: string[];
  appealLetter?: string;
  createdAt: string;
}

export interface ChatSource {
  docId: string;
  chunk: string;
  score: number;
  textSnippet?: string;
}

export interface ChatResponsePayload {
  ok: true;
  answer: string;
  sources: ChatSource[];
}


