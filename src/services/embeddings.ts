import OpenAI from 'openai';
import { Pinecone } from '@pinecone-database/pinecone';
import { getEnv } from '../config/env';
import { logger } from '../utils/logger';

const env = getEnv();

const openai = new OpenAI({
  apiKey: env.OPENAI_API_KEY,
});

const pinecone =
  env.PINECONE_API_KEY && env.PINECONE_INDEX
    ? new Pinecone({ apiKey: env.PINECONE_API_KEY })
    : null;

export const embedText = async (text: string) => {
  const response = await openai.embeddings.create({
    model: 'text-embedding-3-small',
    input: text,
  });
  return response.data[0]?.embedding ?? [];
};

export const upsertEmbeddings = async (params: {
  docId: string;
  userId: string;
  chunks: Array<{ id: string; text: string; index: number }>;
}) => {
  if (!pinecone || !env.PINECONE_INDEX) {
    logger.warn('Pinecone not configured; skipping upsert');
    return [];
  }

  const index = pinecone.Index(env.PINECONE_INDEX);
  const vectors = [];

  for (const chunk of params.chunks) {
    const embedding = await embedText(chunk.text);
    vectors.push({
      id: chunk.id,
      values: embedding,
      metadata: {
        userId: params.userId,
        docId: params.docId,
        chunkIndex: chunk.index,
        snippet: chunk.text.slice(0, 400),
        createdAt: new Date().toISOString(),
      },
    });
  }

  await index.upsert(vectors);
  return vectors;
};

export const similaritySearch = async (params: {
  userId: string;
  query: string;
  topK?: number;
}) => {
  if (!pinecone || !env.PINECONE_INDEX) {
    logger.warn('Pinecone not configured; returning empty search results');
    return [];
  }
  const index = pinecone.Index(env.PINECONE_INDEX);
  const embedding = await embedText(params.query);
  const result = await index.query({
    vector: embedding,
    topK: params.topK ?? 3,
    includeMetadata: true,
  });
  return result.matches?.map((match) => ({
    docId: match.metadata?.docId as string,
    chunk: match.id,
    score: match.score ?? 0,
    textSnippet: (match.metadata?.snippet as string) ?? '',
  }));
};


