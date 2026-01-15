import * as admin from 'firebase-admin';

export const onHistoryCreate = async (snap: FirebaseFirestore.DocumentSnapshot) => {
  const data = snap.data();
  await admin.firestore().collection('history_audit').add({
    historyId: snap.id,
    payload: data,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  });
};
