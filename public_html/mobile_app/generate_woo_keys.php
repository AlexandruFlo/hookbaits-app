<?php
/**
 * Script pentru generarea automată a cheilor WooCommerce REST API
 * 🚨 RULEAZĂ ACEST SCRIPT O SINGURĂ DATĂ pentru a genera cheile!
 */

// Configurare WordPress
require_once('../wp-config.php');

// Verifică dacă WooCommerce este activ
if (!class_exists('WooCommerce')) {
    die('❌ WooCommerce nu este instalat sau activ!');
}

// Generează chei noi
$description = 'Hookbaits Mobile App';
$user_id = 1; // Admin user ID
$permissions = 'read_write';

// Generează Consumer Key și Consumer Secret
$consumer_key = 'ck_' . wp_generate_password(32, false);
$consumer_secret = 'cs_' . wp_generate_password(32, false);

// Hash-ul pentru consumer secret (pentru securitate)
$consumer_secret_hash = wp_hash_password($consumer_secret);

// Inserează în baza de date
global $wpdb;

$result = $wpdb->insert(
    $wpdb->prefix . 'woocommerce_api_keys',
    array(
        'user_id' => $user_id,
        'description' => $description,
        'permissions' => $permissions,
        'consumer_key' => wp_hash($consumer_key),
        'consumer_secret' => $consumer_secret_hash,
        'truncated_key' => substr($consumer_key, -7),
        'last_access' => null
    ),
    array('%d', '%s', '%s', '%s', '%s', '%s', '%s')
);

if ($result) {
    echo "✅ SUCCES! Chei WooCommerce generate:\n\n";
    echo "📋 COPIAZĂ ACESTE CHEI ÎN APLICAȚIE:\n";
    echo "=====================================\n";
    echo "Consumer Key: " . $consumer_key . "\n";
    echo "Consumer Secret: " . $consumer_secret . "\n";
    echo "=====================================\n\n";
    
    echo "🔧 ACTUALIZEAZĂ fișierul: mobile_app/lib/config/woocommerce_config.dart\n\n";
    echo "Înlocuiește:\n";
    echo "static const String consumerKey = 'ck_test_hookbaits_key_here';\n";
    echo "static const String consumerSecret = 'cs_test_hookbaits_secret_here';\n\n";
    echo "Cu:\n";
    echo "static const String consumerKey = '" . $consumer_key . "';\n";
    echo "static const String consumerSecret = '" . $consumer_secret . "';\n\n";
    
    echo "🚨 IMPORTANT: Șterge acest fișier după utilizare pentru securitate!\n";
} else {
    echo "❌ EROARE la generarea cheilor: " . $wpdb->last_error . "\n";
}
?>
