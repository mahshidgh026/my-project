import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  bool get isPrincipalOrStaff => _currentUser?.isPrincipalOrStaff ?? false;
  bool get isTeacher => _currentUser?.isTeacher ?? false;

  Future<bool> checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = await ApiService.getMe();
      _currentUser = user;
      _isLoading = false;
      notifyListeners();
      return user != null;
    } catch (_) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> login(String phone, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await ApiService.login(phone, password);
    _isLoading = false;

    if (result['success']) {
      _currentUser = result['user'];
      notifyListeners();
      return true;
    } else {
      _errorMessage = result['message'];
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String phone,
    required String password,
    required String role,
    int? classId,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await ApiService.register(
      name: name,
      phone: phone,
      password: password,
      role: role,
      classId: classId,
    );
    _isLoading = false;

    if (result['success']) {
      _currentUser = result['user'];
      notifyListeners();
      return true;
    } else {
      _errorMessage = result['message'];
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await ApiService.clearAuth();
    _currentUser = null;
    notifyListeners();
  }
}
