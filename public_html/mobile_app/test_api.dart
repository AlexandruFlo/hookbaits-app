import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

// Test script pentru verificarea API-urilor WooCommerce
Future<void> main() async {
  const baseUrl = 'https://hookbaits.ro';
  const consumerKey = 'ck_fc3db721f487e0ce8ca674147ed1efe4f96b0dba';
  const consumerSecret = 'cs_994e7db656d3a2715f2b47349a9295ce1d2a4386';

  print('🧪 TESTEZ API-URILE WOOCOMMERCE HOOKBAITS...\n');

  // 1. Test WooCommerce Store API (public)
  print('1️⃣ Testez Store API (public)...');
  await testStoreApi(baseUrl);

  print('\n' + '='*50 + '\n');

  // 2. Test WooCommerce REST API (cu autentificare)
  print('2️⃣ Testez REST API (cu autentificare)...');
  await testRestApi(baseUrl, consumerKey, consumerSecret);

  print('\n' + '='*50 + '\n');
  print('🏁 Test completat!');
}

Future<void> testStoreApi(String baseUrl) async {
  try {
    final url = '$baseUrl/wp-json/wc/store/v1/products?per_page=1';
    print('🌐 URL: $url');
    
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
        'User-Agent': 'HOOKBAITS-Test/1.0',
      },
    ).timeout(const Duration(seconds: 10));

    print('📡 Status: ${response.statusCode}');
    print('📋 Headers: ${response.headers}');
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        print('✅ SUCCESS! Găsite ${data.length} produse');
        if (data.isNotEmpty) {
          final product = data.first;
          print('📦 Primul produs: ${product['name'] ?? 'Nume necunoscut'}');
        }
      } else {
        print('⚠️ Răspuns neașteptat (nu este listă)');
      }
    } else {
      print('❌ FAILED! Status: ${response.statusCode}');
      print('📄 Body: ${response.body}');
    }
  } catch (e) {
    print('❌ EXCEPTION: $e');
  }
}

Future<void> testRestApi(String baseUrl, String consumerKey, String consumerSecret) async {
  try {
    final url = '$baseUrl/wp-json/wc/v3/products?per_page=1';
    print('🌐 URL: $url');
    
    final authString = base64Encode(utf8.encode('$consumerKey:$consumerSecret'));
    print('🔐 Auth: Basic $authString');
    
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Basic $authString',
        'User-Agent': 'HOOKBAITS-Test/1.0',
      },
    ).timeout(const Duration(seconds: 10));

    print('📡 Status: ${response.statusCode}');
    print('📋 Headers: ${response.headers}');
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        print('✅ SUCCESS! Găsite ${data.length} produse');
        if (data.isNotEmpty) {
          final product = data.first;
          print('📦 Primul produs: ${product['name'] ?? 'Nume necunoscut'}');
        }
      } else {
        print('⚠️ Răspuns neașteptat (nu este listă)');
      }
    } else {
      print('❌ FAILED! Status: ${response.statusCode}');
      print('📄 Body: ${response.body}');
    }
  } catch (e) {
    print('❌ EXCEPTION: $e');
  }
}
