class ApiPath {
  // Authentication
  static const String login = "auth/books";
  static const String checkToken = "oauth2/v3/userinfo/";

  // Books
  static const String volumes = "volumes";
  static const String books =
      "volumes?fields=items(id,volumeInfo/title,volumeInfo/description, volumeInfo/averageRating, volumeInfo/authors, "
      "volumeInfo/imageLinks/thumbnail, saleInfo/listPrice/amount, saleInfo/listPrice/currencyCode)";
}
