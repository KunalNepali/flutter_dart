'use client';
import { Card, CardHeader, CardTitle } from '@/components/ui/card';
import { useRouter } from 'next/navigation';

const TOPICS = [
    { id: 'verbal', title: 'Verbal Reasoning' },
    { id: 'non-verbal', title: 'Non-Verbal Reasoning' },
    { id: 'numerical', title: 'Numerical Reasoning' },
    { id: 'coding', title: 'Coding & Decoding' },
    { id: 'series', title: 'Series Completion' },
    { id: 'direction', title: 'Direction Sense' },
];

export default function RTTopics() {
    const router = useRouter();

    return (
        <div className="container mx-auto p-6">
            <h1 className="text-2xl font-bold mb-6">Reasoning Test Topics</h1>
            <div className="grid gap-4 md:grid-cols-3">
                {TOPICS.map((topic) => (
                    <Card key={topic.id} className="cursor-pointer hover:border-primary transition-colors" onClick={() => router.push(`/dashboard/asi/mcq?category=RT&topic=${topic.id}`)}>
                        <CardHeader>
                            <CardTitle>{topic.title}</CardTitle>
                        </CardHeader>
                    </Card>
                ))}
            </div>
        </div>
    );
}
