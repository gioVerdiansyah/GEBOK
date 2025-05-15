class ApiPath {
  // Authentication
  static const String login = "auth/books";
  static const String logout = "https://oauth2.googleapis.com/revoke";
  static const String checkToken = "oauth2/v3/userinfo/";

  // Books
  static const String volumes = "volumes";
  static const String addWishlists = "mylibrary/bookshelves/0/addVolume";
  static const String removeWishlists = "mylibrary/bookshelves/0/removeVolume";

  static const String favoriteBooks = "mylibrary/bookshelves/0/volumes";
  static const String recommendationBooks = "mylibrary/bookshelves/8/volumes";
}
