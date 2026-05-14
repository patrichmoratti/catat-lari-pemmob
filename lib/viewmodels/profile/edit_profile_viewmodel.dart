import 'package:flutter/material.dart';

import '../../models/user_model.dart';
import '../../services/auth_service.dart';

class EditProfileViewModel extends ChangeNotifier {
  final AuthService _authService;

  EditProfileViewModel(this._authService);

  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();

  final emailController = TextEditingController();

  final phoneController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  UserModel? currentUser;

  bool obscurePassword = true;

  bool obscureConfirmPassword = true;

  bool changePassword = false;

  bool isLoading = false;

  String? errorMessage;

  Future<void> init() async {
    currentUser = await _authService.getCurrentUser();

    if (currentUser != null) {
      nameController.text = currentUser!.name;

      emailController.text = currentUser!.email;

      phoneController.text = currentUser!.phone;
    }

    notifyListeners();
  }

  String get avatarInitial {
    final t = nameController.text.trim();

    return t.isNotEmpty
        ? t[0].toUpperCase()
        : 'U';
  }

  void togglePassword() {
    obscurePassword = !obscurePassword;

    notifyListeners();
  }

  void toggleConfirmPassword() {
    obscureConfirmPassword = !obscureConfirmPassword;

    notifyListeners();
  }

  void toggleChangePassword(bool value) {
    changePassword = value;

    notifyListeners();
  }

  Future<bool> save() async {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    isLoading = true;

    errorMessage = null;

    notifyListeners();

    final result = await _authService.updateProfile(
      name: nameController.text,
      email: emailController.text,
      phone: phoneController.text,
      newPassword: changePassword &&
              passwordController.text.isNotEmpty
          ? passwordController.text
          : null,
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
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}