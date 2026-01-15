import { Request, Response } from 'express';

export const statusHandler = (req: Request, res: Response) => {
  res.json({ ok: true, ts: Date.now() });
};
