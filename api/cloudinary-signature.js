const { requireActiveAdmin } = require("../server/firebase_admin");
const { getCloudinaryClient } = require("../server/cloudinary_client");
const { applyCors } = require("../server/cors");

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

    const { cloudinary, cloudName, apiKey, apiSecret } = getCloudinaryClient();

    const timestamp = Math.floor(Date.now() / 1000);

    const uploadParameters = {
      timestamp,
      asset_folder: "nina-chicken/products",
      public_id_prefix: "nina-chicken/products",
    };

    const signature = cloudinary.utils.api_sign_request(
      uploadParameters,
      apiSecret,
    );

    return response.status(200).json({
      cloudName,
      apiKey,
      signature,
      timestamp,
      assetFolder: uploadParameters.asset_folder,
      publicIdPrefix: uploadParameters.public_id_prefix,
    });
  } catch (error) {
    return response.status(error.statusCode ?? 500).json({
      error:
        error.statusCode != null
          ? error.message
          : "Gagal membuat signature upload.",
    });
  }
};
