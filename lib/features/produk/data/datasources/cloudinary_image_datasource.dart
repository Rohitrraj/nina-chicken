import 'package:cross_file/cross_file.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/config/app_environment.dart';
import '../model/cloudinary_upload_result.dart';

abstract class CloudinaryImageDatasource {
  Future<CloudinaryUploadResult> uploadProductImage(XFile image);

  Future<void> deleteProductImage(String publicId);
}

class CloudinaryImageDatasourceImpl implements CloudinaryImageDatasource {
  static const int _maximumFileSize = 5 * 1024 * 1024;

  static const Set<String> _allowedExtensions = {'jpg', 'jpeg', 'png', 'webp'};

  final Dio dio;
  final FirebaseAuth firebaseAuth;

  CloudinaryImageDatasourceImpl({
    required this.dio,
    required this.firebaseAuth,
  });

  @override
  Future<CloudinaryUploadResult> uploadProductImage(XFile image) async {
    try {
      await _validateImage(image);

      final token = await _getFirebaseIdToken();
      final signature = await _requestUploadSignature(token);

      final bytes = await image.readAsBytes();

      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          bytes,
          filename: image.name.isEmpty ? 'product-image' : image.name,
        ),
        'api_key': signature.apiKey,
        'timestamp': signature.timestamp,
        'signature': signature.signature,
        'asset_folder': signature.assetFolder,
        'public_id_prefix': signature.publicIdPrefix,
      });

      final response = await dio.post<Map<String, dynamic>>(
        'https://api.cloudinary.com/v1_1/'
        '${signature.cloudName}/image/upload',
        data: formData,
        options: Options(
          sendTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
        ),
      );

      final data = response.data;

      if (data == null) {
        throw const FormatException('Respons upload Cloudinary kosong.');
      }

      return CloudinaryUploadResult.fromJson(data);
    } on DioException catch (error) {
      throw Exception(
        _readDioError(
          error,
          fallback: 'Gagal mengunggah gambar ke Cloudinary.',
        ),
      );
    } on FirebaseAuthException catch (error) {
      throw Exception(error.message ?? 'Autentikasi Firebase gagal.');
    } catch (error) {
      if (error is Exception) {
        rethrow;
      }

      throw Exception('Gagal mengunggah gambar: $error');
    }
  }

  @override
  Future<void> deleteProductImage(String publicId) async {
    if (publicId.trim().isEmpty) {
      throw ArgumentError('Cloudinary public ID tidak boleh kosong.');
    }

    try {
      final token = await _getFirebaseIdToken();

      await dio.post<void>(
        '${AppEnvironment.apiBaseUrl}'
        '/api/cloudinary-delete',
        data: {'publicId': publicId.trim()},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (error) {
      throw Exception(
        _readDioError(error, fallback: 'Gagal menghapus gambar Cloudinary.'),
      );
    }
  }

  Future<void> _validateImage(XFile image) async {
    final fileName = image.name.toLowerCase();
    final extension = fileName.contains('.') ? fileName.split('.').last : '';

    if (!_allowedExtensions.contains(extension)) {
      throw const FormatException(
        'Format gambar harus JPG, JPEG, PNG, atau WEBP.',
      );
    }

    final fileSize = await image.length();

    if (fileSize <= 0) {
      throw const FormatException(
        'File gambar kosong atau tidak dapat dibaca.',
      );
    }

    if (fileSize > _maximumFileSize) {
      throw const FormatException('Ukuran gambar maksimal 5 MB.');
    }
  }

  Future<String> _getFirebaseIdToken() async {
    final user = firebaseAuth.currentUser;

    if (user == null) {
      throw FirebaseAuthException(
        code: 'unauthenticated',
        message: 'Admin belum login.',
      );
    }

    final String? token = await user.getIdToken();

    if (token == null || token.isEmpty) {
      throw FirebaseAuthException(
        code: 'missing-id-token',
        message: 'Firebase ID token tidak tersedia.',
      );
    }

    return token;
  }

  Future<_CloudinarySignature> _requestUploadSignature(String token) async {
    final response = await dio.post<Map<String, dynamic>>(
      '${AppEnvironment.apiBaseUrl}'
      '/api/cloudinary-signature',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    final data = response.data;

    if (data == null) {
      throw const FormatException('Respons signature Cloudinary kosong.');
    }

    return _CloudinarySignature.fromJson(data);
  }

  String _readDioError(DioException error, {required String fallback}) {
    final responseData = error.response?.data;

    if (responseData is Map<String, dynamic>) {
      final serverMessage = responseData['error'];

      if (serverMessage is String && serverMessage.isNotEmpty) {
        return serverMessage;
      }
    }

    if (responseData is Map) {
      final serverMessage = responseData['error'];

      if (serverMessage is String && serverMessage.isNotEmpty) {
        return serverMessage;
      }
    }

    return error.message ?? fallback;
  }
}

class _CloudinarySignature {
  final String cloudName;
  final String apiKey;
  final String signature;
  final int timestamp;
  final String assetFolder;
  final String publicIdPrefix;

  const _CloudinarySignature({
    required this.cloudName,
    required this.apiKey,
    required this.signature,
    required this.timestamp,
    required this.assetFolder,
    required this.publicIdPrefix,
  });

  factory _CloudinarySignature.fromJson(Map<String, dynamic> json) {
    final cloudName = json['cloudName'];
    final apiKey = json['apiKey'];
    final signature = json['signature'];
    final timestamp = json['timestamp'];
    final assetFolder = json['assetFolder'];
    final publicIdPrefix = json['publicIdPrefix'];

    if (cloudName is! String ||
        apiKey is! String ||
        signature is! String ||
        timestamp is! num ||
        assetFolder is! String ||
        publicIdPrefix is! String) {
      throw const FormatException('Respons signature Cloudinary tidak valid.');
    }

    return _CloudinarySignature(
      cloudName: cloudName,
      apiKey: apiKey,
      signature: signature,
      timestamp: timestamp.toInt(),
      assetFolder: assetFolder,
      publicIdPrefix: publicIdPrefix,
    );
  }
}
