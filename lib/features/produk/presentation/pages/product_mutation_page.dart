import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/web.dart';
import '../../../../dependency_injection/dependency_injection.dart';
import '../../domain/entities/product.dart';
import '../bloc/product_catalog_bloc.dart';
import '../bloc/product_mutation_bloc.dart';
import '../models/product_mutation_input.dart';

class ProductMutationPage extends StatefulWidget {
  final Product? product;

  const ProductMutationPage({super.key, this.product});

  @override
  State<ProductMutationPage> createState() => _ProductMutationPageState();
}

class _ProductMutationPageState extends State<ProductMutationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();
  final _shortDescController = TextEditingController();

  String? _selectedCategory;
  String _imageUrlPreview = "";
  XFile? _pickedImage;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _priceController.text = widget.product!.price.toStringAsFixed(0);
      _descController.text = widget.product!.description;
      _shortDescController.text = widget.product!.shortDescription;
      _selectedCategory = widget.product!.category;
      if (widget.product!.imageUrl.isNotEmpty) {
        _imageUrlPreview = widget.product!.imageUrl.first;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descController.dispose();
    _shortDescController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _pickedImage = image;
        _imageUrlPreview = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Logger().i(
      "Building ProductMutationPage with productId: ${widget.product?.id}",
    );
    final bool isUpdate = widget.product != null;

    return BlocProvider(
      create: (_) => getIt<ProductMutationBloc>(),
      child: Scaffold(
        backgroundColor: const Color(0xFFFDFBF0),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(40),
          child: BlocConsumer<ProductMutationBloc, ProductMutationState>(
            listener: (context, state) {
              if (state is ProductMutationSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: const Color(0xFF2E7D32),
                  ),
                );
                // Refresh catalog singleton lalu navigate kembali
                getIt<ProductCatalogBloc>().add(LoadProducts());
                context.go('/admin/catalog');
              } else if (state is ProductMutationFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              return Form(
                key: _formKey,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isUpdate ? "Update Recipe" : "Create Recipe",
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF8B4513),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Introduce a new culinary masterpiece to the Nina's Kitchen catalog.",
                          ),
                          const SizedBox(height: 32),
                          _buildTextField(
                            "Product Name",
                            "e.g., Ayam Penyet Istimewa",
                            _nameController,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  initialValue: _selectedCategory,
                                  decoration: InputDecoration(
                                    labelText: "Category",
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  items: ['food', 'beverage']
                                      .map(
                                        (e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(e.toUpperCase()),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (val) =>
                                      setState(() => _selectedCategory = val),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildTextField(
                                  "Price",
                                  "Rp 0",
                                  _priceController,
                                  isNum: true,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _descController,
                            maxLines: 5,
                            decoration: InputDecoration(
                              labelText: "Culinary Description",
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              hintText:
                                  "Describe the flavor profile, ingredients...",
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _shortDescController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              labelText: "Short Description",
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              hintText: "A brief summary of the dish...",
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 40),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Menu Photography",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              height: 300,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(20),
                                image:
                                    _imageUrlPreview.isNotEmpty &&
                                        _imageUrlPreview.startsWith('http')
                                    ? DecorationImage(
                                        image: NetworkImage(_imageUrlPreview),
                                        fit: BoxFit.cover,
                                      )
                                    : (_pickedImage != null
                                          ? (kIsWeb
                                                ? DecorationImage(
                                                    image: NetworkImage(
                                                      _pickedImage!.path,
                                                    ),
                                                    fit: BoxFit.cover,
                                                  )
                                                : DecorationImage(
                                                    image: FileImage(
                                                      File(_pickedImage!.path),
                                                    ),
                                                    fit: BoxFit.cover,
                                                  ))
                                          : null),
                              ),
                              child: _imageUrlPreview.isEmpty
                                  ? const Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.image, size: 40),
                                          SizedBox(height: 8),
                                          Text(
                                            "Upload Hero Image\nClick to browse files",
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD66B0D),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              onPressed: state is ProductMutationLoading
                                  ? null
                                  : () {
                                      if (_formKey.currentState!.validate() &&
                                          _selectedCategory != null) {
                                        // Validasi gambar wajib saat create
                                        if (!isUpdate &&
                                            _imageUrlPreview.isEmpty) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Gambar produk tidak boleh kosong! Silakan upload gambar terlebih dahulu.",
                                              ),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                          return;
                                        }
                                        final existingImageUrls =
                                            _pickedImage == null &&
                                                _imageUrlPreview.startsWith(
                                                  'http',
                                                )
                                            ? <String>[_imageUrlPreview]
                                            : <String>[];

                                        final product = Product(
                                          id: widget.product?.id ?? '',
                                          name: _nameController.text.trim(),
                                          category: _selectedCategory!,
                                          description: _descController.text
                                              .trim(),
                                          shortDescription: _shortDescController
                                              .text
                                              .trim(),
                                          price: double.parse(
                                            _priceController.text.trim(),
                                          ),
                                          imageUrl: existingImageUrls,
                                          imagePublicIds:
                                              widget.product?.imagePublicIds ??
                                              const <String>[],
                                        );

                                        final mutationInput =
                                            ProductMutationInput(
                                              product: product,
                                              selectedImage: _pickedImage,
                                            );

                                        final productMutationBloc = context
                                            .read<ProductMutationBloc>();

                                        if (isUpdate) {
                                          productMutationBloc.add(
                                            DoUpdateProduct(mutationInput),
                                          );
                                        } else {
                                          productMutationBloc.add(
                                            DoCreateProduct(mutationInput),
                                          );
                                        }
                                      }
                                    },
                              child: state is ProductMutationLoading
                                  ? const CircularProgressIndicator()
                                  : const Text(
                                      "Simpan Produk",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (state is ProductMutationSuccess)
                            Center(
                              child: TextButton(
                                onPressed: () => context.go('/admin/catalog'),
                                child: const Text(
                                  "Kembali ke Katalog",
                                  style: TextStyle(color: Color(0xFFD66B0D)),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController controller, {
    bool isNum = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNum ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (v) => v!.isEmpty ? "Required" : null,
    );
  }
}
