// k6/lib/auth.js
import http from 'k6/http';
import { check } from 'k6';
import { config } from '../config/env.js';

export function login(email, password) {
    const payload = JSON.stringify({ email, password });
    const params = { headers: { 'Content-Type': 'application/json' } };

    const res = http.post(`${config.baseUrl}/api/auth/login`, payload, params);

    check(res, {
        'Login successful': (r) => r.status === 200,
    });

    return res.json('token'); // Assuming your API returns { token: "..." }
}