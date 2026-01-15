import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { statusHandler } from './http/status';
import { createSession } from './http/sessions';
import { onHistoryCreate } from './triggers/historyOnCreate';

admin.initializeApp();

export const status = functions.https.onRequest(statusHandler);
export const createSessionHttp = functions.https.onRequest(createSession);

export const historyOnCreateTrigger = functions.firestore
  .document('history/{docId}')
  .onCreate(onHistoryCreate);
