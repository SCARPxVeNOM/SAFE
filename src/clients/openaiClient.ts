import OpenAI from 'openai';
import { getEnv } from '../config/env';

const env = getEnv();

export const openaiClient = new OpenAI({
  apiKey: env.OPENAI_API_KEY,
});


