import crypto from 'crypto-js';
import { getEnv } from '../config/env';

const env = getEnv();
const ENCRYPTION_KEY = env.NEXTAUTH_SECRET || 'default-encryption-key-change-in-production';

/**
 * Encrypts data using AES-256
 */
export function encryptData(data: string | Buffer): string {
  if (Buffer.isBuffer(data)) {
    const base64 = data.toString('base64');
    return crypto.AES.encrypt(base64, ENCRYPTION_KEY).toString();
  }
  return crypto.AES.encrypt(data, ENCRYPTION_KEY).toString();
}

/**
 * Decrypts AES-256 encrypted data
 */
export function decryptData(encryptedData: string): string {
  const bytes = crypto.AES.decrypt(encryptedData, ENCRYPTION_KEY);
  return bytes.toString(crypto.enc.Utf8);
}

/**
 * Encrypts image buffer for storage
 */
export function encryptImage(imageBuffer: Buffer): string {
  return encryptData(imageBuffer);
}

/**
 * Decrypts image for retrieval
 */
export function decryptImage(encryptedData: string): Buffer {
  const decrypted = decryptData(encryptedData);
  return Buffer.from(decrypted, 'base64');
}

