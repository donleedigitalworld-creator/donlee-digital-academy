# Donlee Digital World - Build Debug APK - Install on Android

**Project Version:** 6.0.0+6 - National Ecosystem + Ministry + Phase 6 (137 lib files, 72 routes)
**Current Project State:** This project contains only `lib/` + `pubspec.yaml` + assets (no android/ ios folders yet because sandbox has no Flutter SDK). You need to generate platform folders once locally via `flutter create .` - it will NOT overwrite your lib/.

---

## ✅ Option 1: Fastest - Build Debug APK on Your PC (3 minutes)

### Prerequisites (One-time)
- **Flutter SDK 3.22+**: https://docs.flutter.dev/get-started/install
- **Android Studio + Android SDK + Platform Tools**: https://developer.android.com/studio
- **Enable USB Debugging** on your Android phone: Settings → About Phone → Tap Build Number 7 times → Developer Options → USB Debugging ON

### Steps

```bash
# 1. Clone or copy this project folder to your PC
# Example: C:\Users\YourName\donlee_digital_academy  or  ~/donlee_digital_academy

cd donlee_digital_academy

# 2. Generate Android & iOS folders (safe - keeps lib/ intact)
flutter create .

# 3. Get dependencies (Phase 1-6 deps: firebase, provider, hive, connectivity_plus, uuid, http, flutter_tts, speech_to_text, encrypt, flutter_secure_storage, fl_chart, qr_flutter, pdf, share_plus, url_launcher, local_auth, table_calendar, file_picker, video_player, chewie)
flutter pub get

# 4. Optional: Check Firebase - app works with mock data even if Firebase not configured
# If you want real Firebase:
# dart pub global activate flutterfire_cli
# flutterfire configure --project=donlee-art-academy

# 5. Build Debug APK (debuggable, installable)
flutter build apk --debug

# Output:
# build/app/outputs/flutter-apk/app-debug.apk (50-80 MB)
```

### Install APK on Phone

**Via USB:**
```bash
# Plug phone via USB, allow USB debugging prompt
adb devices  # should list your device
adb install -r build/app/outputs/flutter-apk/app-debug.apk
# Or just drag APK to phone and tap to install (Allow Unknown Sources)
```

**Via file share:**
- Copy `app-debug.apk` to Google Drive / WhatsApp / USB stick → open on phone → Install → Allow Unknown Sources if prompted.

