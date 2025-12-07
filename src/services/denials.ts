import { generateId, store } from '../store/store';
import { DenialRecord } from '../types/models';

const classifyDenial = (text: string) => {
  if (/physical damage/i.test(text)) return 'physical_damage';
  if (/water/i.test(text)) return 'water_damage';
  if (/late|delay/i.test(text)) return 'late_submission';
  if (/unauthorised|unauthorized/i.test(text)) return 'unauthorized_repair';
  return 'other';
};

const buildNextSteps = (classification: string) => {
  switch (classification) {
    case 'physical_damage':
      return [
        'Request technician inspection report to dispute physical damage claim.',
        'Share purchase proof and photos showing no misuse.',
      ];
    case 'water_damage':
      return [
        'Reference moisture ingress clauses; highlight if water protection promised.',
        'Escalate to manufacturer service head with humidity logs if available.',
      ];
    case 'late_submission':
      return [
        'Explain delay with evidence (service center appointments, hospital records).',
        'Request exception citing Consumer Protection Act Section 17.',
      ];
    case 'unauthorized_repair':
      return [
        'Provide receipts from authorized service centers.',
        'Clarify diagnostics done only; no third-party repair performed.',
      ];
    default:
      return ['Escalate with full chronology and ask for written denial reason.'];
  }
};

export const analyzeDenial = async (params: { claimId: string; rawText: string }) => {
  const classification = classifyDenial(params.rawText);
  const denial: DenialRecord = {
    denialId: generateId('denial'),
    claimId: params.claimId,
    rawText: params.rawText,
    classification,
    suggestedNextSteps: buildNextSteps(classification),
    createdAt: new Date().toISOString(),
  };
  await store.upsertDenial(denial);
  return denial;
};


