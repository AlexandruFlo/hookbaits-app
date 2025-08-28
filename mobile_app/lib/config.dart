import 'package:flutter/material.dart';

class AppConfig {
  static const String appName = 'Hookbaits Shop';

  // Set at build-time via: --dart-define=BASE_URL=https://domeniu.ro
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://hookbaits.ro',
  );

  // WooCommerce Store API (public) base path
  static const String storeApiBase = '/wp-json/wc/store/v1';

  static const Color primaryColor = Color(0xFF0A7F2E);
}

