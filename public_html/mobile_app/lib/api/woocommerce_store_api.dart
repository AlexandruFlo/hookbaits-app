import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config.dart';
import '../config/woocommerce_config.dart';
import '../models/product.dart';

class WooStoreApiClient {
  final String baseUrl;
  final String restApiBaseUrl;
  final http.Client httpClient;

  WooStoreApiClient({String? baseUrl, http.Client? httpClient})
      : baseUrl = (baseUrl ?? AppConfig.baseUrl) + AppConfig.storeApiBase,
        restApiBaseUrl = (baseUrl ?? AppConfig.baseUrl) + '/wp-json/wc/v3',
        httpClient = httpClient ?? http.Client();

  Uri _buildUri(String path, [Map<String, dynamic>? query]) {
    final uri = Uri.parse('$baseUrl$path');
    if (query == null || query.isEmpty) return uri;
    return uri.replace(queryParameters: {
      ...uri.queryParameters,
      ...query.map((k, v) => MapEntry(k, v.toString())),
    });
  }

  Future<List<Product>> fetchProducts({int page = 1, int perPage = 20, String? search, int? category}) async {
    try {
      // Verifică dacă cheile WooCommerce sunt configurate
      if (!WooCommerceConfig.isConfigured) {
        throw Exception('Cheile WooCommerce nu sunt configurate. Verifică fișierul woocommerce_config.dart');
      }

      // 1. Încearcă mai întâi WooCommerce Store API (public)
      final storeUri = _buildUri('/products', {
        'page': page,
        'per_page': perPage,
        if (search != null && search.isNotEmpty) 'search': search,
        if (category != null) 'category': category,
      });
      
      print('🌐 Încerc Store API: $storeUri');
      
      final storeRes = await httpClient.get(storeUri, headers: {
        'Accept': 'application/json',
        'User-Agent': 'HOOKBAITS-Mobile-App/1.0',
      }).timeout(const Duration(seconds: 10));
      
      print('📡 Store API răspuns: ${storeRes.statusCode}');
      print('📄 Store API body length: ${storeRes.body.length}');
      
      if (storeRes.statusCode == 200) {
        final List<dynamic> data = jsonDecode(storeRes.body);
        print('✅ Store API - Produse găsite: ${data.length}');
        
        // Debug primul produs pentru a vedea structura
        if (data.isNotEmpty) {
          final firstProduct = data.first;
          print('🔍 Primul produs debug:');
          print('   - ID: ${firstProduct['id']}');
          print('   - Nume: ${firstProduct['name']}');
          print('   - Preț: ${firstProduct['prices']?['price']}');
          print('   - Min preț: ${firstProduct['prices']?['min_price']}');
          print('   - Max preț: ${firstProduct['prices']?['max_price']}');
        }
        
        return data.map((e) => Product.fromStoreApiJson(e as Map<String, dynamic>)).toList();
      }
      
      print('⚠️ Store API eșuat (${storeRes.statusCode}), încerc REST API...');
      
      // 2. Fallback la WooCommerce REST API cu autentificare
      final restUri = Uri.parse('$restApiBaseUrl/products').replace(queryParameters: {
        'page': page.toString(),
        'per_page': perPage.toString(),
        if (search != null && search.isNotEmpty) 'search': search,
        if (category != null) 'category': category.toString(),
      });
      
      print('🔐 Încerc REST API cu autentificare: $restUri');
      
      final authString = base64Encode(utf8.encode('${WooCommerceConfig.consumerKey}:${WooCommerceConfig.consumerSecret}'));
      
      final restRes = await httpClient.get(restUri, headers: {
        'Accept': 'application/json',
        'Authorization': 'Basic $authString',
        'User-Agent': 'HOOKBAITS-Mobile-App/1.0',
      }).timeout(const Duration(seconds: 10));
      
      print('📡 REST API răspuns: ${restRes.statusCode}');
      
      if (restRes.statusCode == 200) {
        final List<dynamic> data = jsonDecode(restRes.body);
        print('✅ REST API - Produse găsite: ${data.length}');
        return data.map((e) => Product.fromWooCommerceJson(e as Map<String, dynamic>)).toList();
      }
      
      print('❌ Ambele API-uri au eșuat:');
      print('   Store API: ${storeRes.statusCode} - ${storeRes.body}');
      print('   REST API: ${restRes.statusCode} - ${restRes.body}');
      
      throw Exception('Ambele API-uri WooCommerce au eșuat. Verifică configurația site-ului hookbaits.ro');
      
    } catch (e) {
      print('❌ Excepție la încărcarea produselor: $e');
      throw Exception('Eroare de conexiune la API: $e');
    }
  }

  Future<Product> fetchProduct(int id) async {
    try {
      // Verifică dacă cheile WooCommerce sunt configurate
      if (!WooCommerceConfig.isConfigured) {
        throw Exception('Cheile WooCommerce nu sunt configurate. Verifică fișierul woocommerce_config.dart');
      }

      // 1. Încearcă mai întâi WooCommerce Store API (public)
      final storeUri = _buildUri('/products/$id');
      
      print('🌐 Încerc Store API pentru produs $id: $storeUri');
      
      final storeRes = await httpClient.get(storeUri, headers: {
        'Accept': 'application/json',
        'User-Agent': 'HOOKBAITS-Mobile-App/1.0',
      }).timeout(const Duration(seconds: 10));
      
      if (storeRes.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(storeRes.body);
        print('✅ Store API - Produs $id găsit');
        return Product.fromStoreApiJson(data);
      }
      
      print('⚠️ Store API eșuat pentru produs $id (${storeRes.statusCode}), încerc REST API...');
      
      // 2. Fallback la WooCommerce REST API cu autentificare
      final restUri = Uri.parse('$restApiBaseUrl/products/$id');
      
      print('🔐 Încerc REST API pentru produs $id: $restUri');
      
      final authString = base64Encode(utf8.encode('${WooCommerceConfig.consumerKey}:${WooCommerceConfig.consumerSecret}'));
      
      final restRes = await httpClient.get(restUri, headers: {
        'Accept': 'application/json',
        'Authorization': 'Basic $authString',
        'User-Agent': 'HOOKBAITS-Mobile-App/1.0',
      }).timeout(const Duration(seconds: 10));
      
      if (restRes.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(restRes.body);
        print('✅ REST API - Produs $id găsit');
        return Product.fromWooCommerceJson(data);
      }
      
      print('❌ Ambele API-uri au eșuat pentru produs $id:');
      print('   Store API: ${storeRes.statusCode}');
      print('   REST API: ${restRes.statusCode}');
      
      throw Exception('Nu s-a putut încărca produsul $id din ambele API-uri WooCommerce');
      
    } catch (e) {
      print('❌ Excepție la încărcarea produsului $id: $e');
      throw Exception('Eroare de conexiune la API pentru produsul $id: $e');
    }
  }
}

