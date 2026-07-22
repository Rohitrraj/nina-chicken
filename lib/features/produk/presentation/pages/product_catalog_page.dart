import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kedai_ayam_nina/core/widgets/card/card_product.dart';
import '../../../../dependency_injection/dependency_injection.dart';
import '../bloc/product_catalog_bloc.dart';

class ProductCatalogPage extends StatefulWidget {
  const ProductCatalogPage({super.key});

  @override
  State<ProductCatalogPage> createState() => _ProductCatalogPageState();
}

class _ProductCatalogPageState extends State<ProductCatalogPage> {
  late final ProductCatalogBloc _catalogBloc;

  @override
  void initState() {
    super.initState();

    _catalogBloc = getIt<ProductCatalogBloc>();

    if (_catalogBloc.state is ProductCatalogInitial) {
      _catalogBloc.add(LoadProducts());
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    // Singleton tidak di-dispose ketika halaman dilepas.
    return BlocProvider.value(
      value: _catalogBloc,
      child: Scaffold(
        backgroundColor: const Color(0xFFFDFBF0),
        body: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              !isMobile
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Product Catalog",
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD66B0D),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                          ),
                          onPressed: () =>
                              context.go('/admin/catalog/mutation'),
                          icon: const Icon(Icons.add, color: Colors.white),
                          label: const Text(
                            "Add New Product",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Product Catalog",
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD66B0D),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () =>
                              context.go('/admin/catalog/mutation'),
                          icon: const Icon(Icons.add, color: Colors.white),
                          label: const Text(
                            "Add New Product",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
              const SizedBox(height: 8),
              const Text("Manage the delightful offerings of Nina's Kitchen."),
              const SizedBox(height: 32),
              Expanded(
                child: BlocConsumer<ProductCatalogBloc, ProductCatalogState>(
                  listener: (context, state) {
                    if (state is ProductCatalogActionSuccess) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.message)));
                    } else if (state is ProductCatalogError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is ProductCatalogLoading ||
                        state is ProductCatalogInitial) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ProductCatalogLoaded) {
                      if (state.products.isEmpty) {
                        return const Center(
                          child: Text("No products found in the catalog."),
                        );
                      }

                      // PERUBAHAN: Menggunakan GridView.builder
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent:
                                  320, // Lebar maksimal tiap card
                              mainAxisExtent: 340, // Tinggi pasti tiap card
                              crossAxisSpacing:
                                  24, // Jarak horizontal antar card
                              mainAxisSpacing: 24, // Jarak vertikal antar card
                            ),
                        itemCount: state.products.length,
                        itemBuilder: (context, index) {
                          final product = state.products[index];
                          return ProductGridItem(
                            product: product,
                            onTapCard: () {
                              context.go(
                                '/admin/catalog/detail',
                                extra: product,
                              );
                            },
                            onDelete: () {
                              // Logika delete dipindah ke sini agar rapi
                              showDialog(
                                context: context,
                                builder: (dialogCtx) => AlertDialog(
                                  title: const Text("Delete Product"),
                                  content: const Text(
                                    "Are you sure you want to delete ?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(dialogCtx),
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(dialogCtx);
                                        context.read<ProductCatalogBloc>().add(
                                          DeleteProductEvent(product),
                                        );
                                      },
                                      child: const Text(
                                        "Delete",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
