import http from 'k6/http';
import { check, sleep } from 'k6';

export let options = {
    // Gunakan stages untuk simulasi beban yang stabil
    stages: [
        { duration: '1m', target: 100 },  // Ramp-up: perlahan naik ke 100 user
        { duration: '10m', target: 100 }, // SOAK: Tahan di 100 user selama 10 menit
        { duration: '1m', target: 0 },    // Ramp-down
    ],
    thresholds: {
        http_req_duration: ['p(95)<1500'],
        http_req_failed: ['rate<0.01'],
    },
};

export default function () {
    const token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3Njc5NDQ5NDcsInVzZXJJRCI6MX0.i9QcLxNWufQ0UXYfqyQuZ5E3svF2sNK_LuKHRUjLWRY";

    const params = {
        headers: {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json',
        },
    };

    const res = http.get(`http://103.63.25.67:8080/api/user/history`, params);

    // Parsing JSON sekali saja untuk efisiensi
    let jsonData;
    try { jsonData = res.json(); } catch (e) { }

    check(res, {
        'status 200': (r) => r.status === 200,
        'body not empty': () => jsonData !== null,
        'hars_results is valid': () => jsonData && Array.isArray(jsonData.hars_results) && jsonData.hars_results.length > 0,
    });

    sleep(1); // Jeda 1 detik antar request per user agar lebih realistis
}