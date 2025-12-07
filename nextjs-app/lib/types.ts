export interface WarrantyItem {
  itemId: string;
  productName?: string;
  model?: string;
  invoiceNo?: string;
  purchaseDate?: string;
  purchasePrice?: number;
  warrantyMonths?: number;
  warrantyStart?: string;
  warrantyEnd?: string;
  serialNumber?: string;
  serviceCenters: string[];
  extendedWarrantyPurchased?: boolean;
  notes?: string;
}

export interface Document {
  docId: string;
  userId: string;
  title: string;
  items: WarrantyItem[];
  createdAt: string;
  updatedAt: string;
  rawText?: string;
  status?: string;
  sellerName?: string;
  ocrConfidence?: number;
  isVerified: boolean;
}

export interface Reminder {
  reminderId: string;
  docId: string;
  title: string;
  triggerAt: string;
  triggerType: string;
  deliveryChannels: string[];
  status: string;
}

export interface ChatMessage {
  id: string;
  role: 'user' | 'assistant';
  content: string;
  timestamp: string;
  sources?: ChatSource[];
}

export interface ChatSource {
  docId: string;
  chunk: string;
  score: number;
}

export interface User {
  userId: string;
  email: string;
  name?: string;
  picture?: string;
}

export type UserType = 'consumer' | 'merchant';

