import papaparse from 'https://jslib.k6.io/papaparse/5.1.1/index.js';
import { SharedArray } from "k6/data";
import http from 'k6/http';
import { check } from 'k6';

const registerData = new SharedArray("user data", function () {
    const parsed = papaparse.parse(open('./register_data.csv'), {
        header: true,
        skipEmptyLines: true,
    }).data;
    return Object.freeze(parsed);
});

const REGISTER_URL = 'http://103.63.25.67:8080/api/auth/register';

export const options = {
    scenarios: {
        vps_friendly_load: {
            executor: 'ramping-arrival-rate',
            startRate: 2,
            timeUnit: '1s',
            preAllocatedVUs: 20,
            maxVUs: 150, // Higher maxVUs to allow for slow processing without dropping iters
            stages: [
                { target: 15, duration: '1m' }, // Start at 15 RPS (Safer for your VPS)
                { target: 15, duration: '2m' }, // Steady state
                { target: 0, duration: '30s' },
            ],
        },
    },
    thresholds: {
        // Only fail if actual SERVER ERRORS (500) occur. 
        // 409 (Conflict) will NOT trigger a failure here.
        'http_req_failed{status:500}': ['rate<0.05'],

        // Loosen duration to 2.5s. Hashing on a small VPS is slow!
        'http_req_duration': ['p(95)<2500'],

        'checks': ['rate>0.95'],
    },
};

export default function () {
    const idx = (__ITER % registerData.length);
    const user = registerData[idx];
    const uniqueEmail = `test_${Date.now()}_${Math.random()}@example.com`;
    const payload = JSON.stringify({
        email: uniqueEmail,
        password: user.password,
        name: user.name,
        birthdate: user.birthdate,
        gender: user.gender,
    });

    const res = http.post(REGISTER_URL, payload, {
        headers: { 'Content-Type': 'application/json' },
        // IMPORTANT: Tell k6 that 409 is a "Success" at the network level
        responseCallback: http.expectedStatuses(200, 201, 409),
    });

    check(res, {
        'Not a Server Error': (r) => r.status < 500,
        'Expected Result (201/409)': (r) => r.status === 201 || r.status === 409,
    });
}