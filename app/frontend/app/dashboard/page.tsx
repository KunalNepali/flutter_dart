'use client';
import { useEffect, useState } from 'react';
import api from '@/lib/axios';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { useAuth } from '@/components/auth/AuthProvider';
import { useRouter } from 'next/navigation';

interface Item {
    id: string;
    name: string;
    enabled: boolean;
}

export default function Dashboard() {
    const [fields, setFields] = useState<Item[]>([]);
    const [ranks, setRanks] = useState<Item[]>([]);
    const [selectedField, setSelectedField] = useState<string | null>(null);
    const { user, loading } = useAuth();
    const router = useRouter();

    useEffect(() => {
        if (!loading && !user) {
            router.push('/login');
            return;
        }
        const fetchFields = async () => {
            try {
                const res = await api.get('/fields');
                setFields(res.data);
            } catch (error) {
                console.error(error);
            }
        };
        if (user) fetchFields();
    }, [user, loading, router]);

    const handleFieldSelect = async (fieldId: string) => {
        setSelectedField(fieldId);
        try {
            const res = await api.get(`/ranks/${fieldId}`);
            setRanks(res.data);
        } catch (error) {
            console.error(error);
        }
    };

    const handleRankSelect = (rankId: string) => {
        if (rankId === 'asi') {
            router.push('/dashboard/asi');
        }
    };

    if (loading) return <div>Loading...</div>;

    return (
        <div className="container mx-auto p-6">
            <header className="mb-8 flex justify-between items-center">
                <h1 className="text-2xl font-bold">Welcome, {user?.name}</h1>
                <Button variant="outline" onClick={() => {
                    localStorage.removeItem('token');
                    localStorage.removeItem('user');
                    window.location.href = '/login';
                }}>Logout</Button>
            </header>

            {!selectedField ? (
                <div>
                    <h2 className="text-xl font-semibold mb-4">Choose your Field</h2>
                    <div className="grid gap-4 md:grid-cols-3">
                        {fields.map((field) => (
                            <Card
                                key={field.id}
                                className={`cursor-pointer transition-colors hover:border-primary ${!field.enabled ? 'opacity-50 cursor-not-allowed' : ''}`}
                                onClick={() => field.enabled && handleFieldSelect(field.id)}
                            >
                                <CardHeader>
                                    <CardTitle>{field.name}</CardTitle>
                                    <CardDescription>{field.enabled ? 'Available' : 'Coming Soon'}</CardDescription>
                                </CardHeader>
                            </Card>
                        ))}
                    </div>
                </div>
            ) : (
                <div>
                    <Button variant="ghost" onClick={() => { setSelectedField(null); setRanks([]); }} className="mb-4">
                        &larr; Back to Fields
                    </Button>
                    <h2 className="text-xl font-semibold mb-4">Choose your Rank</h2>
                    <div className="grid gap-4 md:grid-cols-3">
                        {ranks.map((rank) => (
                            <Card
                                key={rank.id}
                                className={`cursor-pointer transition-colors hover:border-primary ${!rank.enabled ? 'opacity-50 cursor-not-allowed' : ''}`}
                                onClick={() => rank.enabled && handleRankSelect(rank.id)}
                            >
                                <CardHeader>
                                    <CardTitle>{rank.name}</CardTitle>
                                    <CardDescription>{rank.enabled ? 'Available' : 'Coming Soon'}</CardDescription>
                                </CardHeader>
                            </Card>
                        ))}
                    </div>
                </div>
            )}
        </div>
    );
}
