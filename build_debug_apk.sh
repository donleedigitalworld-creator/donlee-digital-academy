#!/bin/bash
# Donlee Digital World - Build Debug APK - Phase 6 v6.0.0
# Works on Windows (Git Bash), macOS, Linux
# Prereqs: Flutter SDK 3.22+, Android Studio SDK

set -e

echo "=== Donlee Academy v6 - Build Debug APK ==="
echo "Phases 1-6: Foundation + LMS + National Competition + Offline + AI + National Ecosystem + Ministry + Parent Engagement + Teacher PD + CMS + Partnerships + Marketplace + Research + MFA + Creative Expansion"
echo ""

# Check flutter
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter not found. Install from https://docs.flutter.dev/get-started/install"
    exit 1
fi

echo "✅ Flutter found: $(flutter --version | head -n1)"

# 1. Generate platform folders if not exist (keeps lib/ intact)
if [ ! -d "android" ]; then
  echo "📁 Generating android/ios folders via 'flutter create .' (keeps lib/ safe)..."
  flutter create .
else
  echo "📁 Android folder exists, skipping flutter create"
fi

# 2. Dependencies
echo "📦 flutter pub get (137 lib files, 72 routes, Phase 6 deps: qr_flutter, pdf, flutter_tts, speech_to_text, encrypt, etc)..."
flutter pub get

# 3. Optional: ensure minSdk 21 for connectivity_plus, hive, speech_to_text, etc
if [ -f "android/app/build.gradle" ]; then
  echo "🔧 Checking minSdkVersion..."
  if ! grep -q "minSdkVersion 21" android/app/build.gradle; then
    echo "⚠️ Setting minSdkVersion to 21 in android/app/build.gradle (required for Phase 3-6)"
    # This is a simple sed - user may need to manually edit if fails
    sed -i.bak 's/minSdkVersion.*/minSdkVersion 21/' android/app/build.gradle || echo "Please manually set minSdkVersion 21 in android/app/build.gradle"
  fi
fi

# 4. Build debug APK
echo "🔨 Building debug APK (debuggable, installable, ~60-90MB)..."
echo "This may take 2-5 minutes first time..."
flutter build apk --debug

APK_PATH="build/app/outputs/flutter-apk/app-debug.apk"

if [ -f "$APK_PATH" ]; then
  echo ""
  echo "✅ BUILD SUCCESS!"
  echo "📱 APK: $APK_PATH"
  ls -lh "$APK_PATH"
  echo ""
  echo "📲 Install on phone:"
  echo "   adb install -r $APK_PATH"
  echo "   Or copy APK to phone via Drive/WhatsApp/USB and tap to install (Allow Unknown Sources)"
  echo ""
  echo "🧪 Test checklist:"
  echo "   - Home shows WelcomeMessageHomeSection dark blue teal Ministry Portal + WelcomeMessageWidget ministryWelcome"
  echo "   - Ministry Portal: Menu -> Ministry of Education Portal - NEW -> 4 tabs Welcome/Stats/Policy/Future"
  echo "   - Parent Engagement: Menu -> Parent Engagement Tools - NEW -> Family Challenges Ministry theme"
  echo "   - Teacher PD Center, CMS, Partnerships, Scholarship, Marketplace, Research, MFA, Creative Subjects via Menu"
  echo ""
  echo "🇳🇬🎓🚀 Donlee v6.0.0 National Ecosystem + Ministry + Phase 6 Complete!"
else
  echo "❌ APK not found at $APK_PATH - check build logs above"
  exit 1
fi
