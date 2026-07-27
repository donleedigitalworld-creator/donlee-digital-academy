# Architecture - Phase 1

## Tech Stack Chosen

- **Flutter 3.2+** - Single codebase iOS/Android/Web
- **Firebase Auth** - Secure login, email/pass + Google
- **Cloud Firestore** - NoSQL user progress, artworks, notifications
- **Firebase Storage** - Portfolio image uploads
- **Provider** - Lightweight state management for Phase 1 (easy to learn, no boilerplate)
- **google_fonts, cached_network_image** - Polish UI

## Why This Structure?

We used feature-based modular architecture:

```
core/   -> Theme + Constants (no dependencies)
models/ -> Pure data objects (no Flutter dep except maybe DateTime)
services/ -> Firebase abstraction (AuthService, FirestoreService)
features/ -> Each feature has its own screens/widgets + data
widgets/ -> Shared UI
```

Benefits:
- Easy to add new module: just create new ModuleModel + lessons in LessonsData, or fetch from Firestore later
- Services can be mocked for tests
- No circular dependencies

## Data Flow

### Auth
UI (LoginScreen) -> AuthService (FirebaseAuth + Firestore create user doc) -> notifyListeners() -> HomeScreen reads currentUserModel via Provider

### Lesson Completion
LessonDetailScreen -> on Complete -> AuthService.markLessonCompleted() -> Firestore update totalLessonsCompleted increment + moduleProgress map update + completedLessonIds array -> reload user model

### Gallery/Portfolio
Currently mock Stream + List for offline demo. FirestoreService.getGalleryArtworks() returns Stream<List<ArtworkModel>> for future swap – UI already expects StreamBuilder (NotificationScreen does use it). PortfolioScreen still uses local list + ImagePicker mock upload but structure matches FirestoreService.uploadArtwork() signature.

### Notifications
FiresStore collection `notifications` where userId == global or specific UID. Mock fallback in FirestoreService._mockNotifications() if collection empty.

## LessonsData Design

Instead of hardcoding 10 x lessons as separate JSON files, we centralized in `LessonsData` class with:

- `modules` getter = 10 ModuleModel definitions (order, title, desc, icon emoji for quick UI, thumbnail, outcomes)
- `allLessons` getter builds all lessons by calling `_getLessonsForModule()` per module
- For 4 modules (intro, elements, facial, color) we hand-wrote production-quality lessons with real pedagogical content (Loomis method, value scale, color wheel, etc.)
- For other 6 modules, we generate 3 template lessons each with reusable structure but unique titles – so Phase 1 already has navigable content for all 10 modules, but you can replace template with curated content later without breaking routes.

Each LessonModel:
- has steps (LessonStep) which are the core tutorial UI (expandable)
- has quiz (QuizQuestion) with correctIndex + explanation (used inline after answering)

## UI/UX Patterns

- **Black Gold White** -> dark scaffold, gold primary for CTAs, progress, chips, white text
- **Gradients** goldGradient for premium feel, blackGradient for depth, cardGradient for subtle card depth
- **Typography** PlayfairDisplay (serif) for art academy elegance, Poppins (sans) for readability (Google Fonts handles dynamic download)
- **Smooth Navigation** -> Named routes + Hero-like image expands, bottom nav with custom container + shadow, SliverAppBar for lesson detail immersive images

## Error Handling

- Firebase init wrapped in try/catch in main() so UI still loads if not configured
- AuthService._handleAuthException maps Firebase error codes to human messages
- CachedNetworkImage placeholders prevent crashes for broken URLs

## Scalability to Phase 2+

- Need video? Add `videoUrl` field to LessonModel, add video_player/chewie dependency, reuse LessonStep widget
- Offline? Firestore has offline persistence by default, plus LessonsData is already local. Add hive for image cache.
- Role-based? Add `role` field to UserModel (student, admin, mentor)
- Admin: create `/admin` feature with Module CRUD writing to Firestore, then Home switches to Firestore fetched modules via ModuleRepository

## Testing Considerations

- Models have fromMap/toMap -> test serialization
- AuthService can be unit tested with Firebase Auth emulator
- Widget tests for LessonDetail step progression (tap next)

## Security Notes (Production)

- Firestore rules must restrict users to own portfolio (listed dev rules allow all auth users for Phase 1 ease)
- Storage rules restrict to owner writes
- Don't commit real firebase_options.dart if public repo – add to .gitignore after flutterfire configure and use --dart-define or CI env injection

