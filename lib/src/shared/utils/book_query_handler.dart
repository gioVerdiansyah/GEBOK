class BookQuery {
  final String? title;
  final String? author;
  final String? publisher;
  final String? subject;
  final String? isbn;
  final String? filterBy;
  final String? orderBy;
  final int? maxResults;
  final int? startIndex;

  BookQuery({
    this.title,
    this.author,
    this.publisher,
    this.subject,
    this.isbn,
    this.filterBy,
    this.orderBy,
    this.maxResults,
    this.startIndex,
  });

  String toQueryParams() {
    List<String> filters = [];

    if (title != null) {
      filters.add('intitle:${Uri.encodeComponent(title!)}');
    }
    if (author != null) {
      filters.add('inauthor:${Uri.encodeComponent(author!)}');
    }
    if (publisher != null) {
      filters.add('inpublisher:${Uri.encodeComponent(publisher!)}');
    }
    if (subject != null) {
      filters.add('subject:${Uri.encodeComponent(subject!)}');
    }
    if (isbn != null) {
      filters.add('isbn:${Uri.encodeComponent(isbn!)}');
    }


    String q = filters.join('+');
    List<String> params = ['q=$q'];

    if (maxResults != null) {
      params.add('maxResults=$maxResults');
    }
    if (startIndex != null) {
      params.add('startIndex=$startIndex');
    }
    if (filterBy != null) {
      params.add('filter=$filterBy');
    }
    if (orderBy != null) {
      params.add('filter=$orderBy');
    }

    return params.join('&');
  }
}
