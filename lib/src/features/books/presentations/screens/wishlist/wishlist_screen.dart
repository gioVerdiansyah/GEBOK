import 'package:animations/animations.dart';
import 'package:book_shelf/src/core/di/injection.dart';
import 'package:book_shelf/src/features/books/presentations/blocs/bloc/book_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../../../../../shared/constants/color_constant.dart';
import '../../../../../shared/utils/string_util.dart';
import '../../../../../shared/widgets/list/list_paged_view.dart';
import '../../../../../shared/widgets/loading/image_load.dart';
import '../../../domain/entities/simple_book_entity.dart';
import '../../blocs/state/book_state.dart';
import '../../widgets/screen/book_detail_screen.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<StatefulWidget> createState() => _WishlistView();
}

class _WishlistView extends State<WishlistScreen> with AutomaticKeepAliveClientMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final BookCubit _cubit = getIt<BookCubit>();

  Future<void> _refreshData() async {
    await _cubit.resetPagination();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<BookCubit, BookState>(
          bloc: _cubit,
          buildWhen: (previous, current) {
            return previous.pagingState.pages != current.pagingState.pages;
          },
          builder: (context, state) {
            return RefreshIndicator(
              key: _refreshIndicatorKey,
              color: ColorConstant.primary,
              onRefresh: _refreshData,
              child: _buildContent(context, state),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, BookState state) {
    return ListPagedView<SimpleBookEntity>(
      state: state.pagingState,
      fetchNextPage: _cubit.fetchFavoriteBookPagination,
      title: "buku",
      itemBuilder: (context, item, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: OpenContainer(
            transitionType: ContainerTransitionType.fadeThrough,
            transitionDuration: Duration(milliseconds: 600),
            closedElevation: 0,
            closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            closedBuilder: (context, openContainer) {
              return Material(
                color: ColorConstant.secondary,
                child: InkWell(
                  onTap: () {
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: BookDetailScreen(bookId: item.id),
                      withNavBar: false,
                      pageTransitionAnimation: PageTransitionAnimation.cupertino,
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                              Text(
                                item.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12),
                              ),
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
                ),
              );
            },
            openBuilder: (context, _) => Container(),
          ),
        );
      },
    );
  }
}
