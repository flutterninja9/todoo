import 'package:flutter/material.dart';

enum ViewState { idle, loading, loaded, empty, error }

mixin StateMixin on ChangeNotifier {
  ViewState _state = ViewState.idle;
  String _errorMessage = '';

  ViewState get state => _state;
  String get errorMessage => _errorMessage;

  void setState(ViewState newState, {String errorMessage = ''}) {
    _state = newState;
    _errorMessage = errorMessage;
    notifyListeners();
  }

  void setIdle() {
    _state = ViewState.idle;
    _errorMessage = '';
    notifyListeners();
  }

  void setLoading() {
    _state = ViewState.loading;
    _errorMessage = '';
    notifyListeners();
  }

  void setLoaded() {
    _state = ViewState.loaded;
    _errorMessage = '';
    notifyListeners();
  }

  void setEmpty() {
    _state = ViewState.empty;
    _errorMessage = '';
    notifyListeners();
  }

  void setError(String errorMessage) {
    _state = ViewState.error;
    _errorMessage = errorMessage;
    notifyListeners();
  }
}
