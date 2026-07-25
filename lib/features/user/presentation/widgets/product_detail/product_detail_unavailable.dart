import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kedai_ayam_nina/core/design_system/design_system.dart';
import 'package:kedai_ayam_nina/core/widgets/feedback/feedback.dart';
import 'package:kedai_ayam_nina/core/widgets/layout/layout.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/user_drawer.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/user_footer.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/user_navbar.dart';
import 'package:kedai_ayam_nina/router/router.dart';

class ProductDetailUnavailableView extends StatelessWidget {
  const ProductDetailUnavailableView({
    super.key,
    required this.onBackToCatalog,
  });

  final VoidCallback onBackToCatalog;

  @override
  Widget build(BuildContext context) {
    return AppFeedbackView.info(
      title: 'Produk tidak tersedia',
      message:
          'Informasi produk tidak ditemukan. '
          'Buka kembali katalog untuk memilih menu.',
      actionLabel: 'Kembali ke Menu',
      onAction: onBackToCatalog,
    );
  }
}

class ProductDetailUnavailablePage extends StatelessWidget {
  const ProductDetailUnavailablePage({super.key});

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
            child: AppSection(
              spacing: AppSectionSpacing.spacious,
              child: ProductDetailUnavailableView(
                onBackToCatalog: () {
                  context.goNamed(MyRoute.catalog.name);
                },
              ),
            ),
          ),
          SliverToBoxAdapter(child: UserFooter(isDesktop: isDesktop)),
        ],
      ),
    );
  }
}
