class Payload {
  final Map<String, dynamic> fields;

  Payload({Map<String, dynamic>? fields}) : fields = fields ?? {};

  /// Copy with updated fields
  Payload copyWith({Map<String, dynamic>? updatedFields}) {
    return Payload(fields: {...fields, ...?updatedFields});
  }

  /// Create empty Payload
  factory Payload.empty() {
    return Payload();
  }

  /// Get field with generic type
  T? getField<T>(String key) => fields[key] as T?;

  /// Set field
  void setField(String key, dynamic value) {
    fields[key] = value;
  }

  /// Remove field
  void removeField(String key) {
    fields.remove(key);
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return fields;
  }
}
