import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kedai_ayam_nina/core/design_system/design_system.dart';
import 'package:kedai_ayam_nina/core/utils/rupiah_formatter.dart';
import 'package:kedai_ayam_nina/dependency_injection/dependency_injection.dart';
import 'package:kedai_ayam_nina/features/produk/domain/entities/product.dart';

import '../bloc/product_catalog_bloc.dart';

class ProductCatalogPage extends StatefulWidget {
  const ProductCatalogPage({super.key});

  @override
  State<ProductCatalogPage> createState() => _ProductCatalogPageState();
}

class _ProductCatalogPageState extends State<ProductCatalogPage> {
  static const String _allCategory = 'Semua';

  late final ProductCatalogBloc _catalogBloc;
  final TextEditingController _searchController = TextEditingController();

  String _query = '';
  String _selectedCategory = _allCategory;

  @override
  void initState() {
    super.initState();

    _catalogBloc = getIt<ProductCatalogBloc>();

    if (_catalogBloc.state is ProductCatalogInitial) {
      _loadProducts();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadProducts() {
    _catalogBloc.add(LoadProducts());
  }

  List<String> _categories(List<Product> products) {
    final normalized = <String, String>{};

    for (final product in products) {
      final category = product.category.trim();

      if (category.isEmpty) {
        continue;
      }

      normalized.putIfAbsent(category.toLowerCase(), () => category);
    }

    final categories = normalized.values.toList()
      ..sort(
        (first, second) => first.toLowerCase().compareTo(second.toLowerCase()),
      );

    return <String>[_allCategory, ...categories];
  }

  List<Product> _filterProducts(List<Product> products) {
    final normalizedQuery = _query.trim().toLowerCase();

    return products
        .where((product) {
          final matchesCategory =
              _selectedCategory == _allCategory ||
              product.category.trim().toLowerCase() ==
                  _selectedCategory.toLowerCase();

          if (!matchesCategory) {
            return false;
          }

          if (normalizedQuery.isEmpty) {
            return true;
          }

          return product.name.toLowerCase().contains(normalizedQuery) ||
              product.shortDescription.toLowerCase().contains(
                normalizedQuery,
              ) ||
              product.description.toLowerCase().contains(normalizedQuery) ||
              product.category.toLowerCase().contains(normalizedQuery);
        })
        .toList(growable: false);
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

  String _successMessage(String message) {
    if (message.toLowerCase().contains('cleanup requires review')) {
      return 'Produk berhasil dihapus, tetapi pembersihan gambar perlu diperiksa.';
    }

    return 'Produk berhasil dihapus.';
  }

  Future<void> _confirmDelete(Product product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          surfaceTintColor: Colors.transparent,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.lg),
          icon: Container(
            width: 52,
            height: 52,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.errorSurface,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.delete_outline_rounded,
              color: AppColors.error,
            ),
          ),
          title: const Text('Hapus produk?', textAlign: TextAlign.center),
          content: Text(
            'Produk “${product.name}” akan dihapus dari katalog. '
            'Tindakan ini tidak dapat dibatalkan.',
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
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Hapus Produk'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) {
      return;
    }

    _catalogBloc.add(DeleteProductEvent(product));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductCatalogBloc>.value(
      value: _catalogBloc,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          top: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final horizontalPadding = constraints.maxWidth < 600
                  ? AppSpacing.md
                  : constraints.maxWidth < 1100
                  ? AppSpacing.lg
                  : AppSpacing.xl;

              return Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  AppSpacing.lg,
                  horizontalPadding,
                  0,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1440),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _CatalogHeader(
                          onAddProduct: () {
                            context.go('/admin/catalog/mutation');
                          },
                          onRefresh: _loadProducts,
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        Expanded(
                          child:
                              BlocConsumer<
                                ProductCatalogBloc,
                                ProductCatalogState
                              >(
                                buildWhen: (previous, current) {
                                  return current
                                      is! ProductCatalogActionSuccess;
                                },
                                listener: (context, state) {
                                  if (state is ProductCatalogActionSuccess) {
                                    _showMessage(
                                      message: _successMessage(state.message),
                                      error: false,
                                    );
                                  } else if (state is ProductCatalogError) {
                                    _showMessage(
                                      message:
                                          'Data produk belum dapat diproses. '
                                          'Silakan coba lagi.',
                                      error: true,
                                    );
                                  }
                                },
                                builder: (context, state) {
                                  if (state is ProductCatalogInitial ||
                                      state is ProductCatalogLoading) {
                                    return const _CatalogLoadingState();
                                  }

                                  if (state is ProductCatalogError) {
                                    return _CatalogErrorState(
                                      onRetry: _loadProducts,
                                    );
                                  }

                                  if (state is ProductCatalogLoaded) {
                                    return _buildLoadedContent(
                                      context,
                                      state.products,
                                    );
                                  }

                                  return const _CatalogLoadingState();
                                },
                              ),
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
    );
  }

  Widget _buildLoadedContent(BuildContext context, List<Product> products) {
    if (products.isEmpty) {
      return _CatalogEmptyState(
        onAddProduct: () {
          context.go('/admin/catalog/mutation');
        },
      );
    }

    final categories = _categories(products);

    if (!categories.contains(_selectedCategory)) {
      _selectedCategory = _allCategory;
    }

    final visibleProducts = _filterProducts(products);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CatalogToolbar(
          searchController: _searchController,
          categories: categories,
          selectedCategory: _selectedCategory,
          visibleCount: visibleProducts.length,
          totalCount: products.length,
          onSearchChanged: (value) {
            setState(() {
              _query = value;
            });
          },
          onCategorySelected: (category) {
            setState(() {
              _selectedCategory = category;
            });
          },
          onClear: () {
            _searchController.clear();

            setState(() {
              _query = '';
              _selectedCategory = _allCategory;
            });
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        Expanded(
          child: visibleProducts.isEmpty
              ? _CatalogFilterEmptyState(
                  onClear: () {
                    _searchController.clear();

                    setState(() {
                      _query = '';
                      _selectedCategory = _allCategory;
                    });
                  },
                )
              : GridView.builder(
                  key: const Key('admin-product-grid'),
                  padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 360,
                    mainAxisExtent: 390,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                  ),
                  itemCount: visibleProducts.length,
                  itemBuilder: (context, index) {
                    final product = visibleProducts[index];

                    return _AdminProductCard(
                      product: product,
                      onOpen: () {
                        context.go('/admin/catalog/detail', extra: product);
                      },
                      onEdit: () {
                        context.go('/admin/catalog/mutation', extra: product);
                      },
                      onDelete: () {
                        _confirmDelete(product);
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _CatalogHeader extends StatelessWidget {
  const _CatalogHeader({required this.onAddProduct, required this.onRefresh});

  final VoidCallback onAddProduct;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontal = constraints.maxWidth >= 720;

        final heading = Column(
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
                'MANAJEMEN PRODUK',
                style: AppTypography.sectionEyebrow,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Katalog Produk',
              style: theme.textTheme.displaySmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
                height: 1.1,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Kelola menu, harga, informasi, dan gambar produk.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        );

        final actions = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Tooltip(
              message: 'Muat ulang produk',
              child: IconButton(
                key: const Key('admin-product-refresh-button'),
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh_rounded),
                style: IconButton.styleFrom(
                  minimumSize: const Size(48, 48),
                  backgroundColor: AppColors.surface,
                  foregroundColor: AppColors.primary700,
                  side: const BorderSide(color: AppColors.border),
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadius.md,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            FilledButton.icon(
              key: const Key('admin-product-add-button'),
              onPressed: onAddProduct,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Tambah Produk'),
              style: FilledButton.styleFrom(minimumSize: const Size(0, 48)),
            ),
          ],
        );

        if (horizontal) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(child: heading),
              const SizedBox(width: AppSpacing.lg),
              actions,
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heading,
            const SizedBox(height: AppSpacing.lg),
            actions,
          ],
        );
      },
    );
  }
}

class _CatalogToolbar extends StatelessWidget {
  const _CatalogToolbar({
    required this.searchController,
    required this.categories,
    required this.selectedCategory,
    required this.visibleCount,
    required this.totalCount,
    required this.onSearchChanged,
    required this.onCategorySelected,
    required this.onClear,
  });

  final TextEditingController searchController;
  final List<String> categories;
  final String selectedCategory;
  final int visibleCount;
  final int totalCount;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onCategorySelected;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
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
          LayoutBuilder(
            builder: (context, constraints) {
              final horizontal = constraints.maxWidth >= 680;

              final search = TextField(
                key: const Key('admin-product-search-field'),
                controller: searchController,
                onChanged: onSearchChanged,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Cari nama, kategori, atau deskripsi...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: searchController.text.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Hapus pencarian',
                          onPressed: onClear,
                          icon: const Icon(Icons.close_rounded),
                        ),
                ),
              );

              final counter = Text(
                '$visibleCount dari $totalCount produk',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              );

              if (horizontal) {
                return Row(
                  children: [
                    Expanded(child: search),
                    const SizedBox(width: AppSpacing.md),
                    counter,
                  ],
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  search,
                  const SizedBox(height: AppSpacing.sm),
                  counter,
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: categories.map((category) {
              final selected = selectedCategory == category;

              return ChoiceChip(
                key: ValueKey<String>('admin-product-category-$category'),
                label: Text(category),
                selected: selected,
                onSelected: (_) {
                  onCategorySelected(category);
                },
                selectedColor: AppColors.primary100,
                backgroundColor: AppColors.surfaceMuted,
                side: BorderSide(
                  color: selected ? AppColors.primary200 : AppColors.border,
                ),
                labelStyle: TextStyle(
                  color: selected
                      ? AppColors.primary700
                      : AppColors.textSecondary,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _AdminProductCard extends StatelessWidget {
  const _AdminProductCard({
    required this.product,
    required this.onOpen,
    required this.onEdit,
    required this.onDelete,
  });

  final Product product;
  final VoidCallback onOpen;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final imageUrl = product.imageUrl.isNotEmpty
        ? product.imageUrl.first.trim()
        : '';

    return Semantics(
      button: true,
      label: 'Buka detail produk ${product.name}',
      child: Material(
        color: AppColors.surface,
        borderRadius: AppRadius.lg,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onOpen,
          child: Ink(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: AppRadius.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 190,
                  child: imageUrl.startsWith('http')
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          semanticLabel: 'Foto produk ${product.name}',
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }

                            return const _ProductImagePlaceholder(
                              loading: true,
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const _ProductImagePlaceholder();
                          },
                        )
                      : const _ProductImagePlaceholder(),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
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
                            product.category.trim().isEmpty
                                ? 'Tanpa kategori'
                                : product.category,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppColors.primary700,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          product.shortDescription,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                formatRupiah(product.price.round()),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: AppColors.primary700,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Tooltip(
                              message: 'Edit ${product.name}',
                              child: IconButton(
                                onPressed: onEdit,
                                icon: const Icon(Icons.edit_outlined),
                              ),
                            ),
                            Tooltip(
                              message: 'Hapus ${product.name}',
                              child: IconButton(
                                onPressed: onDelete,
                                color: AppColors.error,
                                icon: const Icon(Icons.delete_outline_rounded),
                              ),
                            ),
                          ],
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
    );
  }
}

class _ProductImagePlaceholder extends StatelessWidget {
  const _ProductImagePlaceholder({this.loading = false});

  final bool loading;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surfaceMuted,
      child: Center(
        child: loading
            ? const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              )
            : const Icon(
                Icons.fastfood_rounded,
                color: AppColors.textMuted,
                size: 46,
              ),
      ),
    );
  }
}

class _CatalogLoadingState extends StatelessWidget {
  const _CatalogLoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: AppSpacing.md),
          Text('Memuat katalog produk...'),
        ],
      ),
    );
  }
}

class _CatalogErrorState extends StatelessWidget {
  const _CatalogErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return _CatalogStateCard(
      icon: Icons.error_outline_rounded,
      iconColor: AppColors.error,
      iconBackground: AppColors.errorSurface,
      title: 'Katalog belum dapat dimuat',
      description:
          'Periksa koneksi internet, lalu coba muat kembali data produk.',
      action: FilledButton.icon(
        onPressed: onRetry,
        icon: const Icon(Icons.refresh_rounded),
        label: const Text('Coba Lagi'),
      ),
    );
  }
}

class _CatalogEmptyState extends StatelessWidget {
  const _CatalogEmptyState({required this.onAddProduct});

