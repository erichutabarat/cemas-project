import http from 'k6/http';
import { check, sleep } from 'k6';

export let options = {
    stages: [
        { duration: '30s', target: 300 },
        { duration: '2m', target: 500 },
        { duration: '30s', target: 0 },
    ],
    thresholds: {
        http_req_duration: ['p(90)<1000'],
        http_req_failed: ['rate<0.01'],
    },
};

export default function () {
    const res = http.get('http://103.63.25.67:8080/api/assessment/questions');

    // 1. Simpan hasil parse JSON ke variabel agar tidak parse berkali-kali
    let jsonData;
    try {
        jsonData = res.json();
    } catch (e) {
        jsonData = null;
    }

    check(res, {
        'status is 200': (r) => r.status === 200,
        'valid JSON': () => jsonData !== null,
        'has questions array': () => jsonData && Array.isArray(jsonData.questions) && jsonData.questions.length > 0,
    });

    sleep(1);
}