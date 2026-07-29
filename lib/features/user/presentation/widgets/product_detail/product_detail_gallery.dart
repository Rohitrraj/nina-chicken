import 'package:flutter/material.dart';
import 'package:kedai_ayam_nina/core/assets.dart';
import 'package:kedai_ayam_nina/core/design_system/design_system.dart';
import 'package:kedai_ayam_nina/core/widgets/card/cards.dart';

import 'package:kedai_ayam_nina/core/widgets/images/optimized_network_image.dart';

typedef ProductDetailImageBuilder =
    Widget Function(BuildContext context, String imageUrl, BoxFit fit);

class ProductDetailGallery extends StatefulWidget {
  const ProductDetailGallery({
    super.key,
    required this.productName,
    required this.imageUrls,
    this.imageBuilder,
  });

  final String productName;
  final List<String> imageUrls;

  /// Disediakan agar rendering gambar dapat diganti saat widget test.
  final ProductDetailImageBuilder? imageBuilder;

  @override
  State<ProductDetailGallery> createState() => _ProductDetailGalleryState();
}

class _ProductDetailGalleryState extends State<ProductDetailGallery> {
  late List<String> _imageUrls;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _synchronizeImages();
  }

  @override
  void didUpdateWidget(covariant ProductDetailGallery oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.imageUrls != widget.imageUrls) {
      _synchronizeImages();
    }
  }

  void _synchronizeImages() {
    _imageUrls = widget.imageUrls
        .map((url) => url.trim())
        .where((url) => url.isNotEmpty)
        .toList();

    if (_selectedIndex >= _imageUrls.length) {
      _selectedIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_imageUrls.isEmpty) {
      return const AppCard(
        premium: true,
        padding: EdgeInsets.zero,
        child: AspectRatio(
          aspectRatio: 4 / 3,
          child: _ProductImageFallback(
            key: ValueKey<String>('product-detail-image-fallback'),
          ),
        ),
      );
    }

    final selectedImage = _imageUrls[_selectedIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppCard(
          premium: true,
          padding: EdgeInsets.zero,
          semanticLabel: 'Foto ${widget.productName}',
          child: ClipRRect(
            borderRadius: AppRadius.md,
            child: AspectRatio(
              aspectRatio: 4 / 3,
              child: KeyedSubtree(
                key: ValueKey<String>(
                  'product-detail-main-image-$_selectedIndex',
                ),
                child: _buildImage(context, selectedImage, BoxFit.cover),
              ),
            ),
          ),
        ),
        if (_imageUrls.length > 1) ...[
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 82,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _imageUrls.length,
              separatorBuilder: (_, _) {
                return const SizedBox(width: AppSpacing.sm);
              },
              itemBuilder: (context, index) {
                final selected = index == _selectedIndex;

                return _ProductThumbnail(
                  key: ValueKey<String>('product-detail-thumbnail-$index'),
                  selected: selected,
                  semanticLabel:
                      'Pilih foto ${index + 1} '
                      '${widget.productName}',
                  onTap: () {
                    if (!selected) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    }
                  },
                  child: _buildImage(context, _imageUrls[index], BoxFit.cover),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildImage(BuildContext context, String imageUrl, BoxFit fit) {
    final customBuilder = widget.imageBuilder;

    if (customBuilder != null) {
      return customBuilder(context, imageUrl, fit);
    }

    return _NetworkProductImage(imageUrl: imageUrl, fit: fit);
  }
}

class _ProductThumbnail extends StatelessWidget {
  const _ProductThumbnail({
    super.key,
    required this.selected,
    required this.semanticLabel,
    required this.onTap,
    required this.child,
  });

  final bool selected;
  final String semanticLabel;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      button: true,
      selected: selected,
      label: semanticLabel,
      child: Material(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.sm,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.sm,
          mouseCursor: SystemMouseCursors.click,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            width: 82,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: AppRadius.sm,
              border: Border.all(
                color: selected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outlineVariant,
                width: selected ? 2.5 : 1,
              ),
            ),
            child: ClipRRect(borderRadius: AppRadius.xs, child: child),
          ),
        ),
      ),
    );
  }
}

class _NetworkProductImage extends StatelessWidget {
  const _NetworkProductImage({required this.imageUrl, required this.fit});

  final String imageUrl;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final uri = Uri.tryParse(imageUrl);
    final validScheme =
        uri != null && (uri.scheme == 'http' || uri.scheme == 'https');

    if (!validScheme) {
      return const _ProductImageFallback();
    }

    return OptimizedNetworkImage(
      imageUrl,
      fit: fit,
      filterQuality: FilterQuality.medium,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }

        return const _ProductImageLoading();
      },
      errorBuilder: (context, error, stackTrace) {
        return const _ProductImageFallback();
      },
    );
  }
}

class _ProductImageLoading extends StatelessWidget {
  const _ProductImageLoading();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ColoredBox(
      color: theme.colorScheme.surfaceContainerHighest,
      child: const Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}

class _ProductImageFallback extends StatelessWidget {
  const _ProductImageFallback({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ColoredBox(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Opacity(
            opacity: 0.55,
            child: Image.asset(
              Assets.logoC1,
              fit: BoxFit.contain,
              semanticLabel: 'Logo Kedai Ayam Nina',
            ),
          ),
        ),
      ),
    );
  }
}
