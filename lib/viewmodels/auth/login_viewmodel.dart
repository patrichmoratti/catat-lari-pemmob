import 'package:flutter/material.dart';

import '../../services/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService;

  LoginViewModel(this._authService);

  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;

  bool isLoading = false;

  String? errorMessage;

  void togglePassword() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  void fillDemo(String email, String password) {
    emailController.text = email;
    passwordController.text = password;
    notifyListeners();
  }

  Future<bool> login() async {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 700));

    final result = await _authService.login(
      emailController.text.trim(),
      passwordController.text,
    );

    isLoading = false;

    if (result != null) {
      errorMessage = result;
      notifyListeners();
      return false;
    }

    notifyListeners();
    return true;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}