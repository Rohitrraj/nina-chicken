const { v2: cloudinary } = require("cloudinary");

function getRequiredEnvironmentVariable(name) {
  const value = process.env[name];

  if (!value) {
    const error = new Error(`${name} belum dikonfigurasi.`);
    error.statusCode = 500;
    throw error;
  }

  return value;
}

function getCloudinaryClient() {
  const cloudName = getRequiredEnvironmentVariable("CLOUDINARY_CLOUD_NAME");
  const apiKey = getRequiredEnvironmentVariable("CLOUDINARY_API_KEY");
  const apiSecret = getRequiredEnvironmentVariable("CLOUDINARY_API_SECRET");

  cloudinary.config({
    cloud_name: cloudName,
    api_key: apiKey,
    api_secret: apiSecret,
    secure: true,
  });

  return {
    cloudinary,
    cloudName,
    apiKey,
    apiSecret,
  };
}

module.exports = {
  getCloudinaryClient,
};
