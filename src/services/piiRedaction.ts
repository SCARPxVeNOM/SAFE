/**
 * PII Redaction Service
 * Redacts sensitive personal information before embedding
 */

interface RedactionRule {
  pattern: RegExp;
  replacement: string;
}

const REDACTION_RULES: RedactionRule[] = [
  // Email addresses
  {
    pattern: /\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b/g,
    replacement: '[EMAIL_REDACTED]',
  },
  // Phone numbers (Indian format)
  {
    pattern: /(\+91[- ]?)?[6-9]\d{9}/g,
    replacement: '[PHONE_REDACTED]',
  },
  // Aadhaar numbers
  {
    pattern: /\b\d{4}\s?\d{4}\s?\d{4}\b/g,
    replacement: '[AADHAAR_REDACTED]',
  },
  // PAN numbers
  {
    pattern: /\b[A-Z]{5}\d{4}[A-Z]\b/g,
    replacement: '[PAN_REDACTED]',
  },
  // Credit/Debit card numbers
  {
    pattern: /\b\d{4}[\s-]?\d{4}[\s-]?\d{4}[\s-]?\d{4}\b/g,
    replacement: '[CARD_REDACTED]',
  },
  // Bank account numbers (12-18 digits)
  {
    pattern: /\b\d{12,18}\b/g,
    replacement: '[ACCOUNT_REDACTED]',
  },
];

/**
 * Redacts PII from text before embedding
 */
export function redactPII(text: string): string {
  let redacted = text;

  for (const rule of REDACTION_RULES) {
    redacted = redacted.replace(rule.pattern, rule.replacement);
  }

  return redacted;
}

/**
 * Checks if text contains PII
 */
export function containsPII(text: string): boolean {
  for (const rule of REDACTION_RULES) {
    if (rule.pattern.test(text)) {
      return true;
    }
  }
  return false;
}

