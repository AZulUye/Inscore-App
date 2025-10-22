import 'package:dio/dio.dart';
import '../../../services/api_service.dart';
import '../domain/home_model.dart';

class HomeRepository {
  final ApiService _apiService;

  HomeRepository(this._apiService);

  Future<HomeResponse> getHomeData() async {
    try {
      final response = await _apiService.get('/home');
      return HomeResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response != null) {
        final data = e.response!.data;
        if (data is Map<String, dynamic>) {
          throw HomeException(
            message: data['message'] ?? 'Terjadi kesalahan saat mengambil data',
            statusCode: e.response!.statusCode,
          );
        }
      }
      throw HomeException(
        message: _getErrorMessage(e),
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw HomeException(
        message: 'Terjadi kesalahan yang tidak terduga. Silakan coba lagi.',
      );
    }
  }

  String _getErrorMessage(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Koneksi timeout. Periksa koneksi internet Anda dan coba lagi.';
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 401) {
          return 'Sesi Anda telah berakhir. Silakan login kembali.';
        } else if (statusCode == 403) {
          return 'Anda tidak memiliki akses. Silakan hubungi administrator.';
        } else if (statusCode == 404) {
          return 'Data tidak ditemukan. Silakan coba lagi nanti.';
        } else if (statusCode != null && statusCode >= 500) {
          return 'Server sedang mengalami gangguan. Silakan coba lagi nanti.';
        }
        return 'Terjadi kesalahan. Silakan coba lagi.';
      case DioExceptionType.cancel:
        return 'Permintaan dibatalkan.';
      case DioExceptionType.connectionError:
        return 'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.';
      default:
        return 'Terjadi kesalahan jaringan. Periksa koneksi internet Anda.';
    }
  }
}

class HomeException implements Exception {
  final String message;
  final int? statusCode;

  HomeException({required this.message, this.statusCode});

  @override
  String toString() => message;
}
