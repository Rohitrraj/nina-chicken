import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kedai_ayam_nina/core/design_system/design_system.dart';
import 'package:kedai_ayam_nina/core/widgets/animated_scroll_item.dart';
import 'package:kedai_ayam_nina/features/produk/presentation/bloc/product_catalog_bloc.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/home/home.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/user_drawer.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/user_footer.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/user_navbar.dart';
import 'package:kedai_ayam_nina/router/router.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();

    context.read<ProductCatalogBloc>().add(LoadProducts());
  }

  @override
  Widget build(BuildContext context) {
    final viewportWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = AppBreakpoints.isDesktopWidth(viewportWidth);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.brightness == Brightness.light
          ? AppColors.publicBackground
          : theme.scaffoldBackgroundColor,
      drawer: isDesktop ? null : const UserDrawer(),
      body: CustomScrollView(
        slivers: [
          UserNavBar(isDesktop: isDesktop),
          SliverToBoxAdapter(
            child: AnimatedScrollItem(
              id: 'home_hero',
              child: HomeHeroSection(onViewMenu: _openCatalog),
            ),
          ),
          SliverToBoxAdapter(
            child: AnimatedScrollItem(
              id: 'home_featured_menu',
              child: BlocBuilder<ProductCatalogBloc, ProductCatalogState>(
                builder: (context, state) {
                  if (state is ProductCatalogLoading ||
                      state is ProductCatalogInitial) {
                    return HomeFeaturedMenuSection.loading(
                      onViewAll: _openCatalog,
                    );
                  }

                  if (state is ProductCatalogLoaded) {
                    if (state.products.isEmpty) {
                      return HomeFeaturedMenuSection.empty(
                        onViewAll: _openCatalog,
                      );
                    }

                    return HomeFeaturedMenuSection.loaded(
                      products: state.products,
                      onViewAll: _openCatalog,
                      onProductTap: (product) {
                        context.pushNamed(MyRoute.detail.name, extra: product);
                      },
                    );
                  }

                  if (state is ProductCatalogError) {
                    return HomeFeaturedMenuSection.error(
                      onViewAll: _openCatalog,
                      onRetry: _reloadProducts,
                    );
                  }

                  return HomeFeaturedMenuSection.loading(
                    onViewAll: _openCatalog,
                  );
                },
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: AnimatedScrollItem(
              id: 'home_values',
              child: HomeValueSection(),
            ),
          ),
          SliverToBoxAdapter(
            child: AnimatedScrollItem(
              id: 'home_about',
              child: HomeAboutPreview(onReadMore: _openAbout),
            ),
          ),
          SliverToBoxAdapter(
            child: AnimatedScrollItem(
              id: 'home_cta',
              child: HomeCtaSection(onContact: _openContact),
            ),
          ),
          SliverToBoxAdapter(child: UserFooter(isDesktop: isDesktop)),
        ],
      ),
    );
  }

  void _reloadProducts() {
    context.read<ProductCatalogBloc>().add(
      const LoadProducts(forceRefresh: true),
    );
  }

  void _openCatalog() {
    context.goNamed(MyRoute.catalog.name);
  }

  void _openAbout() {
    context.goNamed(MyRoute.about.name);
  }

  void _openContact() {
    context.goNamed(MyRoute.contactUs.name);
  }
}
