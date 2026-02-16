'use client';
import { useEffect, useState } from 'react';
import api from '@/lib/axios';
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card';
import { useAuth } from '@/components/auth/AuthProvider';
import { Button } from '@/components/ui/button';

export default function Profile() {
    const { user, logout } = useAuth();
    const [stats, setStats] = useState({ totalAttempts: 0, correctAttempts: 0, accuracy: 0 });

    useEffect(() => {
        if (user) {
            api.get('/attempts/stats').then(res => setStats(res.data)).catch(console.error);
        }
    }, [user]);

    if (!user) return null;

    return (
        <div className="container mx-auto p-6">
            <div className="flex justify-between items-center mb-6">
                <h1 className="text-2xl font-bold">User Profile</h1>
                <Button variant="destructive" onClick={logout}>Logout</Button>
            </div>

            <Card className="mb-6">
                <CardHeader>
                    <CardTitle>{user.name}</CardTitle>
                </CardHeader>
                <CardContent>
                    <p className="text-gray-600">Email: {user.email}</p>
                    <p className="text-gray-600">Role: {user.role}</p>
                </CardContent>
            </Card>

            <h2 className="text-xl font-semibold mb-4">Performance Statistics</h2>
            <div className="grid gap-4 md:grid-cols-3">
                <Card>
                    <CardHeader><CardTitle className="text-lg">Total Attempts</CardTitle></CardHeader>
                    <CardContent className="text-4xl font-bold">{stats.totalAttempts}</CardContent>
                </Card>
                <Card>
                    <CardHeader><CardTitle className="text-lg">Correct Answers</CardTitle></CardHeader>
                    <CardContent className="text-4xl font-bold text-green-600">{stats.correctAttempts}</CardContent>
                </Card>
                <Card>
                    <CardHeader><CardTitle className="text-lg">Accuracy</CardTitle></CardHeader>
                    <CardContent className="text-4xl font-bold text-blue-600">{stats.accuracy}%</CardContent>
                </Card>
            </div>
        </div>
    );
}
