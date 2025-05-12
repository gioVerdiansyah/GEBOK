import 'package:animations/animations.dart';
import 'package:book_shelf/src/core/di/injection.dart';
import 'package:book_shelf/src/features/books/presentations/blocs/bloc/book_cubit.dart';
import 'package:book_shelf/src/features/books/presentations/blocs/state/book_state.dart';
import 'package:book_shelf/src/features/books/presentations/widgets/search_screen.dart';
import 'package:book_shelf/src/features/books/presentations/widgets/skeleteon/book_horizontal_skeleton.dart'
    show BookHorizontalSkeleton;
import 'package:book_shelf/src/shared/constants/asset_constant.dart';
import 'package:book_shelf/src/shared/constants/color_constant.dart';
import 'package:book_shelf/src/shared/utils/book_query_handler.dart';
import 'package:book_shelf/src/shared/utils/book_subject_maker.dart';
import 'package:book_shelf/src/shared/utils/string_util.dart';
import 'package:book_shelf/src/shared/widgets/others/dynamic_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/widgets/loading/image_load.dart';
import '../../widgets/skeleteon/book_horizontal_skeleton.dart';

class HomeScreen extends StatefulWidget {
  final ScrollController scrollController;

  const HomeScreen({super.key, required this.scrollController});

  @override
  State<StatefulWidget> createState() => _HomeView();
}

class _HomeView extends State<HomeScreen> {
  late List<String> _subjects;
  List<BookCubit> _bookCubits = [];

  @override
  void initState() {
    super.initState();

    _subjects = BookSubjectPicker().pickRandomSubjects();
  }

  Future<void> _onRefresh() async {
    _subjects = BookSubjectPicker().pickRandomSubjects();

    // Refresh all cubits
    for (var i = 0; i < _subjects.length; i++) {
      final subject = _subjects[i];
      if (i < _bookCubits.length) {
        _bookCubits[i].getBooks(BookQuery(subject: subject));
      } else {
        final cubit = getIt<BookCubit>();
        cubit.getBooks(BookQuery(subject: subject));
        _bookCubits.add(cubit);
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DynamicAppBar(
        backgroundColor: ColorConstant.secondary,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(AssetConstant.appLogo, width: 30),
            const SizedBox(width: 8),
            Text("GEBOK", style: TextStyle(color: ColorConstant.primary, fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        trailingWidgets: [
          OpenContainer(
            transitionType: ContainerTransitionType.fadeThrough,
            // .fade, .fadeThrough, .fadeScale
            transitionDuration: Duration(milliseconds: 600),
            closedElevation: 0,
            closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            closedBuilder: (context, openContainer) {
              return IconButton(icon: const Icon(Icons.search, color: ColorConstant.gray), onPressed: openContainer);
            },
            openBuilder: (context, _) => SearchScreen(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          controller: widget.scrollController,
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_exploreApp(), const SizedBox(height: 16), _buildRecommendationBooks()],
          ),
        ),
      ),
    );
  }

  Widget _exploreApp() {
    final List<Map<String, dynamic>> genres = [
      {"icon": Icons.emoji_emotions, "label": "Genre"},
      {"icon": Icons.hotel_class, "label": "Popular"},
      {"icon": Icons.book, "label": "Baru"},
      {"icon": Icons.favorite, "label": "Romantis"},
      {"icon": Icons.menu_book, "label": "Comic"},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text("Explore GEBOK", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: genres.length,
            itemBuilder: (context, index) {
              final genre = genres[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: ColorConstant.gray),
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [Icon(genre["icon"] as IconData), const SizedBox(width: 4), Text(genre["label"])],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendationBooks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          _subjects.map((subject) {
            final query = BookQuery(subject: subject, filterBy: "paid-ebooks");

            return Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: BlocProvider(
                create: (context) {
                  final cubit = getIt<BookCubit>();
                  _bookCubits.add(cubit);

                  cubit.getBooks(query);
                  return cubit;
                },
                child: BlocBuilder<BookCubit, BookState>(
                  builder: (context, state) {
                    if (state.api.isLoading) {
                      return const BookHorizontalSkeleton();
                    } else if (state.api.error != null) {
                      return Center(child: Text("Error: ${state.api.error?.message ?? 'Unknown error'}"));
                    } else if (state.listBooks.books.isEmpty) {
                      return const SizedBox();
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(subject, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        ),
                        const SizedBox(height: 8),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:
                                    state.listBooks.books.map((item) {
                                      return Padding(
                                        padding: const EdgeInsets.only(right: 16.0),
                                        child: SizedBox(
                                          width: 140,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(8),
                                                child: shimmerImage(
                                                    item.thumbnail,
                                                  width: 140,
                                                  height: 190,
                                                )
                                                // FadeInImage.assetNetwork(
                                                //   placeholder: AssetConstant.loading,
                                                //   image: item.thumbnail,
                                                //   width: 140,
                                                //   height: 190,
                                                //   fit: BoxFit.cover,
                                                //   imageErrorBuilder: (context, error, stackTrace) {
                                                //     return Container(
                                                //       width: 120,
                                                //       height: 180,
                                                //       color: Colors.grey[300],
                                                //       child: const Center(child: Icon(Icons.broken_image, size: 40)),
                                                //     );
                                                //   },
                                                // ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                item.title,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                              ),
                                              Row(
                                                children: [
                                                  ...[
                                                    if (item.rating != null && item.discountPrice == null) ...[
                                                      const Icon(Icons.star, color: Colors.amber, size: 14),
                                                      const SizedBox(width: 2),
                                                      Text(item.rating!.toString(), style: const TextStyle(fontSize: 12)),
                                                      const SizedBox(width: 8),
                                                    ],
                                                  ],
                                                  ...[
                                                    if (item.discountPrice != null) ...[
                                                      Text(
                                                        "${item.currencyCode} ${formatNumToIdr(item.discountPrice!)}",
                                                        style: TextStyle(
                                                          decoration: TextDecoration.lineThrough,
                                                          fontSize: 12,
                                                        ),
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
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          }).toList(),
    );
  }
}
