import 'package:flutter/material.dart';

import '../../models/run_model.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../services/run_service.dart';

class DashboardViewModel extends ChangeNotifier {
  final AuthService _authService;
  final RunService _runService;

  DashboardViewModel(
    this._authService,
    this._runService,
  );

  UserModel? currentUser;

  List<RunModel> runs = [];
  List<RunModel> weekRuns = [];

  bool isLoading = false;

  double totalDistance = 0;
  int totalDuration = 0;
  int totalCalories = 0;

  Future<void> init() async {
    isLoading = true;
    notifyListeners();

    currentUser = await _authService.getCurrentUser();

    if (currentUser != null) {
      runs = await _runService.runsForUser(currentUser!.id);

      weekRuns = _runService.thisWeekRuns(runs);

      totalDistance = _runService.totalDistance(runs);

      totalDuration = _runService.totalDuration(runs);

      totalCalories = _runService.totalCalories(runs);
    }

    isLoading = false;
    notifyListeners();
  }
}