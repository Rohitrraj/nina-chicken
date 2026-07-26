import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kedai_ayam_nina/core/design_system/design_system.dart';
import 'package:kedai_ayam_nina/dependency_injection/dependency_injection.dart';

import '../../domain/entities/product.dart';
import '../bloc/product_catalog_bloc.dart';
import '../bloc/product_mutation_bloc.dart';
import '../models/product_mutation_input.dart';

class ProductMutationPage extends StatefulWidget {
  const ProductMutationPage({super.key, this.product, this.mutationBloc});

  final Product? product;
  final ProductMutationBloc? mutationBloc;

  @override
  State<ProductMutationPage> createState() => _ProductMutationPageState();
}

class _ProductMutationPageState extends State<ProductMutationPage> {
  static const List<String> _allowedCategories = ['food', 'beverage'];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _shortDescriptionController =
      TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();

  String? _selectedCategory;
  late final String _existingImageUrl;

  XFile? _pickedImage;
  Uint8List? _pickedImageBytes;
  String? _imageError;

  bool get _isUpdate => widget.product != null;

  bool get _hasImage {
    return _pickedImage != null || _existingImageUrl.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();

    final product = widget.product;

    _existingImageUrl = product != null && product.imageUrl.isNotEmpty
        ? product.imageUrl.first.trim()
        : '';

    if (product == null) {
      return;
    }

    _nameController.text = product.name;
    _priceController.text = product.price.toStringAsFixed(0);
    _descriptionController.text = product.description;
    _shortDescriptionController.text = product.shortDescription;

    final normalizedCategory = product.category.trim().toLowerCase();

    if (_allowedCategories.contains(normalizedCategory)) {
      _selectedCategory = normalizedCategory;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _shortDescriptionController.dispose();

    super.dispose();
  }

  Future<void> _pickImage(
    BuildContext context, {
    required bool disabled,
  }) async {
    if (disabled) {
      return;
    }

    try {
      final image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );

      if (image == null) {
        return;
      }

      final bytes = await image.readAsBytes();

      if (!mounted) {
        return;
      }

      setState(() {
        _pickedImage = image;
        _pickedImageBytes = bytes;
        _imageError = null;
      });
    } catch (_) {
      if (!context.mounted) {
        return;
      }

      _showMessage(
        context,
        message:
            'Gambar belum dapat dipilih. Silakan coba menggunakan file lain.',
        error: true,
      );
    }
  }

  void _cancelSelectedImage() {
    setState(() {
      _pickedImage = null;
      _pickedImageBytes = null;
      _imageError = null;
    });
  }

  void _submit(BuildContext context) {
    FocusScope.of(context).unfocus();

    final validForm = _formKey.currentState?.validate() ?? false;
    final validImage = _hasImage;

    setState(() {
      _imageError = validImage ? null : 'Gambar produk wajib dipilih.';
    });

    if (!validForm || !validImage) {
      return;
    }

    final price = double.tryParse(_priceController.text.trim());

    if (price == null || price <= 0) {
      return;
    }

    final existingImageUrls =
        _pickedImage == null && _existingImageUrl.isNotEmpty
        ? <String>[_existingImageUrl]
        : <String>[];

    final product = Product(
      id: widget.product?.id ?? '',
      name: _nameController.text.trim(),
      category: _selectedCategory!,
      description: _descriptionController.text.trim(),
      shortDescription: _shortDescriptionController.text.trim(),
      price: price,
      imageUrl: existingImageUrls,
      imagePublicIds: widget.product?.imagePublicIds ?? const <String>[],
    );

    final input = ProductMutationInput(
      product: product,
      selectedImage: _pickedImage,
    );

    final bloc = context.read<ProductMutationBloc>();

    if (_isUpdate) {
      bloc.add(DoUpdateProduct(input));
    } else {
      bloc.add(DoCreateProduct(input));
    }
  }

  void _handleSuccess(BuildContext context) {
    getIt<ProductCatalogBloc>().add(LoadProducts());

    _showMessage(
      context,
      message: _isUpdate
          ? 'Produk berhasil diperbarui.'
          : 'Produk berhasil ditambahkan.',
      error: false,
    );

    context.go('/admin/catalog');
  }

