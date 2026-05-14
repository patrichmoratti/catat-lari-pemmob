import 'package:flutter/material.dart';

import '../../models/run_model.dart';
import '../../services/auth_service.dart';
import '../../services/run_service.dart';

class CreateRunViewModel extends ChangeNotifier {
  final RunService _runService;
  final AuthService _authService;

  CreateRunViewModel(
    this._runService,
    this._authService,
    this.existing,
  ) {
    _init();
  }

  final RunModel? existing;

  final formKey = GlobalKey<FormState>();

  final distanceController = TextEditingController();

  final hourController = TextEditingController();

  final minuteController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  bool isSaving = false;

  bool get isEdit => existing != null;

  void _init() {
    if (existing != null) {
      selectedDate = existing!.date;

      distanceController.text =
          existing!.distanceKm.toString();

      final h = existing!.durationMinutes ~/ 60;

      final m = existing!.durationMinutes % 60;

      if (h > 0) {
        hourController.text = h.toString();
      }

      minuteController.text = m.toString();
    }

    distanceController.addListener(notifyListeners);
    hourController.addListener(notifyListeners);
    minuteController.addListener(notifyListeners);
  }

  double? get previewDistance {
    return double.tryParse(
      distanceController.text.replaceAll(',', '.'),
    );
  }

  int get previewTotalMinutes {
    return (int.tryParse(hourController.text) ?? 0) * 60 +
        (int.tryParse(minuteController.text) ?? 0);
  }

  String? get previewPace {
    final d = previewDistance;

    final t = previewTotalMinutes;

    if (d == null || d <= 0 || t <= 0) {
      return null;
    }

    final p = t / d;

    final pm = p.floor();

    final ps = ((p - pm) * 60).round();

    return "$pm'${ps.toString().padLeft(2, '0')}\"";
  }

  int? get previewCalories {
    final d = previewDistance;

    if (d == null || d <= 0) return null;

    return (d * 62).round();
  }

  Future<void> pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      selectedDate = picked;
      notifyListeners();
    }
  }

  Future<bool> save() async {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    final dist = double.tryParse(
      distanceController.text.replaceAll(',', '.'),
    )!;

    final total = previewTotalMinutes;

    if (total <= 0) {
      return false;
    }

    isSaving = true;

    notifyListeners();

    if (isEdit) {
      await _runService.updateRun(
        existing!.copyWith(
          date: selectedDate,
          distanceKm: dist,
          durationMinutes: total,
        ),
      );
    } else {
      final user = await _authService.getCurrentUser();

      if (user == null) {
        isSaving = false;
        notifyListeners();
        return false;
      }

      await _runService.addRun(
        userId: user.id,
        date: selectedDate,
        distanceKm: dist,
        durationMinutes: total,
      );
    }

    isSaving = false;

    notifyListeners();

    return true;
  }

  @override
  void dispose() {
    distanceController.dispose();
    hourController.dispose();
    minuteController.dispose();
    super.dispose();
  }
}