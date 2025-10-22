import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../core/constants.dart';
import '../core/exception_handler.dart';
import '../features/profile/data/models/score_response.dart';
import '../features/profile/data/models/response_metric_facebook.dart';
import '../features/profile/data/models/response_metric_instagram.dart';

class ApiService {
  late final Dio _dio;
  final Logger _logger = Logger();

  ApiService() {
    _dio = Dio();
    _initializeDio();
  }

  void _initializeDio() {
    _dio.options = BaseOptions(
      baseUrl: AppConstants.baseUrl,
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

  // Authentication endpoints
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {'email': email, 'password': password},
      );
      final data = response.data as Map<String, dynamic>;
      if (data['success'] == true && data['data'] != null) {
        return data['data'] as Map<String, dynamic>;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: data['message'] ?? 'Login failed',
        );
      }
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    } catch (e) {
      throw ExceptionHandler.handleGenericException(e);
    }
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _dio.post(
        '/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      final data = response.data as Map<String, dynamic>;
      if (data['success'] == true && data['data'] != null) {
        return data['data'] as Map<String, dynamic>;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: data['message'] ?? 'Register failed',
        );
      }
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    } catch (e) {
      throw ExceptionHandler.handleGenericException(e);
    }
  }

  Future<void> logout() async {
    try {
      // Mock logout
      await Future.delayed(const Duration(milliseconds: 500));

      // For real implementation:
      // await _dio.post('/auth/logout');
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    } catch (e) {
      throw ExceptionHandler.handleGenericException(e);
    }
  }

  // User endpoints
  Future<Map<String, dynamic>> getUser() async {
    try {
      final response = await _dio.get('/profile');
      final data = response.data;
      if (data['success'] == true && data['data'] != null) {
        return data['data'] as Map<String, dynamic>;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: data['message'] ?? 'Failed to fetch user',
        );
      }
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    } catch (e) {
      throw ExceptionHandler.handleGenericException(e);
    }
  }

  Future<Map<String, dynamic>> updateUser(Map<String, dynamic> userData) async {
    try {
      // Mock update user for demo purposes
      await Future.delayed(const Duration(milliseconds: 500));

      return {...userData, 'updatedAt': DateTime.now().toIso8601String()};

      // For real implementation:
      // final response = await _dio.put('/users/${userData['id']}', data: userData);
      // return response.data;
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    } catch (e) {
      throw ExceptionHandler.handleGenericException(e);
    }
  }

  Future<Map<String, dynamic>> updateProfile({
    required String name,
    required String email,
    String? avatarPath,
  }) async {
    try {
      Map<String, dynamic> formDataMap = {'name': name, 'email': email};

      if (avatarPath != null && avatarPath.isNotEmpty) {
        try {
          formDataMap['avatar'] = await MultipartFile.fromFile(avatarPath);
          _logger.d('Avatar file added: $avatarPath');
        } catch (e) {
          _logger.e('Error creating MultipartFile: $e');
          // Continue without avatar if file creation fails
        }
      }

      FormData formData = FormData.fromMap(formDataMap);

      _logger.d('FormData fields: ${formData.fields}');
      _logger.d('FormData files: ${formData.files}');

      final response = await _dio.post(
        '/profile',
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
          sendTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
        ),
      );
      final data = response.data as Map<String, dynamic>;

      if (data['success'] == true && data['data'] != null) {
        return data['data'] as Map<String, dynamic>;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: data['message'] ?? 'Failed to update profile',
        );
      }
    } on DioException catch (e) {
      _logger.e('DioException in updateProfile: ${e.message}');
      _logger.e('Response data: ${e.response?.data}');
      _logger.e('Request data: ${e.requestOptions.data}');
      throw ExceptionHandler.handleDioException(e);
    } catch (e) {
      _logger.e('Generic exception in updateProfile: $e');
      throw ExceptionHandler.handleGenericException(e);
    }
  }

  // Alternative method for testing without multipart
  Future<Map<String, dynamic>> updateProfileSimple({
    required String name,
    required String email,
  }) async {
    try {
      _logger.d('Updating profile with name: $name, email: $email');

      final response = await _dio.post(
        '/profile',
        data: {'name': name, 'email': email},
        options: Options(
          headers: {'Content-Type': 'application/json'},
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      final data = response.data as Map<String, dynamic>;
      _logger.d('Profile update response: $data');

      if (data['success'] == true && data['data'] != null) {
        return data['data'] as Map<String, dynamic>;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: data['message'] ?? 'Failed to update profile',
        );
      }
    } on DioException catch (e) {
      _logger.e('DioException in updateProfileSimple: ${e.message}');
      _logger.e('Response data: ${e.response?.data}');
      throw ExceptionHandler.handleDioException(e);
    } catch (e) {
      _logger.e('Generic exception in updateProfileSimple: $e');
      throw ExceptionHandler.handleGenericException(e);
    }
  }

  // Generic request methods
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    } catch (e) {
      throw ExceptionHandler.handleGenericException(e);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    } catch (e) {
      throw ExceptionHandler.handleGenericException(e);
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    } catch (e) {
      throw ExceptionHandler.handleGenericException(e);
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    } catch (e) {
      throw ExceptionHandler.handleGenericException(e);
    }
  }

  //fetch user score for profile screens
  Future<Data> fetchUserScore() async {
    try {
      final response = await _dio.get('/score');
      final result = ResponseScore.fromJson(response.data);
      return result.data;
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    } catch (e) {
      throw ExceptionHandler.handleGenericException(e);
    }
  }

  Future<DataInstagram> fetchInstagramMetrics() async {
    try {
      final response = await _dio.get('/instagram/metrics');
      final result = ResponseMetricInstagram.fromJson(response.data);
      return result.data;
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    } catch (e) {
      throw ExceptionHandler.handleGenericException(e);
    }
  }

  Future<DataFacebook> fetchFacebookMetrics() async {
    try {
      final response = await _dio.get('/facebook/metrics');
      final result = ResponseMetricFacebook.fromJson(response.data);
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
