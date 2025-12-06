import { createHash } from 'crypto';
import { WarrantyItem } from '../types/models';
import { addMonthsSafe, formatDate } from '../utils/dates';

const invoiceNoRegex = /(inv(?:oice)?[\s#:]*)([A-Z0-9\-\/]+)/i;
const gstRegex = /(gstin?)[\s#:]*([0-9A-Z]{15})/i;
const dateRegex =
  /(\d{1,2}[\/\-\.]\d{1,2}[\/\-\.]\d{2,4}|\d{4}[\/\-\.]\d{1,2}[\/\-\.]\d{1,2})/g;
const currencyRegex = /(?:₹|rs\.?|inr)\s?([\d,]+(?:\.\d{1,2})?)/i;
const modelRegex = /(model|variant)[\s#:]*([A-Z0-9\-\s]+)/i;

const parseNumber = (value?: string | null) => {
  if (!value) return null;
  const sanitized = value.replace(/,/g, '');
  const parsed = Number.parseFloat(sanitized);
  return Number.isFinite(parsed) ? parsed : null;
};

const normalizeDate = (value?: string | null): string | null => {
  if (!value) return null;
  const parts = value.replace(/\./g, '-').replace(/\//g, '-').split('-');
  if (parts.length === 3) {
    const [partA, partB, partC] = parts;
    if (!partA || !partB || !partC) return null;
    if (partA.length === 4) {
      return formatDate(new Date(`${partA}-${partB}-${partC}`));
    }
    return formatDate(new Date(`${partC}-${partB}-${partA}`));
  }
  const timestamp = Date.parse(value);
  if (Number.isNaN(timestamp)) return null;
  return formatDate(new Date(timestamp));
};

const detectWarrantyMonths = (text: string) => {
  const match = text.match(/(\d+)\s*(?:months?|mos?)/i);
  if (match?.[1]) return Number.parseInt(match[1], 10);
  if (/1\s*(?:year|yr)/i.test(text)) return 12;
  if (/2\s*(?:years|yrs)/i.test(text)) return 24;
  return null;
};

const detectSeller = (text: string) => {
  const lines = text.split('\n').map((line) => line.trim());
  const sellerCandidates = lines.filter((line) =>
    /(electronics|store|retail|india|shop)/i.test(line),
  );
  return sellerCandidates[0] ?? lines[0] ?? null;
};

const detectProduct = (text: string) => {
  const lines = text.split('\n').map((line) => line.trim());
  const productLine = lines.find((line) =>
    /(tv|laptop|phone|fridge|ac|camera|watch|device)/i.test(line),
  );
  return productLine ?? null;
};

const computeWarrantyWindow = (
  purchaseDate: string | null,
  warrantyMonths: number | null,
): { start: string | null; end: string | null } => {
  if (!purchaseDate || !warrantyMonths) return { start: purchaseDate, end: null };
  const start = new Date(purchaseDate);
  const end = addMonthsSafe(start, warrantyMonths);
  return {
    start: formatDate(start),
    end: formatDate(end),
  };
};

export const parseInvoiceText = (params: {
  text: string;
  userId: string;
}): WarrantyItem[] => {
  const { text, userId } = params;
  const invoiceMatch = text.match(invoiceNoRegex);
  const gstMatch = text.match(gstRegex);
  const priceMatch = text.match(currencyRegex);
  const modelMatch = text.match(modelRegex);
  const dateMatches = text.match(dateRegex);
  const purchaseDate: string | null = dateMatches
    ? normalizeDate(dateMatches[0])
    : null;
  const warrantyMonths: number | null = detectWarrantyMonths(text);
  const { start, end } = computeWarrantyWindow(purchaseDate, warrantyMonths);
  const seller = detectSeller(text);
  const product = detectProduct(text);

  const item: WarrantyItem = {
    itemId: createHash('sha1').update(text + userId).digest('hex'),
    product_name: product,
    model: modelMatch?.[2]?.trim() ?? null,
    invoice_no: invoiceMatch?.[2]?.trim() ?? null,
    purchase_date: purchaseDate,
    purchase_price: parseNumber(priceMatch?.[1] ?? null),
    gstin: gstMatch?.[2]?.trim() ?? null,
    seller_name: seller,
    warranty_months: warrantyMonths,
    warranty_start: start ?? purchaseDate,
    warranty_end: end ?? null,
    warranty_conditions: null,
    extended_warranty_purchased: null,
    service_centers: null,
    serial_no: null,
    return_window_days: null,
    warranty_notes: null,
  };

  return [item];
};

