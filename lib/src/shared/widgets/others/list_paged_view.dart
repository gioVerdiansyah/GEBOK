import 'package:book_shelf/src/shared/constants/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ListPagedView<T> extends StatelessWidget {
  final PagingController<int, T> controller;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final String title;
  final EdgeInsets? padding;
  final Axis? scrollDirection;

  const ListPagedView({
    super.key,
    required this.controller,
    required this.itemBuilder,
    this.padding,
    this.scrollDirection,
    this.title = "data",
  });

  @override
  Widget build(BuildContext context) {
    return PagingListener(
      controller: controller,
      builder: (context, state, fetchNextPage) => PagedListView<int, T>(
        fetchNextPage: fetchNextPage,
        state: state,
        shrinkWrap: true,
        padding: padding,
        scrollDirection: scrollDirection ?? Axis.vertical,
        builderDelegate: PagedChildBuilderDelegate<T>(
          itemBuilder: (context, item, index) => itemBuilder(context, item, index),
          noItemsFoundIndicatorBuilder:
              (_) => SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Belum ada $title...",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const Text(
                    "Cobalah lagi nanti...",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: ColorConstant.gray,
                    ),
                  ),
                ],
              ),
            ),
          ),
          firstPageErrorIndicatorBuilder:
              (context) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Error...", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                Text(state.error.toString()),
                FittedBox(
                  child: ElevatedButton(
                    onPressed: () => fetchNextPage(),
                    child: const Row(
                      children: [
                        Icon(Icons.refresh, color: ColorConstant.primary),
                        SizedBox(width: 3),
                        Text('Refresh', style: TextStyle(color: ColorConstant.primary)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          newPageProgressIndicatorBuilder:
              (_) => const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(ColorConstant.primary)),
            ),
          ),
          firstPageProgressIndicatorBuilder:
              (_) => const Center(
            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(ColorConstant.primary)),
          ),
        ),
      ),
    );
  }
}
