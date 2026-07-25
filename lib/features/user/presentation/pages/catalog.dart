import 'package:flutter/material.dart';
import 'package:kedai_ayam_nina/core/design_system/design_system.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kedai_ayam_nina/core/widgets/animated_scroll_item.dart';
import 'package:kedai_ayam_nina/core/widgets/card/card_product.dart';
import 'package:kedai_ayam_nina/core/widgets/feedback/feedback.dart';
import 'package:kedai_ayam_nina/features/produk/presentation/bloc/product_catalog_bloc.dart';
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
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();

    context.read<ProductCatalogBloc>().add(LoadProducts());
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = AppBreakpoints.isDesktopWidth(screenWidth);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: isDesktop ? null : const UserDrawer(),
      bottomNavigationBar: UserFooter(isDesktop: isDesktop),
      body: CustomScrollView(
        slivers: [
          UserNavBar(isDesktop: isDesktop),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 64 : 24,
                vertical: 48,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedScrollItem(
                    id: 'catalog_title',
                    child: Text(
                      'Our Menu',
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: -1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  AnimatedScrollItem(
                    id: 'catalog_subtitle',
                    child: Text(
                      'Discover the golden, crispy perfection of '
                      'Kedai Ayam Nina. From our signature original '
                      'recipe to fiery geprek, every bite is a taste '
                      'of home.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  AnimatedScrollItem(
                    id: 'catalog_cats',
                    child: _buildCategories(context),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          BlocBuilder<ProductCatalogBloc, ProductCatalogState>(
            builder: (context, state) {
              if (state is ProductCatalogLoading) {
                return const SliverFillRemaining(
                  hasScrollBody: false,
                  child: AppLoadingView(message: 'Memuat daftar menu...'),
                );
              }

              if (state is ProductCatalogLoaded) {
                final products = state.products;

                if (products.isEmpty) {
                  return const SliverFillRemaining(
                    hasScrollBody: false,
                    child: AppFeedbackView.empty(
                      title: 'Menu belum tersedia',
                      message: 'Daftar menu Kedai Ayam Nina masih kosong.',
                    ),
                  );
                }

                final filteredProducts = selectedCategory == 'All'
                    ? products
                    : products
                          .where(
                            (product) =>
                                product.category.toLowerCase() ==
                                selectedCategory.toLowerCase(),
                          )
                          .toList();

                if (filteredProducts.isEmpty) {
                  return const SliverFillRemaining(
                    hasScrollBody: false,
                    child: AppFeedbackView.empty(
                      title: 'Produk tidak ditemukan',
                      message: 'Belum ada produk pada kategori yang dipilih.',
                    ),
                  );
                }

                return SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 64 : 24,
                  ).copyWith(bottom: 64),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isDesktop ? 3 : 1,
                      mainAxisSpacing: 24,
                      crossAxisSpacing: 24,
                      childAspectRatio: isDesktop ? 0.8 : 0.85,
                    ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final product = filteredProducts[index];

                      return AnimatedScrollItem(
                        id: 'product_$index',
                        child: ProductGridItem(
                          product: product,
                          isAdmin: false,
                          onDelete: () {},
                          onTapCard: () {
                            context.pushNamed(
                              MyRoute.detail.name,
                              extra: product,
                            );
                          },
                        ),
                      );
                    }, childCount: filteredProducts.length),
                  ),
                );
              }

              return SliverFillRemaining(
                hasScrollBody: false,
                child: AppFeedbackView.error(
                  title: 'Gagal memuat produk',
                  message: 'Terjadi kendala ketika mengambil daftar menu.',
                  actionLabel: 'Coba lagi',
                  onAction: () {
                    context.read<ProductCatalogBloc>().add(LoadProducts());
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategories(BuildContext context) {
    final theme = Theme.of(context);
    const categories = ['All', 'Food', 'Beverage'];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: categories.map((category) {
        final isSelected = selectedCategory == category;

        return InkWell(
          onTap: () {
            setState(() {
              selectedCategory = category;
            });
          },
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outlineVariant,
              ),
            ),
            child: Text(
              category,
              style: theme.textTheme.labelLarge?.copyWith(
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
