import 'package:flutter/material.dart';

import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../services/run_service.dart';

class ProfileViewModel extends ChangeNotifier {
  final AuthService _authService;
  final RunService _runService;

  ProfileViewModel(
    this._authService,
    this._runService,
  );

  UserModel? currentUser;

  bool isLoading = false;

  double totalDistance = 0;

  int totalRuns = 0;

  int totalCalories = 0;

  Future<void> init() async {
    isLoading = true;

    notifyListeners();

    currentUser = await _authService.getCurrentUser();

    if (currentUser != null) {
      final runs = await _runService.runsForUser(
        currentUser!.id,
      );

      totalRuns = runs.length;

      totalDistance = _runService.totalDistance(runs);

      totalCalories = _runService.totalCalories(runs);
    }

    isLoading = false;

    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.logout();
  }

  Future<void> refresh() async {
  await init();
}
}