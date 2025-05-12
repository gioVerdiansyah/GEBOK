//! Entity
class PaginationEntity<T> {
  final List<T> data;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  PaginationEntity({
    required this.data,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });
}

//! Model
class PaginationModel<T> extends PaginationEntity<T> {
  PaginationModel({
    required super.data,
    required super.total,
    required super.page,
    required super.limit,
    required super.totalPages,
  });

  factory PaginationModel.fromJson(
      Map<String, dynamic> json,
      T Function(Map<String, dynamic>) fromJson,
      ) {
    final raw = json['data'];
    final meta = raw['meta'];

    return PaginationModel<T>(
      data: (raw['data'] as List).map((e) => fromJson(e)).toList(),
      total: meta['total'],
      page: meta['page'],
      limit: meta['limit'],
      totalPages: meta['totalPages'],
    );
  }

  PaginationEntity<T> toEntity() {
    return PaginationEntity<T>(
      data: data,
      total: total,
      page: page,
      limit: limit,
      totalPages: totalPages,
    );
  }
}


//! Extension
extension PaginationModelMapper<T> on PaginationModel<T> {
  PaginationEntity<E> mapToEntity<E>(E Function(T) mapper) {
    return PaginationEntity<E>(
      data: data.map(mapper).toList(),
      total: total,
      page: page,
      limit: limit,
      totalPages: totalPages,
    );
  }
}
