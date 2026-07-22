function isLocalOrigin(origin) {
  return /^https?:\/\/(localhost|127\.0\.0\.1)(:\d+)?$/.test(origin);
}

function isSameHost(request, origin) {
  try {
    const originUrl = new URL(origin);

    const requestHost =
      request.headers["x-forwarded-host"] ?? request.headers.host;

    return originUrl.host === requestHost;
  } catch (_) {
    return false;
  }
}

function isVercelPreview(origin) {
  return origin.startsWith("https://") && origin.endsWith(".vercel.app");
}

function applyCors(request, response) {
  const origin = request.headers.origin;

  if (!origin) {
    return true;
  }

  const allowed =
    isLocalOrigin(origin) ||
    isSameHost(request, origin) ||
    isVercelPreview(origin);

  if (allowed) {
    response.setHeader("Access-Control-Allow-Origin", origin);
    response.setHeader("Vary", "Origin");
  }

  response.setHeader(
    "Access-Control-Allow-Headers",
    "Authorization, Content-Type",
  );
  response.setHeader("Access-Control-Allow-Methods", "POST, OPTIONS");

  return allowed;
}

module.exports = {
  applyCors,
};
