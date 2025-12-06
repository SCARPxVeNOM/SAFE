import { openaiClient } from '../clients/openaiClient';
import { store } from '../store/inMemoryStore';
import type { DocumentRecord, WarrantyItem } from '../types/models';
import { parseInvoiceText } from './parser';

const extractionSystemPrompt = `
You are a structured-data extraction assistant. Input is raw OCR text from an Indian invoice or warranty document.

Return ONLY a single JSON object with fields:
product_name, model, invoice_no, purchase_date (YYYY-MM-DD), purchase_price (number), seller_name,
gstin (or null), warranty_months (integer or null), warranty_notes (string or null),
extended_warranty (true/false/null), service_centers (array or null).

If a field is not present, set it to null. Do not add extra commentary.
`;

const callLLMExtraction = async (text: string) => {
  const completion = await openaiClient.responses.create({
    model: 'gpt-4.1-mini',
    input: `${extractionSystemPrompt}\nOCR_TEXT: """${text}"""`,
  });
  const responseText = completion.output_text?.[0];
  if (!responseText) return null;
  try {
    const jsonStart = responseText.indexOf('{');
    const jsonEnd = responseText.lastIndexOf('}');
    const jsonString =
      jsonStart >= 0 && jsonEnd >= 0
        ? responseText.slice(jsonStart, jsonEnd + 1)
        : responseText;
    return JSON.parse(jsonString);
  } catch {
    return null;
  }
};

export const extractDocument = async (params: {
  userId: string;
  docId: string;
  rawText: string;
}) => {
  const deterministicItems = parseInvoiceText({
    text: params.rawText,
    userId: params.userId,
  });

  if (deterministicItems.length === 0) {
    throw new Error('Parser failed to extract any warranty items');
  }

  const baseItem = deterministicItems[0];
  if (!baseItem) {
    throw new Error('Parser did not yield any items');
  }
  let enrichedItem: WarrantyItem = { ...baseItem };
  const llmResult = await callLLMExtraction(params.rawText);
  if (llmResult) {
    enrichedItem = {
      ...enrichedItem,
      product_name: llmResult.product_name ?? enrichedItem.product_name,
      model: llmResult.model ?? enrichedItem.model,
      invoice_no: llmResult.invoice_no ?? enrichedItem.invoice_no,
      purchase_date: llmResult.purchase_date ?? enrichedItem.purchase_date,
      purchase_price:
        llmResult.purchase_price ?? enrichedItem.purchase_price ?? null,
      seller_name: llmResult.seller_name ?? enrichedItem.seller_name,
      gstin: llmResult.gstin ?? enrichedItem.gstin,
      warranty_months:
        llmResult.warranty_months ?? enrichedItem.warranty_months,
      warranty_notes:
        llmResult.warranty_notes ?? enrichedItem.warranty_notes,
      extended_warranty_purchased:
        llmResult.extended_warranty ?? enrichedItem.extended_warranty_purchased,
      service_centers:
        llmResult.service_centers ?? enrichedItem.service_centers,
    };
  }

  const document: DocumentRecord = {
    docId: params.docId,
    userId: params.userId,
    rawText: params.rawText,
    items: [enrichedItem],
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
    status: 'ready',
  };

  store.upsertDocument(document);

  return document;
};

