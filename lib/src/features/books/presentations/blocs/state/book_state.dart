import 'package:book_shelf/src/features/books/domain/entities/book_entity.dart';
import 'package:book_shelf/src/features/books/domain/entities/books_entity.dart';
import 'package:book_shelf/src/features/books/domain/entities/simple_book_entity.dart';
import 'package:book_shelf/src/shared/state/api_state.dart';
import 'package:book_shelf/src/shared/utils/book_query_handler.dart';
import 'package:equatable/equatable.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class BookState extends Equatable {
  final ApiState api;
  final BooksEntity listBooks;
  final BookEntity book;
  final BookQuery? query;
  final bool onSearch;
  final bool isWaitingSubmit;
  final PagingState<int, SimpleBookEntity> pagingState;

  BookState({
    ApiState? api,
    BooksEntity? listBooks,
    BookEntity? book,
    this.query,
    this.onSearch = false,
    this.isWaitingSubmit = false,
    PagingState<int, SimpleBookEntity>? pagingState
  }):
        api = api ?? ApiState(),
        listBooks = listBooks ?? BooksEntity.empty(),
        book = book ?? BookEntity.empty(),
        pagingState = pagingState ?? PagingState<int, SimpleBookEntity>();

  BookState copyWith({
    ApiState? api,
    BooksEntity? listBooks,
    BookQuery? query,
    bool? onSearch,
    bool? isWaitingSubmit,
    BookEntity? book,
    PagingState<int, SimpleBookEntity>? pagingState
  }){
    return BookState(
        api: api ?? this.api,
        listBooks: listBooks ?? this.listBooks,
        query: query ?? this.query,
        onSearch: onSearch ?? this.onSearch,
        book: book ?? this.book,
        isWaitingSubmit: isWaitingSubmit ?? this.isWaitingSubmit,
        pagingState: pagingState ?? this.pagingState
    );
  }

  @override
  List<Object?> get props => [api, listBooks, pagingState, query, onSearch, pagingState, book];
}