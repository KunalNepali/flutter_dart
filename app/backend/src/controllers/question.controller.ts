import { Request, Response } from 'express';
import prisma from '../utils/prisma';
import { z } from 'zod';

const getQuestionsSchema = z.object({
    category: z.enum(['GK', 'RT']),
    topic: z.string().optional(),
});

export const getQuestions = async (req: Request, res: Response): Promise<void> => {
    try {
        const { category, topic } = getQuestionsSchema.parse(req.query);

        const where: any = { category };
        if (topic) {
            where.topic = topic;
        }

        const questions = await prisma.question.findMany({
            where,
        });

        res.json(questions);
    } catch (error) {
        if (error instanceof z.ZodError) {
            res.status(400).json({ errors: (error as any).errors });
        } else {
            console.error(error);
            res.status(500).json({ message: 'Internal server error' });
        }
    }
};
