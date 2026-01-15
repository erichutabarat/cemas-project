// k6/config/env.js
const environments = {
    local: {
        baseUrl: 'https://erichutabarat.my.id',
    },
    staging: {
        baseUrl: 'https://localhost:8080',
    },
};

// Default to 'local' if K6_ENV is not set
const selectedEnv = __ENV.K6_ENV || 'local';

export const config = environments[selectedEnv];
