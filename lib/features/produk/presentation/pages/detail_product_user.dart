import 'package:flutter/material.dart';
import 'package:kedai_ayam_nina/features/produk/domain/entities/product.dart';

class DetailProductUserPage extends StatelessWidget {
  final Product product;

  const DetailProductUserPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(isDesktop ? 32 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button + Title
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
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
                    style: isDesktop
                        ? theme.textTheme.displayMedium
                        : theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Main Content: Image + Details responsive
              isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left: Image Gallery
                        Expanded(flex: 5, child: _buildImageSection(theme)),
                        const SizedBox(width: 40),

                        // Right: Product Info
                        Expanded(flex: 5, child: _buildInfoSection(theme)),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildImageSection(theme),
                        const SizedBox(height: 24),
                        _buildInfoSection(theme),
                      ],
                    ),
            ],
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

  Widget _buildInfoSection(ThemeData theme) {
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
            ],
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
