import { openaiClient } from '../clients/openaiClient';
import { similaritySearch } from './embeddings';
import { fetchRelatedGraphNodes } from './graph';
import type { ChatResponsePayload } from '../types/models';

const buildPrompt = (params: {
  question: string;
  contexts: string[];
  graphContext: string[];
}) => {
  return [
    'You are SafeBill Assistant. Use ONLY the provided context.',
    'If you cannot answer, say "I don\'t know" and request more info.',
    'Provide short actionable steps and cite docId + chunk IDs.',
    '',
    'Context:',
    ...params.contexts,
    '',
    'Graph context:',
    ...params.graphContext,
    '',
    `User question: ${params.question}`,
  ].join('\n');
};

export const answerQuestion = async (params: {
  userId: string;
  question: string;
}): Promise<ChatResponsePayload> => {
  const matches = await similaritySearch({
    userId: params.userId,
    query: params.question,
    topK: 5,
  });

  const entities = params.question
    .match(/[A-Za-z0-9]+/g)
    ?.filter((token) => token.length > 3)
    .slice(0, 5);

  const graphRelations = entities
    ? await fetchRelatedGraphNodes({ entities })
    : [];

  const prompt = buildPrompt({
    question: params.question,
    contexts: matches.map(
      (match) =>
        `docId=${match.docId} chunk=${match.chunk} score=${match.score}\n${match.textSnippet}`,
    ),
    graphContext: graphRelations.map(
      (relation) =>
        `${relation.from.name ?? relation.from.id} -[${relation.relation}]-> ${
          relation.to.name ?? relation.to.id
        }`,
    ),
  });

  const completion = await openaiClient.responses.create({
    model: 'gpt-4.1-mini',
    input: prompt,
  });

  const answer = completion.output_text?.[0] ?? 'I could not generate an answer.';

  return {
    ok: true,
    answer,
    sources: matches,
  };
};

