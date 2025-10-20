import 'package:dio/dio.dart';
import 'package:inscore_app/features/leaderboard/data/models/leaderboard_response_mock.dart';
import 'package:logger/logger.dart';
import '../../../core/constants.dart';
import '../../../core/exception_handler.dart';

class MockApiService {
  late final Dio _dio;
  final Logger _logger = Logger();

  MockApiService() {
    _dio = Dio();
    _initializeDio();
  }

  void _initializeDio() {
    _dio.options = BaseOptions(
      baseUrl: "https://inscore-mock.fly.biz.id",
      connectTimeout: AppConstants.connectTimeout,
      receiveTimeout: AppConstants.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // Add interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          _logger.d('Request: ${options.method} ${options.path}');
          _logger.d('Headers: ${options.headers}');
          if (options.data != null) {
            _logger.d('Data: ${options.data}');
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          _logger.d(
            'Response: ${response.statusCode} ${response.requestOptions.path}',
          );
          _logger.d('Data: ${response.data}');
          handler.next(response);
        },
        onError: (error, handler) {
          _logger.e('Error: ${error.message}');
          _logger.e('Response: ${error.response?.data}');
          handler.next(error);
        },
      ),
    );
  }

  // fetch all user scores for leaderboard screen
  Future<List<UserScore>> fetchLeaderboard(String period) async {
    final queryParams = {'period': period};
    try {
      final response = await _dio.get(
        "/leaderboard",
        queryParameters: queryParams,
      );

      final result = LeaderboardResponseMock.fromJson(response.data);

      if (result.error) {
        throw ExceptionHandler.handleGenericException(result.message);
      }

      return result.data;
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    } catch (e) {
      throw ExceptionHandler.handleGenericException(e);
    }
  }

  // Add authorization header
  void setAuthorizationHeader(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  // Remove authorization header
  void removeAuthorizationHeader() {
    _dio.options.headers.remove('Authorization');
  }
}
