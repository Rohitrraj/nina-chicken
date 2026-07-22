class CloudinaryUploadResult {
  final String secureUrl;
  final String publicId;
  final String format;
  final int bytes;
  final int? width;
  final int? height;

  const CloudinaryUploadResult({
    required this.secureUrl,
    required this.publicId,
    required this.format,
    required this.bytes,
    this.width,
    this.height,
  });

  factory CloudinaryUploadResult.fromJson(Map<String, dynamic> json) {
    final secureUrl = json['secure_url'];
    final publicId = json['public_id'];

    if (secureUrl is! String || secureUrl.isEmpty) {
      throw const FormatException('Cloudinary secure URL tidak ditemukan.');
    }

    if (publicId is! String || publicId.isEmpty) {
      throw const FormatException('Cloudinary public ID tidak ditemukan.');
    }

    return CloudinaryUploadResult(
      secureUrl: secureUrl,
      publicId: publicId,
      format: json['format']?.toString() ?? '',
      bytes: (json['bytes'] as num?)?.toInt() ?? 0,
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
    );
  }
}
