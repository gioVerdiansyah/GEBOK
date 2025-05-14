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
  final List<String> genre;
  final List<String> categories;
  final ImageLinks imageLinks;
  final double? averageRating;
  final int? ratingsCount;
  final String language;
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

  factory BookEntity.empty() {
    return BookEntity(
      id: '',
      title: '',
      subtitle: null,
      authors: [],
      publisher: '',
      publishedDate: '',
      description: '',
      industryIdentifiers: [IndustryIdentifier.empty()],
      pageCount: 0,
      categories: [],
      imageLinks: ImageLinks.empty(),
      averageRating: null,
      ratingsCount: null,
      language: '',
      genre: [],
      previewLink: '',
      infoLink: '',
      canonicalVolumeLink: '',
      discountPrice: null,
      originalPrice: null,
      currencyCode: null,
      isEbook: false,
      embeddable: false,
      publicDomain: false,
      epubAvailable: false,
      pdfAvailable: false,
      pdfAcsTokenLink: null,
      webReaderLink: '',
      accessViewStatus: '',
      quoteSharingAllowed: false,
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

  factory IndustryIdentifier.empty() {
    return IndustryIdentifier(
      type: '',
      identifier: '',
    );
  }
}

class ImageLinks {
  final String thumbnail;
  final String largeImage;

  ImageLinks({
    required this.thumbnail,
    required this.largeImage,
  });

  factory ImageLinks.empty() {
    return ImageLinks(
      thumbnail: '',
      largeImage: '',
    );
  }
}
