import { Router } from 'express';
import { createAttempt, getStats } from '../controllers/attempt.controller';
import { authenticateToken } from '../middleware/auth.middleware';

const router = Router();

router.use(authenticateToken);

router.post('/', createAttempt);
router.get('/stats', getStats);

export default router;
