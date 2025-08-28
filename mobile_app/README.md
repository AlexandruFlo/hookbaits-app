Hookbaits Shop - Android App (Flutter)

Acest director conține sursa aplicației Flutter pentru Android (APK/AAB).

Configurare rapidă

1) Instalează Flutter (canal stable): https://docs.flutter.dev/get-started/install
2) Actualizează URL-ul site-ului în `lib/config.dart`:
   - `baseUrl` = adresa site-ului tău (ex: https://exemplu.ro)
3) Instalează dependențe: `flutter pub get`
4) Rulează pe un emulator/dispozitiv cu URL setat la build-time:
   - `flutter run -d android --dart-define=BASE_URL=https://hookbaits.ro`
5) Build APK debug:
   - `flutter build apk --debug --dart-define=BASE_URL=https://hookbaits.ro`
6) Build APK release:
   - `flutter build apk --release --dart-define=BASE_URL=https://hookbaits.ro`
7) Build AAB pentru Google Play:
   - `flutter build appbundle --release --dart-define=BASE_URL=https://hookbaits.ro`

Build din GitHub Actions (APK):

1) Pune acest repo pe GitHub (cu structura existentă).
2) În repo, mergi la Settings → Secrets and variables → Actions → New repository secret:
   - Name: `BASE_URL`
   - Value: `https://hookbaits.ro`
   - (opțional) Name: `LOGO_URL` → URL spre PNG 1024x1024 al logo-ului tău
3) La fiecare push, workflow-ul va construi un APK și îl va publica drept artifact descărcabil.

Icon aplicație

- Dacă setezi `LOGO_URL` (PNG 1024×1024), workflow-ul va descărca imaginea și va genera automat launcher icons.
- Fără `LOGO_URL`, se folosește un placeholder verde cu litera „H”.

Include

- Listă produse, detalii produs (WooCommerce Store API public)
- Coș local în aplicație
- Checkout în WebView către pagina checkout a site-ului

Note

- Pentru funcții avansate (login, comenzi utilizator, plăți native, push), se va adăuga autentificare și endpointuri suplimentare.
- Dacă anumite resurse sunt blocate de CORS, se ajustează configurația pe server sau se folosesc chei API.

