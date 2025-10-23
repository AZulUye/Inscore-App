import 'package:flutter/material.dart';
import 'enums.dart';

abstract class BaseViewModel extends ChangeNotifier {
  ViewState _state = ViewState.idle;
  String _errorMessage = '';

  ViewState get state => _state;
  String get errorMessage => _errorMessage;

  bool get isIdle => _state == ViewState.idle;
  bool get isLoading => _state == ViewState.loading;
  bool get isError => _state == ViewState.error;
  bool get isSuccess => _state == ViewState.success;

  void setState(ViewState newState) {
    _state = newState;
    if (hasListeners) {
      notifyListeners();
    }
  }

  void setLoading(bool bool) {
    setState(ViewState.loading);
  }

  void setIdle() {
    setState(ViewState.idle);
  }

  void setSuccess() {
    setState(ViewState.success);
  }

  void setError(String message) {
    _errorMessage = message;
    setState(ViewState.error);
  }

  void clearError() {
    _errorMessage = '';
    setIdle();
  }

  // Override dispose if needed in subclasses
}
