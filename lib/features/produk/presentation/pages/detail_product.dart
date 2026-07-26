import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kedai_ayam_nina/core/design_system/design_system.dart';
import 'package:kedai_ayam_nina/core/utils/rupiah_formatter.dart';
import 'package:kedai_ayam_nina/dependency_injection/dependency_injection.dart';
import 'package:kedai_ayam_nina/features/produk/domain/entities/product.dart';
import 'package:kedai_ayam_nina/features/produk/presentation/bloc/product_catalog_bloc.dart';

class DetailProductPage extends StatefulWidget {
  const DetailProductPage({super.key, required this.product, this.catalogBloc});

  final Product product;
  final ProductCatalogBloc? catalogBloc;

  @override
  State<DetailProductPage> createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {
  late final ProductCatalogBloc _catalogBloc;

  int _selectedImageIndex = 0;
  bool _deleting = false;

  Product get _product => widget.product;

  List<String> get _validImages {
    return _product.imageUrl
        .map((imageUrl) => imageUrl.trim())
        .where((imageUrl) => imageUrl.startsWith('http'))
        .toList(growable: false);
  }

  String get _categoryLabel {
    switch (_product.category.trim().toLowerCase()) {
      case 'food':
        return 'Makanan';
      case 'beverage':
        return 'Minuman';
      default:
        final category = _product.category.trim();

        return category.isEmpty ? 'Tanpa kategori' : category;
    }
  }

  @override
  void initState() {
    super.initState();
    _catalogBloc = widget.catalogBloc ?? getIt<ProductCatalogBloc>();
  }

  void _handleBack() {
    if (context.canPop()) {
      context.pop();
      return;
    }

    context.go('/admin/catalog');
  }

  void _openEditPage() {
    context.go('/admin/catalog/mutation', extra: _product);
  }

  String _deleteSuccessMessage(String message) {
    if (message.toLowerCase().contains('cleanup requires review')) {
      return 'Produk berhasil dihapus, tetapi pembersihan gambar perlu diperiksa.';
    }

    return 'Produk berhasil dihapus.';
  }

  void _showMessage({required String message, required bool error}) {
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

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          surfaceTintColor: Colors.transparent,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.lg),
          icon: Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.errorSurface,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.delete_outline_rounded,
              color: AppColors.error,
              size: 28,
            ),
          ),
          title: const Text('Hapus produk?', textAlign: TextAlign.center),
          content: Text(
            'Produk “${_product.name}” akan dihapus dari katalog beserta '
            'gambar terkait. Tindakan ini tidak dapat dibatalkan.',
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Batal'),
            ),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              icon: const Icon(Icons.delete_outline_rounded),
              label: const Text('Hapus Produk'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) {
      return;
    }

    setState(() {
      _deleting = true;
    });

    _catalogBloc.add(DeleteProductEvent(_product));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductCatalogBloc>.value(
      value: _catalogBloc,
      child: BlocListener<ProductCatalogBloc, ProductCatalogState>(
        listener: (context, state) {
          if (state is ProductCatalogActionSuccess) {
            _showMessage(
              message: _deleteSuccessMessage(state.message),
              error: false,
            );

            context.go('/admin/catalog');
            return;
          }

          if (state is ProductCatalogError && _deleting) {
            setState(() {
              _deleting = false;
            });

            _showMessage(
              message:
                  'Produk belum dapat dihapus. Periksa koneksi dan coba kembali.',
              error: true,
            );
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            top: false,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final contentPadding = constraints.maxWidth < 600
                    ? AppSpacing.md
                    : constraints.maxWidth < 1100
                    ? AppSpacing.lg
                    : AppSpacing.xl;

                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    contentPadding,
                    AppSpacing.lg,
                    contentPadding,
                    AppSpacing.xxl,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1280),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _DetailHeader(
                            productName: _product.name,
                            onBack: _handleBack,
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          if (constraints.maxWidth >= 980)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: _ProductImageSection(
                                    productName: _product.name,
                                    images: _validImages,
                                    selectedIndex: _selectedImageIndex,
                                    onSelected: (index) {
                                      setState(() {
                                        _selectedImageIndex = index;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.lg),
                                Expanded(
                                  flex: 5,
                                  child: _ProductInformationSection(
                                    product: _product,
                                    categoryLabel: _categoryLabel,
                                    deleting: _deleting,
                                    onEdit: _openEditPage,
                                    onDelete: _confirmDelete,
                                  ),
                                ),
                              ],
                            )
                          else
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _ProductImageSection(
                                  productName: _product.name,
                                  images: _validImages,
                                  selectedIndex: _selectedImageIndex,
                                  onSelected: (index) {
                                    setState(() {
                                      _selectedImageIndex = index;
                                    });
                                  },
                                ),
                                const SizedBox(height: AppSpacing.md),
                                _ProductInformationSection(
                                  product: _product,
                                  categoryLabel: _categoryLabel,
                                  deleting: _deleting,
                                  onEdit: _openEditPage,
                                  onDelete: _confirmDelete,
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailHeader extends StatelessWidget {
  const _DetailHeader({required this.productName, required this.onBack});

  final String productName;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Tooltip(
          message: 'Kembali ke katalog',
          child: IconButton(
            key: const Key('product-detail-back-button'),
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
                  'DETAIL PRODUK',
                  style: AppTypography.sectionEyebrow,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                productName,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Periksa informasi produk yang tampil pada katalog pelanggan.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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

class _ProductImageSection extends StatelessWidget {
  const _ProductImageSection({
    required this.productName,
    required this.images,
    required this.selectedIndex,
    required this.onSelected,
  });

  final String productName;
  final List<String> images;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final safeIndex = selectedIndex < images.length ? selectedIndex : 0;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lg,
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 4 / 3,
            child: ClipRRect(
              borderRadius: AppRadius.md,
              child: images.isEmpty
                  ? const _ProductImageFallback()
                  : Image.network(
                      images[safeIndex],
                      key: ValueKey<String>(
                        'product-detail-main-image-${images[safeIndex]}',
                      ),
                      fit: BoxFit.cover,
                      semanticLabel: 'Foto produk $productName',
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }

                        return const _ProductImageLoading();
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const _ProductImageFallback();
                      },
                    ),
            ),
          ),
          if (images.length > 1) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              'Galeri Foto',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              height: 76,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                separatorBuilder: (_, _) {
                  return const SizedBox(width: AppSpacing.sm);
                },
                itemBuilder: (context, index) {
                  final selected = index == safeIndex;

                  return Semantics(
                    button: true,
                    selected: selected,
                    label: 'Pilih foto ${index + 1} produk $productName',
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: AppRadius.sm,
                      child: InkWell(
                        key: ValueKey<String>(
                          'product-detail-thumbnail-$index',
                        ),
                        onTap: () {
                          onSelected(index);
                        },
                        borderRadius: AppRadius.sm,
                        child: Ink(
                          width: 76,
                          decoration: BoxDecoration(
                            borderRadius: AppRadius.sm,
                            border: Border.all(
                              color: selected
                                  ? AppColors.primary500
                                  : AppColors.border,
                              width: selected ? 2 : 1,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: AppRadius.sm,
                            child: Image.network(
                              images[index],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const _ProductImageFallback(
                                  iconSize: 24,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ProductInformationSection extends StatelessWidget {
  const _ProductInformationSection({
    required this.product,
    required this.categoryLabel,
    required this.deleting,
    required this.onEdit,
    required this.onDelete,
  });

  final Product product;
  final String categoryLabel;
  final bool deleting;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

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
          _CategoryBadge(label: categoryLabel),
          const SizedBox(height: AppSpacing.md),
          Text(
            product.name,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            formatRupiah(product.price.round()),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.primary700,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: AppSpacing.lg),
          _DescriptionBlock(
            title: 'Deskripsi Singkat',
            description: product.shortDescription,
          ),
          const SizedBox(height: AppSpacing.lg),
          _DescriptionBlock(
            title: 'Deskripsi Lengkap',
            description: product.description,
          ),
          const SizedBox(height: AppSpacing.lg),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Informasi Produk',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _ProductMetadata(
            category: categoryLabel,
            imageCount: product.imageUrl.length,
          ),
          const SizedBox(height: AppSpacing.xl),
          LayoutBuilder(
            builder: (context, constraints) {
              final horizontal = constraints.maxWidth >= 480;

              final editButton = FilledButton.icon(
                key: const Key('product-detail-edit-button'),
                onPressed: deleting ? null : onEdit,
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Edit Produk'),
                style: FilledButton.styleFrom(minimumSize: const Size(0, 50)),
              );

              final deleteButton = OutlinedButton.icon(
                key: const Key('product-detail-delete-button'),
                onPressed: deleting ? null : onDelete,
                icon: deleting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.error,
                        ),
                      )
                    : const Icon(Icons.delete_outline_rounded),
                label: Text(deleting ? 'Menghapus...' : 'Hapus Produk'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 50),
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                ),
              );

              if (horizontal) {
                return Row(
                  children: [
                    Expanded(child: editButton),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(child: deleteButton),
                  ],
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  editButton,
                  const SizedBox(height: AppSpacing.sm),
                  deleteButton,
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: const BoxDecoration(
        color: AppColors.primary50,
        borderRadius: AppRadius.pill,
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: AppColors.primary700,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _DescriptionBlock extends StatelessWidget {
  const _DescriptionBlock({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final normalizedDescription = description.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          normalizedDescription.isEmpty
              ? 'Informasi belum tersedia.'
              : normalizedDescription,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
            height: 1.65,
          ),
        ),
      ],
    );
  }
}

class _ProductMetadata extends StatelessWidget {
  const _ProductMetadata({required this.category, required this.imageCount});

  final String category;
  final int imageCount;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontal = constraints.maxWidth >= 420;

        final categoryItem = _MetadataItem(
          icon: Icons.category_outlined,
          label: 'Kategori',
          value: category,
        );

        final imageItem = _MetadataItem(
          icon: Icons.photo_library_outlined,
          label: 'Jumlah Foto',
          value: '$imageCount foto',
        );

        if (horizontal) {
          return Row(
            children: [
              Expanded(child: categoryItem),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: imageItem),
            ],
          );
        }

        return Column(
          children: [
            categoryItem,
            const SizedBox(height: AppSpacing.sm),
            imageItem,
          ],
        );
      },
    );
  }
}

class _MetadataItem extends StatelessWidget {
  const _MetadataItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: const BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: AppRadius.md,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.primary50,
              borderRadius: AppRadius.sm,
            ),
            child: Icon(icon, color: AppColors.primary700, size: 21),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(color: AppColors.textMuted),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductImageLoading extends StatelessWidget {
  const _ProductImageLoading();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.surfaceMuted,
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _ProductImageFallback extends StatelessWidget {
  const _ProductImageFallback({this.iconSize = 48});

  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surfaceMuted,
      child: Center(
        child: Icon(
          Icons.fastfood_rounded,
          color: AppColors.textMuted,
          size: iconSize,
        ),
      ),
    );
  }
}
