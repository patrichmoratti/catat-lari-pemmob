import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/user_model.dart';

class RegisterViewModel extends ChangeNotifier {

  final List<UserModel> _users = [];

  bool _isLoading = false;

  static const _uuid = Uuid();

  bool get isLoading => _isLoading;

  Future<String?> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {

    _isLoading = true;
    notifyListeners();

    await Future.delayed(
      const Duration(milliseconds: 700),
    );

    final prefs = await SharedPreferences.getInstance();

    final usersJson = prefs.getString('cl_users');

    if (usersJson != null) {

      final decoded = jsonDecode(usersJson) as List;

      _users.clear();

      _users.addAll(
        decoded.map(
          (e) => UserModel.fromJson(
            e as Map<String, dynamic>,
          ),
        ),
      );
    }

    final exists = _users.any(
      (u) =>
          u.email.toLowerCase() ==
          email.trim().toLowerCase(),
    );

    if (exists) {

      _isLoading = false;
      notifyListeners();

      return 'Email sudah terdaftar';
    }

    final user = UserModel(
      id: _uuid.v4(),
      name: name.trim(),
      email: email.trim(),
      phone: phone.trim(),
      password: password,
    );

    _users.add(user);

    await prefs.setString(
      'cl_users',
      jsonEncode(
        _users.map((u) => u.toJson()).toList(),
      ),
    );

    await prefs.setString(
      'cl_current_user_id',
      user.id,
    );

    _isLoading = false;
    notifyListeners();

    return null;
  }
}