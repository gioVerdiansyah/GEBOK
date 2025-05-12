class AppException implements Exception {
  final String message;
  final String? source;
  final StackTrace? stackTrace;

  const AppException(this.message, {this.source, this.stackTrace});

  @override
  String toString() {
    String result = message;
    if (source != null) result += '\nSource: $source';
    if (stackTrace != null) result += '\nStackTrace: $stackTrace';
    return result;
  }
}