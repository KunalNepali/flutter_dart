'use client';
import { Card, CardHeader, CardTitle } from '@/components/ui/card';
import { useRouter } from 'next/navigation';

const TOPICS = [
    { id: 'geography', title: 'Geography of Nepal' },
    { id: 'history', title: 'History of Nepal' },
    { id: 'polity', title: 'Political System' },
    { id: 'economy', title: 'Economy' },
    { id: 'science', title: 'Science & Technology' },
    { id: 'current', title: 'Current Affairs' },
];

export default function GKTopics() {
    const router = useRouter();

    return (
        <div className="container mx-auto p-6">
            <h1 className="text-2xl font-bold mb-6">General Knowledge Topics</h1>
            <div className="grid gap-4 md:grid-cols-3">
                {TOPICS.map((topic) => (
                    <Card key={topic.id} className="cursor-pointer hover:border-primary transition-colors" onClick={() => router.push(`/dashboard/asi/mcq?category=GK&topic=${topic.id}`)}>
                        <CardHeader>
                            <CardTitle>{topic.title}</CardTitle>
                        </CardHeader>
                    </Card>
                ))}
            </div>
        </div>
    );
}
