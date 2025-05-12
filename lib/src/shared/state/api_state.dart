import 'package:book_shelf/src/core/exceptions/app_exception.dart';
import 'package:book_shelf/src/core/network/payload.dart';
import 'package:flutter/foundation.dart';

class ApiState {
  final bool isLoading;
  final bool isSuccess;
  final String? message;
  final AppException? error;
  final Payload payload;
  final Map<String, dynamic> validationErrors;

  ApiState({
    this.isLoading = false,
    this.isSuccess = false,
    this.message,
    this.error,
    Payload? payload,
    this.validationErrors = const {},
  }) : payload = payload ?? Payload.empty();

  bool get isValid => validationErrors.isEmpty;

  String? getFieldError(String field) => validationErrors[field];

  ApiState copyWith({
    Payload? payload,
    bool? isLoading,
    bool? isSuccess,
    String? message,
    AppException? error,
    Map<String, dynamic>? validationErrors,
  }) {
    return ApiState(
      payload: payload ?? this.payload,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      message: message ?? this.message,
      error: error,
      validationErrors: validationErrors ?? this.validationErrors,
    );
  }
}


//! Extension
extension FormDataStateBuilder on ApiState {
  ApiState loading() {
    return copyWith(
      isLoading: true,
      isSuccess: false,
      error: null,
    );
  }

  ApiState success({message}) {
    return copyWith(
      isLoading: false,
      isSuccess: true,
      message: message,
      error: null,
    );
  }

  ApiState errorException(dynamic exception) {
    debugPrint("== ERROR EXCEPTION ==");
    debugPrint(exception.toString());
    return copyWith(
      isLoading: false,
      isSuccess: false,
      error: AppException(
        exception.toString(),
        stackTrace: exception.stackTrace,
        source: exception.source,
      ),
    );
  }

  ApiState withPayload(Payload payload) {
    return copyWith(payload: payload);
  }

  ApiState withValidationErrors(Map<String, dynamic>? validationErrors) {
    return copyWith(
      validationErrors: validationErrors ?? {},
      isLoading: false,
    );
  }
}

extension FormDataStateFieldUpdater on ApiState {
  ApiState updateField(String key, dynamic value) {
    final updatedPayload = payload.copyWith(updatedFields: {key: value});
    return copyWith(payload: updatedPayload, validationErrors: {});
  }
}