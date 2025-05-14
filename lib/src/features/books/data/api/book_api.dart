import 'package:book_shelf/src/core/network/api_client.dart';
import 'package:book_shelf/src/core/network/api_path.dart';
import 'package:book_shelf/src/shared/utils/book_query_handler.dart';

import '../../../../core/config/api_config.dart';
import '../models/books_model.dart';
import '../models/book_model.dart';

class BookApi {
  final ApiClient _api;

  BookApi(this._api);

  Future<BooksModel> getBooks(BookQuery query, {String? loginType}) async {
    Map<String, dynamic> queryParam = query.toObject();
    queryParam.addAll({
      "fields":
          "items(id,volumeInfo/title,volumeInfo/description, volumeInfo/averageRating, volumeInfo/authors, "
          "volumeInfo/imageLinks/thumbnail, saleInfo/listPrice/amount, saleInfo/retailPrice/amount, "
          "saleInfo/listPrice/currencyCode)",
    });

    // if (loginType == "guest") {
    print("== LOGIN AS GUEST ==");
    print("API KEY: ${ApiConfig.apiKey}");
    queryParam["key"] = ApiConfig.apiKey;
    // }

    print("=== PARAMS ===");
    print(queryParam);

    final results = await _api.get(ApiPath.volumes, queryParameters: queryParam);

    return BooksModel.fromJson(results.data);
  }

  Future<BookModel> getBook(String id) async {
    final results = await _api.get("${ApiPath.volumes}/$id");

    return BookModel.fromJson(results.data);
  }
}
