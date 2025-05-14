import 'package:book_shelf/src/core/exceptions/api_exception.dart';
import 'package:book_shelf/src/core/exceptions/repository_exception.dart';
import 'package:book_shelf/src/core/system/auth_local.dart';
import 'package:book_shelf/src/features/books/data/api/book_api.dart';
import 'package:book_shelf/src/features/books/domain/entities/book_entity.dart';
import 'package:book_shelf/src/features/books/domain/entities/books_entity.dart';
import 'package:book_shelf/src/features/books/domain/repositories/book_repository.dart';
import 'package:book_shelf/src/shared/utils/book_query_handler.dart';

class BookRepositoryImpl implements BookRepository {
  final BookApi _api;
  final AuthLocal _local;

  BookRepositoryImpl(this._api) : _local = AuthLocal();

  @override
  Future<BooksEntity> getBooks(BookQuery query) async {
    try {
      final res = await _api.getBooks(query, loginType: _local.getLoginType());

      return res.toEntity();
    } on ApiException {
      rethrow;
    } catch (e, stackTrace) {
      throw RepositoryException(
        e.toString(),
        stackTrace: stackTrace,
        source: "BookRepositoryImpl",
        details: "May failed while get books from Google Books API.",
      );
    }
  }

  @override
  Future<BookEntity> getBook(String id) async {
    try {
      final res = await _api.getBook(id);

      return res.toEntity();
    } on ApiException {
      rethrow;
    } catch (e, stackTrace) {
      throw RepositoryException(
        e.toString(),
        stackTrace: stackTrace,
        source: "BookRepositoryImpl",
        details: "May failed while get the book from Google Books API.",
      );
    }
  }
}
