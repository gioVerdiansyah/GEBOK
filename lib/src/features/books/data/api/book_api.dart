import 'package:book_shelf/src/core/network/api_client.dart';
import 'package:book_shelf/src/core/network/api_path.dart';
import 'package:book_shelf/src/shared/utils/book_query_handler.dart';

import '../../../../core/config/api_config.dart';
import '../models/books_model.dart';
import '../models/book_model.dart';

class BookApi {
  final ApiClient _api;
  final String items = "items(id,volumeInfo/title,volumeInfo/description, volumeInfo/averageRating, volumeInfo/authors, "
      "volumeInfo/imageLinks/thumbnail, saleInfo/listPrice/amount, saleInfo/retailPrice/amount, "
      "saleInfo/listPrice/currencyCode)";

  BookApi(this._api);

  Future<BooksModel> getBooks(BookQuery query, {String? loginType}) async {
    Map<String, dynamic> queryParam = query.toObject();
    queryParam.addAll({
      "fields": items,
    });

    if (loginType == "guest") {
      queryParam["key"] = ApiConfig.apiKey;
    }

    final results = await _api.get(ApiPath.volumes, queryParameters: queryParam);

    return BooksModel.fromJson(results.data);
  }

  Future<BooksModel> getFavoriteBook(BookQuery query) async {
    Map<String, dynamic> queryParam = query.toObject();
    queryParam.addAll({
      "fields": items,
    });

    final results = await _api.get(ApiPath.favoriteBooks, queryParameters: queryParam);

    return BooksModel.fromJson(results.data);
  }

  Future<BookModel> getBook(String id) async {
    final results = await _api.get("${ApiPath.volumes}/$id");

    return BookModel.fromJson(results.data);
  }

  Future<void> addBookToWishlist(String id) async {
    await _api.post(ApiPath.addWishlists, queryParameters: {
      "volumeId": id
    });
  }

  Future<void> removeBookFromWishlist(String id) async {
    await _api.post(ApiPath.removeWishlists, queryParameters: {
      "volumeId": id
    });
  }
}
