const { requireActiveAdmin } = require("../server/firebase_admin");
const { getCloudinaryClient } = require("../server/cloudinary_client");
const { applyCors } = require("../server/cors");

function parseRequestBody(request) {
  if (typeof request.body === "string") {
    return JSON.parse(request.body);
  }

  return request.body ?? {};
}

module.exports = async function handler(request, response) {
  const originAllowed = applyCors(request, response);

  if (request.method === "OPTIONS") {
    return response.status(originAllowed ? 204 : 403).end();
  }

  if (!originAllowed) {
    return response.status(403).json({
      error: "Origin tidak diizinkan.",
    });
  }

  if (request.method !== "POST") {
    response.setHeader("Allow", "POST, OPTIONS");

    return response.status(405).json({
      error: "Method tidak diizinkan.",
    });
  }

  try {
    await requireActiveAdmin(request);

    const body = parseRequestBody(request);
    const publicId = body.publicId;

    if (
      typeof publicId !== "string" ||
      !publicId.startsWith("nina-chicken/products/")
    ) {
      return response.status(400).json({
        error: "Cloudinary public ID tidak valid.",
      });
    }

    const { cloudinary } = getCloudinaryClient();

    const result = await cloudinary.uploader.destroy(publicId, {
      resource_type: "image",
      invalidate: true,
    });

    return response.status(200).json({
      result: result.result,
    });
  } catch (error) {
    return response.status(error.statusCode ?? 500).json({
      error:
        error.statusCode != null ? error.message : "Gagal menghapus gambar.",
    });
  }
};
