import http from 'k6/http';
import { check, sleep } from 'k6';
import { config } from '../config/env.js';

export let options = {
    vus: 200,                       // 200 pengguna simultan
    duration: '3m',                 // berjalan selama 3 menit
    thresholds: {
        http_req_duration: ['p(90)<1000'], // 90% response < 1 detik
        http_req_failed: ['rate<0.01'],    // error rate < 1%
    },
};

export default function () {
    // 🚀 Kirim kedua endpoint secara paralel
    const responses = http.batch([
        ['GET', `http://103.63.25.67:8080/api/recommendations/foods`],
        ['GET', `http://103.63.25.67:8080/api/recommendations/activities`],
    ]);

    // Validasi kedua response
    check(responses[0], {
        'foods status 200': (r) => r.status === 200,
        'foods response < 1s': (r) => r.timings.duration < 1000,
        'foods body not empty': (r) => r.body.length > 0,
    });

    check(responses[1], {
        'activities status 200': (r) => r.status === 200,
        'activities response < 1s': (r) => r.timings.duration < 1000,
        'activities body not empty': (r) => r.body.length > 0,
    });

    sleep(1); // Delay antar iteration untuk simulasi natural
}
