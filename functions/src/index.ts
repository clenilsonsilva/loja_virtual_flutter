import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp(functions.config().firebase);

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

export const helloWorld = functions.https.onCall((data, context) => {
  return {data: "Hello from cloud functions"};
});

export const getUserData = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    return {"data": "Nenhum usuario logado"};
  }
  const snapshot = await admin.firestore().collection("users")
    .doc(context.auth.uid).get();
  return {"data": snapshot.data()};
});
