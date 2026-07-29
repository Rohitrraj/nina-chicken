import 'package:flutter/material.dart';
import 'package:kedai_ayam_nina/core/images/cloudinary_image_url.dart';

class OptimizedNetworkImage extends StatelessWidget {
  const OptimizedNetworkImage(
    this.source, {
    super.key,
    this.maxDeliveryWidth = 1280,
    this.scale = 1,
    this.frameBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    this.width,
    this.height,
    this.color,
    this.opacity,
    this.colorBlendMode,
    this.fit,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.centerSlice,
    this.matchTextDirection = false,
    this.gaplessPlayback = false,
    this.filterQuality = FilterQuality.medium,
    this.isAntiAlias = false,
    this.headers,
    this.cacheWidth,
    this.cacheHeight,
  });

  final String source;
  final int maxDeliveryWidth;
  final double scale;
  final ImageFrameBuilder? frameBuilder;
  final ImageLoadingBuilder? loadingBuilder;
  final ImageErrorWidgetBuilder? errorBuilder;
  final String? semanticLabel;
  final bool excludeFromSemantics;
  final double? width;
  final double? height;
  final Color? color;
  final Animation<double>? opacity;
  final BlendMode? colorBlendMode;
  final BoxFit? fit;
  final AlignmentGeometry alignment;
  final ImageRepeat repeat;
  final Rect? centerSlice;
  final bool matchTextDirection;
  final bool gaplessPlayback;
  final FilterQuality filterQuality;
  final bool isAntiAlias;
  final Map<String, String>? headers;
  final int? cacheWidth;
  final int? cacheHeight;

  @override
  Widget build(BuildContext context) {
    if (source.trim().isEmpty) {
      return _fallback(context);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final deliveryWidth = _resolveDeliveryWidth(context, constraints);

        final optimizedSource = CloudinaryImageUrl.optimized(
          source,
          maxWidth: deliveryWidth,
        );

        return Image.network(
          optimizedSource,
          scale: scale,
          frameBuilder: frameBuilder ?? _defaultFrameBuilder,
          loadingBuilder: loadingBuilder,
          errorBuilder:
              errorBuilder ??
              (context, error, stackTrace) => _fallback(context),
          semanticLabel: semanticLabel,
          excludeFromSemantics: excludeFromSemantics,
          width: width,
          height: height,
          color: color,
          opacity: opacity,
          colorBlendMode: colorBlendMode,
          fit: fit,
          alignment: alignment,
          repeat: repeat,
          centerSlice: centerSlice,
          matchTextDirection: matchTextDirection,
          gaplessPlayback: gaplessPlayback,
          filterQuality: filterQuality,
          isAntiAlias: isAntiAlias,
          headers: headers,
          cacheWidth: cacheWidth,
          cacheHeight: cacheHeight,
        );
      },
    );
  }

  int _resolveDeliveryWidth(BuildContext context, BoxConstraints constraints) {
    final constrainedWidth = constraints.maxWidth.isFinite
        ? constraints.maxWidth
        : width;

    if (constrainedWidth == null || constrainedWidth <= 0) {
      return _bucketWidth(maxDeliveryWidth);
    }

    final pixelRatio = MediaQuery.devicePixelRatioOf(context);
    final requestedWidth = (constrainedWidth * pixelRatio).ceil();

    return _bucketWidth(
      requestedWidth.clamp(CloudinaryImageUrl.minimumWidth, maxDeliveryWidth),
    );
  }

  int _bucketWidth(num requestedWidth) {
    const buckets = <int>[320, 640, 960, 1280, 1600];

    for (final bucket in buckets) {
      if (requestedWidth <= bucket && bucket <= maxDeliveryWidth) {
        return bucket;
      }
    }

    return maxDeliveryWidth
        .clamp(CloudinaryImageUrl.minimumWidth, CloudinaryImageUrl.maximumWidth)
        .toInt();
  }

  Widget _defaultFrameBuilder(
    BuildContext context,
    Widget child,
    int? frame,
    bool wasSynchronouslyLoaded,
  ) {
    if (wasSynchronouslyLoaded || frame != null) {
      return child;
    }

    return _loadingPlaceholder(context);
  }

  Widget _loadingPlaceholder(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Center(
        child: SizedBox(
          width: 26,
          height: 26,
          child: CircularProgressIndicator(
            strokeWidth: 2.2,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }

  Widget _fallback(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
