import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kedai_ayam_nina/dependency_injection/dependency_injection.dart';
import 'package:kedai_ayam_nina/features/produk/domain/entities/product.dart';
import 'package:kedai_ayam_nina/features/produk/presentation/bloc/product_catalog_bloc.dart';
import 'package:kedai_ayam_nina/features/produk/presentation/bloc/product_mutation_bloc.dart';

class DetailProductPage extends StatelessWidget {
  final Product product;

  const DetailProductPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (_) => getIt<ProductMutationBloc>(),
      child: Builder(
        builder: (innerContext) => Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button + Title
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(innerContext).pop(),
                        icon: const Icon(Icons.arrow_back_rounded),
                        tooltip: "Kembali",
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        "Detail Produk",
                        style: theme.textTheme.displayMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Main Content: Image + Details side by side
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left: Image Gallery
                      Expanded(flex: 5, child: _buildImageSection(theme)),
                      const SizedBox(width: 40),

                      // Right: Product Info
                      Expanded(
                        flex: 5,
                        child: _buildInfoSection(theme, innerContext),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(ThemeData theme) {
    return Column(
      children: [
        // Main Image
        Container(
          height: 400,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child:
                product.imageUrl.isNotEmpty &&
                    product.imageUrl.first.startsWith('http')
                ? Image.network(
                    product.imageUrl.first,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _imagePlaceholder(),
                  )
                : _imagePlaceholder(),
          ),
        ),
        const SizedBox(height: 16),

        // Thumbnail gallery
        if (product.imageUrl.length > 1)
          SizedBox(
            height: 80,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: product.imageUrl.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                return Container(
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: index == 0
                          ? theme.colorScheme.primary
                          : Colors.grey.shade300,
                      width: index == 0 ? 2.5 : 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: product.imageUrl[index].startsWith('http')
                        ? Image.network(
                            product.imageUrl[index],
                            fit: BoxFit.cover,
                          )
                        : _imagePlaceholder(size: 30),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildInfoSection(ThemeData theme, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              product.category,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Product Name
          Text(
            product.name,
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          // Price
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFF57C00).withValues(alpha: 0.1),
                  const Color(0xFFFF9800).withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.sell_rounded,
                  color: const Color(0xFFD66B0D),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  "Rp ${_formatCurrency(product.price)}",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD66B0D),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Divider
          Divider(color: Colors.grey.shade200),
          const SizedBox(height: 20),

          // Short Description
          Text(
            "Deskripsi Singkat",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            product.shortDescription,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.grey.shade700,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),

          // Full Description
          Text(
            "Deskripsi Lengkap",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            product.description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 28),

          // Divider
          Divider(color: Colors.grey.shade200),
          const SizedBox(height: 20),

          // Product Info Cards
          Text(
            "Informasi Produk",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _infoChip(
                icon: Icons.category_rounded,
                label: "Kategori",
                value: product.category,
                color: const Color(0xFF5D6037),
                theme: theme,
              ),
              const SizedBox(width: 12),
              _infoChip(
                icon: Icons.photo_library_rounded,
                label: "Gambar",
                value: "${product.imageUrl.length} foto",
                color: const Color(0xFF1976D2),
                theme: theme,
              ),
            ],
          ),
          const SizedBox(height: 28),

          // Action Buttons
          BlocListener<ProductCatalogBloc, ProductCatalogState>(
            bloc: getIt<ProductCatalogBloc>(),
            listener: (context, state) {
              if (state is ProductCatalogActionSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Produk berhasil dihapus"),
                    backgroundColor: Color(0xFF2E7D32),
                  ),
                );
                context.go('/admin/catalog');
              }
            },
            child: BlocListener<ProductMutationBloc, ProductMutationState>(
              listener: (context, state) {
                if (state is ProductMutationSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: const Color(0xFF2E7D32),
                    ),
                  );
                  // Refresh catalog singleton lalu kembali
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
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.go('/admin/catalog/mutation', extra: product);
                      },
                      icon: const Icon(Icons.edit_rounded, size: 18),
                      label: const Text("Edit Produk"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD66B0D),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (dialogCtx) => AlertDialog(
                          title: const Text("Hapus Produk"),
                          content: Text(
                            "Yakin ingin menghapus \"${product.name}\"?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(dialogCtx),
                              child: const Text("Batal"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(dialogCtx);
                                // Pakai ProductCatalogBloc singleton — sudah auto-reload setelah delete
                                getIt<ProductCatalogBloc>().add(
                                  DeleteProductEvent(product),
                                );
                              },
                              child: const Text(
                                "Hapus",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.delete_outline_rounded, size: 18),
                    label: const Text("Hapus"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red.shade600,
                      side: BorderSide(color: Colors.red.shade300),
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 24,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required ThemeData theme,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _imagePlaceholder({double size = 50}) {
    return Center(
      child: Icon(
        Icons.fastfood_rounded,
        color: Colors.grey.shade400,
        size: size,
      ),
    );
  }

  String _formatCurrency(double value) {
    final str = value.toStringAsFixed(0);
    final result = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      result.write(str[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        result.write('.');
      }
    }
    return result.toString().split('').reversed.join();
  }
}
