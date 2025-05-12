class RepositoryException implements Exception {
  final String message;
  final dynamic details;
  final String? source;
  final StackTrace? stackTrace;

  const RepositoryException(
      this.message, {
        this.details,
        this.source,
        this.stackTrace
      });

  @override
  String toString() {
    String result = 'RepositoryException: $message';

    if (source != null) result += '\nSource: $source';
    if (details != null) result += '\nDetails: $details';

    return result;
  }
}
