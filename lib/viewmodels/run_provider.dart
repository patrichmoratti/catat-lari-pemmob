import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/run_model.dart';

class RunProvider extends ChangeNotifier {
  List<RunModel> _allRuns = [];
  bool _isInitialized = false;

  static const _uuid = Uuid();

  bool get isInitialized => _isInitialized;

  RunProvider() {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString('cl_runs');

    if (json == null) {
      _allRuns = _seedRuns();
      await _persist(prefs);
    } else {
      final decoded = jsonDecode(json) as List;
      _allRuns =
          decoded.map((e) => RunModel.fromJson(e as Map<String, dynamic>)).toList();
    }

    _isInitialized = true;
    notifyListeners();
  }

  List<RunModel> _seedRuns() {
    final now = DateTime.now();
    return [
      RunModel(id: 'r-001', userId: 'u-001', date: now.subtract(const Duration(days: 1)), distanceKm: 5.2, durationMinutes: 32),
      RunModel(id: 'r-002', userId: 'u-001', date: now.subtract(const Duration(days: 3)), distanceKm: 8.0, durationMinutes: 48),
      RunModel(id: 'r-003', userId: 'u-001', date: now.subtract(const Duration(days: 5)), distanceKm: 3.5, durationMinutes: 22),
      RunModel(id: 'r-004', userId: 'u-001', date: now.subtract(const Duration(days: 9)), distanceKm: 10.0, durationMinutes: 61),
      RunModel(id: 'r-005', userId: 'u-001', date: now.subtract(const Duration(days: 13)), distanceKm: 6.8, durationMinutes: 43),
      RunModel(id: 'r-006', userId: 'u-001', date: now.subtract(const Duration(days: 17)), distanceKm: 4.0, durationMinutes: 26),
      RunModel(id: 'r-007', userId: 'u-002', date: now.subtract(const Duration(days: 2)), distanceKm: 5.0, durationMinutes: 35),
      RunModel(id: 'r-008', userId: 'u-002', date: now.subtract(const Duration(days: 6)), distanceKm: 7.5, durationMinutes: 50),
      RunModel(id: 'r-009', userId: 'u-003', date: now.subtract(const Duration(days: 1)), distanceKm: 3.0, durationMinutes: 20),
      RunModel(id: 'r-010', userId: 'u-003', date: now.subtract(const Duration(days: 4)), distanceKm: 12.0, durationMinutes: 72),
    ];
  }

  Future<void> _persist(SharedPreferences prefs) async {
    await prefs.setString(
        'cl_runs', jsonEncode(_allRuns.map((r) => r.toJson()).toList()));
  }

  List<RunModel> runsForUser(String userId) => _allRuns
      .where((r) => r.userId == userId)
      .toList()
    ..sort((a, b) => b.date.compareTo(a.date));

  double totalDistanceForUser(String userId) =>
      runsForUser(userId).fold(0.0, (s, r) => s + r.distanceKm);

  int totalDurationForUser(String userId) =>
      runsForUser(userId).fold(0, (s, r) => s + r.durationMinutes);

  int totalCaloriesForUser(String userId) =>
      runsForUser(userId).fold(0, (s, r) => s + r.calories);

  List<RunModel> thisWeekRunsForUser(String userId) {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday - 1));
    return runsForUser(userId)
        .where((r) => r.date.isAfter(start.subtract(const Duration(seconds: 1))))
        .toList();
  }

  Future<void> addRun({
    required String userId,
    required DateTime date,
    required double distanceKm,
    required int durationMinutes,
  }) async {
    _allRuns.add(RunModel(
      id: _uuid.v4(),
      userId: userId,
      date: date,
      distanceKm: distanceKm,
      durationMinutes: durationMinutes,
    ));
    final prefs = await SharedPreferences.getInstance();
    await _persist(prefs);
    notifyListeners();
  }

  Future<void> updateRun(RunModel updated) async {
    final idx = _allRuns.indexWhere((r) => r.id == updated.id);
    if (idx == -1) return;
    _allRuns[idx] = updated;
    final prefs = await SharedPreferences.getInstance();
    await _persist(prefs);
    notifyListeners();
  }

  Future<void> deleteRun(String id) async {
    _allRuns.removeWhere((r) => r.id == id);
    final prefs = await SharedPreferences.getInstance();
    await _persist(prefs);
    notifyListeners();
  }
}
