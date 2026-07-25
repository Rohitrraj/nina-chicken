import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kedai_ayam_nina/core/design_system/design_system.dart';
import 'package:kedai_ayam_nina/core/widgets/animated_scroll_item.dart';
import 'package:kedai_ayam_nina/core/widgets/feedback/feedback.dart';
import 'package:kedai_ayam_nina/core/widgets/layout/layout.dart';
import 'package:kedai_ayam_nina/features/produk/domain/entities/product.dart';
import 'package:kedai_ayam_nina/features/produk/presentation/bloc/product_catalog_bloc.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/catalog/catalog.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/user_drawer.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/user_footer.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/user_navbar.dart';
import 'package:kedai_ayam_nina/router/router.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  String _selectedCategory = CatalogProductFilter.allCategory;

  @override
  void initState() {
    super.initState();

    context.read<ProductCatalogBloc>().add(LoadProducts());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewportWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = AppBreakpoints.isDesktopWidth(viewportWidth);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: isDesktop ? null : const UserDrawer(),
      body: CustomScrollView(
        slivers: [
          UserNavBar(isDesktop: isDesktop),
          const SliverToBoxAdapter(
            child: AnimatedScrollItem(
              id: 'catalog_header',
              child: CatalogHeader(),
            ),
          ),
          SliverToBoxAdapter(
            child: BlocBuilder<ProductCatalogBloc, ProductCatalogState>(
              builder: (context, state) {
                return _buildCatalogContent(context, state);
              },
            ),
          ),
          SliverToBoxAdapter(child: UserFooter(isDesktop: isDesktop)),
        ],
      ),
    );
  }

  Widget _buildCatalogContent(BuildContext context, ProductCatalogState state) {
    final theme = Theme.of(context);

    if (state is ProductCatalogInitial || state is ProductCatalogLoading) {
      return AppSection(
        backgroundColor: theme.colorScheme.surface,
        child: const AppLoadingView(message: 'Memuat daftar menu...'),
      );
    }

    if (state is ProductCatalogError) {
      return AppSection(
        backgroundColor: theme.colorScheme.surface,
        child: AppFeedbackView.error(
          title: 'Gagal memuat menu',
          message: 'Terjadi kendala ketika mengambil daftar menu.',
          actionLabel: 'Coba lagi',
          onAction: _reloadProducts,
        ),
      );
    }

    if (state is ProductCatalogLoaded) {
      return _buildLoadedContent(context, state.products);
    }

    return AppSection(
      backgroundColor: theme.colorScheme.surface,
      child: AppFeedbackView.error(
        title: 'Menu tidak dapat ditampilkan',
        message: 'Status daftar menu tidak dikenali. Silakan muat ulang.',
        actionLabel: 'Muat ulang',
        onAction: _reloadProducts,
      ),
    );
  }

  Widget _buildLoadedContent(BuildContext context, List<Product> products) {
    final theme = Theme.of(context);

    final categories = CatalogProductFilter.categories(products);

    final effectiveCategory = _resolveSelectedCategory(categories);

    final filteredProducts = CatalogProductFilter.apply(
      products: products,
      query: _searchQuery,
      category: effectiveCategory,
    );

    return AppSection(
      backgroundColor: theme.colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CatalogToolbar(
            searchController: _searchController,
            categories: categories,
            selectedCategory: effectiveCategory,
            resultCount: filteredProducts.length,
            totalCount: products.length,
            onSearchChanged: _handleSearchChanged,
            onCategorySelected: _handleCategorySelected,
          ),
          const SizedBox(height: AppSpacing.xl),
          _buildCatalogResults(
            context: context,
            products: products,
            filteredProducts: filteredProducts,
            effectiveCategory: effectiveCategory,
          ),
        ],
      ),
    );
  }

  Widget _buildCatalogResults({
    required BuildContext context,
    required List<Product> products,
    required List<Product> filteredProducts,
    required String effectiveCategory,
  }) {
    if (products.isEmpty) {
      return const AppFeedbackView.empty(
        title: 'Menu belum tersedia',
        message: 'Daftar menu Kedai Ayam Nina masih kosong.',
      );
    }

    if (filteredProducts.isEmpty) {
      final hasSearch = _searchQuery.trim().isNotEmpty;
      final hasCategory =
          effectiveCategory.toLowerCase() !=
          CatalogProductFilter.allCategory.toLowerCase();

      if (hasSearch) {
        return AppFeedbackView.empty(
          title: 'Menu tidak ditemukan',
          message:
              'Tidak ada menu yang cocok dengan pencarian '
              '"${_searchQuery.trim()}".',
          actionLabel: 'Hapus filter',
          onAction: _resetFilters,
        );
      }

      if (hasCategory) {
        return AppFeedbackView.empty(
          title: 'Kategori masih kosong',
          message:
              'Belum ada menu pada kategori '
              '$effectiveCategory.',
          actionLabel: 'Lihat semua menu',
          onAction: _resetFilters,
        );
      }

      return const AppFeedbackView.empty(
        title: 'Menu tidak ditemukan',
        message: 'Belum ada menu yang dapat ditampilkan.',
      );
    }

    return CatalogProductGrid(
      products: filteredProducts,
      onProductTap: (product) {
        context.pushNamed(MyRoute.detail.name, extra: product);
      },
    );
  }

  String _resolveSelectedCategory(List<String> categories) {
    for (final category in categories) {
      if (category.toLowerCase() == _selectedCategory.toLowerCase()) {
        return category;
      }
    }

    return CatalogProductFilter.allCategory;
  }

  void _handleSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  void _handleCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _resetFilters() {
    _searchController.clear();

    setState(() {
      _searchQuery = '';
      _selectedCategory = CatalogProductFilter.allCategory;
    });
  }

  void _reloadProducts() {
    context.read<ProductCatalogBloc>().add(LoadProducts());
  }
}
