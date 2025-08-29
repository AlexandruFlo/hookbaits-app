#!/bin/bash
echo "🎯 GENEREZ ICONIȚA HOOKBAITS PE FUNDAL NEGRU..."
echo

echo "📦 Instalez dependențele..."
flutter pub get
echo

echo "🎨 Generez iconița cu logo Hook pe fundal negru..."
flutter pub run flutter_launcher_icons:main
echo

echo "🔍 Verific iconițele generate..."
find android/app/src/main/res -name "*launcher*" -type f | head -5
echo

echo "✅ ICONIȚA HOOKBAITS A FOST GENERATĂ CU SUCCES!"
echo "📱 Logo-ul Hook pe fundal negru este acum iconița aplicației."
