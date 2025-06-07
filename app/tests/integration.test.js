const request = require('supertest');
const app = require('../src/index');  // to teraz będzie sama funkcja-express

describe('GET /api/status', () => {
    it('should return status and version', async () => {
        const res = await request(app).get('/api/status');
        expect(res.statusCode).toBe(200);
        expect(res.body).toHaveProperty('version');
        expect(res.body.status).toBe('OK');
    });
});
