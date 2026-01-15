import { Request, Response } from 'express';
import * as admin from 'firebase-admin';

export async function createSession(req: Request, res: Response) {
  try {
    const { title, startedAt } = req.body || {};
    if (!title) return res.status(400).json({ error: 'title required' });

    // Simplified auth detection for demo — in real code use callable functions or verify ID tokens
    const uid = req.headers['x-user-id'] || (req as any).user?.uid;
    if (!uid) return res.status(401).json({ error: 'unauthenticated' });

    const docRef = await admin.firestore().collection('history').add({
      title,
      startedAt: startedAt ?? admin.firestore.FieldValue.serverTimestamp(),
      createdBy: uid,
    });

    res.status(201).json({ id: docRef.id });
  } catch (err) {
    console.error('createSession error', err);
    res.status(500).json({ error: 'internal' });
  }
}
