class ApiException implements Exception {
  final String message;
  final String? requestId;
  final int? statusCode;
  final dynamic details;
  final String? source;
  final StackTrace? stackTrace;

  const ApiException(
      this.message, {
        this.requestId,
        this.statusCode,
        this.details,
        this.source,
        this.stackTrace
      });

  @override
  String toString() {
    String result = 'ApiException: $message';

    if (source != null) result += '\nSource: $source';
    if (requestId != null) result += '\nRequest Id: $requestId';
    if (statusCode != null) result += '\nStatus Code: $statusCode';
    if (details != null) result += '\nDetails: $details';

    return result;
  }
}
