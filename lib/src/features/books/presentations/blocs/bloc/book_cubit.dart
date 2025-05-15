import 'package:book_shelf/src/core/exceptions/api_exception.dart';
import 'package:book_shelf/src/core/exceptions/repository_exception.dart';
import 'package:book_shelf/src/features/books/domain/entities/books_entity.dart';
import 'package:book_shelf/src/features/books/domain/entities/simple_book_entity.dart';
import 'package:book_shelf/src/features/books/domain/repositories/book_repository.dart';
import 'package:book_shelf/src/features/books/presentations/blocs/state/book_state.dart';
import 'package:book_shelf/src/shared/state/api_state.dart';
import 'package:book_shelf/src/shared/utils/book_query_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookCubit extends Cubit<BookState> {
  final BookRepository repo;

  BookCubit(this.repo) : super(BookState());

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

  Future<void> getBook(String id) async {
    try {
      emit(state.copyWith(api: state.api.loading()));

      final result = await repo.getBook(id);

      emit(state.copyWith(api: state.api.success(), book: result));
    } on ApiException catch (e) {
      emit(state.copyWith(api: state.api.errorException(e)));
    } on RepositoryException catch (e) {
      emit(state.copyWith(api: state.api.errorException(e)));
    }
  }

  Future<void> addBookToWishlist(String id) async {
    try {
      emit(state.copyWith(api: state.api.loading()));

      await repo.addBookToWishlist(id);

      emit(state.copyWith(api: state.api.success()));
    } on ApiException catch (e) {
      emit(state.copyWith(api: state.api.errorException(e)));
    } on RepositoryException catch (e) {
      emit(state.copyWith(api: state.api.errorException(e)));
    }
  }

  Future<void> removeBookFromWishlist(String id) async {
    try {
      emit(state.copyWith(api: state.api.loading()));

      await repo.removeBookFromWishlist(id);

      emit(state.copyWith(api: state.api.success()));
    } on ApiException catch (e) {
      emit(state.copyWith(api: state.api.errorException(e)));
    } on RepositoryException catch (e) {
      emit(state.copyWith(api: state.api.errorException(e)));
    }
  }

  // SIDE EFFECT SECTION
  void setOnSearch(bool onSearch) {
    final loadingState = state.pagingState.copyWith(isLoading: onSearch, error: null);
    emit(state.copyWith(onSearch: onSearch, pagingState: loadingState));
  }

  void setWaitingSubmit(bool isWaiting) {
    emit(state.copyWith(isWaitingSubmit: isWaiting));
  }

  // PAGINATION SECTION
  void setQuery(BookQuery? query) {
    emit(state.copyWith(query: query));
  }

  Future<void> resetPagination() async {
    final updatedPagingState = state.pagingState.copyWith(
      pages: null,
      keys: null,
      hasNextPage: true,
      isLoading: true,
      //* NOTE: JIKA isLoading DI SET TRUE MAKA SAMA SAJA AKAN REFRESH, HATI_HATI DOUBLE STATE
      error: null,
    );
    emit(state.copyWith(pagingState: updatedPagingState));
  }

  Future<List<SimpleBookEntity>> fetchPagination(int pageKey) async {
    try {
      // Set loading state first
      final loadingState = state.pagingState.copyWith(isLoading: true, error: null);
      emit(state.copyWith(pagingState: loadingState));

      // Calculate the correct key based on existing state
      final int newKey = (state.pagingState.keys?.isEmpty ?? true) ? 1 : (state.pagingState.keys?.last ?? 0) + 1;

      // Create query with proper startIndex
      final newQuery = BookQuery(
        generic: state.query?.generic,
        filterBy: state.query?.filterBy,
        orderBy: state.query?.orderBy,
        langRestrict: state.query?.langRestrict,
        startIndex: (newKey - 1) * 10,
      );

      final results = await repo.getBooks(newQuery);
      final newItems = results.books;

      // Update pagination state with new results
      final updatedPagingState = state.pagingState.copyWith(
        pages: [...?state.pagingState.pages, newItems],
        keys: [...?state.pagingState.keys, newKey],
        hasNextPage: newItems.isNotEmpty && newItems.length > 10,
        isLoading: false,
      );

      emit(state.copyWith(pagingState: updatedPagingState));

      return results.books;
    } on ApiException catch (e) {
      final errorState = state.pagingState.copyWith(error: e.message, isLoading: false);
      emit(state.copyWith(pagingState: errorState));

      rethrow;
    } on RepositoryException catch (e) {
      final errorState = state.pagingState.copyWith(error: e.message, isLoading: false);
      emit(state.copyWith(pagingState: errorState));

      rethrow;
    } catch (e) {
      final errorState = state.pagingState.copyWith(error: e.toString(), isLoading: false);
      emit(state.copyWith(pagingState: errorState));

      rethrow;
    }
  }
  Future<List<SimpleBookEntity>> fetchFavoriteBookPagination(int pageKey) async {
    try {
      final loadingState = state.pagingState.copyWith(isLoading: true, error: null);
      emit(state.copyWith(pagingState: loadingState));

      final int newKey = (state.pagingState.keys?.isEmpty ?? true) ? 1 : (state.pagingState.keys?.last ?? 0) + 1;

      final newQuery = BookQuery(
        generic: 'a',
        startIndex: (newKey - 1) * 10,
      );

      final results = await repo.getWishlistBook(newQuery);
      final newItems = results.books;

      final updatedPagingState = state.pagingState.copyWith(
        pages: [...?state.pagingState.pages, newItems],
        keys: [...?state.pagingState.keys, newKey],
        hasNextPage: newItems.isNotEmpty && newItems.length > 10,
        isLoading: false,
      );

      emit(state.copyWith(pagingState: updatedPagingState));

      return results.books;
    } on ApiException catch (e) {
      final errorState = state.pagingState.copyWith(error: e.message, isLoading: false);
      emit(state.copyWith(pagingState: errorState));

      rethrow;
    } on RepositoryException catch (e) {
      final errorState = state.pagingState.copyWith(error: e.message, isLoading: false);
      emit(state.copyWith(pagingState: errorState));

      rethrow;
    } catch (e) {
      final errorState = state.pagingState.copyWith(error: e.toString(), isLoading: false);
      emit(state.copyWith(pagingState: errorState));

      rethrow;
    }
  }
}
