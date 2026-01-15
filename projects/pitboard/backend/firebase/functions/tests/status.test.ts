import request from 'supertest';
import express from 'express';
import { statusHandler } from '../src/http/status';

const app = express();
app.get('/status', statusHandler);

test('status returns ok', async () => {
  const res = await request(app).get('/status');
  expect(res.status).toBe(200);
  expect(res.body.ok).toBe(true);
});
