import { generateId, store } from '../store/inMemoryStore';
import { ClaimRecord, DocumentRecord, WarrantyItem } from '../types/models';

const buildClaimLetter = (params: {
  userId: string;
  document: DocumentRecord;
  item: WarrantyItem;
  issue: string;
}) => {
  const warrantyEnd = params.item.warranty_end ?? 'unknown date';
  return [
    `Subject: Warranty claim for ${params.item.product_name ?? 'product'}`,
    '',
    `Dear ${params.item.seller_name ?? 'Seller'},`,
    '',
    `I purchased ${params.item.product_name ?? 'the item'} (Model ${
      params.item.model ?? 'N/A'
    }) on ${params.item.purchase_date ?? 'unknown date'} with invoice ${
      params.item.invoice_no ?? params.document.docId
    }. The warranty is valid through ${warrantyEnd}.`,
    '',
    `Issue reported: ${params.issue}.`,
    '',
    'Please process this warranty claim within the timelines stipulated under the Consumer Protection Act 2019.',
    '',
    'Regards,',
    `User ${params.userId}`,
  ].join('\n');
};

export const createClaim = (params: {
  userId: string;
  document: DocumentRecord;
  item: WarrantyItem;
  issueDescription: string;
}) => {
  const claim: ClaimRecord = {
    claimId: generateId('claim'),
    userId: params.userId,
    docId: params.document.docId,
    itemId: params.item.itemId,
    stage: 'draft',
    generatedArtifacts: [
      {
        type: 'email',
        body: buildClaimLetter({
          userId: params.userId,
          document: params.document,
          item: params.item,
          issue: params.issueDescription,
        }),
      },
    ],
    history: [
      {
        status: 'draft_created',
        at: new Date().toISOString(),
        note: params.issueDescription,
      },
    ],
  };
  store.upsertClaim(claim);
  return claim;
};


