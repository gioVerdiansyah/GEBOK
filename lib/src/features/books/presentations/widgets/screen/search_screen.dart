import 'package:book_shelf/src/core/di/injection.dart';
import 'package:book_shelf/src/features/books/domain/entities/simple_book_entity.dart';
import 'package:book_shelf/src/features/books/presentations/blocs/bloc/book_cubit.dart';
import 'package:book_shelf/src/features/books/presentations/blocs/state/book_state.dart';
import 'package:book_shelf/src/features/books/presentations/widgets/screen/filter_screen.dart';
import 'package:book_shelf/src/shared/constants/color_constant.dart';
import 'package:book_shelf/src/shared/widgets/list/list_paged_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../../shared/utils/book_query_handler.dart';
import '../../../../../shared/utils/string_util.dart';
import '../../../../../shared/widgets/loading/image_load.dart';

class SearchScreen extends StatefulWidget {
  final String titleSearch;
  final BookQuery? query;

  const SearchScreen({super.key, this.titleSearch = '', this.query});

  @override
  State<StatefulWidget> createState() => _SearchView();
}

class _SearchView extends State<SearchScreen> {
  late final TextEditingController _searchController;
  late final BookCubit _cubit;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();

    _searchController = TextEditingController(text: widget.titleSearch);
    _cubit = getIt<BookCubit>();

    // INITIAL
    if (widget.titleSearch.isNotEmpty) {
      _cubit.setQuery(widget.query);
      _cubit.setOnSearch(true);
      _cubit.fetchPagination(0);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  void _performSearch() {
    final value = _searchController.text;
    _cubit.setOnSearch(value.isNotEmpty);

    if (value.isNotEmpty) {
      final BookQuery? query = _cubit.state.query;
      _cubit.setWaitingSubmit(false);
      _cubit.resetPagination();
      _cubit.setQuery(
        BookQuery(generic: value, filterBy: query?.filterBy, orderBy: query?.orderBy, langRestrict: query?.langRestrict),
      );
      _cubit.fetchPagination(0);
    }
  }

  // Improved refresh function to properly reset pagination state
  Future<void> _refreshData() async {
    final value = _searchController.text;
    if (value.isNotEmpty || _cubit.state.query?.isApplyFilter() == true) {
      _cubit.setWaitingSubmit(false);
      _cubit.resetPagination();
      _cubit.setOnSearch(true);
      _cubit.fetchPagination(0);
    }
    return Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.secondary,
      body: SafeArea(
        child: BlocProvider(
          create: (context) => _cubit,
          child: BlocConsumer<BookCubit, BookState>(
            listenWhen: (previous, current) {
              return (previous.query != current.query || previous.onSearch != current.onSearch);
            },
            listener: (context, state) {
              // We no longer need to set _shouldFetchOnNextBuild flag
              // All refreshing is now handled in appropriate functions
            },
            builder: (context, state) {
              return Column(
                children: [
                  _buildInput(context, state),
                  if (state.onSearch)
                    Expanded(
                      child: RefreshIndicator(
                        key: _refreshIndicatorKey,
                        onRefresh: _refreshData,
                        color: ColorConstant.primary,
                        child: _searchResult(context, state),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInput(BuildContext context, BookState state) {
    final bool isApplyFilter = state.query?.isApplyFilter() ?? false;

    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black54, width: 1))),
      child: Row(
        children: [
          IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back, color: Colors.black54)),
          Expanded(
            child: StatefulBuilder(
              builder: (_, setInnerState) {
                _searchController.addListener(() {
                  setInnerState(() {});
                });

                return TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Cari buku apapun...",
                    border: InputBorder.none,
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: ColorConstant.primary, width: 2)),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                    suffixIcon:
                        _searchController.text.isNotEmpty
                            ? IconButton(
                              icon: Icon(Icons.close, color: Colors.black54),
                              onPressed: () {
                                _searchController.clear();
                                _cubit.resetPagination();
                                context.read<BookCubit>().setQuery(null);
                                context.read<BookCubit>().setOnSearch(false);
                              },
                            )
                            : null,
                  ),
                  autofocus: widget.titleSearch.isNotEmpty ? false : true,
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  style: TextStyle(fontSize: 16),
                  cursorColor: ColorConstant.primary,
                  onChanged: (value) {
                    context.read<BookCubit>().setQuery(
                      BookQuery(
                        generic: value,
                        filterBy: state.query?.filterBy,
                        orderBy: state.query?.orderBy,
                        langRestrict: state.query?.langRestrict,
                      ),
                    );
                  },
                  onSubmitted: (value) {
                    context.read<BookCubit>().setOnSearch(value.isNotEmpty);
                    _performSearch();
                  },
                );
              },
            ),
          ),
          IconButton(
            onPressed:
                () => Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    duration: Duration(milliseconds: 500),
                    child: BlocProvider.value(value: context.read<BookCubit>(), child: FilterScreen()),
                    opaque: true,
                  ),
                ).then((_) {
                  if (state.query?.isApplyFilter() == true) {
                    _refreshIndicatorKey.currentState?.show();
                  }
                }),
            icon: Icon(Icons.filter_alt_outlined, color: isApplyFilter ? ColorConstant.primary : Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _searchResult(BuildContext context, BookState state) {
    return ListPagedView<SimpleBookEntity>(
      state: state.pagingState,
      fetchNextPage: _cubit.fetchPagination,
      title: "buku",
      itemBuilder: (context, item, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SizedBox(
                  width: 30,
                  height: 190,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("${index + 1}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: shimmerImage(item.thumbnail, width: 140, height: 190),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
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
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 14),
                              const SizedBox(width: 2),
                              Text(item.rating!.toString(), style: const TextStyle(fontSize: 12)),
                            ],
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
              ),
            ],
          ),
        );
      },
    );
  }
}
