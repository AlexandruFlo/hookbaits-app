# 🔐 Configurare Autentificare WordPress/WooCommerce

## Problemă Rezolvată
**Conturile create în aplicație nu funcționează pe site** - REZOLVAT! ✅

## Ce s-a schimbat?
Aplicația acum creează utilizatori **reali** în WordPress/WooCommerce în loc de conturi locale demo.

## 🔧 Pași de configurare obligatori:

### 1. **Configurează Chei WooCommerce API**
```
WordPress Admin → WooCommerce → Settings → Advanced → REST API
```

1. Clic pe **"Add key"**
2. Setează:
   - **Description**: "Hookbaits Mobile App"
   - **User**: admin (sau un utilizator cu drepturi complete)
   - **Permissions**: **Read/Write**
3. Clic pe **"Generate API key"**
4. **COPIAZĂ** Consumer Key și Consumer Secret

### 2. **Actualizează fișierul de configurare**
Editează: `lib/config/woocommerce_config.dart`

```dart
class WooCommerceConfig {
  static const String consumerKey = 'ck_AICI_CHEIA_TA_REALA';
  static const String consumerSecret = 'cs_AICI_SECRETUL_TAU_REAL';
}
```

**Exemplu real:**
```dart
static const String consumerKey = 'ck_1234567890abcdef1234567890abcdef12345678';
static const String consumerSecret = 'cs_abcdef1234567890abcdef1234567890abcdef12';
```

### 3. **Pentru WordPress User Creation (Opțional)**
Pentru crearea de utilizatori WordPress (nu doar WooCommerce customers):

Editează funcția `_createWordPressUser` în `lib/state/auth_state.dart`:
```dart
'Authorization': 'Basic ${base64Encode(utf8.encode('ADMIN_USERNAME:ADMIN_PASSWORD'))}'
```

Înlocuiește cu username-ul și parola de admin reale.

## 🎯 Rezultat
După configurare:
- ✅ Conturile create în aplicație vor funcționa și pe site
- ✅ Utilizatorii se pot loga cu aceleași credențiale în ambele locuri
- ✅ Comenzile vor fi asociate cu utilizatori reali
- ✅ Sincronizare completă WordPress ↔ Mobile App

## 🔒 Securitate
**IMPORTANT**: În producție, stochează cheile securizat (environment variables, server config, etc.) nu în cod!

## 🧪 Testare
1. Creează un cont nou în aplicație
2. Încearcă să te loghezi pe site cu aceleași credențiale
3. Contul trebuie să funcționeze în ambele locuri

## 🆘 Depanare
Dacă înregistrarea eșuează:
1. Verifică console log-urile din aplicație
2. Verifică că cheile WooCommerce sunt corecte
3. Verifică că utilizatorul API are drepturi suffice
4. Testează cheile cu un client REST (Postman, etc.)
