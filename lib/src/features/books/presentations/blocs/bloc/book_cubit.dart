import 'package:book_shelf/src/core/exceptions/api_exception.dart';
import 'package:book_shelf/src/core/exceptions/repository_exception.dart';
import 'package:book_shelf/src/features/books/domain/entities/books_entity.dart';
import 'package:book_shelf/src/features/books/domain/entities/simple_book_entity.dart';
import 'package:book_shelf/src/features/books/domain/repositories/book_repository.dart';
import 'package:book_shelf/src/features/books/presentations/blocs/state/book_state.dart';
import 'package:book_shelf/src/shared/state/api_state.dart';
import 'package:book_shelf/src/shared/utils/book_query_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class BookCubit extends Cubit<BookState> {
  final BookRepository repo;
  late final PagingController<int, SimpleBookEntity> pagingController;

  BookCubit(this.repo) : super(BookState()) {
    pagingController = PagingController<int, SimpleBookEntity>(
      fetchPage: _fetchPagination,
      getNextPageKey: _getNextPageKey,
    );
  }

  Future<void> getBooks(BookQuery query) async {
    try {
      emit(state.copyWith(api: state.api.loading()));

      final BooksEntity result = await repo.getBooks(query);

      emit(state.copyWith(api: state.api.success(), listBooks: result));
    } on ApiException catch (e) {
      emit(state.copyWith(api: state.api.errorException(e)));
    } on RepositoryException catch (e) {
      emit(state.copyWith(api: state.api.errorException(e)));
    }
  }

  // Pagination section
  void setQuery(BookQuery query) {
    state.copyWith(query: query);
  }
  Future<List<SimpleBookEntity>> _fetchPagination(int pageKey) async {
    try {
      final results = await repo.getBooks(state.query ?? BookQuery());
      return results.books;
    } catch (e) {
      rethrow;
    }
  }

  int? _getNextPageKey(PagingState<int, SimpleBookEntity> state) {
    final lastPageItemCount = state.items?.length ?? 0;

    if (lastPageItemCount < 10) return null;

    final lastKey = state.keys?.lastOrNull ?? 0;
    return lastKey + 1;
  }
}
