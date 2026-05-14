import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/run_model.dart';

class RunService {
  static const _uuid = Uuid();

  Future<List<RunModel>> getRuns() async {
    final prefs = await SharedPreferences.getInstance();

    final json = prefs.getString('cl_runs');

    if (json == null) {
      final seed = _seedRuns();

      await saveRuns(seed);

      return seed;
    }

    final decoded = jsonDecode(json) as List;

    return decoded
        .map((e) => RunModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveRuns(List<RunModel> runs) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      'cl_runs',
      jsonEncode(
        runs.map((e) => e.toJson()).toList(),
      ),
    );
  }

  Future<List<RunModel>> runsForUser(String userId) async {
    final runs = await getRuns();

    return runs.where((r) => r.userId == userId).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  double totalDistance(List<RunModel> runs) {
    return runs.fold(
      0.0,
      (s, r) => s + r.distanceKm,
    );
  }

  int totalDuration(List<RunModel> runs) {
    return runs.fold(
      0,
      (s, r) => s + r.durationMinutes,
    );
  }

  int totalCalories(List<RunModel> runs) {
    return runs.fold(
      0,
      (s, r) => s + r.calories,
    );
  }

  List<RunModel> thisWeekRuns(List<RunModel> runs) {
    final now = DateTime.now();

    final start = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(
      Duration(days: now.weekday - 1),
    );

    return runs.where(
      (r) {
        return r.date.isAfter(
          start.subtract(
            const Duration(seconds: 1),
          ),
        );
      },
    ).toList();
  }

  Future<void> addRun({
    required String userId,
    required DateTime date,
    required double distanceKm,
    required int durationMinutes,
  }) async {
    final runs = await getRuns();

    runs.add(
      RunModel(
        id: _uuid.v4(),
        userId: userId,
        date: date,
        distanceKm: distanceKm,
        durationMinutes: durationMinutes,
      ),
    );

    await saveRuns(runs);
  }

  Future<void> updateRun(RunModel updated) async {
    final runs = await getRuns();

    final idx = runs.indexWhere((r) => r.id == updated.id);

    if (idx == -1) return;

    runs[idx] = updated;

    await saveRuns(runs);
  }

  Future<void> deleteRun(String id) async {
    final runs = await getRuns();

    runs.removeWhere((r) => r.id == id);

    await saveRuns(runs);
  }

  List<RunModel> _seedRuns() {
    final now = DateTime.now();

    return [
      RunModel(
        id: 'r-001',
        userId: 'u-001',
        date: now.subtract(const Duration(days: 1)),
        distanceKm: 5.2,
        durationMinutes: 32,
      ),
      RunModel(
        id: 'r-002',
        userId: 'u-001',
        date: now.subtract(const Duration(days: 3)),
        distanceKm: 8.0,
        durationMinutes: 48,
      ),
    ];
  }
}