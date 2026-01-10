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
        ramping_load: {
            executor: 'ramping-arrival-rate',
            startRate: 5,
            timeUnit: '1s',
            preAllocatedVUs: 50,
            maxVUs: 100,
            stages: [
                { target: 25, duration: '1m' }, // Safer target for your CPU
                { target: 25, duration: '2m' },
                { target: 0, duration: '30s' },
            ],
        },
    },
    thresholds: {
        // We now target "expected_response" so 409s don't break the test
        'http_req_failed{status:500}': ['rate<0.01'], // Only fail if server errors occur
        'http_req_duration': ['p(95)<1500'],
        'checks': ['rate>0.99'],
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

    // We use responseCallback to tell k6 that 409 is "Expected"
    const res = http.post(REGISTER_URL, payload, {
        headers: { 'Content-Type': 'application/json' },
        // This prevents 409 from counting towards the global http_req_failed metric
        responseCallback: http.expectedStatuses(200, 201, 409),
    });

    check(res, {
        'Valid Response (20x or 409)': (r) => [200, 201, 409].includes(r.status),
        'Server is Healthy (Not 500)': (r) => r.status < 500,
    });
}