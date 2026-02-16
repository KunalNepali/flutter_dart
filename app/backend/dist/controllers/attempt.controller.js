"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.getStats = exports.createAttempt = void 0;
const prisma_1 = __importDefault(require("../utils/prisma"));
const zod_1 = require("zod");
const attemptSchema = zod_1.z.object({
    questionId: zod_1.z.string(),
    selectedOption: zod_1.z.string(),
});
const createAttempt = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const userId = req.user.userId;
        const { questionId, selectedOption } = attemptSchema.parse(req.body);
        const question = yield prisma_1.default.question.findUnique({
            where: { id: questionId },
        });
        if (!question) {
            res.status(404).json({ message: 'Question not found' });
            return;
        }
        const isCorrect = question.correctOption === selectedOption;
        const attempt = yield prisma_1.default.attempt.create({
            data: {
                userId,
                questionId,
                selectedOption,
                isCorrect,
            },
        });
        res.status(201).json({ isCorrect, correctOption: question.correctOption, attemptId: attempt.id });
    }
    catch (error) {
        if (error instanceof zod_1.z.ZodError) {
            res.status(400).json({ errors: error.errors });
        }
        else {
            console.error(error);
            res.status(500).json({ message: 'Internal server error' });
        }
    }
});
exports.createAttempt = createAttempt;
const getStats = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const userId = req.user.userId;
        const totalAttempts = yield prisma_1.default.attempt.count({ where: { userId } });
        const correctAttempts = yield prisma_1.default.attempt.count({ where: { userId, isCorrect: true } });
        const accuracy = totalAttempts > 0 ? (correctAttempts / totalAttempts) * 100 : 0;
        res.json({
            totalAttempts,
            correctAttempts,
            accuracy: accuracy.toFixed(2),
        });
    }
    catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
    }
});
exports.getStats = getStats;
