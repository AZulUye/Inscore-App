import 'package:dio/dio.dart';

import '../../../services/api_service.dart';
import '../../../core/exception_handler.dart';

class AuthRepository {
  final ApiService _apiService;

  AuthRepository(this._apiService);

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _apiService.post(
        '/login',
        data: {'email': email, 'password': password},
      );

      final data = response.data as Map<String, dynamic>;
      if (data['success'] == true && data['data'] != null) {
        return data['data'] as Map<String, dynamic>;
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: data['error'] ?? data['message'],
      );
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
      final response = await _apiService.post(
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
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: data['message'] ?? 'Register failed',
      );
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    } catch (e) {
      throw ExceptionHandler.handleGenericException(e);
    }
  }

  Future<void> logout() async {
    try {
      final response = await _apiService.post('/logout');

      final data = response.data as Map<String, dynamic>;
      if (data['success'] == true) return;

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: data['error'] ?? data['message'],
      );
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    } catch (e) {
      throw ExceptionHandler.handleGenericException(e);
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      final response = await _apiService.post(
        '/reset-password',
        data: {'email': email},
      );

      final data = response.data as Map<String, dynamic>;
      if (data['success'] == true) return;

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: data['error'] ?? data['message'],
      );
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    } catch (e) {
      throw ExceptionHandler.handleGenericException(e);
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    try {
      final response = await _apiService.post(
        '/profile/change-password',
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
          'new_password_confirmation': newPasswordConfirmation,
        },
      );

      final data = response.data as Map<String, dynamic>;
      if (data['success'] == true) return;

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: data['error'] ?? data['message'],
      );
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    } catch (e) {
      throw ExceptionHandler.handleGenericException(e);
    }
  }

  Future<Map<String, dynamic>> getUser() async {
    try {
      final response = await _apiService.get('/profile');
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

  void setAuthorizationHeader(String token) =>
      _apiService.setAuthorizationHeader(token);

  void removeAuthorizationHeader() => _apiService.removeAuthorizationHeader();
}
