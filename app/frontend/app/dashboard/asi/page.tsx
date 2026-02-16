'use client';
import { Card, CardHeader, CardTitle } from '@/components/ui/card';
import { useRouter } from 'next/navigation';
import { BookOpen, FileText, UserCheck, Scale, Gavel, HelpCircle } from 'lucide-react';

const TOPICS = [
    { id: 'syllabus', title: 'Syllabus', icon: <BookOpen className="h-6 w-6" />, path: '/dashboard/asi/syllabus' },
    { id: 'paper1', title: 'I Paper (GK & Reasoning)', icon: <FileText className="h-6 w-6" />, path: '/dashboard/asi/paper1' },
    { id: 'paper2', title: 'II Paper', icon: <FileText className="h-6 w-6" />, path: '/dashboard/asi/paper2' },
    { id: 'paper3', title: 'III Paper', icon: <FileText className="h-6 w-6" />, path: '/dashboard/asi/paper3' },
    { id: 'interview', title: 'Interview', icon: <UserCheck className="h-6 w-6" />, path: '/dashboard/asi/interview' },
    { id: 'act', title: 'Police Act', icon: <Scale className="h-6 w-6" />, path: '/dashboard/asi/act' },
    { id: 'regulations', title: 'Police Regulations', icon: <Gavel className="h-6 w-6" />, path: '/dashboard/asi/regulations' },
    { id: 'past', title: 'Past Questions', icon: <HelpCircle className="h-6 w-6" />, path: '/dashboard/asi/past' },
];

export default function ASIOverview() {
    const router = useRouter();

    return (
        <div className="container mx-auto p-6">
            <h1 className="text-2xl font-bold mb-6">ASI Preparation Materials</h1>
            <div className="grid gap-4 md:grid-cols-4">
                {TOPICS.map((topic) => (
                    <Card key={topic.id} className="cursor-pointer hover:border-primary transition-colors flex items-center" onClick={() => router.push(topic.path)}>
                        <CardHeader className="flex flex-row items-center space-y-0 space-x-4 w-full">
                            <div className="p-2 bg-primary/10 rounded-full text-primary">
                                {topic.icon}
                            </div>
                            <CardTitle className="text-base">{topic.title}</CardTitle>
                        </CardHeader>
                    </Card>
                ))}
            </div>
        </div>
    );
}
