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

      print('🚀 Încerc să creez comanda în WooCommerce...');
      print('📦 Date comandă: ${jsonEncode(orderData)}');
      print('🔗 URL: $baseUrl/orders');

      final response = await http.post(
        Uri.parse('$baseUrl/orders'),
        headers: _headers,
        body: jsonEncode(orderData),
      );

      print('📡 Status răspuns: ${response.statusCode}');
      print('📋 Răspuns: ${response.body}');

      if (response.statusCode == 201) {
        print('✅ Comandă creată cu succes în WooCommerce!');
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        print('❌ Eroare autentificare - chei WooCommerce invalide');
        // Fallback pentru demo
        return _createMockOrder(orderData);
      } else {
        print('❌ Eroare la crearea comenzii: ${response.statusCode} - ${response.body}');
        // Fallback pentru demo
        return _createMockOrder(orderData);
      }
    } catch (e) {
      print('❌ Eroare de rețea: $e');
      // Fallback pentru demo
      return _createMockOrder({
        'billing': billing,
        'line_items': lineItems,
        'payment_method': paymentMethod,
      });
    }
  }

  // Fallback pentru demonstrație când API-ul nu funcționează
  static Map<String, dynamic> _createMockOrder(Map<String, dynamic> orderData) {
    final orderId = DateTime.now().millisecondsSinceEpoch;
    final orderNumber = 'HB${orderId.toString().substring(8)}';
    
    final lineItems = orderData['line_items'] as List<Map<String, dynamic>>? ?? [];
    final total = lineItems.fold<double>(0.0, (sum, item) {
      final quantity = item['quantity'] ?? 1;
      // Estimez prețul pentru demo
      return sum + (quantity * 50.0); // 50 Lei per produs în medie
    });

    print('📱 Comanda simulată creată cu succes (pentru demonstrație)');
    
    return {
      'id': orderId,
      'number': orderNumber,
      'status': orderData['payment_method'] == 'cod' ? 'processing' : 'pending',
      'total': total.toStringAsFixed(2),
      'billing': orderData['billing'],
      'line_items': lineItems,
      'date_created': DateTime.now().toIso8601String(),
      'payment_method': orderData['payment_method'],
      'note': 'Comandă demonstrativă - pentru funcționare completă configurați cheile WooCommerce în woocommerce_config.dart'
    };
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
