import 'package:flutter/material.dart';

import '../../services/auth_service.dart';

class SplashViewModel extends ChangeNotifier {
  final AuthService _authService;

  SplashViewModel(this._authService);

  bool isLoggedIn = false;

  Future<void> init() async {
    await Future.delayed(
      const Duration(milliseconds: 2800),
    );

    final user = await _authService.getCurrentUser();

    isLoggedIn = user != null;

    notifyListeners();
  }
}