// k6/config/env.js
const environments = {
    local: {
        baseUrl: 'http://localhost:8080',
    },
    staging: {
        baseUrl: 'https://staging-api.example.com',
    },
};

// Default to 'local' if K6_ENV is not set
const selectedEnv = __ENV.K6_ENV || 'local';

export const config = environments[selectedEnv];