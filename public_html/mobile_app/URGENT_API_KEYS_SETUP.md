# 🚨 CONFIGURARE URGENTĂ CHEI WOOCOMMERCE

## Problemă Actuală:
- ❌ **Crearea contului nu funcționează**
- ❌ **Plasarea comenzilor eșuează**: "cheile woocommerce nu sunt configurate"

## 🎯 SOLUȚIE RAPIDĂ (2 metode):

---

### **METODA 1: SCRIPT AUTOMAT (RECOMANDAT)** ⚡

1. **Rulează scriptul automat:**
   ```bash
   cd public_html/mobile_app
   php generate_woo_keys.php
   ```

2. **Copiază cheile generate** și le inserează în `lib/config/woocommerce_config.dart`

3. **Șterge scriptul pentru securitate:**
   ```bash
   rm generate_woo_keys.php
   ```

---

### **METODA 2: MANUAL DIN WORDPRESS ADMIN** 🖱️

1. **Intră în WordPress Admin:**
   ```
   https://hookbaits.ro/wp-admin/
   ```

2. **Navighează la:**
   ```
   WooCommerce → Settings → Advanced → REST API
   ```

3. **Clic pe "Add key"**

4. **Completează:**
   - **Description**: `Hookbaits Mobile App`
   - **User**: `admin` (sau utilizatorul tău)
   - **Permissions**: `Read/Write`

5. **Clic pe "Generate API key"**

6. **COPIAZĂ RAPID** Consumer Key și Consumer Secret
   ⚠️ **ATENȚIE**: Consumer Secret va fi ascuns permanent după refresh!

7. **Actualizează fișierul:**
   `mobile_app/lib/config/woocommerce_config.dart`
   
   ```dart
   class WooCommerceConfig {
     static const String consumerKey = 'ck_CHEIA_TA_COPIATĂ_AICI';
     static const String consumerSecret = 'cs_SECRETUL_TĂU_COPIAT_AICI';
   }
   ```

---

## 🔧 **VERIFICARE RAPID CONFIGURARE:**

După configurare, testează:

1. **Creează un cont nou în aplicație**
2. **Adaugă produse în coș**  
3. **Încearcă să plasezi o comandă**

Dacă funcționează = ✅ **SUCCES!**
Dacă nu = 🔄 **Verifică din nou cheile**

---

## 🚨 **PROBLEME FRECVENTE:**

### **Eroare: "Consumer key is missing"**
- ✅ Verifică că ai înlocuit `ck_test_hookbaits_key_here`

### **Eroare: "Consumer secret is missing"**  
- ✅ Verifică că ai înlocuit `cs_test_hookbaits_secret_here`

### **Eroare: "Invalid signature"**
- ✅ Verifică că ai copiat cheile EXACT (fără spații)

### **Eroare: "Insufficient permissions"**
- ✅ Setează permissions la `Read/Write` în WordPress

---

## 📱 **DUPĂ CONFIGURARE:**

1. **Build APK nou:**
   ```bash
   git add .
   git commit -m "CONFIG: Adauga chei WooCommerce reale"
   git push origin main
   ```

2. **Instalează APK-ul nou pe telefon**

3. **Testează toate funcțiile:**
   - ✅ Creare cont
   - ✅ Login  
   - ✅ Adăugare produse în coș
   - ✅ Plasare comandă
   - ✅ Verificare comandă în WordPress Admin

---

## 🎯 **REZULTAT AȘTEPTAT:**

După configurare:
- ✅ **Conturile din aplicație vor funcționa și pe site**
- ✅ **Comenzile se vor afișa în WooCommerce Admin**
- ✅ **Sincronizare completă între aplicație și site**

**URGENT: Configurează cheile ACUM pentru ca aplicația să devină 100% funcțională!** 🚀
