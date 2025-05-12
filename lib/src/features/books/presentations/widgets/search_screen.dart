import 'package:book_shelf/src/core/di/injection.dart';
import 'package:book_shelf/src/features/books/domain/entities/simple_book_entity.dart';
import 'package:book_shelf/src/features/books/presentations/blocs/bloc/book_cubit.dart';
import 'package:book_shelf/src/features/books/presentations/blocs/state/book_state.dart';
import 'package:book_shelf/src/shared/constants/color_constant.dart';
import 'package:book_shelf/src/shared/widgets/others/list_paged_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/utils/book_query_handler.dart';
import '../../../../shared/utils/string_util.dart';
import '../../../../shared/widgets/loading/image_load.dart';

class SearchScreen extends StatefulWidget {
  final String searchQuery;

  const SearchScreen({super.key, this.searchQuery = ''});

  @override
  State<StatefulWidget> createState() => _SearchView();
}

class _SearchView extends State<SearchScreen> {
  late final TextEditingController _searchController;
  late final BookCubit _cubit;

  @override
  void initState() {
    super.initState();

    _searchController = TextEditingController(text: widget.searchQuery);
    _cubit = getIt<BookCubit>();
  }

  void _performSearch() {
    _cubit.pagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (context) => _cubit,
          child: BlocBuilder<BookCubit, BookState>(
            builder: (context, state) {
              return Column(children: [
                _buildInput(context, state),
                if (state.query != null) _searchResult(context, state)
              ]);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInput(BuildContext context, BookState state) {
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black54, width: 2))),
      child: Row(
        children: [
          IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back, color: Colors.black54)),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Cari buku apapun...",
                border: InputBorder.none,
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: ColorConstant.primary, width: 2)),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
              autofocus: true,
              onTapUpOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              style: TextStyle(fontSize: 16),
              cursorColor: ColorConstant.primary,
              onChanged: (value) => context.read<BookCubit>().setQuery(BookQuery(title: value)),
              onSubmitted: (_) => _performSearch()
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchResult(BuildContext context, BookState state) {
    return Flexible(
      child: ListPagedView<SimpleBookEntity>(
        controller: _cubit.pagingController,
        title: "buku",
        itemBuilder: (context, item, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(index.toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: shimmerImage(item.thumbnail, width: 140, height: 190),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)),
                      ...[
                        if (item.rating != null && item.discountPrice == null) ...[
                          Expanded(
                            child: Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 14),
                                const SizedBox(width: 2),
                                Text(item.rating!.toString(), style: const TextStyle(fontSize: 12)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ],
                      ...[
                        if (item.discountPrice != null) ...[
                          Text(
                            "${item.currencyCode} ${formatNumToIdr(item.discountPrice!)}",
                            style: TextStyle(decoration: TextDecoration.lineThrough, fontSize: 12),
                          ),
                          const SizedBox(width: 4),
                        ],
                      ],
                      if (item.originalPrice != null)
                        Text(
                          "${item.currencyCode} ${formatNumToIdr(item.originalPrice!)}",
                          style: const TextStyle(fontSize: 12),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
