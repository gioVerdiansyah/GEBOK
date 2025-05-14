import 'package:animations/animations.dart';
import 'package:book_shelf/src/features/books/domain/entities/book_entity.dart';
import 'package:book_shelf/src/features/books/presentations/widgets/screen/search_screen.dart';
import 'package:book_shelf/src/shared/widgets/others/expandable_content.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../shared/constants/color_constant.dart';
import '../../../../../shared/utils/string_util.dart';
import '../../../../../shared/widgets/loading/image_load.dart';
import '../../../../../shared/widgets/others/dynamic_app_bar.dart';
import '../../../../../shared/widgets/others/expandable_description.dart';
import '../../blocs/bloc/book_cubit.dart';
import '../../blocs/state/book_state.dart';

class BookDetailScreen extends StatefulWidget {
  final String bookId;

  const BookDetailScreen({super.key, required this.bookId});

  @override
  State<StatefulWidget> createState() => _BookDetailView();
}

class _BookDetailView extends State<BookDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = getIt<BookCubit>();
        cubit.getBook(widget.bookId);
        return cubit;
      },
      child: BlocBuilder<BookCubit, BookState>(
        builder: (context, state) {
          if (state.api.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: DynamicAppBar(
              backgroundColor: Colors.white,
              showBackButton: true,
              trailingWidgets: [
                Row(
                  children: [
                    OpenContainer(
                      transitionType: ContainerTransitionType.fadeThrough,
                      transitionDuration: const Duration(milliseconds: 600),
                      closedElevation: 0,
                      closedShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      closedBuilder: (context, openContainer) {
                        return IconButton(
                          icon: const Icon(Icons.search,
                              color: ColorConstant.gray),
                          onPressed: openContainer,
                        );
                      },
                      openBuilder: (context, _) => const SearchScreen(),
                    ),
                    IconButton(
                      onPressed: () {
                        final params = ShareParams(uri: Uri.parse(state.book.canonicalVolumeLink));

                        SharePlus.instance.share(params);
                      },
                      icon: const Icon(Icons.share_outlined,
                          color: ColorConstant.gray, size: 24),
                    ),
                  ],
                ),
              ],
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBookDetail(context, state),
                      _buildStats(context, state),
                      _buildDescription(context, state),
                      _buildDetail(context, state),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }


  Widget _buildStats(BuildContext context, BookState state) {
    final BookEntity book = state.book;

    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Rating
          ...[
            if (book.ratingsCount != null)
              ...[Column(
                children: [
                  Row(
                    children: [
                      Text(
                        book.averageRating!.toStringAsFixed(1),
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                    ],
                  ),
                  Text(
                    "${book.ratingsCount!} reviews",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            Container(margin: const EdgeInsets.symmetric(horizontal: 16), height: 40, width: 1, color: Colors.grey),]
          ],
          // Format
          Column(
            children: [
              const Icon(Icons.menu_book_outlined, color: Colors.black, size: 18),
              const SizedBox(height: 4),
              Text(
                book.isEbook ? "Ebook" : "Book",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black54),
              ),
            ],
          ),
          Container(margin: const EdgeInsets.symmetric(horizontal: 16), height: 40, width: 1, color: Colors.grey),
          // Page count
          Column(
            children: [
              Text(
                "${book.pageCount}",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 4),
              Text("Pages", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black54)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBookDetail(BuildContext context, BookState state) {
    final BookEntity book = state.book;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Book cover image
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: shimmerImage(book.imageLinks.thumbnail, width: 100, height: 150),
        ),
        const SizedBox(width: 16),
        // Book details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                book.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 4),
              Text(
                book.authors.isNotEmpty ? book.authors.first : "Unknown Author",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                "Released ${book.publishedDate}",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 8),
              if (book.originalPrice != null)
                Text(
                  "${book.currencyCode} ${formatNumToIdr(book.originalPrice!)}",
                  style: const TextStyle(fontSize: 12, decoration: TextDecoration.lineThrough,),
                ),
              if (book.discountPrice != null) ...[
                Text(
                    "${book.currencyCode} ${formatNumToIdr(book.discountPrice!)}",
                    style: const TextStyle(fontSize: 12)
                ),
                const SizedBox(width: 4),
              ],
              const SizedBox(height: 16),
            ],
          ),
        ),
        // Stats row
      ],
    );
  }

  Widget _buildDescription(BuildContext context, BookState state) {
    final BookEntity book = state.book;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Container(width: double.infinity, height: 1, color: Colors.black54),
        const SizedBox(height: 16),
        ExpandableWidget(
          title: "Deskripsi",
          titleStyle: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.black),
          child: ExpandableDescription(
            collapsedHeight: 150,
            expandText: "Tampilkan",
            collapseText: "Sembunyikan",
            child: Html(data: book.description),
          ),
        ),
      ],
    );
  }

  Widget _buildDetail(BuildContext context, BookState state) {
    final BookEntity book = state.book;

    return ExpandableWidget(
      title: "Detail Buku",
      titleStyle: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.black),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('Title', book.title),
          if (book.subtitle != null) _buildInfoRow('Sub Title', book.subtitle!),
          _buildInfoRow('Language', book.language.toUpperCase()),
          ...book.authors.map((e) => _buildInfoRow('Author', e)),
          _buildInfoRow('Publisher', book.publisher),
          _buildInfoRow('Published on', book.publishedDate),
          _buildInfoRow('Pages', book.pageCount.toString()),
          _buildInfoRow('Content protection', 'This content is DRM protected.'),
          _buildInfoRow('Genre', book.genre.join(",")),
          ...book.industryIdentifiers.map((e) => _buildInfoRow(e.type, e.identifier)),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isLink = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: Text(label, style: TextStyle(color: Colors.black, fontSize: 16))),
          Expanded(
            flex: 3,
            child:
                isLink
                    ? Text(value, style: TextStyle(color: Colors.blue, fontSize: 16))
                    : Text(value, style: TextStyle(color: Colors.black54, fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
