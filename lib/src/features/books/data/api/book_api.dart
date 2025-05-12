import 'package:book_shelf/src/core/network/api_client.dart';
import 'package:book_shelf/src/core/network/api_path.dart';
import 'package:book_shelf/src/features/books/data/models/book_model.dart';
import 'package:book_shelf/src/shared/utils/book_query_handler.dart';

class BookApi{
  final ApiClient _api;

  BookApi(this._api);

  Future<BooksModel> getBooks(BookQuery query) async {
    final String queryParam = query.toQueryParams();
    final results = await _api.get("${ApiPath.books}&$queryParam");

    return BooksModel.fromJson(results.data);
  }
}