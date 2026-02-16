'use client';
import { Card, CardHeader, CardTitle } from '@/components/ui/card';
import { useRouter } from 'next/navigation';
import { Brain, Globe } from 'lucide-react';

export default function Paper1() {
    const router = useRouter();

    const handleSelect = (path: string) => {
        router.push(path);
    };

    return (
        <div className="container mx-auto p-6">
            <h1 className="text-2xl font-bold mb-6">Paper I: General Knowledge & Reasoning</h1>
            <div className="grid gap-4 md:grid-cols-2">
                <Card className="cursor-pointer hover:border-primary transition-colors" onClick={() => handleSelect('/dashboard/asi/paper1/gk')}>
                    <CardHeader className="flex flex-row items-center space-y-0 space-x-4">
                        <div className="p-3 bg-blue-100 dark:bg-blue-900 rounded-full text-blue-600 dark:text-blue-300">
                            <Globe className="h-8 w-8" />
                        </div>
                        <div>
                            <CardTitle className="text-xl">General Knowledge (GK)</CardTitle>
                        </div>
                    </CardHeader>
                </Card>
                <Card className="cursor-pointer hover:border-primary transition-colors" onClick={() => handleSelect('/dashboard/asi/paper1/rt')}>
                    <CardHeader className="flex flex-row items-center space-y-0 space-x-4">
                        <div className="p-3 bg-green-100 dark:bg-green-900 rounded-full text-green-600 dark:text-green-300">
                            <Brain className="h-8 w-8" />
                        </div>
                        <div>
                            <CardTitle className="text-xl">Reasoning Test (RT)</CardTitle>
                        </div>
                    </CardHeader>
                </Card>
            </div>
        </div>
    );
}
