import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'book_skeleton.dart';

class BookHorizontalSkeleton extends StatelessWidget {
  const BookHorizontalSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title skeleton
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: 430,
                height: 18,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            )
        ),
        const SizedBox(height: 5),
        // This expanded height will match the actual ListView in home_screen.dart
        SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 10,
            itemBuilder: (context, index) => const BookSkeleton(),
          ),
        ),
      ],
    );
  }
}