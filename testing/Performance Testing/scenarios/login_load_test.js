// k6/scenarios/auth_load.js
import { check, sleep } from 'k6';
import { login } from '../lib/auth_login.js';

// 1. Configuration: Define how the load test runs
export const options = {
    // A standard load test profile
    stages: [
        { duration: '2m', target: 200 }, // Spend 2 minutes slowly ramping up to 200 users
        { duration: '3m', target: 200 }, // Stay at 200 users for 3 minutes
    ],

    // Pass/Fail criteria
    thresholds: {
        http_req_duration: ['p(90)<1500'], // 90% of logins must be faster than 1500ms
        http_req_failed: ['rate<0.01'],   // Error rate must be less than 1%
    },
};

// 2. The Virtual User (VU) Logic
export default function () {
    // Ideally, avoid using the same user for high concurrency to prevent 
    // database row-locking in MySQL. 
    // (See "Data Parametrization" below for how to fix this).
    const email = 'jane.doe@example.com';
    const password = 'test123';

    // Call your helper function
    const token = login(email, password);

    // Additional check: Ensure the helper actually returned a string (token)
    // The helper checks status 200, but we also want to ensure the body was valid.
    check(token, {
        'Token is present': (t) => t && t.length > 0,
        'Token is string': (t) => typeof t === 'string',
    });

    // Simulate "Think Time"
    // Users don't login, logout, and login again instantly. 
    // Wait 1-3 seconds between iterations.
    sleep(1);
}