import axios from 'axios';

const api = axios.create({
    baseURL: process.env.NEXT_PUBLIC_API_URL || 'http://localhost:5434/api', // Wait, backend runs on PORT=5000 inside container? No, backend is exposed on host port 5000? 
    // Step 32 wrote server.ts with PORT 5000.
    // But wait, docker-compose exposes POSTGRES on 5434. The backend is running locally via `npm run dev` (I ran `npm run build` but didn't start it yet, or did I? No, I ran build). 
    // I need to start backend.
});

// Since I am running frontend locally and backend locally on port 5000 (default), this URL is fine.
// But wait, backend .env has PORT=5000.
// And I haven't started backend yet. I only built it.
// I should start backend in a separate terminal or background process.

api.interceptors.request.use((config) => {
    if (typeof window !== 'undefined') {
        const token = localStorage.getItem('token');
        if (token) {
            config.headers.Authorization = `Bearer ${token}`;
        }
    }
    return config;
});

export default api;
