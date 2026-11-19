import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  String? _name;
  String? _email;
  bool _loaded = false;

  String? get name => _name;
  String? get email => _email;
  bool get loaded => _loaded;
  bool get isLoggedIn => _name != null && _email != null;

  AuthProvider() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _name = prefs.getString('user_name');
    _email = prefs.getString('user_email');
    _loaded = true;
    notifyListeners();
  }

  Future<void> login(String name, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    await prefs.setString('user_email', email);
    _name = name;
    _email = email;
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_name');
    await prefs.remove('user_email');
    _name = null;
    _email = null;
    notifyListeners();
  }
}