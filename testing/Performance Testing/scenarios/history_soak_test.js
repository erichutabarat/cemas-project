import http from 'k6/http';
import { check, sleep } from 'k6';
import { config } from '../config/env.js';

export let options = {
    vus: 1,                         // Soak test = 1 user tetapi sangat banyak request
    iterations: 1000,               // Total 1000 permintaan berturut-turut
    thresholds: {
        http_req_duration: ['p(95)<1500'],   // 95% response < 1.5 detik
        http_req_failed: ['rate<0.01'],      // Error < 1%
    },
};

export default function () {
    const token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3NjUxNzM3NTksInVzZXJJRCI6MX0.T43QN0Jwkodpq-IJqu3oj2L4571v3YJaL-wH1jsc-RA"; // ambil token dari env.js

    const headers = {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json',
    };

    const res = http.get(`${config.baseUrl}/api/user/history`, { headers });

    check(res, {
        'status 200': (r) => r.status === 200,
        'response ≤ 1.5s': (r) => r.timings.duration < 1500,
        'body contains hars_results': (r) => r.json('hars_results') !== undefined,
        'hars_results is array': (r) => Array.isArray(r.json('hars_results')),
        'hars_results not empty': (r) => r.json('hars_results').length > 0,
        // contoh validasi lebih detail:
        'first item has score': (r) => {
            const arr = r.json('hars_results');
            return arr.length > 0 && typeof arr[0].score === 'number';
        },
    });

    sleep(0.1); // kecilkan delay untuk tes berurutan
}
