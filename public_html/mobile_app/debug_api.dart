import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

// 🧪 SCRIPT DE DEBUG PENTRU API-URILE HOOKBAITS
Future<void> main() async {
  const baseUrl = 'https://hookbaits.ro';
  const consumerKey = 'ck_fc3db721f487e0ce8ca674147ed1efe4f96b0dba';
  const consumerSecret = 'cs_994e7db656d3a2715f2b47349a9295ce1d2a4386';

  print('🧪 === DEBUG API HOOKBAITS ===\n');

  // 1. Test Store API (public)
  print('1️⃣ Test Store API (public)...');
  await testStoreApi(baseUrl);

  print('\n' + '='*60 + '\n');

  // 2. Test REST API (cu autentificare)
  print('2️⃣ Test REST API (cu autentificare)...');
  await testRestApi(baseUrl, consumerKey, consumerSecret);

  print('\n' + '='*60 + '\n');

  // 3. Test WordPress login
  print('3️⃣ Test WordPress API pentru login...');
  await testWordPressAuth(baseUrl);

  print('\n🏁 === DEBUGGING COMPLETAT ===');
}

Future<void> testStoreApi(String baseUrl) async {
  try {
    final url = '$baseUrl/wp-json/wc/store/v1/products?per_page=1';
    print('🌐 URL: $url');
    
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
        'User-Agent': 'HOOKBAITS-Debug/1.0',
      },
    ).timeout(const Duration(seconds: 15));

    print('📡 Status: ${response.statusCode}');
    print('📋 Headers: ${response.headers}');
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        print('✅ SUCCESS! Store API funcționează - găsite ${data.length} produse');
        if (data.isNotEmpty) {
          final product = data.first;
          print('📦 Primul produs: ${product['name'] ?? 'Nume necunoscut'}');
          print('💰 Preț: ${product['prices']?['price'] ?? 'N/A'}');
        }
      } else {
        print('⚠️ Răspuns neașteptat - nu este listă de produse');
        print('📄 Răspuns: ${response.body.substring(0, 200)}...');
      }
    } else {
      print('❌ EROARE Store API! Status: ${response.statusCode}');
      print('📄 Body: ${response.body}');
      
      // Verifică dacă este o eroare de plugin
      if (response.body.contains('rest_no_route')) {
        print('🔧 CAUZA: WooCommerce Store API nu este activat sau instalat!');
      }
    }
  } catch (e) {
    print('❌ EXCEPȚIE Store API: $e');
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
        'User-Agent': 'HOOKBAITS-Debug/1.0',
      },
    ).timeout(const Duration(seconds: 15));

    print('📡 Status: ${response.statusCode}');
    print('📋 Headers: ${response.headers}');
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        print('✅ SUCCESS! REST API funcționează - găsite ${data.length} produse');
        if (data.isNotEmpty) {
          final product = data.first;
          print('📦 Primul produs: ${product['name'] ?? 'Nume necunoscut'}');
          print('💰 Preț: ${product['price'] ?? 'N/A'}');
          print('🆔 ID: ${product['id'] ?? 'N/A'}');
        }
      } else {
        print('⚠️ Răspuns neașteptat - nu este listă de produse');
      }
    } else {
      print('❌ EROARE REST API! Status: ${response.statusCode}');
      print('📄 Body: ${response.body}');
      
      if (response.statusCode == 401) {
        print('🔧 CAUZA: Chei WooCommerce invalide sau fără permisiuni!');
      } else if (response.statusCode == 404) {
        print('🔧 CAUZA: WooCommerce REST API nu este disponibil!');
      }
    }
  } catch (e) {
    print('❌ EXCEPȚIE REST API: $e');
  }
}

Future<void> testWordPressAuth(String baseUrl) async {
  try {
    final url = '$baseUrl/wp-json/wp/v2/users/me';
    print('🌐 URL: $url');
    
    // Test cu credențiale de test
    final testEmail = 'test@example.com';
    final testPassword = 'test123';
    
    final authString = base64Encode(utf8.encode('$testEmail:$testPassword'));
    
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Basic $authString',
        'User-Agent': 'HOOKBAITS-Debug/1.0',
      },
    ).timeout(const Duration(seconds: 15));

    print('📡 Status: ${response.statusCode}');
    
    if (response.statusCode == 200) {
      print('✅ WordPress API funcționează pentru autentificare');
    } else if (response.statusCode == 401) {
      print('✅ WordPress API funcționează (credențiale test invalide - normal)');
    } else {
      print('❌ WordPress API nu funcționează: ${response.statusCode}');
      print('📄 Body: ${response.body}');
    }
  } catch (e) {
    print('❌ EXCEPȚIE WordPress API: $e');
  }
}
