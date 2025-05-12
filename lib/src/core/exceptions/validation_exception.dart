class ValidationException implements Exception {
  final Map<String, dynamic>? validations;
  final String? message;

  const ValidationException(this.validations, {String? message})
      : message = "Error validation";
}