import 'package:dio/dio.dart';
import 'package:cross_file/cross_file.dart';
import '../model/product_model.dart';
import 'package:http_parser/http_parser.dart';

abstract class ProductNetworkDatasource {
  Future<List<ProductModel>> getProducts();
  Future<void> createProduct(ProductModel product);
  Future<void> updateProduct(ProductModel product);
  Future<void> deleteProduct(String id);
}

class ProductNetworkDatasourceImpl implements ProductNetworkDatasource {
  final Dio dio;

  ProductNetworkDatasourceImpl({required this.dio});

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await dio.get('/products');

      final List data = response.data ?? [];
      if (data.isEmpty) {
        return [];
      } else {
        return data.map((json) => ProductModel.fromJson(json)).toList();
      }
    } catch (e) {
      throw Exception('Gagal memuat daftar produk: $e');
    }
  }

  @override
  Future<void> createProduct(ProductModel product) async {
    try {
      // 1. Siapkan Dulu Sebuah Map Kosong (BUKAN FormData)
      final Map<String, dynamic> mapData = {
        'name': product.name,
        'price': product.price.toString(),
        'type': product.category,
        'longDescription': product.description,
        'shortDescription': product.shortDescription,
      };

      // 2. Perbaiki Pengecekan Gambar Baru
      // Gambar dari internet biasanya dari Firebase Storage (https://firebasestorage...)
      // Gambar lokal dari Flutter Web berawalan (blob:http://...)
      // Jadi, kita anggap gambar baru JIKA BUKAN dari domain storage backend kamu.
      bool isNewImage =
          product.imageUrl.isNotEmpty &&
          !product.imageUrl.first.startsWith('https://');

      if (isNewImage) {
        final xFile = XFile(product.imageUrl.first);
        final bytes = await xFile.readAsBytes();

        if (bytes.isNotEmpty) {
          // 3. Masukkan file LANGSUNG ke dalam Map tadi
          mapData['image'] = MultipartFile.fromBytes(
            bytes,
            filename: xFile.name.isEmpty ? 'upload.png' : xFile.name,
            contentType: MediaType("image", "png"), // Wajib untuk Web
          );
        }
      }

      // 4. BIKIN FORM DATA SEKALIGUS DI AKHIR!
      // Ini kunci rahasianya agar Dio di Web menghitung Content-Length dengan benar.
      final formData = FormData.fromMap(mapData);

      // 5. Kirim request
      await dio.post('/products', data: formData);
    } catch (e) {
      throw Exception('Gagal membuat produk: $e');
    }
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    try {
      final formData = FormData.fromMap({
        'name': product.name,
        'price': product.price.toString(),
        'type': product.category,
        'longDescription': product.description,
        'shortDescription': product.shortDescription,
      });

      // Gunakan XFile dan .readAsBytes() agar kompatibel lintas platform (Web blob: & Native path)
      bool isNewImage =
          product.imageUrl.isNotEmpty &&
          !product.imageUrl.first.startsWith(RegExp(r'^http'));

      if (isNewImage) {
        final xFile = XFile(product.imageUrl.first);
        final bytes = await xFile.readAsBytes();

        formData.files.add(
          MapEntry(
            'image',
            MultipartFile.fromBytes(
              bytes,
              filename: xFile.name.isEmpty ? 'upload.png' : xFile.name,
            ),
          ),
        );
      }

      await dio.put('/products/${product.id}', data: formData);
    } catch (e) {
      throw Exception('Gagal memperbarui produk: $e');
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    try {
      await dio.delete('/products/$id');
    } catch (e) {
      throw Exception('Gagal menghapus produk: $e');
    }
  }
}
