import papaparse from 'https://jslib.k6.io/papaparse/5.1.1/index.js';
import { SharedArray } from "k6/data";
import http from 'k6/http';
import { check, sleep } from 'k6';

// ===== 1. LOAD CSV REGISTER_DATA (EMAIL & PASSWORD UNTUK LOGIN) =====
const loginData = new SharedArray("login data", function () {
    const parsed = papaparse.parse(open('./register_data.csv'), {
        header: true,
        skipEmptyLines: true,
    }).data;

    return Object.freeze(parsed);
});

// ===== 2. LOGIN URL =====
const LOGIN_URL = 'http://103.63.25.67:8080/api/auth/login';

// ===== 3. OPTIONS =====
export const options = {
    scenarios: {
        load_test: {
            executor: "constant-arrival-rate",
            rate: 200,              // 200 Login Request / second
            timeUnit: "1s",
            duration: "2m",
            preAllocatedVUs: 50,
            maxVUs: 200,
        }
    },
    thresholds: {
        http_req_duration: ['p(95)<1000'],   // 95% < 1s
        http_req_failed: ['rate<0.001'],     // Error < 0.1%
        checks: ['rate>0.99'],               // 99% checks success
    },
};

// ===== 4. LOGIN TEST =====
export default function () {
    const idx = (__ITER % loginData.length);
    const user = loginData[idx];

    const payload = JSON.stringify({
        email: user.email,
        password: user.password,
    });

    const res = http.post(LOGIN_URL, payload, {
        headers: { 'Content-Type': 'application/json' },
    });

    check(res, {
        'Login success (200)': (r) => r.status === 200,
    });

    sleep(1); // Tirukan perilaku real user
}
