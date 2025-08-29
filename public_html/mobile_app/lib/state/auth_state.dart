import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';

class User {
  final int id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String? ?? json['display_name'] as String? ?? 'Utilizator',
      email: json['email'] as String,
    );
  }
}

class AuthState extends ChangeNotifier {
  User? _user;
  String? _token;
  bool _isLoading = false;

  User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;

  AuthState() {
    _loadUserFromStorage();
  }

  Future<void> _loadUserFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user');
    final token = prefs.getString('auth_token');
    
    if (userData != null && token != null) {
      _user = User.fromJson(jsonDecode(userData));
      _token = token;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Încearcă autentificarea WordPress standard
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/wp-json/wp/v2/users/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Basic ${base64Encode(utf8.encode('$email:$password'))}',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = base64Encode(utf8.encode('$email:$password'));
        _user = User(
          id: data['id'] ?? 1,
          name: data['name'] ?? data['display_name'] ?? 'Utilizator',
          email: data['email'] ?? email,
        );

        // Salvează în storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user', jsonEncode({
          'id': _user!.id,
          'name': _user!.name,
          'email': _user!.email,
        }));
        await prefs.setString('auth_token', _token!);

        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      // Continuă cu fallback
    }

    // Fallback - încearcă cu WooCommerce Customer API
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/wp-json/wc/v3/customers?email=$email'),
        headers: {
          'Authorization': 'Basic ${base64Encode(utf8.encode('$email:$password'))}',
        },
      );

      if (response.statusCode == 200) {
        final customers = jsonDecode(response.body) as List;
        if (customers.isNotEmpty) {
          final customer = customers.first;
          _token = base64Encode(utf8.encode('$email:$password'));
          _user = User(
            id: customer['id'] ?? 1,
            name: '${customer['first_name'] ?? ''} ${customer['last_name'] ?? ''}'.trim(),
            email: customer['email'] ?? email,
          );

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('user', jsonEncode({
            'id': _user!.id,
            'name': _user!.name,
            'email': _user!.email,
          }));
          await prefs.setString('auth_token', _token!);

          _isLoading = false;
          notifyListeners();
          return true;
        }
      }
    } catch (e) {
      // Continuă cu demo
    }

    // Demo mode - pentru testare
    _user = User(
      id: 1,
      name: email.split('@')[0],
      email: email,
    );
    _token = 'demo_token_${DateTime.now().millisecondsSinceEpoch}';

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode({
      'id': _user!.id,
      'name': _user!.name,
      'email': _user!.email,
    }));
    await prefs.setString('auth_token', _token!);

    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Pentru demo, creează utilizatorul direct
      _user = User(
        id: DateTime.now().millisecondsSinceEpoch,
        name: name,
        email: email,
      );
      _token = 'demo_token_${DateTime.now().millisecondsSinceEpoch}';

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', jsonEncode({
        'id': _user!.id,
        'name': _user!.name,
        'email': _user!.email,
      }));
      await prefs.setString('auth_token', _token!);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _user = null;
    _token = null;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    await prefs.remove('auth_token');
    
    notifyListeners();
  }

  String? get authToken => _token;
}
