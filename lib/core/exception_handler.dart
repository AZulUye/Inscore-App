import 'package:logger/logger.dart';
import 'package:dio/dio.dart';

class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  AppException(this.message, {this.code, this.details});

  @override
  String toString() {
    return 'AppException: $message${code != null ? ' (Code: $code)' : ''}';
  }
}

class NetworkException extends AppException {
  NetworkException(super.message, {super.code, super.details});
}

class ServerException extends AppException {
  ServerException(super.message, {super.code, super.details});
}

class ValidationException extends AppException {
  ValidationException(super.message, {super.code, super.details});
}

class AuthenticationException extends AppException {
  AuthenticationException(super.message, {super.code, super.details});
}

class ExceptionHandler {
  static final Logger _logger = Logger();

  static AppException handleDioException(DioException dioException) {
    _logger.e('DioException: ${dioException.message}', 
      error: dioException,
              stackTrace: dioException.stackTrace);

    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          'Connection timeout. Please check your internet connection.',
          code: 'TIMEOUT',
          details: dioException,
        );

      case DioExceptionType.badResponse:
        final statusCode = dioException.response?.statusCode;
        switch (statusCode) {
          case 400:
            return ValidationException(
              'Invalid request. Please check your input.',
              code: 'BAD_REQUEST',
              details: dioException.response?.data,
            );
          case 422:
            // Validation error from backend (Laravel style)
            final data = dioException.response?.data;
            String message = 'Validation error';
            if (data is Map<String, dynamic>) {
              if (data['error'] is Map<String, dynamic>) {
                final errors = data['error'] as Map<String, dynamic>;
                final firstKey = errors.keys.isNotEmpty
                    ? errors.keys.first
                    : null;
                final firstVal = firstKey != null ? errors[firstKey] : null;
                if (firstVal is List && firstVal.isNotEmpty) {
                  message = firstVal.first.toString();
                }
              } else
              if (data['message'] is String &&
                  (data['message'] as String).isNotEmpty) {
                message = data['message'];
              } 
            }
            return ValidationException(
              message,
              code: 'UNPROCESSABLE_ENTITY',
              details: data,
            );
          case 401:
            return AuthenticationException(
              'Authentication failed. Please login again.',
              code: 'UNAUTHORIZED',
              details: dioException.response?.data,
            );
          case 403:
            return AuthenticationException(
              'Access denied. You don\'t have permission.',
              code: 'FORBIDDEN',
              details: dioException.response?.data,
            );
          case 404:
            return ServerException(
              'Resource not found.',
              code: 'NOT_FOUND',
              details: dioException.response?.data,
            );
          case 500:
          case 502:
          case 503:
            return ServerException(
              'Server error. Please try again later.',
              code: 'SERVER_ERROR',
              details: dioException.response?.data,
            );
          default:
            return ServerException(
              'Server error occurred.',
              code: statusCode.toString(),
              details: dioException.response?.data,
            );
        }

      case DioExceptionType.cancel:
        return AppException(
          'Request was cancelled.',
          code: 'CANCELLED',
          details: dioException,
        );

      case DioExceptionType.unknown:
      default:
        return NetworkException(
          'Network error. Please check your internet connection.',
          code: 'NETWORK_ERROR',
          details: dioException,
        );
    }
  }

  static AppException handleGenericException(dynamic exception) {
    _logger.e('Generic Exception: $exception');

    if (exception is AppException) {
      return exception;
    }

    return AppException(
      'An unexpected error occurred.',
      code: 'UNKNOWN_ERROR',
      details: exception,
    );
  }

  static String getErrorMessage(dynamic exception) {
    if (exception is AppException) {
      return exception.message;
    }

    if (exception is DioException) {
      return handleDioException(exception).message;
    }

    _logger.e('Unhandled exception: $exception');
    return 'An unexpected error occurred.';
  }

  static void logException(dynamic exception, [StackTrace? stackTrace]) {
    _logger.e('Exception logged', error: exception, stackTrace: stackTrace);
  }
}
