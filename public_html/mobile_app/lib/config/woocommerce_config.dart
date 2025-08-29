// Configurație WooCommerce API
// ⚠️ CONFIGURARE OBLIGATORIE PENTRU FUNCȚIONARE COMPLETĂ!
class WooCommerceConfig {
  // 🚨 URGENT: Înlocuiește cu chei reale din WooCommerce
  static const String consumerKey = 'ck_test_hookbaits_key_here';
  static const String consumerSecret = 'cs_test_hookbaits_secret_here';
  
  // ✅ VERIFICĂ dacă sunt configurate corect
  static bool get isConfigured => 
    consumerKey != 'ck_test_hookbaits_key_here' && 
    consumerSecret != 'cs_test_hookbaits_secret_here' &&
    consumerKey.startsWith('ck_') && 
    consumerSecret.startsWith('cs_');
  
  // 📋 Pentru obținerea cheilor reale:
  // 1. WordPress Admin → WooCommerce → Settings → Advanced → REST API
  // 2. Add Key → Description: "Hookbaits Mobile App" 
  // 3. User: admin → Permissions: Read/Write → Generate API key
  // 4. Copiază Consumer Key și Consumer Secret
  // 5. Înlocuiește valorile de mai sus
  
  // 🎯 Format corect:
  // static const String consumerKey = 'ck_1234567890abcdef1234567890abcdef12345678';
  // static const String consumerSecret = 'cs_abcdef1234567890abcdef1234567890abcdef12';
}
