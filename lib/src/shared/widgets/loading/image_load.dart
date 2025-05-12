import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget shimmerImage(String imageUrl, {double? width, double? height}) {
  return Image.network(
    imageUrl,
    width: width,
    height: height,
    fit: BoxFit.cover,
    loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null) return child;
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: width,
          height: height,
          color: Colors.white,
        ),
      );
    },
    errorBuilder: (context, error, stackTrace) {
      return Container(
        width: width,
        height: height,
        color: Colors.grey[300],
        child: const Center(child: Icon(Icons.broken_image, size: 40)),
      );
    },
  );
}
