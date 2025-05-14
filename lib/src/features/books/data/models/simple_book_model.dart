import 'package:book_shelf/src/features/books/domain/entities/simple_book_entity.dart';

class SimpleBookModel {
  final String id;
  final String title;
  final String author;
  final String thumbnail;
  final int? discountPrice;
  final int? originalPrice;
  final String? currencyCode;
  final double? rating;

  SimpleBookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.thumbnail,
    this.discountPrice,
    this.originalPrice,
    this.currencyCode,
    this.rating,
  });

  factory SimpleBookModel.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'] ?? {};
    final saleInfo = json['saleInfo'] ?? {};
    final retailPrice = saleInfo['retailPrice'];
    final listPrice = saleInfo['listPrice'];

    return SimpleBookModel(
      id: json['id'],
      title: volumeInfo['title'] ?? '',
      author: volumeInfo['authors']?[0] ?? '',
      thumbnail: volumeInfo['imageLinks']?['thumbnail'] ?? '',
      discountPrice: retailPrice != null ? retailPrice['amount'] : null,
      originalPrice: listPrice != null ? listPrice['amount'] : null,
      currencyCode: listPrice != null ? listPrice['currencyCode'] : null,
      rating: volumeInfo['averageRating']?.toDouble(),
    );
  }

  SimpleBookEntity toEntity() {
    return SimpleBookEntity(
      id: id,
      title: title,
      author: author,
      thumbnail: thumbnail,
      discountPrice: discountPrice,
      originalPrice: originalPrice,
      currencyCode: currencyCode,
      rating: rating,
    );
  }
}
