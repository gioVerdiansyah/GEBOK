import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;

  const LoadImage({super.key, required this.url, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    if (url.startsWith('asset')) {
      return Image.asset(
        url,
        fit: BoxFit.cover,
        width: width,
        height: height,
      );
    }

    return Image.network(
      url,
      fit: BoxFit.cover,
      width: width,
      height: height,
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return _buildSkeleton();
      },
      errorBuilder: (context, error, stackTrace) {
        return const Center(child: Icon(Icons.error));
      },
    );
  }

  Widget _buildSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
      ),
    );
  }
}

class LoadCachedImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;

  const LoadCachedImage({super.key, required this.url, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    if (url.startsWith('asset')) {
      return Image.asset(
        url,
        fit: BoxFit.cover,
        width: width,
        height: height,
      );
    }

    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      ),
      placeholder: (context, url) => _buildSkeleton(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }

  Widget _buildSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
      ),
    );
  }
}
