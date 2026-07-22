const { cert, getApps, initializeApp } = require("firebase-admin/app");
const { getAuth } = require("firebase-admin/auth");
const { getFirestore } = require("firebase-admin/firestore");

function createHttpError(statusCode, message) {
  const error = new Error(message);
  error.statusCode = statusCode;
  return error;
}

function getFirebaseAdminApp() {
  if (getApps().length > 0) {
    return getApps()[0];
  }

  const encodedServiceAccount = process.env.FIREBASE_SERVICE_ACCOUNT_BASE64;

  if (!encodedServiceAccount) {
    throw createHttpError(
      500,
      "FIREBASE_SERVICE_ACCOUNT_BASE64 belum dikonfigurasi.",
    );
  }

  let serviceAccount;

  try {
    const decoded = Buffer.from(encodedServiceAccount, "base64").toString(
      "utf8",
    );

    serviceAccount = JSON.parse(decoded);
  } catch (_) {
    throw createHttpError(500, "Firebase service account tidak valid.");
  }

  if (serviceAccount.project_id !== "nina-chicken-rohitraj-mpti") {
    throw createHttpError(
      500,
      "Firebase service account berasal dari project yang salah.",
    );
  }

  return initializeApp({
    credential: cert(serviceAccount),
    projectId: serviceAccount.project_id,
  });
}

async function requireActiveAdmin(request) {
  const authorization = request.headers.authorization ?? "";

  if (!authorization.startsWith("Bearer ")) {
    throw createHttpError(401, "Firebase ID token tidak ditemukan.");
  }

  const idToken = authorization.slice("Bearer ".length).trim();

  if (!idToken) {
    throw createHttpError(401, "Firebase ID token kosong.");
  }

  const app = getFirebaseAdminApp();

  let decodedToken;

  try {
    decodedToken = await getAuth(app).verifyIdToken(idToken);
  } catch (_) {
    throw createHttpError(
      401,
      "Firebase ID token tidak valid atau kedaluwarsa.",
    );
  }

  const adminSnapshot = await getFirestore(app)
    .collection("admins")
    .doc(decodedToken.uid)
    .get();

  if (!adminSnapshot.exists) {
    throw createHttpError(403, "Akun tidak terdaftar sebagai admin.");
  }

  const adminData = adminSnapshot.data();

  if (adminData?.role !== "admin" || adminData?.isActive !== true) {
    throw createHttpError(403, "Akun admin tidak aktif atau role tidak valid.");
  }

  return {
    uid: decodedToken.uid,
    email: decodedToken.email ?? null,
  };
}

module.exports = {
  createHttpError,
  requireActiveAdmin,
};
