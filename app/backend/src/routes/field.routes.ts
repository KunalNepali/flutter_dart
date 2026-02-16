import { Router } from 'express';
import { getFields, getRanks } from '../controllers/field.controller';
import { authenticateToken } from '../middleware/auth.middleware';

const router = Router();

router.use(authenticateToken);

router.get('/fields', getFields);
router.get('/ranks/:fieldId', getRanks);

export default router;
