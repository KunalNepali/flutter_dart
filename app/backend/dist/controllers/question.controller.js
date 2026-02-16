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
exports.getQuestions = void 0;
const prisma_1 = __importDefault(require("../utils/prisma"));
const zod_1 = require("zod");
const getQuestionsSchema = zod_1.z.object({
    category: zod_1.z.enum(['GK', 'RT']),
    topic: zod_1.z.string().optional(),
});
const getQuestions = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { category, topic } = getQuestionsSchema.parse(req.query);
        const where = { category };
        if (topic) {
            where.topic = topic;
        }
        const questions = yield prisma_1.default.question.findMany({
            where,
        });
        res.json(questions);
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
exports.getQuestions = getQuestions;
