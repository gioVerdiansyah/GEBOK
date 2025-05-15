import 'package:animations/animations.dart';
import 'package:book_shelf/src/core/di/injection.dart';
import 'package:book_shelf/src/features/books/presentations/blocs/bloc/book_cubit.dart';
import 'package:book_shelf/src/features/books/presentations/blocs/state/book_state.dart';
import 'package:book_shelf/src/features/books/presentations/screens/home/pick_genre_screen.dart';
import 'package:book_shelf/src/shared/constants/color_constant.dart';
import 'package:book_shelf/src/shared/utils/book_query_handler.dart';
import 'package:book_shelf/src/shared/utils/book_subject_maker.dart';
import 'package:book_shelf/src/shared/utils/string_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../../../../../shared/widgets/loading/image_load.dart';
import '../../../domain/entities/simple_book_entity.dart';
import '../../widgets/screen/book_detail_screen.dart';
import '../../widgets/screen/search_screen.dart';
import '../../widgets/skeletons/book_horizontal_skeleton.dart';

class HomeScreen extends StatefulWidget {
  final ScrollController scrollController;

  const HomeScreen({super.key, required this.scrollController});

  @override
  State<StatefulWidget> createState() => _HomeView();
}

class _HomeView extends State<HomeScreen> {
  DateTime? _lastBackPressed;
  late List<String> _subjects;
  final List<BookCubit> _bookCubits = [];

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

  Future<bool> _onWillPop() async {
    final now = DateTime.now();
    if (_lastBackPressed == null || now.difference(_lastBackPressed!) > Duration(seconds: 2)) {
      _lastBackPressed = now;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Tekan sekali lagi untuk keluar'), duration: Duration(seconds: 2)));
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: ColorConstant.secondary,
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
      ),
    );
  }

  Widget _exploreApp() {
    final List<Map<String, dynamic>> genres = [
      {"icon": Icons.emoji_emotions, "label": "Genre", "ontab": PickGenreScreen()},
      {
        "icon": Icons.hotel_class,
        "label": "Popular",
        "ontab": SearchScreen(titleSearch: "Popular", query: BookQuery(generic: "bestseller", orderBy: "relevance")),
      },
      {
        "icon": Icons.book,
        "label": "Baru",
        "ontab": SearchScreen(titleSearch: "Baru", query: BookQuery(generic: "New", orderBy: "newest")),
      },
      {
        "icon": Icons.favorite,
        "label": "Romantis",
        "ontab": SearchScreen(titleSearch: "Romantis", query: BookQuery(generic: "romance")),
      },
      {
        "icon": Icons.menu_book,
        "label": "Komik",
        "ontab": SearchScreen(titleSearch: "Komik", query: BookQuery(generic: "comic")),
      },
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
                child: OpenContainer(
                  transitionType: ContainerTransitionType.fadeThrough,
                  transitionDuration: const Duration(milliseconds: 500),
                  openBuilder: (context, _) => genre["ontab"],
                  closedElevation: 0,
                  closedColor: Colors.transparent,
                  closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  closedBuilder: (context, openContainer) {
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                        onTap: () {
                          // openContainer();
                          Future.delayed(const Duration(milliseconds: 300), () {
                            PersistentNavBarNavigator.pushNewScreen(
                              context,
                              screen: genre["ontab"],
                              withNavBar: false,
                              pageTransitionAnimation: PageTransitionAnimation.cupertino,
                            );
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: [Icon(genre["icon"] as IconData), const SizedBox(width: 4), Text(genre["label"])],
                          ),
                        ),
                      ),
                    );
                  },
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
            final query = BookQuery(subject: subject);

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
                        Material(
                          color: ColorConstant.secondary,
                          child: InkWell(
                            onTap: () {
                              PersistentNavBarNavigator.pushNewScreen(
                                context,
                                screen: SearchScreen(titleSearch: subject, query: BookQuery(generic: subject, subject: subject)),
                                withNavBar: false,
                                pageTransitionAnimation: PageTransitionAnimation.cupertino,
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(subject, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                  Icon(Icons.arrow_forward, color: ColorConstant.gray, size: 16),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: state.listBooks.books.map((item) => _buildBook(context, item)).toList(),
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

  Widget _buildBook(BuildContext context, SimpleBookEntity item) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: SizedBox(
        width: 140,
        child: OpenContainer(
          transitionType: ContainerTransitionType.fadeThrough,
          transitionDuration: const Duration(milliseconds: 500),
          openBuilder: (context, _) => BookDetailScreen(bookId: item.id),
          closedElevation: 0,
          closedColor: Colors.transparent,
          closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          closedBuilder: (context, openContainer) {
            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // openContainer();
                  Future.delayed(const Duration(milliseconds: 300), () {
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: BookDetailScreen(bookId: item.id),
                      withNavBar: false,
                      pageTransitionAnimation: PageTransitionAnimation.cupertino,
                    );
                  });
                },
                borderRadius: BorderRadius.circular(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: shimmerImage(item.thumbnail, width: 140, height: 190),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    Wrap(
                      spacing: 4,
                      runSpacing: 2,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        if (item.rating != null && item.discountPrice == null) ...[
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          Text(item.rating!.toString(), style: const TextStyle(fontSize: 12)),
                        ],
                        if (item.originalPrice != null)
                          Text(
                            "${item.currencyCode} ${formatNumToIdr(item.originalPrice!)}",
                            style: TextStyle(
                              fontSize: 12,
                              decoration: item.discountPrice != null ? TextDecoration.lineThrough : null,
                            ),
                          ),
                        if (item.discountPrice != null)
                          Text(
                            "${item.currencyCode} ${formatNumToIdr(item.discountPrice!)}",
                            style: const TextStyle(fontSize: 12),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
