import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  List<UserModel> _users = [];
  bool _isLoading = false;
  bool _isInitialized = false;

  static const _uuid = Uuid();

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;

  AuthProvider() {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString('cl_users');

    if (usersJson == null) {
      _users = _seedUsers();
      await _persistUsers(prefs);
    } else {
      final decoded = jsonDecode(usersJson) as List;
      _users = decoded.map((e) => UserModel.fromJson(e as Map<String, dynamic>)).toList();
    }

    final uid = prefs.getString('cl_current_user_id');
    if (uid != null) {
      try {
        _currentUser = _users.firstWhere((u) => u.id == uid);
      } catch (_) {}
    }

    _isInitialized = true;
    notifyListeners();
  }

  List<UserModel> _seedUsers() => [
        UserModel(
          id: 'u-001',
          name: 'Reza Pratama',
          email: 'reza@gmail.com',
          phone: '08123456789',
          password: 'reza123',
        ),
        UserModel(
          id: 'u-002',
          name: 'Sari Dewi',
          email: 'sari@gmail.com',
          phone: '08987654321',
          password: 'sari123',
        ),
        UserModel(
          id: 'u-003',
          name: 'Budi Santoso',
          email: 'budi@gmail.com',
          phone: '08234567890',
          password: 'budi123',
        ),
      ];

  Future<void> _persistUsers(SharedPreferences prefs) async {
    await prefs.setString(
        'cl_users', jsonEncode(_users.map((u) => u.toJson()).toList()));
  }

  Future<String?> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 700));

    try {
      final user = _users.firstWhere(
        (u) =>
            u.email.toLowerCase() == email.trim().toLowerCase() &&
            u.password == password,
      );
      _currentUser = user;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('cl_current_user_id', user.id);
      _isLoading = false;
      notifyListeners();
      return null;
    } catch (_) {
      _isLoading = false;
      notifyListeners();
      return 'Email atau password salah.';
    }
  }

  Future<String?> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 700));

    final exists = _users.any(
        (u) => u.email.toLowerCase() == email.trim().toLowerCase());
    if (exists) {
      _isLoading = false;
      notifyListeners();
      return 'Email sudah terdaftar. Gunakan email lain.';
    }

    final user = UserModel(
      id: _uuid.v4(),
      name: name.trim(),
      email: email.trim(),
      phone: phone.trim(),
      password: password,
    );
    _users.add(user);
    _currentUser = user;

    final prefs = await SharedPreferences.getInstance();
    await _persistUsers(prefs);
    await prefs.setString('cl_current_user_id', user.id);

    _isLoading = false;
    notifyListeners();
    return null;
  }

  Future<String?> updateProfile({
    required String name,
    required String email,
    required String phone,
    String? newPassword,
  }) async {
    if (_currentUser == null) return 'Tidak ada sesi aktif.';

    final emailTaken = _users.any((u) =>
        u.email.toLowerCase() == email.trim().toLowerCase() &&
        u.id != _currentUser!.id);
    if (emailTaken) return 'Email sudah digunakan akun lain.';

    final idx = _users.indexWhere((u) => u.id == _currentUser!.id);
    if (idx == -1) return 'Pengguna tidak ditemukan.';

    _users[idx] = _users[idx].copyWith(
      name: name.trim(),
      email: email.trim(),
      phone: phone.trim(),
      password: newPassword,
    );
    _currentUser = _users[idx];

    final prefs = await SharedPreferences.getInstance();
    await _persistUsers(prefs);
    notifyListeners();
    return null;
  }

  Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cl_current_user_id');
    notifyListeners();
  }
}
