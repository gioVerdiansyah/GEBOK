import 'package:book_shelf/src/features/books/domain/entities/simple_book_entity.dart';

class BooksEntity {
  final int totalItems;
  final List<SimpleBookEntity> books;

  BooksEntity({
    required this.totalItems,
    required this.books
  });

  factory BooksEntity.empty(){
    return BooksEntity(totalItems: 0, books: []);
  }
}