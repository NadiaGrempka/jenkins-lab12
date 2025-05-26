const request = require('supertest');
const app = require('../src/index');

describe('GET /api/data', () => {
    it('should return array of data', async () => {
        const res = await request(app).get('/api/data');
        expect(res.statusCode).toBe(200);
        expect(Array.isArray(res.body.data)).toBe(true);
    });
});
