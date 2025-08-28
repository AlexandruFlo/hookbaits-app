import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config.dart';
import '../models/product.dart';

class WooStoreApiClient {
  final String baseUrl;
  final http.Client httpClient;

  WooStoreApiClient({String? baseUrl, http.Client? httpClient})
      : baseUrl = (baseUrl ?? AppConfig.baseUrl) + AppConfig.storeApiBase,
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
    final uri = _buildUri('/products', {
      'page': page,
      'per_page': perPage,
      if (search != null && search.isNotEmpty) 'search': search,
      if (category != null) 'category': category,
    });
    final res = await httpClient.get(uri, headers: {'Accept': 'application/json'});
    if (res.statusCode != 200) {
      throw Exception('Failed to load products (${res.statusCode})');
    }
    final List<dynamic> data = jsonDecode(res.body);
    return data.map((e) => Product.fromStoreApiJson(e as Map<String, dynamic>)).toList();
  }

  Future<Product> fetchProduct(int id) async {
    final uri = _buildUri('/products/$id');
    final res = await httpClient.get(uri, headers: {'Accept': 'application/json'});
    if (res.statusCode != 200) {
      throw Exception('Failed to load product (${res.statusCode})');
    }
    final Map<String, dynamic> data = jsonDecode(res.body);
    return Product.fromStoreApiJson(data);
  }
}