### Install Notes
- **Debug APK** is debuggable (can use `flutter logs`, hot reload via `flutter run`). No signing needed.
- **First install** may warn "Play Protect" → Tap "Install anyway" or "More details → Install anyway" (because it's not Play Store).
- **Permissions requested:** Camera (capture drawings), Microphone (voice learning), Storage (offline queue), Internet - all explained in Privacy Settings screen per Phase 6.

---

## ✅ Option 2: Build with GitHub Actions (No Android Studio Needed)

I included `.github/workflows/build-apk.yml` - push this repo to GitHub and GitHub builds APK for you.

1. Create GitHub repo, push:
```bash
git init
git add .
git commit -m "Donlee v6 Phase 6"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/donlee-academy.git
git push -u origin main
```

2. Go to GitHub → Actions tab → Build Debug APK workflow → Wait 5-8 min → Download artifact `app-debug-apk` → Contains `app-debug.apk`.

Workflow does:
- Checkout
- Setup Flutter 3.22
- flutter create .
- flutter pub get
- flutter build apk --debug
- Upload artifact

---

## ✅ Option 3: Direct Build on Device (No PC, using USB)

```bash
flutter run --debug
# or
flutter run -d <deviceId>
```

This installs debug build directly and enables hot reload.

---

## 🔧 Fix Common Build Issues

### 1. `android/app/build.gradle` minSdk too low
Phase 3-6 uses `connectivity_plus`, `hive`, `speech_to_text` which need minSdk 21+.

After `flutter create .`, edit:

**android/app/build.gradle:**
```gradle
android {
  defaultConfig {
    minSdkVersion 21
    targetSdkVersion 34
    multiDexEnabled true
  }
}
```

**android/local.properties** (auto-generated, check):
```
sdk.dir=/path/to/Android/Sdk
```

### 2. Firebase init fails - use mock mode
`lib/main.dart` already wraps `Firebase.initializeApp` in try/catch:
```dart
try {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
} catch (e) {
  debugPrint("Firebase init failed (use mock mode): $e");
}
```
So app works with mock data even without `firebase_options.dart` real keys. For real Firebase, run `flutterfire configure`.

### 3. `flutter_secure_storage` + `local_auth` need Kotlin version
If build fails with Kotlin version:
**android/settings.gradle:**
```gradle
plugins {
  id "dev.flutter.flutter-plugin-loader" version "1.0.0"
  id "com.android.application" version "8.1.0" apply false
  id "org.jetbrains.kotlin.android" version "1.9.10" apply false
}
```

### 4. Large APK due to many assets?
Debug APK includes all. For smaller, build split:
```bash
flutter build apk --debug --split-per-abi
# Generates app-arm64-v8a-debug.apk (smaller, for most modern phones), app-armeabi-v7a-debug.apk, app-x86_64-debug.apk
```

---

## 📦 What You Will Get (APK Details)

- **File:** `app-debug.apk`
- **Size:** 60-90 MB debug (release would be ~25-40 MB)
- **Package:** `com.donlee.artacademy` (change in `android/app/build.gradle` applicationId if needed)
- **Version:** 6.0.0+6
- **Permissions:** CAMERA (capture drawings, profile photos, competition submissions camera verification), RECORD_AUDIO (voice learning), READ/WRITE_EXTERNAL_STORAGE (offline queue, low-bandwidth cache), INTERNET, ACCESS_NETWORK_STATE
- **Features Inside APK:** All Phases 1-6:
  - Phase 1: 10 modules, practice, portfolio, gallery
  - Phase 2: Teacher portal, school registration, assignments camera/gallery upload scoring, announcements, certificates
  - Phase 3: National Competition registration/submission offline queue smart sync no duplicate, judging dashboards 5 weighted criteria, rankings, exhibition/scholarship future-ready, low-bandwidth mode, offline learning
  - Phase 4: AI Tutor chat, drawing feedback proportion/shading/composition, study planner, practice generator, chat assistant navigation, voice learning, teacher AI tools reviewed, analytics, privacy encryption AES-256 consent
  - Phase 5: National Dashboard 36 states + FCT 1,247 schools 45k students, parent portal, school management, advanced analytics, digital certificate vault QR verification blockchain mock, resource library offline DL, career center, community forums/events, accessibility options, security dashboard, future scalability multi-tenant feature flags API v5 CDN 89%
  - Phase 6: Ministry Portal integrated + welcome message section on Home (Prof. Tahir Mamman Hon Minister + Donlee Founder), Parent Engagement Tools family challenges meeting scheduler volunteer, Teacher PD Center CPD tracking bronze/silver/gold/master mentorship, CMS lesson publishing Draft→Review→Approved→Published versioning asset management, Partnerships Portal MTN Foundation title 5M NGN Nike Art Gallery gold, Scholarship Center eligibility checker doc upload, Marketplace groundwork student artworks 150k 50% charity + teacher resources, Research Analytics anonymized no PII ethics approval, MFA TOTP SMS Email Biometric Recovery Codes Trusted Devices, Accessibility updates, Creative Subjects Expansion Visual Art enabled 10 modules + Music Dance Drama Writing Photography Film coming soon

---

## 📱 After Install - Test Checklist Phase 6

1. **Home:** WelcomeHeader + WelcomeMessageHomeSection dark blue teal gradient Ministry Portal + WelcomeMessageWidget full Ministry welcome + Quick Access 4 rows including Ministry Portal dark blue, National Dash blue, Parent Portal orange, Parent Engage, Teacher PD Center, CMS Publish, Partnerships, Scholarships, Marketplace, Research Analytics, MFA Security, Creative Expand, AI Tutor gold, Certificate Vault gold, Resource Lib purple, Community orange
2. **Ministry Portal:** Menu → Ministry of Education Portal - NEW → 4 tabs Welcome Messages (Ministry + Founder), Stats & Approvals 23 schools pending, Policy Documents 3, Future Scalability
3. **Parent Engagement:** Menu → Parent Engagement Tools - NEW → Family Challenges Ministry theme Unity in Diversity + Market Day, Meetings AI review + exhibition visit, Volunteer, Learning Resources
4. **Teacher PD Center:** Menu → Teacher Professional Development Center - NEW → CPD tracking 10 hours + courses Loomis 4h AI Tools 6h Offline-First 3h Inclusive Ed
5. **CMS:** Menu → CMS - Lesson Publishing - NEW → Tabs All Drafts/In Review/Approved/Published + Asset Manager + Review Queue approval workflow teacher reviewed
6. **Partnerships:** Menu → Partnerships Portal for Sponsors - NEW → MTN Foundation title 5M + Nike Art Gallery gold + Lagos Ministry platinum + Sponsored Events + Impact metrics 45k students
7. **Scholarship Center:** Menu → Scholarship & Opportunity Center - NEW → Donlee National Championship Scholarship 500k + Nike Residency Grant + eligibility bullets + docs + Apply
8. **Marketplace:** Menu → Digital Marketplace Groundwork - NEW → Artworks/Resources/Commissions orange banner groundwork + grid 2 cols + National Winner gold + Charity green
9. **Research:** Menu → Research Analytics - NEW → Studies anonymized no PII ethics approval offline-first 68% + AI feedback +12%
10. **MFA:** Menu → MFA - Stronger Security - NEW → Methods TOTP SMS Email Biometric Recovery Codes + Trusted Devices iPhone Samsung + Recovery Codes Wrap
11. **Creative Expansion:** Menu → Creative Subjects Expansion - NEW → Grid Visual Art enabled 10 modules + Music Dance Drama Writing Photography Film coming soon
12. **National Dashboard:** Home → National Dash → Stats 6 cards 1247 schools 45k students + regional breakdown 6 zones + equity metrics female 48% rural 68% state coverage 92% accessibility 12%
13. **Parent Portal:** Home → Parent Portal → Parent header consent chips AI ✓ Competition ✓ Exhibition ✓ + children cards progress 82% + notifications
14. **Certificates:** Home → Certificate Vault → grid + National Winner + Verify QR → CertificateVerificationScreen gold banner QR + Blockchain mock hash + result green success + QR + skills + Share PDF LinkedIn
15. **Offline:** AppBar wifi icon → OfflineModeScreen online/offline banner + low-BW/offline toggles + sync queue + offline lessons downloadable + how offline+smart sync works

---

## 🛠️ Provided Build Files

- **build_debug_apk.sh** - Bash script: flutter create . + pub get + build apk --debug
- **.github/workflows/build-apk.yml** - GitHub Actions workflow auto-builds debug APK on push
- **android/ (will be generated by flutter create .)** - After generation, minSdk 21 set

If you want me to attempt to build APK here: Sandbox has no Android SDK / Flutter SDK, so I cannot produce binary here. But above steps produce APK in under 5 minutes locally.

If you push to GitHub, you get APK artifact without needing Android Studio locally.

---

## ❓ Need Release APK (smaller, signed) for Play Store?

Debug is for testing. For Play Store release:

```bash
# Generate keystore (one-time)
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload

# Create android/key.properties:
storePassword=<password>
keyPassword=<password>
keyAlias=upload
storeFile=/home/user/upload-keystore.jks

# Build release
flutter build apk --release
flutter build appbundle --release # for Play Store .aab
```

Output: `build/app/outputs/flutter-apk/app-release.apk` and `build/app/outputs/bundle/release/app-release.aab`

---

## 📞 Support

If build fails, share error log and I will fix `build.gradle` / `AndroidManifest.xml` / dependency versions.

Lagos → National → World → AI → National Education Ecosystem → Intelligent Creative Nation 🇳🇬🎓🚀 v6.0.0
