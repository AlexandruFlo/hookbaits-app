@echo off
echo 🎯 GENEREZ ICONITA HOOKBAITS PE FUNDAL NEGRU...
echo.

echo 📦 Instalez dependentele...
flutter pub get
echo.

echo 🎨 Generez iconita cu logo Hook pe fundal negru...
flutter pub run flutter_launcher_icons:main
echo.

echo 🔍 Verific iconitele generate...
dir android\app\src\main\res\mipmap-*\ic_launcher.png 2>nul
echo.

echo ✅ ICONITA HOOKBAITS A FOST GENERATA CU SUCCES!
echo 📱 Logo-ul Hook pe fundal negru este acum iconita aplicatiei.
pause
