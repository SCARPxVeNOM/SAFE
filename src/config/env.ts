import dotenv from 'dotenv';
import { z } from 'zod';

dotenv.config();

const envSchema = z.object({
  NODE_ENV: z.enum(['development', 'test', 'production']).default('development'),
  PORT: z.coerce.number().default(8080),
  OPENAI_API_KEY: z.string().min(1, 'OPENAI_API_KEY is required'),
  PINECONE_API_KEY: z.string().optional(),
  PINECONE_INDEX: z.string().optional(),
  GRAPH_DB_URI: z.string().optional(),
  GRAPH_DB_USER: z.string().optional(),
  GRAPH_DB_PASSWORD: z.string().optional(),
  FIREBASE_PROJECT_ID: z.string().optional(),
  FIREBASE_CLIENT_EMAIL: z.string().optional(),
  FIREBASE_PRIVATE_KEY: z.string().optional(),
  DEFAULT_REMINDER_OFFSETS: z
    .string()
    .default('30,7,3,1')
    .transform((value) =>
      value
        .split(',')
        .map((v) => Number.parseInt(v.trim(), 10))
        .filter((v) => Number.isFinite(v)),
    ),
  LOCAL_ONLY_MODE: z
    .string()
    .optional()
    .transform((value) => value === 'true'),
});

export type Env = z.infer<typeof envSchema>;

let cachedEnv: Env | null = null;

export const getEnv = (): Env => {
  if (!cachedEnv) {
    const parsed = envSchema.safeParse(process.env);
    if (!parsed.success) {
      throw new Error(
        `Invalid environment variables: ${parsed.error.message}`,
      );
    }
    cachedEnv = parsed.data;
  }
  return cachedEnv;
};


