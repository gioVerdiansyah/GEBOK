import 'package:book_shelf/src/features/books/domain/entities/books_entity.dart';
import 'package:book_shelf/src/features/books/domain/entities/simple_book_entity.dart';
import 'package:book_shelf/src/shared/state/api_state.dart';
import 'package:book_shelf/src/shared/utils/book_query_handler.dart';
import 'package:equatable/equatable.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class BookState extends Equatable {
  final ApiState api;
  final BooksEntity listBooks;
  final BookQuery? query;
  final PagingState<int, SimpleBookEntity>? pagingState;

  BookState({
    ApiState? api,
    BooksEntity? listBooks,
    this.query,
    this.pagingState
  }):
        api = api ?? ApiState(),
        listBooks = listBooks ?? BooksEntity.empty();

  BookState copyWith({
    ApiState? api,
    BooksEntity? listBooks,
    BookQuery? query,
    PagingState<int, SimpleBookEntity>? pagingState
  }){
    return BookState(
        api: api ?? this.api,
        listBooks: listBooks ?? this.listBooks,
        query: query ?? this.query,
        pagingState: pagingState ?? this.pagingState
    );
  }

  @override
  List<Object?> get props => [api, listBooks, pagingState];
}