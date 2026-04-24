import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';

class EbzimImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;
  final bool showPlaceholder;
  final Widget? errorWidget;
  final bool useShimmer;

  const EbzimImage({
    super.key,
    this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 0,
    this.showPlaceholder = true,
    this.errorWidget,
    this.useShimmer = true,
  });

  @override
  Widget build(BuildContext context) {
    // Sanitize URL
    final String? sanitizedUrl = imageUrl?.trim();

    if (sanitizedUrl == null || sanitizedUrl.isEmpty || sanitizedUrl.contains('placehold.co')) {
      return _buildErrorWidget();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: sanitizedUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => useShimmer ? _buildShimmer() : _buildDefaultPlaceholder(),
        errorWidget: (context, url, error) => errorWidget ?? _buildErrorWidget(),
        fadeInDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: AppTheme.primaryColor.withOpacity(0.1),
      highlightColor: AppTheme.primaryColor.withOpacity(0.05),
      child: Container(
        width: width ?? double.infinity,
        height: height ?? double.infinity,
        color: Colors.white,
      ),
    );
  }

  Widget _buildDefaultPlaceholder() {
    return Container(
      width: width ?? double.infinity,
      height: height ?? double.infinity,
      color: AppTheme.primaryColor.withOpacity(0.05),
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentColor),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Center(
        child: Icon(
          Icons.broken_image_outlined,
          color: AppTheme.primaryColor.withOpacity(0.2),
          size: (width != null && width! < 50) ? 20 : 32,
        ),
      ),
    );
  }
}
