import 'package:flutter/foundation.dart';
import '../features/home/data/home_repository.dart';
import '../features/home/domain/home_model.dart';

enum HomeStatus { initial, loading, success, error }

class HomeProvider extends ChangeNotifier {
  final HomeRepository _homeRepository;

  HomeProvider(this._homeRepository);

  HomeStatus _status = HomeStatus.initial;
  HomeData? _homeData;
  String? _errorMessage;

  HomeStatus get status => _status;
  HomeData? get homeData => _homeData;
  String? get errorMessage => _errorMessage;

  bool get isLoading => _status == HomeStatus.loading;
  bool get hasError => _status == HomeStatus.error;
  bool get hasData => _homeData != null;

  Future<void> fetchHomeData() async {
    _status = HomeStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _homeRepository.getHomeData();
      
      if (response.success && response.data != null) {
        _homeData = response.data;
        _status = HomeStatus.success;
      } else {
        _errorMessage = response.message.isNotEmpty 
            ? response.message 
            : 'Gagal memuat data. Silakan coba lagi.';
        _status = HomeStatus.error;
      }
    } on HomeException catch (e) {
      _errorMessage = e.message;
      _status = HomeStatus.error;
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan yang tidak terduga. Silakan coba lagi.';
      _status = HomeStatus.error;
    }

    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> refresh() async {
    await fetchHomeData();
  }
}
