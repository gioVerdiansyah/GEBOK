class SimpleBookEntity {
  final String id;
  final String title;
  final String author;
  final String thumbnail;
  final int? discountPrice;
  final int? originalPrice;
  final String? currencyCode;
  final double? rating;

  SimpleBookEntity({
    required this.id,
    required this.title,
    required this.author,
    required this.thumbnail,
    this.discountPrice,
    this.originalPrice,
    this.currencyCode,
    this.rating,
  });
}