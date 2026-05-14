import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/user_model.dart';

class AuthService {
  static const _uuid = Uuid();

  Future<List<UserModel>> getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString('cl_users');

    if (usersJson == null) {
      final seed = _seedUsers();
      await saveUsers(seed);
      return seed;
    }

    final decoded = jsonDecode(usersJson) as List;

    return decoded
        .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveUsers(List<UserModel> users) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      'cl_users',
      jsonEncode(users.map((e) => e.toJson()).toList()),
    );
  }

  Future<void> saveCurrentUser(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cl_current_user_id', userId);
  }

  Future<String?> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final users = await getUsers();

    final exists = users.any(
      (u) => u.email.toLowerCase() == email.trim().toLowerCase(),
    );

    if (exists) {
      return 'Email sudah terdaftar. Gunakan email lain.';
    }

    final user = UserModel(
      id: _uuid.v4(),
      name: name.trim(),
      email: email.trim(),
      phone: phone.trim(),
      password: password,
    );

    users.add(user);

    await saveUsers(users);
    await saveCurrentUser(user.id);

    return null;
  }

  List<UserModel> _seedUsers() => [
        UserModel(
          id: 'u-001',
          name: 'Reza Pratama',
          email: 'reza@gmail.com',
          phone: '08123456789',
          password: 'reza123',
        ),
      ];


  Future<String?> login(String email, String password) async {
  final users = await getUsers();

  try {
    final user = users.firstWhere(
      (u) =>
          u.email.toLowerCase() == email.trim().toLowerCase() &&
          u.password == password,
    );

    await saveCurrentUser(user.id);

    return null;
  } catch (_) {
    return 'Email atau password salah.';
  }
}


Future<UserModel?> getCurrentUser() async {
  final prefs = await SharedPreferences.getInstance();

  final currentId = prefs.getString('cl_current_user_id');

  if (currentId == null) return null;

  final users = await getUsers();

  try {
    return users.firstWhere((u) => u.id == currentId);
  } catch (_) {
    return null;
  }
}

Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.remove('cl_current_user_id');
}

Future<String?> updateProfile({
  required String name,
  required String email,
  required String phone,
  String? newPassword,
}) async {
  final currentUser = await getCurrentUser();

  if (currentUser == null) {
    return 'Tidak ada sesi aktif.';
  }

  final users = await getUsers();

  final emailTaken = users.any(
    (u) =>
        u.email.toLowerCase() == email.trim().toLowerCase() &&
        u.id != currentUser.id,
  );

  if (emailTaken) {
    return 'Email sudah digunakan akun lain.';
  }

  final idx = users.indexWhere(
    (u) => u.id == currentUser.id,
  );

  if (idx == -1) {
    return 'Pengguna tidak ditemukan.';
  }

  users[idx] = users[idx].copyWith(
    name: name.trim(),
    email: email.trim(),
    phone: phone.trim(),
    password: newPassword,
  );

  await saveUsers(users);

  return null;
}

}