import 'package:flutter/material.dart';
import 'package:kedai_ayam_nina/core/design_system/design_system.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kedai_ayam_nina/core/assets.dart';
import 'package:kedai_ayam_nina/core/widgets/animated_scroll_item.dart';
import 'package:kedai_ayam_nina/core/widgets/card/card_product.dart';
import 'package:kedai_ayam_nina/core/widgets/custom_button_gradient.dart';
import 'package:kedai_ayam_nina/features/produk/presentation/bloc/product_catalog_bloc.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/user_navbar.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/user_footer.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/user_drawer.dart';
import 'package:go_router/go_router.dart';
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
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = AppBreakpoints.isDesktopWidth(screenWidth);

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF0),
      drawer: isDesktop ? null : const UserDrawer(),
      bottomNavigationBar: UserFooter(isDesktop: isDesktop),
      body: CustomScrollView(
        slivers: [
          UserNavBar(isDesktop: isDesktop),

          // Section 1: Hero
          SliverToBoxAdapter(
            child: AnimatedScrollItem(
              id: 'dash_hero',
              child: _buildHeroSection(isDesktop),
            ),
          ),

          // Section 2: Best Sellers
          SliverToBoxAdapter(
            child: AnimatedScrollItem(
              id: 'dash_best_seller',
              child: _buildBestSellersSection(isDesktop),
            ),
          ),

          // Section 3: Rooted in Tradition
          SliverToBoxAdapter(
            child: AnimatedScrollItem(
              id: 'dash_footer',
              child: _buildFooterSection(isDesktop),
            ),
          ),

          // Section 4: Contact Us
          SliverToBoxAdapter(
            child: AnimatedScrollItem(
              id: 'dash_contact',
              child: _buildContactUsSection(isDesktop),
            ),
          ),

          // Footer
        ],
      ),
    );
  }

  Widget _buildHeroSection(bool isDesktop) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 64.0 : 24.0,
        vertical: 48.0,
      ),
      child: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: _buildHeroText()),
                const SizedBox(width: 64),
                Expanded(child: _buildHeroImage()),
              ],
            )
          : Column(
              children: [
                _buildHeroText(),
                const SizedBox(height: 32),
                _buildHeroImage(),
              ],
            ),
    );
  }

  Widget _buildHeroText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Image.asset(Assets.logoC1, fit: BoxFit.fitWidth),
          ),
        ),
        const SizedBox(height: 24),
        RichText(
          text: const TextSpan(
            style: TextStyle(
              fontSize: 52,
              fontWeight: FontWeight.w900,
              color: Colors.black87,
              height: 1.1,
            ),
            children: [
              TextSpan(text: "The Modern Hearth of "),
              TextSpan(
                text: "Perfectly Fried ",
                style: TextStyle(color: Color(0xFF8B4513)),
              ),
              TextSpan(text: "Chicken."),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          "Experience the warmth of our kitchen. Golden-brown textures, artisan quality, and flavors that feel like home.",
          style: TextStyle(fontSize: 18, color: Colors.black54),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: 250,
          child: CustomGradientButton(
            text: "View All Menu",
            onTap: () {
              context.goNamed(MyRoute.catalog.name);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeroImage() {
    return Container(
      height: 500,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(32),
        image: const DecorationImage(
          image: NetworkImage(
            "https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?q=80&w=1000&auto=format&fit=crop",
          ), // Placeholder Fried Chicken
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildBestSellersSection(bool isDesktop) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 64.0 : 24.0,
        vertical: 48.0,
      ),
      color: const Color(0xFFF9F7E8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Best Sellers",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Curated favorites from our kitchen.",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  context.goNamed(MyRoute.catalog.name);
                },
                child: const Row(
                  children: [
                    Text(
                      "View Full Menu",
                      style: TextStyle(
                        color: Color(0xFF8B4513),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.arrow_forward, color: Color(0xFF8B4513)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          BlocBuilder<ProductCatalogBloc, ProductCatalogState>(
            builder: (context, state) {
              if (state is ProductCatalogLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ProductCatalogLoaded) {
                final products = state.products;
                if (products.isEmpty) {
                  return const Center(child: Text("Menu belum tersedia."));
                }

                final bestSellers = products.take(2).toList();

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 320,
                    mainAxisExtent: 340,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                  ),
                  itemCount: bestSellers.length,
                  itemBuilder: (context, index) {
                    final product = bestSellers[index];
                    return ProductGridItem(
                      product: product,
                      isAdmin: false,
                      onDelete: () {},
                      onTapCard: () => context.pushNamed(
                        MyRoute.detail.name,
                        extra: product,
                      ),
                    );
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFooterSection(bool isDesktop) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isDesktop ? 64.0 : 24.0,
        vertical: 64.0,
      ),
      padding: EdgeInsets.all(isDesktop ? 64.0 : 32.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF2EFE5),
        borderRadius: BorderRadius.circular(40),
      ),
      child: isDesktop
          ? Row(
              children: [
                Expanded(child: _buildFooterText()),
                const SizedBox(width: 64),
                Expanded(child: _buildFooterImage()),
              ],
            )
          : Column(
              children: [
                _buildFooterText(),
                const SizedBox(height: 32),
                _buildFooterImage(),
              ],
            ),
    );
  }

  Widget _buildFooterText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Rooted in Tradition,\nCrafted for Today.",
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          "Kedai Ayam Nina started with a simple belief: fried chicken should be an experience, not just a meal. We source local ingredients, marinate overnight, and fry to order.",
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
        const SizedBox(height: 16),
        const Text(
          "Our hearth is always warm, and our doors are always open. Come taste the difference intention makes.",
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
        const SizedBox(height: 32),
        TextButton(
          onPressed: () {
            context.goNamed(MyRoute.about.name);
          },
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Read Our Story",
                style: TextStyle(
                  color: Color(0xFF8B4513),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward, color: Color(0xFF8B4513)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooterImage() {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: const DecorationImage(
          image: NetworkImage(
            "https://images.unsplash.com/photo-1555939594-58d7cb561ad1?q=80&w=1000&auto=format&fit=crop",
          ), // Placeholder Chef
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildContactUsSection(bool isDesktop) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 64.0 : 24.0,
        vertical: 48.0,
      ),
      color: const Color(0xFFFDFBF0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Contact Us",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Punya pertanyaan atau masukan? Jangan ragu untuk menghubungi kami.",
            style: TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
          ),
          const SizedBox(height: 32),
          _buildContactCard(Icons.phone, "Phone", "+62 895-3832-05337"),
          const SizedBox(height: 16),
          _buildContactCard(
            Icons.location_on,
            "Location",
            "Jakarta Barat, Indonesia",
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(IconData icon, String title, String content) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFDFBF0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF8B4513)),
          ),
          const SizedBox(width: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
