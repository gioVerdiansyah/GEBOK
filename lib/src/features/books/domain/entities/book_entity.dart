class BookEntity {
  final String id;
  final String title;
  final String? subtitle;
  final List<String> authors;
  final String publisher;
  final String publishedDate;
  final String description;
  final List<IndustryIdentifier> industryIdentifiers;
  final int pageCount;
  final String printType;
  final List<String> categories;
  final String maturityRating;
  final bool allowAnonLogging;
  final String contentVersion;
  final ImageLinks imageLinks;
  final String language;
  final String previewLink;
  final String infoLink;
  final String canonicalVolumeLink;
  final String saleability;
  final bool isEbook;
  final bool embeddable;
  final bool publicDomain;
  final bool epubAvailable;
  final bool pdfAvailable;
  final String? pdfAcsTokenLink;
  final String webReaderLink;
  final String accessViewStatus;
  final bool quoteSharingAllowed;

  BookEntity({
    required this.id,
    required this.title,
    this.subtitle,
    required this.authors,
    required this.publisher,
    required this.publishedDate,
    required this.description,
    required this.industryIdentifiers,
    required this.pageCount,
    required this.printType,
    required this.categories,
    required this.maturityRating,
    required this.allowAnonLogging,
    required this.contentVersion,
    required this.imageLinks,
    required this.language,
    required this.previewLink,
    required this.infoLink,
    required this.canonicalVolumeLink,
    required this.saleability,
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

  factory BookEntity.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'];
    final saleInfo = json['saleInfo'];
    final accessInfo = json['accessInfo'];

    return BookEntity(
      id: json['id'],
      title: volumeInfo['title'],
      subtitle: volumeInfo['subtitle'],
      authors: List<String>.from(volumeInfo['authors'] ?? []),
      publisher: volumeInfo['publisher'] ?? '',
      publishedDate: volumeInfo['publishedDate'] ?? '',
      description: volumeInfo['description'] ?? '',
      industryIdentifiers: (volumeInfo['industryIdentifiers'] as List)
          .map((e) => IndustryIdentifier.fromJson(e))
          .toList(),
      pageCount: volumeInfo['pageCount'] ?? 0,
      printType: volumeInfo['printType'] ?? '',
      categories: List<String>.from(volumeInfo['categories'] ?? []),
      maturityRating: volumeInfo['maturityRating'] ?? '',
      allowAnonLogging: volumeInfo['allowAnonLogging'] ?? false,
      contentVersion: volumeInfo['contentVersion'] ?? '',
      imageLinks: ImageLinks.fromJson(volumeInfo['imageLinks']),
      language: volumeInfo['language'] ?? '',
      previewLink: volumeInfo['previewLink'] ?? '',
      infoLink: volumeInfo['infoLink'] ?? '',
      canonicalVolumeLink: volumeInfo['canonicalVolumeLink'] ?? '',
      saleability: saleInfo['saleability'] ?? '',
      isEbook: saleInfo['isEbook'] ?? false,
      embeddable: accessInfo['embeddable'] ?? false,
      publicDomain: accessInfo['publicDomain'] ?? false,
      epubAvailable: accessInfo['epub']['isAvailable'] ?? false,
      pdfAvailable: accessInfo['pdf']['isAvailable'] ?? false,
      pdfAcsTokenLink: accessInfo['pdf']['acsTokenLink'],
      webReaderLink: accessInfo['webReaderLink'] ?? '',
      accessViewStatus: accessInfo['accessViewStatus'] ?? '',
      quoteSharingAllowed: accessInfo['quoteSharingAllowed'] ?? false,
    );
  }
}

class IndustryIdentifier {
  final String type;
  final String identifier;

  IndustryIdentifier({
    required this.type,
    required this.identifier,
  });

  factory IndustryIdentifier.fromJson(Map<String, dynamic> json) {
    return IndustryIdentifier(
      type: json['type'],
      identifier: json['identifier'],
    );
  }
}

class ImageLinks {
  final String smallThumbnail;
  final String thumbnail;

  ImageLinks({
    required this.smallThumbnail,
    required this.thumbnail,
  });

  factory ImageLinks.fromJson(Map<String, dynamic> json) {
    return ImageLinks(
      smallThumbnail: json['smallThumbnail'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
    );
  }
}
