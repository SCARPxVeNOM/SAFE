import { Router } from 'express';
import { z } from 'zod';
import { answerQuestion } from '../services/chat';

const schema = z.object({
  userId: z.string().min(1),
  question: z.string().min(5),
});

export const chatRouter = Router();

chatRouter.post('/', async (req, res, next) => {
  try {
    const body = schema.parse(req.body);
    const response = await answerQuestion(body);
    res.json(response);
  } catch (error) {
    next(error);
  }
});


