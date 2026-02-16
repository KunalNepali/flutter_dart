import express, { Request, Response } from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import authRoutes from './routes/auth.routes';
import fieldRoutes from './routes/field.routes';
import questionRoutes from './routes/question.routes';
import attemptRoutes from './routes/attempt.routes';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());

app.get('/', (req: Request, res: Response) => {
    res.send('Nepal Police ASI Exam Prep API is running');
});

app.use('/api/auth', authRoutes);
app.use('/api', fieldRoutes); // /api/fields, /api/ranks
app.use('/api/questions', questionRoutes);
app.use('/api/attempts', attemptRoutes);

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
