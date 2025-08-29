// Configurație WooCommerce API
// ⚠️ CONFIGURARE OBLIGATORIE PENTRU FUNCȚIONARE COMPLETĂ!
class WooCommerceConfig {
  // ✅ CHEI REALE CONFIGURATE!
  static const String consumerKey = 'ck_fc3db721f487e0ce8ca674147ed1efe4f96b0dba';
  static const String consumerSecret = 'cs_994e7db656d3a2715f2b47349a9295ce1d2a4386';
  
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