  final VoidCallback onAddProduct;

  @override
  Widget build(BuildContext context) {
    return _CatalogStateCard(
      icon: Icons.inventory_2_outlined,
      iconColor: AppColors.primary700,
      iconBackground: AppColors.primary50,
      title: 'Belum ada produk',
      description:
          'Tambahkan produk pertama agar menu dapat tampil pada katalog.',
      action: FilledButton.icon(
        onPressed: onAddProduct,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Tambah Produk'),
      ),
    );
  }
}

class _CatalogFilterEmptyState extends StatelessWidget {
  const _CatalogFilterEmptyState({required this.onClear});

  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return _CatalogStateCard(
      icon: Icons.search_off_rounded,
      iconColor: AppColors.primary700,
      iconBackground: AppColors.primary50,
      title: 'Produk tidak ditemukan',
      description:
          'Tidak ada produk yang sesuai dengan pencarian atau kategori.',
      action: OutlinedButton.icon(
        onPressed: onClear,
        icon: const Icon(Icons.restart_alt_rounded),
        label: const Text('Atur Ulang Filter'),
      ),
    );
  }
}

class _CatalogStateCard extends StatelessWidget {
  const _CatalogStateCard({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.title,
    required this.description,
    required this.action,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String title;
  final String description;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 520),
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.lg,
          border: Border.all(color: AppColors.border),
          boxShadow: AppShadows.sm,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: iconBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 30),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            action,
          ],
        ),
      ),
    );
  }
}
