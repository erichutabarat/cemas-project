import http from 'k6/http';
import { check, sleep } from 'k6';
import { config } from '../config/env.js';

export let options = {
    stages: [
        { duration: '30s', target: 300 },
        { duration: '2m', target: 300 },  // stay 300 user
        { duration: '30s', target: 0 },   // ramp down
    ],
    thresholds: {
        http_req_duration: ['p(90)<1000'],   // 90% harus < 1 detik
        http_req_failed: ['rate<0.01'],      // error rate < 1%
    },
};

export default function () {
    const res = http.get('http://localhost:8080/api/assessment/questions');

    check(res, {
        'status is 200': () => res.status === 200,

        // pastikan response tidak kosong
        'response body not empty': () => res.body && res.body.length > 0,

        // pastikan JSON valid
        'valid JSON': () => {
            try {
                JSON.parse(res.body);
                return true;
            } catch (e) {
                return false;
            }
        },

        // pastikan ada key "questions"
        'response has questions key': () => {
            const body = JSON.parse(res.body);
            return body.questions !== undefined;
        },

        // pastikan "questions" berupa array
        'questions is array': () => {
            const body = JSON.parse(res.body);
            return Array.isArray(body.questions);
        },

        // pastikan array tidak kosong
        'questions has at least 1 item': () => {
            const body = JSON.parse(res.body);
            return Array.isArray(body.questions) && body.questions.length > 0;
        },
    });

    sleep(1);
}