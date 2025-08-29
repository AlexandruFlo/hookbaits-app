import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../config/woocommerce_config.dart';
import '../models/product.dart';

class WooCommerceAPI {
  static const String _consumerKey = WooCommerceConfig.consumerKey;
  static const String _consumerSecret = WooCommerceConfig.consumerSecret;
  
  static const String baseUrl = '${AppConfig.baseUrl}/wp-json/wc/v3';
  
  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Basic ${base64Encode(utf8.encode('$_consumerKey:$_consumerSecret'))}'
  };

  // Obține produsele
  static Future<List<Product>> getProducts({int page = 1, int perPage = 20}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products?page=$page&per_page=$perPage&status=publish'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Product.fromWooCommerceJson(json)).toList();
      } else {
        print('API Error: ${response.statusCode} - ${response.body}');
        return [];
      }
    } catch (e) {
      print('Network Error: $e');
      return [];
    }
  }

  // Creează o comandă nouă
  static Future<Map<String, dynamic>?> createOrder({
    required List<Map<String, dynamic>> lineItems,
    required Map<String, dynamic> billing,
    Map<String, dynamic>? shipping,
    String paymentMethod = 'cod', // Cash on delivery default
    String status = 'pending',
  }) async {
    try {
      final orderData = {
        'payment_method': paymentMethod,
        'payment_method_title': _getPaymentMethodTitle(paymentMethod),
        'set_paid': false,
        'billing': billing,
        'shipping': shipping ?? billing,
        'line_items': lineItems,
        'shipping_lines': [
          {
            'method_id': 'flat_rate',
            'method_title': 'Livrare standard',
            'total': '20.00'
          }
        ],
        'status': status,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/orders'),
        headers: _headers,
        body: jsonEncode(orderData),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        print('Order creation failed: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Order creation error: $e');
      return null;
    }
  }

  // Obține comenzile utilizatorului
  static Future<List<dynamic>> getUserOrders(int customerId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/orders?customer=$customerId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Get orders failed: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Get orders error: $e');
      return [];
    }
  }

  // Creează client nou
  static Future<Map<String, dynamic>?> createCustomer({
    required String email,
    required String firstName,
    required String lastName,
    String? password,
  }) async {
    try {
      final customerData = {
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'username': email,
        if (password != null) 'password': password,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/customers'),
        headers: _headers,
        body: jsonEncode(customerData),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        print('Customer creation failed: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Customer creation error: $e');
      return null;
    }
  }

  // Obține client după email
  static Future<Map<String, dynamic>?> getCustomerByEmail(String email) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/customers?email=$email'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> customers = jsonDecode(response.body);
        return customers.isNotEmpty ? customers.first : null;
      } else {
        print('Get customer failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Get customer error: $e');
      return null;
    }
  }

  static String _getPaymentMethodTitle(String method) {
    switch (method) {
      case 'cod':
        return 'Plată la livrare (Ramburs)';
      case 'bacs':
        return 'Transfer bancar';
      case 'stripe':
        return 'Card online';
      default:
        return 'Plată la livrare';
    }
  }
}
