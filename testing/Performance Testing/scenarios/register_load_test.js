import papaparse from 'https://jslib.k6.io/papaparse/5.1.1/index.js';
import { SharedArray } from "k6/data";
import http from 'k6/http';
import { check, sleep } from 'k6';

const registerData = new SharedArray("user data", function () {
    const parsed = papaparse.parse(open('./register_data.csv'), {
        header: true,
        skipEmptyLines: true,
    }).data;

    return Object.freeze(parsed);  // IMPORTANT FIX
});

const REGISTER_URL = 'http://localhost:8080/api/auth/register';

export const options = {
    scenarios: {
        load_test: {
            executor: "constant-arrival-rate",
            rate: 100,              // 100 requests per second
            timeUnit: "1s",
            duration: "2m",
            preAllocatedVUs: 50,
            maxVUs: 200,
        }
    },
    thresholds: {
        http_req_duration: ['p(95)<1000'],
        http_req_failed: ['rate<0.001'],
        checks: ['rate>0.99'],
    },
};

export default function () {
    const idx = (__ITER % registerData.length);
    const user = registerData[idx];

    const payload = JSON.stringify({
        email: user.email,
        password: user.password,
        name: user.name,
        birthdate: user.birthdate,
        gender: user.gender,
    });

    const res = http.post(REGISTER_URL, payload, {
        headers: { 'Content-Type': 'application/json' },
    });

    check(res, {
        'Status OK or 409': (r) => r.status === 200 || r.status === 201 || r.status === 409,
    });

    sleep(1); // Slight delay to mimic real user behavior
}
