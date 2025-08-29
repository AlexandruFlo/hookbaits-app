import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../config/woocommerce_config.dart';

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
  Map<String, dynamic>? get currentUser => _user != null ? {
    'id': _user!.id,
    'email': _user!.email,
    'first_name': _user!.name.split(' ').first,
    'last_name': _user!.name.split(' ').length > 1 ? _user!.name.split(' ').skip(1).join(' ') : '',
  } : null;
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

    // ❌ AUTENTIFICARE EȘUATĂ - doar conturi reale!
    print('❌ Autentificare eșuată - cont inexistent sau parolă greșită');
    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Împarte numele complet în prenume și nume
      final nameParts = name.trim().split(' ');
      final firstName = nameParts.isNotEmpty ? nameParts.first : 'Utilizator';
      final lastName = nameParts.length > 1 ? nameParts.skip(1).join(' ') : '';

      print('🔄 Încerc să creez utilizator în WordPress/WooCommerce...');
      print('📧 Email: $email');
      print('👤 Nume: $firstName $lastName');

      // 1. Încearcă să creeze utilizatorul în WooCommerce
      final customerData = await _createWooCommerceCustomer(firstName, lastName, email, password);
      
      if (customerData != null) {
        print('✅ Utilizator creat cu succes în WooCommerce!');
        
        _user = User(
          id: customerData['id'] ?? DateTime.now().millisecondsSinceEpoch,
          name: '$firstName $lastName'.trim(),
          email: email,
        );
        _token = base64Encode(utf8.encode('$email:$password'));

        // Salvează utilizatorul real în storage
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

      // 2. Dacă WooCommerce eșuează, încearcă WordPress direct
      print('⚠️ WooCommerce eșuat, încerc WordPress direct...');
      final wpUser = await _createWordPressUser(firstName, lastName, email, password);
      
      if (wpUser != null) {
        print('✅ Utilizator creat cu succes în WordPress!');
        
        _user = User(
          id: wpUser['id'] ?? DateTime.now().millisecondsSinceEpoch,
          name: '$firstName $lastName'.trim(),
          email: email,
        );
        _token = base64Encode(utf8.encode('$email:$password'));

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

      // 3. Toate metodele au eșuat
      print('❌ Nu am putut crea utilizatorul - toate metodele au eșuat');
      _isLoading = false;
      notifyListeners();
      return false;

    } catch (e) {
      print('❌ Eroare la înregistrare: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Creează customer în WooCommerce
  Future<Map<String, dynamic>?> _createWooCommerceCustomer(String firstName, String lastName, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/wp-json/wc/v3/customers'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Basic ${base64Encode(utf8.encode('${WooCommerceConfig.consumerKey}:${WooCommerceConfig.consumerSecret}'))}'
        },
        body: jsonEncode({
          'email': email,
          'first_name': firstName,
          'last_name': lastName,
          'username': email,
          'password': password,
        }),
      );

      print('📡 WooCommerce răspuns: ${response.statusCode}');
      print('📋 WooCommerce body: ${response.body}');

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('❌ Eroare WooCommerce: $e');
      return null;
    }
  }

  // Creează user în WordPress
  Future<Map<String, dynamic>?> _createWordPressUser(String firstName, String lastName, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/wp-json/wp/v2/users'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Basic ${base64Encode(utf8.encode('${WooCommerceConfig.consumerKey}:${WooCommerceConfig.consumerSecret}'))}'
        },
        body: jsonEncode({
          'username': email,
          'name': '$firstName $lastName'.trim(),
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'password': password,
          'roles': ['customer'],
        }),
      );

      print('📡 WordPress răspuns: ${response.statusCode}');
      print('📋 WordPress body: ${response.body}');

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('❌ Eroare WordPress: $e');
      return null;
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
