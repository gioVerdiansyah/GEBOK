import 'package:book_shelf/src/features/books/data/models/simple_book_model.dart';
import 'package:book_shelf/src/features/books/domain/entities/books_entity.dart';

class BooksModel {
  final int totalItems;
  final List<SimpleBookModel> books;

  BooksModel({
    required this.totalItems,
    required this.books,
  });

  factory BooksModel.fromJson(Map<String, dynamic> json) {
    return BooksModel(
      totalItems: json['totalItems'] ?? 0,
      books: (json['items'] as List<dynamic>?)
          ?.map((item) => SimpleBookModel.fromJson(item))
          .toList() ??
          [],
    );
  }

  BooksEntity toEntity() {
    return BooksEntity(
      totalItems: totalItems,
      books: books.map((bookModel) => bookModel.toEntity()).toList(),
    );
  }
}