# Donlee Academy - Phase 1 Setup & Firebase Guide

## Quick Start (5 mins without Firebase)

If you want to preview UI without Firebase:

1. In `lib/main.dart`, comment out Firebase.initializeApp() line.
2. In `lib/services/auth_service.dart`, replace Firebase calls with mock delay or use `kIsWeb` check.
3. However, recommended flow: run with Firebase even if using mock auth fallback (code already tries/catches init failure).

The current code gracefully handles Firebase init failure and still shows lessons/practice/gallery with static mock data, because LessonsData is local. Auth screens will show error if Firebase not configured, but you can bypass by directly navigating to `/home` for UI review.

## Full Firebase Setup (Recommended)

### 1. Create Firebase Project
- Go to console.firebase.google.com
- New project: `donlee-art-academy`
- Disable Google Analytics for dev (or enable)

### 2. Register Apps
- Android: package name `com.donlee.artacademy` (change in android/app/build.gradle if needed)
- iOS: bundle `com.donlee.artAcademy`
- Web if needed

### 3. Install FlutterFire CLI
```
dart pub global activate flutterfire_cli
flutterfire configure --project=donlee-art-academy --platforms=android,ios,web
```
This overwrites `lib/firebase_options.dart` with real keys.

### 4. Enable Products
**Authentication:**
- Email/Password → Enable
- Google → Enable (add SHA1 for Android: `cd android && ./gradlew signingReport`)

**Firestore:**
- Create database in test mode (Lagos region closest is europe-west)
- Collections to create manually or let app auto-create on register:
  - `users/{uid}` fields: email, displayName, photoUrl, createdAt (string ISO), totalLessonsCompleted (int), totalArtworksUploaded, moduleProgress (map), completedLessonIds (array)
  - `artworks/{artworkId}` fields: id, userId, userName, title, description, imageUrl, lessonId?, moduleId?, tags (array), likes (int), createdAt, isInGallery (bool)
  - `notifications` fields: title, body, type, isRead, createdAt, userId (or 'global'), actionLink?

**Storage:**
- Enable, create folder `portfolios/`
- Rules for dev:
```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

**Messaging (Optional Phase 1):**
- Enable Cloud Messaging for new lessons & challenges notifications

### 5. Seed Data (Optional)

You can seed gallery with script or manually add docs to `artworks` collection as sample data. Example doc:
```json
{
  "id": "g1",
  "userId": "demoUser1",
  "userName": "Amara Okafor",
  "title": "Market Day - Charcoal",
  "description": "Texture study",
  "imageUrl": "https://images.unsplash.com/photo-1578301978693-85fa9c0320b9?w=800",
  "tags": ["Charcoal", "Value"],
  "likes": 42,
  "createdAt": "2024-05-01T12:00:00.000Z",
  "isInGallery": true
}
```

### 6. Run
```
flutter pub get
flutter run -d android/ios/chrome
```

## Design Asset Notes

- Logo placeholder: simple palette icon with goldGradient circle. Replace with real Donlee logo in `assets/images/logo.png` and update AssetPaths.
- Lesson thumbnails use Unsplash art images for Phase 1 (network). For offline, download and put in `assets/images/lessons/` and update LessonsData to use AssetImage.
- Fonts: Google Fonts Poppins + Playfair Display automatically downloaded via google_fonts package – no asset needed.

## Code Highlights for Phase 1 Review

- **AuthService** is ChangeNotifier → Provider pattern, easy to swap to Riverpod/Bloc later
- **LessonsData** centralized – in Phase 2, replace with Firestore fetched ModuleRepository
- **Progress**: simple 33% per lesson increment → in production, calculate from completed lesson count / total lessons in module
- **Offline-first considerations**: LessonsData is local so app works without internet for learning (images need cache). Firestore caching enabled by default.

## Testing Checklist

- [ ] Register → creates user doc
- [ ] Login → loads user model
- [ ] Home shows name + progress
- [ ] Click featured lesson → steps → next → complete → quiz
- [ ] Complete quiz → updates? (manual for Phase 1, auto in Phase 2)
- [ ] Practice screen shows exercises
- [ ] Portfolio upload (mock + Firebase when configured)
- [ ] Gallery filter & detail
- [ ] Notifications stream shows mocks

## Deployment Notes

- Android: update `android/app/build.gradle` minSdk 21, targetSdk 34. Add internet permission (already there).
- iOS: update Info.plist for image picker permission (NSPhotoLibraryUsageDescription).

## What's Next?

Tell me when you're ready for Phase 2 wireframes + implementation! Suggestions:
- Admin panel to add lessons without code
- Video player integration
- Drawing canvas (custom painter) for in-app practice instead of paper

Donlee team – Lagos to the world 🎨🚀
