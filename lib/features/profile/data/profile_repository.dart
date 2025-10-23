import 'package:dio/dio.dart';
import '../../../services/api_service.dart';
import '../../../core/exception_handler.dart';
import '../domain/score_response.dart';
import '../domain/response_metric_instagram.dart';
import '../domain/response_metric_facebook.dart';

class ProfileRepository {
  final ApiService _apiService;

  ProfileRepository(this._apiService);

  Future<Data> fetchUserScore() async {
    try {
      final response = await _apiService.get('/score');
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
      final response = await _apiService.get('/instagram/metrics');
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
      final response = await _apiService.get('/facebook/metrics');
      final result = ResponseMetricFacebook.fromJson(response.data);
      return result.data;
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    } catch (e) {
      throw ExceptionHandler.handleGenericException(e);
    }
  }

  Future<Map<String, dynamic>> checkInstagramConnectionStatus() async {
    try {
      final response = await _apiService.get('/instagram/metrics');
      final data = response.data as Map<String, dynamic>;

      if (data['success'] == true && data['data'] != null) {
        // If we get metrics data, it means connected
        return {'connected': true, 'data': data['data']};
      } else {
        // If no metrics data, return status indicating not connected
        return {
          'connected': false,
          'message': data['message'] ?? 'Not connected',
        };
      }
    } on DioException catch (e) {
      // Handle various error cases
      if (e.response?.statusCode == 404 || e.response?.statusCode == 400) {
        return {'connected': false, 'message': 'Not connected'};
      }

      // Handle server errors (500, etc.)
      if (e.response?.statusCode != null && e.response!.statusCode! >= 500) {
        return {'connected': false, 'message': 'Server error - not connected'};
      }

      // Handle other DioExceptions
      return {'connected': false, 'message': 'Connection check failed'};
    } catch (e) {
      // Handle any other exceptions
      return {'connected': false, 'message': 'Connection check failed'};
    }
  }

  Future<Map<String, dynamic>> checkFacebookConnectionStatus() async {
    try {
      final response = await _apiService.get('/facebook/metrics');
      final data = response.data as Map<String, dynamic>;

      if (data['success'] == true && data['data'] != null) {
        // If we get metrics data, it means connected
        return {'connected': true, 'data': data['data']};
      } else {
        // If no metrics data, return status indicating not connected
        return {
          'connected': false,
          'message': data['message'] ?? 'Not connected',
        };
      }
    } on DioException catch (e) {
      // Handle various error cases
      if (e.response?.statusCode == 404 || e.response?.statusCode == 400) {
        return {'connected': false, 'message': 'Not connected'};
      }

      // Handle server errors (500, etc.)
      if (e.response?.statusCode != null && e.response!.statusCode! >= 500) {
        return {'connected': false, 'message': 'Server error - not connected'};
      }

      // Handle other DioExceptions
      return {'connected': false, 'message': 'Connection check failed'};
    } catch (e) {
      // Handle any other exceptions
      return {'connected': false, 'message': 'Connection check failed'};
    }
  }
}
