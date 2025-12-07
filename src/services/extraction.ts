import { openaiClient } from '../clients/openaiClient';
import { store } from '../store/store';
import type { DocumentRecord, WarrantyItem } from '../types/models';
import { parseInvoiceText } from './parser';

const extractionSystemPrompt = `
You are a structured-data extraction assistant. Extract warranty and invoice information from Indian invoices.

Return a JSON object with these exact fields:
{
  "product_name": "string or null",
  "model": "string or null", 
  "invoice_no": "string or null",
  "purchase_date": "YYYY-MM-DD or null",
  "purchase_price": "number or null",
  "seller_name": "string or null",
  "gstin": "string or null",
  "warranty_months": "integer or null",
  "warranty_notes": "string or null",
  "extended_warranty": "boolean or null",
  "service_centers": "array of strings or null"
}

If a field is not present in the text, set it to null.
`;

const callLLMExtraction = async (text: string) => {
  const completion = await openaiClient.chat.completions.create({
    model: 'gpt-4o-mini',
    messages: [
      {
        role: 'system',
        content: extractionSystemPrompt,
      },
      {
        role: 'user',
        content: `OCR_TEXT: """${text}"""`,
      },
    ],
    temperature: 0.1,
    response_format: { type: 'json_object' },
  });
  const responseText = completion.choices[0]?.message?.content;
  if (!responseText) return null;
  try {
    return JSON.parse(responseText);
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
  
  // Try LLM enrichment, but don't fail if it doesn't work
  try {
    const llmResult = await Promise.race([
      callLLMExtraction(params.rawText),
      new Promise<null>((resolve) => setTimeout(() => resolve(null), 10000)), // 10s timeout
    ]);
    
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
  } catch (error) {
    // Continue with baseItem if LLM enrichment fails
    console.warn('LLM enrichment failed, using parser results:', error);
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

  await store.upsertDocument(document);

  return document;
};

