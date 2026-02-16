'use client';
import { useEffect, useState, Suspense } from 'react';
import { useSearchParams, useRouter } from 'next/navigation';
import api from '@/lib/axios';
import { Card, CardContent, CardFooter, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { useAuth } from '@/components/auth/AuthProvider';
import { toast } from 'sonner';

interface Question {
    id: string;
    question: string;
    optionA: string;
    optionB: string;
    optionC: string;
    optionD: string;
    correctOption: string;
}

function MCQContent() {
    const searchParams = useSearchParams();
    const category = searchParams.get('category');
    const topic = searchParams.get('topic');
    const [questions, setQuestions] = useState<Question[]>([]);
    const [currentIndex, setCurrentIndex] = useState(0);
    const [selectedOption, setSelectedOption] = useState<string | null>(null);
    const [isCorrect, setIsCorrect] = useState<boolean | null>(null); // null, true, false
    const [loading, setLoading] = useState(true);
    const { user } = useAuth();
    const router = useRouter();

    useEffect(() => {
        if (!category) return;
        const fetchQuestions = async () => {
            try {
                const res = await api.get('/questions', { params: { category, topic } });
                setQuestions(res.data);
            } catch (error) {
                console.error(error);
                toast.error('Failed to load questions');
            } finally {
                setLoading(false);
            }
        };
        fetchQuestions();
    }, [category, topic]);

    const handleOptionSelect = async (option: string) => {
        if (selectedOption) return; // Prevent re-selection
        setSelectedOption(option);

        const currentQuestion = questions[currentIndex];
        const correct = currentQuestion.correctOption === option;
        setIsCorrect(correct);

        if (correct) {
            toast.success('Correct Answer!');
        } else {
            toast.error(`Incorrect! Correct answer: ${currentQuestion.correctOption}`);
        }

        try {
            await api.post('/attempts', {
                questionId: currentQuestion.id,
                selectedOption: option,
            });
        } catch (error) {
            console.error('Failed to record attempt', error);
        }
    };

    const handleNext = () => {
        setSelectedOption(null);
        setIsCorrect(null);
        if (currentIndex < questions.length - 1) {
            setCurrentIndex(prev => prev + 1);
        } else {
            toast.success('Quiz Completed!');
            router.push('/dashboard/asi/paper1');
        }
    };

    if (loading) return <div>Loading questions...</div>;
    if (questions.length === 0) return <div>No questions found for this topic.</div>;

    const currentQuestion = questions[currentIndex];
    const options = [
        { key: 'A', text: currentQuestion.optionA },
        { key: 'B', text: currentQuestion.optionB },
        { key: 'C', text: currentQuestion.optionC },
        { key: 'D', text: currentQuestion.optionD },
    ];

    return (
        <div className="container mx-auto p-6 max-w-2xl">
            <div className="mb-4 flex justify-between">
                <span className="text-sm font-medium">Question {currentIndex + 1} of {questions.length}</span>
                <span className="text-sm font-medium">{category} - {topic}</span>
            </div>
            <Card>
                <CardHeader>
                    <CardTitle className="text-lg">{currentQuestion.question}</CardTitle>
                </CardHeader>
                <CardContent className="space-y-3">
                    {options.map((opt) => {
                        let buttonClass = 'w-full justify-start text-left';
                        if (selectedOption) {
                            if (opt.key === currentQuestion.correctOption) {
                                buttonClass += ' bg-green-500 hover:bg-green-600 text-white';
                            } else if (opt.key === selectedOption && !isCorrect) {
                                buttonClass += ' bg-red-500 hover:bg-red-600 text-white';
                            } else {
                                buttonClass += ' opacity-50';
                            }
                        }

                        return (
                            <Button
                                key={opt.key}
                                variant={selectedOption ? 'secondary' : 'outline'}
                                className={buttonClass}
                                onClick={() => handleOptionSelect(opt.key)}
                                disabled={!!selectedOption}
                            >
                                <span className="mr-2 font-bold">{opt.key}.</span> {opt.text}
                            </Button>
                        );
                    })}
                </CardContent>
                <CardFooter className="flex justify-end">
                    {selectedOption && (
                        <Button onClick={handleNext}>
                            {currentIndex < questions.length - 1 ? 'Next Question' : 'Finish'}
                        </Button>
                    )}
                </CardFooter>
            </Card>
        </div>
    );
}

export default function MCQPage() {
    return (
        <Suspense fallback={<div>Loading...</div>}>
            <MCQContent />
        </Suspense>
    );
}
