// Configurație WooCommerce API
// IMPORTANT: În producție, aceste valori trebuie stocate securizat și nu în cod!
class WooCommerceConfig {
  // Acestea sunt chei de test - trebuie înlocuite cu chei reale din WooCommerce
  static const String consumerKey = 'ck_test_hookbaits_key_here';
  static const String consumerSecret = 'cs_test_hookbaits_secret_here';
  
  // Pentru obținerea cheilor reale:
  // 1. Intră în WordPress Admin -> WooCommerce -> Settings -> Advanced -> REST API
  // 2. Adaugă o cheie nouă cu permisiuni Read/Write
  // 3. Copiază Consumer Key și Consumer Secret
  // 4. Înlocuiește valorile de mai sus
  
  // Exemplu real format:
  // static const String consumerKey = 'ck_1234567890abcdef1234567890abcdef12345678';
  // static const String consumerSecret = 'cs_abcdef1234567890abcdef1234567890abcdef12';
}
