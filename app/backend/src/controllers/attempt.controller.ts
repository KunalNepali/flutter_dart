import { Request, Response } from 'express';
import prisma from '../utils/prisma';
import { z } from 'zod';

const attemptSchema = z.object({
    questionId: z.string(),
    selectedOption: z.string(),
});

interface AuthRequest extends Request {
    user?: any;
}

export const createAttempt = async (req: AuthRequest, res: Response): Promise<void> => {
    try {
        const userId = req.user.userId;
        const { questionId, selectedOption } = attemptSchema.parse(req.body);

        const question = await prisma.question.findUnique({
            where: { id: questionId },
        });

        if (!question) {
            res.status(404).json({ message: 'Question not found' });
            return;
        }

        const isCorrect = question.correctOption === selectedOption;

        const attempt = await prisma.attempt.create({
            data: {
                userId,
                questionId,
                selectedOption,
                isCorrect,
            },
        });

        res.status(201).json({ isCorrect, correctOption: question.correctOption, attemptId: attempt.id });
    } catch (error) {
        if (error instanceof z.ZodError) {
            res.status(400).json({ errors: (error as any).errors });
        } else {
            console.error(error);
            res.status(500).json({ message: 'Internal server error' });
        }
    }
};

export const getStats = async (req: AuthRequest, res: Response): Promise<void> => {
    try {
        const userId = req.user.userId;

        const totalAttempts = await prisma.attempt.count({ where: { userId } });
        const correctAttempts = await prisma.attempt.count({ where: { userId, isCorrect: true } });

        const accuracy = totalAttempts > 0 ? (correctAttempts / totalAttempts) * 100 : 0;

        res.json({
            totalAttempts,
            correctAttempts,
            accuracy: accuracy.toFixed(2),
        });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
    }
};
