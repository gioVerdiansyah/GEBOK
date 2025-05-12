import 'package:book_shelf/src/features/books/domain/entities/book_entity.dart';
import 'package:book_shelf/src/features/books/domain/entities/books_entity.dart';
import 'package:book_shelf/src/shared/utils/book_query_handler.dart';

abstract class BookRepository {
  Future<BooksEntity> getBooks(BookQuery query);
  Future<BookEntity> getBook(String id);
}