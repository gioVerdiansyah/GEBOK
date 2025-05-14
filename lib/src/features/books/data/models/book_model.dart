import '../../domain/entities/book_entity.dart';

class BookModel {
  final String id;
  final String title;
  final String? subtitle;
  final List<String> authors;
  final String publisher;
  final String publishedDate;
  final String description;
  final List<IndustryIdentifierModel> industryIdentifiers;
  final int pageCount;
  final List<String> categories;
  final ImageLinksModel imageLinks;
  final double? averageRating;
  final int? ratingsCount;
  final String language;
  final List<String> genre;
  final String previewLink;
  final String infoLink;
  final String canonicalVolumeLink;
  final int? discountPrice;
  final int? originalPrice;
  final String? currencyCode;
  final bool isEbook;
  final bool embeddable;
  final bool publicDomain;
  final bool epubAvailable;
  final bool pdfAvailable;
  final String? pdfAcsTokenLink;
  final String webReaderLink;
  final String accessViewStatus;
  final bool quoteSharingAllowed;

  BookModel({
    required this.id,
    required this.title,
    this.subtitle,
    required this.authors,
    required this.publisher,
    required this.publishedDate,
    required this.description,
    required this.industryIdentifiers,
    required this.pageCount,
    required this.categories,
    required this.imageLinks,
    required this.averageRating,
    required this.ratingsCount,
    required this.language,
    required this.genre,
    required this.previewLink,
    required this.infoLink,
    required this.canonicalVolumeLink,
    this.discountPrice,
    this.originalPrice,
    this.currencyCode,
    required this.isEbook,
    required this.embeddable,
    required this.publicDomain,
    required this.epubAvailable,
    required this.pdfAvailable,
    this.pdfAcsTokenLink,
    required this.webReaderLink,
    required this.accessViewStatus,
    required this.quoteSharingAllowed,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'] ?? {};
    final saleInfo = json['saleInfo'] ?? {};
    final accessInfo = json['accessInfo'] ?? {};
    final epub = accessInfo['epub'] ?? {};
    final pdf = accessInfo['pdf'] ?? {};
    final retailPrice = saleInfo['retailPrice'];
    final listPrice = saleInfo['listPrice'];

    return BookModel(
      id: json['id'] ?? '',
      title: volumeInfo['title'] ?? '',
      subtitle: volumeInfo['subtitle'],
      authors: List<String>.from(volumeInfo['authors'] ?? []),
      publisher: volumeInfo['publisher'] ?? '',
      publishedDate: volumeInfo['publishedDate'] ?? '',
      description: volumeInfo['description'] ?? '',
      industryIdentifiers: (volumeInfo['industryIdentifiers'] as List<dynamic>?)
          ?.map((e) => IndustryIdentifierModel.fromJson(e))
          .toList() ??
          [],
      pageCount: volumeInfo['pageCount'] ?? 0,
      categories: List<String>.from(volumeInfo['categories'] ?? []),
      imageLinks:
      ImageLinksModel.fromJson(volumeInfo['imageLinks'] ?? <String, dynamic>{}),
      averageRating: (volumeInfo['averageRating'] != null)
          ? (volumeInfo['averageRating'] as num).toDouble()
          : null,
      ratingsCount: volumeInfo['ratingsCount'],
      language: volumeInfo['language'] ?? '',
      genre: List<String>.from(volumeInfo['categories'] ?? []),
      previewLink: volumeInfo['previewLink'] ?? '',
      infoLink: volumeInfo['infoLink'] ?? '',
      canonicalVolumeLink: volumeInfo['canonicalVolumeLink'] ?? '',
      discountPrice: retailPrice != null ? retailPrice['amount'] : null,
      originalPrice: listPrice != null ? listPrice['amount'] : null,
      currencyCode: listPrice != null ? listPrice['currencyCode'] : null,
      isEbook: saleInfo['isEbook'] ?? false,
      embeddable: accessInfo['embeddable'] ?? false,
      publicDomain: accessInfo['publicDomain'] ?? false,
      epubAvailable: epub['isAvailable'] ?? false,
      pdfAvailable: pdf['isAvailable'] ?? false,
      pdfAcsTokenLink: pdf['acsTokenLink'],
      webReaderLink: accessInfo['webReaderLink'] ?? '',
      accessViewStatus: accessInfo['accessViewStatus'] ?? '',
      quoteSharingAllowed: accessInfo['quoteSharingAllowed'] ?? false,
    );
  }

  BookEntity toEntity() {
    return BookEntity(
      id: id,
      title: title,
      subtitle: subtitle,
      authors: authors,
      publisher: publisher,
      publishedDate: publishedDate,
      description: description,
      industryIdentifiers:
      industryIdentifiers.map((e) => e.toEntity()).toList(),
      pageCount: pageCount,
      categories: categories,
      imageLinks: imageLinks.toEntity(),
      averageRating: averageRating,
      ratingsCount: ratingsCount,
      language: language,
      genre: genre,
      previewLink: previewLink,
      infoLink: infoLink,
      canonicalVolumeLink: canonicalVolumeLink,
      discountPrice: discountPrice,
      originalPrice: originalPrice,
      currencyCode: currencyCode,
      isEbook: isEbook,
      embeddable: embeddable,
      publicDomain: publicDomain,
      epubAvailable: epubAvailable,
      pdfAvailable: pdfAvailable,
      pdfAcsTokenLink: pdfAcsTokenLink,
      webReaderLink: webReaderLink,
      accessViewStatus: accessViewStatus,
      quoteSharingAllowed: quoteSharingAllowed,
    );
  }
}

class IndustryIdentifierModel {
  final String type;
  final String identifier;

  IndustryIdentifierModel({
    required this.type,
    required this.identifier,
  });

  factory IndustryIdentifierModel.fromJson(Map<String, dynamic> json) {
    return IndustryIdentifierModel(
      type: json['type'] ?? '',
      identifier: json['identifier'] ?? '',
    );
  }

  IndustryIdentifier toEntity() {
    return IndustryIdentifier(
      type: type,
      identifier: identifier,
    );
  }
}


class ImageLinksModel {
  final String thumbnail;
  final String largeImage;

  ImageLinksModel({
    required this.thumbnail,
    required this.largeImage,
  });

  factory ImageLinksModel.fromJson(Map<String, dynamic> json) {
    return ImageLinksModel(
      thumbnail: json['thumbnail'] ?? '',
      largeImage: json['large'] ?? json['thumbnail'] ?? '',
    );
  }

  ImageLinks toEntity() {
    return ImageLinks(
      thumbnail: thumbnail,
      largeImage: largeImage,
    );
  }
}
