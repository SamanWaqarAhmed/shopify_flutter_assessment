import 'dart:io';

import 'package:dio/dio.dart';

enum ApiErrorType {
  noConnection,
  timeout,
  notFound,
  server,
  cancelled,
  parsing,
  unknown,
}

class ApiException implements Exception {
  const ApiException({
    required this.type,
    required this.message,
    this.statusCode,
  });

  const ApiException.parsing()
      : type = ApiErrorType.parsing,
        message = 'Received an unexpected response from the server.',
        statusCode = null;

  factory ApiException.fromDio(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiException(
          type: ApiErrorType.timeout,
          message: 'The request timed out. Please try again.',
        );
      case DioExceptionType.connectionError:
        return const ApiException(
          type: ApiErrorType.noConnection,
          message: 'No internet connection.',
        );
      case DioExceptionType.badResponse:
        final code = error.response?.statusCode;
        if (code == 404) {
          return ApiException(
            type: ApiErrorType.notFound,
            message: 'The requested item was not found.',
            statusCode: code,
          );
        }
        return ApiException(
          type: ApiErrorType.server,
          message: 'Server error ($code). Please try again later.',
          statusCode: code,
        );
      case DioExceptionType.cancel:
        return const ApiException(
          type: ApiErrorType.cancelled,
          message: 'The request was cancelled.',
        );
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return const ApiException(
            type: ApiErrorType.noConnection,
            message: 'No internet connection.',
          );
        }
        return const ApiException(
          type: ApiErrorType.unknown,
          message: 'Something went wrong. Please try again.',
        );
      case DioExceptionType.transformTimeout:
        return const ApiException(
          type: ApiErrorType.timeout,
          message: 'The request timed out. Please try again.',
        );
    }
  }

  final ApiErrorType type;
  final String message;
  final int? statusCode;

  @override
  String toString() => 'ApiException($type, status: $statusCode): $message';
}