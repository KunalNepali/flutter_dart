import { Router } from 'express';
import { getQuestions } from '../controllers/question.controller';
import { authenticateToken } from '../middleware/auth.middleware';

const router = Router();

router.use(authenticateToken);

router.get('/', getQuestions);

export default router;