  void _showMessage(
    BuildContext context, {
    required String message,
    required bool error,
  }) {
    final messenger = ScaffoldMessenger.of(context);

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: error ? AppColors.error : const Color(0xFF2E7D32),
        ),
      );
  }

  void _handleBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
      return;
    }

    context.go('/admin/catalog');
  }

  String? _validateName(String? value) {
    final name = value?.trim() ?? '';

    if (name.isEmpty) {
      return 'Nama produk wajib diisi.';
    }

    if (name.length < 3) {
      return 'Nama produk minimal terdiri dari 3 karakter.';
    }

    return null;
  }

  String? _validatePrice(String? value) {
    final rawValue = value?.trim() ?? '';

    if (rawValue.isEmpty) {
      return 'Harga produk wajib diisi.';
    }

    final price = double.tryParse(rawValue);

    if (price == null) {
      return 'Harga produk harus berupa angka.';
    }

    if (price <= 0) {
      return 'Harga produk harus lebih dari nol.';
    }

    return null;
  }

  String? _validateShortDescription(String? value) {
    final description = value?.trim() ?? '';

    if (description.isEmpty) {
      return 'Deskripsi singkat wajib diisi.';
    }

    if (description.length < 5) {
      return 'Deskripsi singkat minimal terdiri dari 5 karakter.';
    }

    return null;
  }

  String? _validateDescription(String? value) {
    final description = value?.trim() ?? '';

    if (description.isEmpty) {
      return 'Deskripsi lengkap wajib diisi.';
    }

    if (description.length < 10) {
      return 'Deskripsi lengkap minimal terdiri dari 10 karakter.';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductMutationBloc>(
      create: (_) => widget.mutationBloc ?? getIt<ProductMutationBloc>(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          top: false,
          child: BlocConsumer<ProductMutationBloc, ProductMutationState>(
            listener: (context, state) {
              if (state is ProductMutationSuccess) {
                _handleSuccess(context);
              } else if (state is ProductMutationFailure) {
                _showMessage(
                  context,
                  message:
                      'Produk belum dapat disimpan. '
                      'Periksa data dan coba kembali.',
                  error: true,
                );
              }
            },
            builder: (context, state) {
              final isLoading = state is ProductMutationLoading;

              return LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth >= 980;

                  final horizontalPadding = constraints.maxWidth < 600
                      ? AppSpacing.md
                      : constraints.maxWidth < 1100
                      ? AppSpacing.lg
                      : AppSpacing.xl;

                  return SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      AppSpacing.lg,
                      horizontalPadding,
                      AppSpacing.xxl,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1280),
                        child: Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _MutationHeader(
                                isUpdate: _isUpdate,
                                onBack: () {
                                  _handleBack(context);
                                },
                              ),
                              const SizedBox(height: AppSpacing.xl),
                              if (isDesktop)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 7,
                                      child: _buildFormPanel(
                                        context,
                                        isLoading: isLoading,
                                      ),
                                    ),
                                    const SizedBox(width: AppSpacing.lg),
                                    Expanded(
                                      flex: 4,
                                      child: _buildImagePanel(
                                        context,
                                        isLoading: isLoading,
                                      ),
                                    ),
                                  ],
                                )
                              else
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    _buildImagePanel(
                                      context,
                                      isLoading: isLoading,
                                    ),
                                    const SizedBox(height: AppSpacing.md),
                                    _buildFormPanel(
                                      context,
                                      isLoading: isLoading,
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFormPanel(BuildContext context, {required bool isLoading}) {
    return _FormCard(
      title: 'Informasi Produk',
      description:
          'Masukkan informasi yang akan ditampilkan pada katalog pelanggan.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            key: const Key('product-name-field'),
            controller: _nameController,
            enabled: !isLoading,
            validator: _validateName,
            textInputAction: TextInputAction.next,
            maxLength: 80,
            decoration: const InputDecoration(
              labelText: 'Nama produk',
              hintText: 'Contoh: Ayam Penyet Istimewa',
              prefixIcon: Icon(Icons.restaurant_menu_rounded),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          LayoutBuilder(
            builder: (context, constraints) {
              final horizontal = constraints.maxWidth >= 620;

              final categoryField = DropdownButtonFormField<String>(
                key: const Key('product-category-field'),
                initialValue: _selectedCategory,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: const [
                  DropdownMenuItem<String>(
                    value: 'food',
                    child: Text('Makanan'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'beverage',
                    child: Text('Minuman'),
                  ),
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Kategori produk wajib dipilih.';
                  }

                  return null;
                },
                onChanged: isLoading
                    ? null
                    : (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
              );

              final priceField = TextFormField(
                key: const Key('product-price-field'),
                controller: _priceController,
                enabled: !isLoading,
                validator: _validatePrice,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Harga',
                  hintText: '25000',
                  prefixText: 'Rp ',
                  prefixIcon: Icon(Icons.payments_outlined),
                ),
              );

              if (horizontal) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: categoryField),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(child: priceField),
                  ],
                );
              }

              return Column(
                children: [
                  categoryField,
                  const SizedBox(height: AppSpacing.md),
                  priceField,
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            key: const Key('product-short-description-field'),
            controller: _shortDescriptionController,
            enabled: !isLoading,
            validator: _validateShortDescription,
            minLines: 2,
            maxLines: 3,
            maxLength: 140,
            textInputAction: TextInputAction.newline,
            decoration: const InputDecoration(
              labelText: 'Deskripsi singkat',
              hintText: 'Ringkasan singkat produk untuk kartu katalog.',
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.short_text_rounded),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            key: const Key('product-description-field'),
            controller: _descriptionController,
            enabled: !isLoading,
            validator: _validateDescription,
            minLines: 5,
            maxLines: 8,
            maxLength: 800,
            textInputAction: TextInputAction.newline,
            decoration: const InputDecoration(
              labelText: 'Deskripsi lengkap',
              hintText:
                  'Jelaskan rasa, bahan, penyajian, atau informasi penting lainnya.',
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.notes_rounded),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePanel(BuildContext context, {required bool isLoading}) {
    return _FormCard(
      title: 'Foto Produk',
      description: _isUpdate
          ? 'Pilih gambar baru hanya ketika foto produk ingin diganti.'
          : 'Pilih satu gambar utama untuk kartu dan detail produk.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ProductImagePicker(
            pickedImageBytes: _pickedImageBytes,
            existingImageUrl: _existingImageUrl,
            disabled: isLoading,
            errorText: _imageError,
            onPickImage: () {
              _pickImage(context, disabled: isLoading);
            },
          ),
          if (_pickedImage != null) ...[
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton.icon(
              onPressed: isLoading ? null : _cancelSelectedImage,
              icon: const Icon(Icons.undo_rounded),
              label: Text(
                _existingImageUrl.isEmpty
                    ? 'Batalkan Pilihan'
                    : 'Gunakan Gambar Lama',
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              key: const Key('product-submit-button'),
              onPressed: isLoading
                  ? null
                  : () {
                      _submit(context);
                    },
              child: isLoading
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 19,
                          height: 19,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: AppSpacing.sm),
                        Text('Menyimpan...'),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _isUpdate ? Icons.save_outlined : Icons.add_rounded,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(_isUpdate ? 'Simpan Perubahan' : 'Tambah Produk'),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Pastikan nama, harga, deskripsi, kategori, dan gambar sudah benar.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textMuted,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _MutationHeader extends StatelessWidget {
  const _MutationHeader({required this.isUpdate, required this.onBack});

  final bool isUpdate;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Tooltip(
          message: 'Kembali ke katalog',
          child: IconButton(
            key: const Key('product-mutation-back-button'),
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_rounded),
            style: IconButton.styleFrom(
              minimumSize: const Size(48, 48),
              backgroundColor: AppColors.surface,
              foregroundColor: AppColors.primary700,
              side: const BorderSide(color: AppColors.border),
              shape: const RoundedRectangleBorder(borderRadius: AppRadius.md),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.primary50,
                  borderRadius: AppRadius.pill,
                ),
                child: Text(
                  isUpdate ? 'EDIT PRODUK' : 'PRODUK BARU',
                  style: AppTypography.sectionEyebrow,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                isUpdate ? 'Perbarui Produk' : 'Tambah Produk',
                style: theme.textTheme.displaySmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                isUpdate
                    ? 'Perbarui informasi produk tanpa mengubah alur penyimpanan.'
                    : 'Tambahkan menu baru ke katalog Kedai Ayam Nina.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FormCard extends StatelessWidget {
  const _FormCard({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lg,
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          child,
        ],
      ),
    );
  }
}

class _ProductImagePicker extends StatelessWidget {
  const _ProductImagePicker({
    required this.pickedImageBytes,
    required this.existingImageUrl,
    required this.disabled,
    required this.errorText,
    required this.onPickImage,
  });

  final Uint8List? pickedImageBytes;
  final String existingImageUrl;
  final bool disabled;
  final String? errorText;
  final VoidCallback onPickImage;

  bool get _hasPickedImage => pickedImageBytes != null;

  bool get _hasExistingImage => existingImageUrl.startsWith('http');

  @override
  Widget build(BuildContext context) {
    final hasImage = _hasPickedImage || _hasExistingImage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          button: true,
          enabled: !disabled,
          label: hasImage ? 'Ganti foto produk' : 'Pilih foto produk',
          child: Material(
            color: Colors.transparent,
            borderRadius: AppRadius.lg,
            child: InkWell(
              key: const Key('product-image-picker'),
              onTap: disabled ? null : onPickImage,
              borderRadius: AppRadius.lg,
              child: Ink(
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  borderRadius: AppRadius.lg,
                  border: Border.all(
                    color: errorText == null
                        ? AppColors.border
                        : AppColors.error,
                    width: errorText == null ? 1 : 1.5,
                  ),
                ),
                child: AspectRatio(
                  aspectRatio: 4 / 3,
                  child: ClipRRect(
                    borderRadius: AppRadius.lg,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (_hasPickedImage)
                          Image.memory(
                            pickedImageBytes!,
                            fit: BoxFit.cover,
                            semanticLabel: 'Preview foto produk baru',
                          )
                        else if (_hasExistingImage)
                          Image.network(
                            existingImageUrl,
                            fit: BoxFit.cover,
                            semanticLabel: 'Foto produk saat ini',
                            errorBuilder: (context, error, stackTrace) {
                              return const _ImagePlaceholder();
                            },
                          )
                        else
                          const _ImagePlaceholder(),
                        if (hasImage)
                          Positioned(
                            right: AppSpacing.sm,
                            bottom: AppSpacing.sm,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                                vertical: AppSpacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.textPrimary.withValues(
                                  alpha: 0.78,
                                ),
                                borderRadius: AppRadius.pill,
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.photo_camera_outlined,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'Ganti Foto',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            errorText!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surfaceMuted,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxHeight < 210;
          final iconContainerSize = compact ? 48.0 : 58.0;
          final iconSize = compact ? 24.0 : 29.0;

          return Center(
            child: Padding(
              padding: EdgeInsets.all(compact ? AppSpacing.md : AppSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: iconContainerSize,
                    height: iconContainerSize,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: AppColors.primary50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.add_photo_alternate_outlined,
                      color: AppColors.primary700,
                      size: iconSize,
                    ),
                  ),
                  SizedBox(height: compact ? AppSpacing.sm : AppSpacing.md),
                  Text(
                    'Pilih Foto Produk',
                    textAlign: TextAlign.center,
                    style:
                        (compact
                                ? Theme.of(context).textTheme.titleSmall
                                : Theme.of(context).textTheme.titleMedium)
                            ?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w800,
                            ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Klik untuk memilih gambar dari perangkat.',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      height: compact ? 1.3 : 1.4,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
