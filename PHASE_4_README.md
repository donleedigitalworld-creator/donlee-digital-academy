# Donlee Digital World Creative Art Academy - Phase 4: AI Intelligent Educational Platform

**Phases 1-3:** Foundation (10 modules) + LMS (teacher portal, schools, assignments with camera/gallery) + National Competition (registration, offline submission, judging, rankings, exhibition/scholarship) + Offline-first (smart sync, low-bandwidth)
**Phase 4:** **AI Powered Learning Tools** - makes the app an intelligent educational platform with privacy safeguards

> Design: Same black #0A0A0A, gold #D4AF37, white luxury + AI gold accents + encrypted badges. New deps: http, flutter_tts, speech_to_text, encrypt, flutter_secure_storage, fl_chart, record

---

## 🤖 Phase 4 Feature Matrix (Prompt vs Delivered)

| Requirement | Delivered |
|-------------|-----------|
| AI fine art tutor answering questions & suggesting lessons | `AIService` mock + real API structure (OpenAI gpt-4o-mini), `AIAssistantScreen` chat UI with history, system prompt teaches 10 modules, rule-based responses for Loomis, shading (5 elements), perspective (2-point VPs outside page), color theory (complementary/analogous). Suggests lessons via metadata, shows suggestedLessons chips. Encrypted, consent required. |
| AI drawing feedback proportion/shading/composition guidance | `AIDrawingFeedbackService` analyzes drawing (mock vision logic + future GPT-4o Vision), `AIDrawingFeedbackScreen` camera/gallery pick with consent dialog for AI Art Analysis, preview with proportionMarkers overlay (10% jaw long), scores grid 5 types (proportion/shading/composition/anatomy/lineQuality) with progress bars, detailed guidance per type (e.g., "jaw 10% too long, core shadow darker"), strengths/improvements, suggested exercises + lessons, teacher-reviewed pending badge, secure. Mock feedback `AIDrawingFeedback.mock()`. |
| AI study planner personalized timetables | `AIStudyPlannerService.generateStudyPlan()` takes goal enum dailyPractice/examPrep/competitionPrep/portfolioBuilding/skillMastery, minutesPerDay 10-60, start/end dates, currentProgress map, weak/strong areas, lowBandwidth bool. Generates `AIStudyPlan` with days list, each day theme (Competition Piece, Anatomy & Proportion etc) + tasks lesson/practice/quiz/assignment with aiReason why suggested. `AIStudyPlannerScreen` form with goal chips, minutes slider, date pickers, generates plan, shows days expansion tiles with tasks + Start button. |
| Practice generator quizzes & art challenges | Same service `generateChallenges()` returns `AIPracticeChallenge` list: Non-Dominant Hand Portrait 5 min daily, Lagos Market Negative Space 12 min, Complementary Color Self-Portrait limited palette 25 min. Each with description, AI prompt why (breaks perfectionism, rewires brain), difficulty beginner/intermediate/advanced/master, tags, estimatedMinutes, evaluationCriteria. `AIPracticeGeneratorScreen` difficulty dropdown + Generate button, cards with difficulty badge + timer + prompt box gold + tags + Camera Submit + Start Challenge. Privacy box. |
| AI chat assistant to help navigate & learn concepts | `AIAssistantScreen` is global assistant: system prompt includes app navigation (Learn tab, Competitions center bottom nav Compete, Camera Upload quick access, Assignments, Offline Mode AppBar wifi icon, Certificates, Teacher Portal, Exhibition & Scholarships). Handles queries "where to find", "how to submit competition offline" - responds with navigation guidance. Also general art concept explanation. Suggestion chips for quick queries. Voice support via mic button that uses AIVoiceService speech-to-text. |
| Voice learning support | `AIVoiceService` - FlutterTts for text to speech (setLanguage en-US, rate 0.5), SpeechToText for STT with listenFor 30s pauseFor 3s, isListening bool, lastWords, confidence, requestMicrophonePermission mock permission request with explanation, translateForVoice mock Yoruba/Igbo/Hausa, `VoiceLearningScreen` with language selector chips en/yo/ig/ha/fr, mic listening animation, Start Voice / Stop Listening + Test TTS, examples 3 (Explain perspective 2-point etc) with play button, privacy safeguards box (mic permission, encrypted, on-device when possible low-BW, delete via Privacy Settings). |
| AI tools for teachers to generate quizzes & lesson plans, reviewed by teachers before use | `AITeacherToolsService` generateQuiz(teacherId, lessonId, topic, count, difficulty) returns mock 3 questions Loomis brow line middle, core shadow darkest ON object, 2-point VPs outside page - with explanation, source, teacherReviewed false. teacherReviewQuiz sets teacherReviewed true + reviewedBy. generateLessonPlan(topic, ageGroup, level, duration) returns `AILessonPlanDraft` with objectives, materials (sketchbook, pencils, phone for camera capture, Donlee app offline mode), steps 6 including warm-up blind contour 5 min, demo 15 min, guided practice 20 min camera verification, AI feedback intro 5 min teacher-guided, share & critique 10 min, assignment camera upload 5 min. teacherReviewLessonPlan sets teacherApproved + approvedBy. `AITeacherToolsScreen` Tab Quiz Generator + Lesson Plan Generator, each form with topic/age/level/duration + Generate button + list cards with needs review badge + Approve & Publish button calls teacherReview → Snackbar teacher-reviewed flag set, secure. |
| AI analytics for learning trends & engagement | `AIAnalyticsService.generateStudentInsights()` takes moduleProgress, lessonsCompleted, artworks, recent submissions, quizResults → returns list `AIAnalyticsInsight` types: weakness (Focus Area perspective 30% needs boost 10 min daily Loomis + value scale), engagement (3 day streak broken, best time evenings 6-8pm), strength (Elements 82% mentor potential Top 10% competition portrait), prediction (Competition Readiness 78% → 89% if plan followed). Each with confidence, data map, recommendations, isTeacherVisible/isStudentVisible. Class analytics generateClassAnalytics avgCompletion, atRiskCount, offlineQueueAvg, lowBandwidthPercent, cameraVerifiedPercent, insights trend/engagement/prediction. `AIAnalyticsDashboardScreen` grid 4 metric cards Avg Completion 68% +5%, Camera Verified 73% low-BW saves 60%, At-Risk 2 of 12, Competition Readiness 78%, LineChart fl_chart actual gold vs predicted purple dashed, insights list with color/icon per type, privacy box. |
| Privacy safeguards permission requests & encryption | `PrivacyService` - FlutterSecureStorage for encryption key + IV, AES-256 via encrypt package, _isEncrypted bool, init(encryption key generate SecureRandom 32/16 store in secure storage, init encrypter). encryptData/decryptData base64. Consent model `PrivacyConsent` with bools aiTutorConsent, aiArtAnalysisConsent, voiceRecordingConsent, dataCollectionConsent, analyticsConsent, cameraUsageConsent, consentedAt, encryptionKeyId. defaultConsent false all. _loadConsent from SharedPreferences JSON encrypted/decrypted, saveConsent encrypts JSON then stores. requestPermission mock permission_handler with explanation + 300ms delay + true. revokeAllConsent deletes keys + resets. exportUserData mock encrypted JSON export, deleteAllUserData removes prefs. getPrivacySummary() long text explaining permission requests, encryption AES-256 keys Secure Storage, consent required per feature, teacher review required for AI quizzes/lesson plans, local first offline AI analysis, no training without Data Collection consent, delete & export GDPR, child safety under-13 parental consent, low-BW compresses locally. `PrivacySettingsScreen` gold banner encryption active AES-256, AI Feature Consents 6 toggles with Switch + icon + description + border green if true, Permissions 4 tiles Microphone/Camera/Storage/Notifications with Request button calling privacyService.requestPermission, Data Control GDPR: Export My Data + Delete AI Data + Revoke All Consents red button, Full Privacy Policy Summary text. Consent dialogs in AIAssistantScreen and AIDrawingFeedbackScreen before using AI if not consented. |
| Makes app intelligent educational platform | HomeScreen v4: AppBar shows role V4 AI + offline pending + AI ON badge green if consent true. Popup menu adds AI Tutor Chat, AI Drawing Feedback, AI Study Planner, AI Practice Generator, Voice Learning, AI Analytics, Privacy & AI Safeguards, etc. Quick Access 3 rows: row1 AI Tutor gold, AI Feedback purple, AI Planner blue, AI Practice orange; row2 Voice Learn green, Competitions purple, Exhibition blue, Privacy green success; row3 Assignments gold, Offline orange, Teacher AI Tools blue, AI Analytics orange. Banner gold AI Intelligent: AI Art Tutor + Feedback + Planner with Compete Now + Analyze Drawing buttons. National Competition banner purple now below. Featured Today + AI Suggestions. AI Insights for You card with weakness/perspective. Bottom nav center changed from Compete (Phase3) to AI Tutor auto_awesome rounded (Phase 4). OfflineBanner still appears. |

---

## 📁 New Files Phase 4 (Total libs ~85)

```
lib/models/ai/ai_models.dart - AIMessage, AITutorSession, AIDrawingFeedback (mock), AIStudyPlan/Day/Task, AIPracticeChallenge, AIQuizQuestionGenerated, AILessonPlanDraft/Step, AIAnalyticsInsight, PrivacyConsent (6 bools)
lib/services/ai/
  ai_service.dart - mock + real OpenAI structure, chatCompletion with rule-based responses for Loomis/shading/perspective/color/navigation, suggestLessons, setApiKey via SharedPrefs, _mockChatResponse with suggestedLessons metadata
  ai_drawing_feedback_service.dart - analyzeDrawing mock + lesson context awareness (perspective -> VPs too close), generateProportionOverlay, teacherReviewFeedback
  ai_study_planner_service.dart - generateStudyPlan algorithm allocates time based on weakness/goal/lowBandwidth, generateChallenges 3 mock
  ai_teacher_tools_service.dart - generateQuiz 3 mock Qs, generateLessonPlan 6 steps warm-up/demo/practice/AI intro/critique/assignment, teacherReview
  ai_analytics_service.dart - generateStudentInsights weakness/engagement/strength/prediction, generateClassAnalytics
  ai_voice_service.dart - FlutterTts init setLanguage en-US rate 0.5, isSpeaking, speak/stopSpeaking, SpeechToText isListening lastWords confidence, requestMicrophonePermission mock, startListening with onResult, translateForVoice mock Yoruba/Igbo/Hausa
  privacy_service.dart - FlutterSecureStorage key Encrypter AES, encryptData/decryptData base64, consent load/save encrypted JSON SharedPrefs, requestPermission mock, revokeAllConsent, export/delete, getPrivacySummary

lib/features/
  ai_chat/
    widgets/ai_message_bubble.dart - AIMessageBubble gold user vs card assistant with avatar gradient gold circle auto_awesome, encrypted badge, suggestedLessons chips, timestamp + volume + copy, AIThinkingIndicator 3 dots animation
    screens/ai_assistant_screen.dart - init session welcome message with capabilities + privacy + try examples, _messages list, _thinking bool, ScrollController, input + mic button voiceService.isListening, suggestion chips (Loomis 3/4, shading sphere, generate challenge, study plan competition), consent dialog if aiTutorConsent false, voiceService.speak on bubble, OfflineBanner + AI info bar, calls AIService.chatCompletion with context progress/weakness/strength
  ai_feedback/screens/ai_drawing_feedback_screen.dart - XFile selectedImage, feedback, analyzing bool, pickCamera/gallery calls privacyService cameraUsageConsent + aiArtAnalysisConsent consent dialog if not, preview Image.file 350 + proportionMarkers red circles + camera verified badge, Change Image + Analyze with AI buttons, if feedback: overallScore/100 + teacher-reviewed pending badge, scores grid 3 per row 14px, detailed guidance per type with color/icon, strengths/improvements lists, suggested exercises + lessons, Ask AI Tutor + View Suggested Lessons buttons, privacy safeguards box
  ai_planner/screens/ai_study_planner_screen.dart - goal chips AIStudyGoal, minutes slider 10-60, date fields start/end, privacy offline box, Generate AI Study Plan button, plan view card with completionRate progress bar, days take 7 expansion tiles with tasks + Start button, _taskColor/Icon per type lesson blue, practice gold, quiz purple, assignment green
  ai_practice/screens/ai_practice_generator_screen.dart - difficulty dropdown beginner/intermediate/advanced/master + Generate button, list cards with difficulty badge color (green beginner gold intermediate orange advanced red master) + timer + DAILY success badge, title playfair 14 bold, description, AI Prompt box lightbulb gold, tags, Camera Submit + Start Challenge buttons, privacy box
  ai_voice/screens/voice_learning_screen.dart - language selector chips en/yo/ig/ha/fr, voiceService init, mic card with listening animation LinearProgressIndicator, Start Voice/Stop Listening + Test TTS buttons, examples 3 with play, privacy safeguards 6 bullets
  ai_teacher/screens/ai_teacher_tools_screen.dart - TabController 2 tabs Quiz Generator + Lesson Plan Generator, _QuizGeneratorTab: topic text field, difficulty/count dropdowns, Generate Quiz button, list questions with needs review orange vs reviewed green badge, options circles with correct green, explanation italic, Edit + Approve & Publish calls teacherReviewQuiz
    _LessonPlanGeneratorTab: topic, ageGroup, level, duration dropdowns, Generate Lesson Plan, draft card with objectives/materials/steps (title + description + minutes + tip) + needs review badge + Edit + Approve & Publish calls teacherReviewLessonPlan
  ai_analytics/screens/ai_analytics_dashboard_screen.dart - fl_chart LineChart actual gold vs predicted purple dashed, metric cards 4 Avg Completion 68% Camera Verified 73% At-Risk 2 of 12 Competition Readiness 78%, insights list with color/icon per weakness orange star green engagement blue prediction purple trend gold, recommendations bullets
  privacy/screens/privacy_settings_screen.dart - init privacyService.init(uid), gold banner encryption active AES-256, AI Feature Consents 6 toggles with Switch activeColor success + icon + description + border green if true, Permissions 4 tiles with Request button, Data Control Export My Data + Delete AI Data + Revoke All Consents red, full privacy policy summary text, extension copyWith
  (enhanced) home/screens/home_screen.dart v4 - AppBar V4 AI + offline pending + AI ON badge if consent, wifi icon + AI tutor icon gold AppBar, popup menu adds AI Tutor, AI Feedback, AI Planner, AI Practice, Voice Learn, AI Teacher Tools, AI Analytics, Privacy Settings, plus competitions etc, OfflineBanner, Quick Access 3 rows AI Tutor gold, AI Feedback purple, AI Planner blue, AI Practice orange, Voice Learn green, Competitions purple, Exhibition blue, Privacy success, Assignments gold, Offline orange, Teacher AI Tools blue, AI Analytics orange, AI Banner gold AI Art Tutor + Feedback + Planner with Analyze Drawing button, national competition banner purple still, featured + AI Suggestions, progress tracker, assignment preview, AI Insights for You card with weakness/perspective etc, bottom nav center AI Tutor
  (enhanced) widgets/custom_bottom_nav.dart v4 - center tab AI Tutor auto_awesome_rounded
  core/offline/offline_banner.dart still
  core/constants/app_constants.dart - v4 version + AI collections ai_conversations, ai_feedback, ai_study_plans, ai_challenges, ai_generated_quizzes, ai_lesson_plans, ai_analytics, privacy_consents + folders ai_models, ai_voice
  main.dart - Provider AIVoiceService, PrivacyService, all Phase 4 routes /aiTutor, /aiChat, /aiFeedback, /aiPlanner, /aiPractice, /aiVoice, /aiTeacherTools, /aiAnalytics, /privacySettings
```

---

## 🔐 Firestore Collections Phase 4 Added

- `ai_conversations/{id}`: studentId, topic, personality encouraging, messages array of {id,role,content,timestamp,imageUrls,metadata,isVoice}, createdAt, lastActive, suggestedLessons, context
- `ai_feedback/{id}`: studentId, imageUrl, lowResUrl, analyzedAt, overallScore, scores map type->double, guidance map type->String, strengths, improvements, proportionMarkers [{x,y}], suggestedExercises, suggestedLessons, isOfflineAnalysis, aiMetadata {model, confidence, lowBandwidth}, teacherReviewed bool, reviewedBy
- `ai_study_plans/{id}`: studentId, goal dailyPractice/examPrep/competitionPrep/portfolioBuilding/skillMastery, createdAt, startDate, endDate, minutesPerDay, days array of {date, theme, tasks [{id,title,type,lessonId,assignmentId,estimatedMinutes,completed,aiReason}], completed, minutesSpent}, preferences lowBandwidth/weakAreas, completionRate
- `ai_challenges/{id}`: title, description, prompt, difficulty beginner/intermediate/advanced/master, tags, estimatedMinutes, referenceImageUrl, evaluationCriteria, isDaily, createdAt
- `ai_generated_quizzes/{id}`: teacherId, lessonId, topic, questionCount, difficulty, questions array {question, options, correctIndex, explanation, difficulty, source, teacherReviewed, reviewedBy}
- `ai_lesson_plans/{id}`: teacherId, topic, ageGroup, level, objectives, materials, steps [{title,desc,minutes,tip}], durationMinutes, teacherApproved bool, approvedBy, createdAt, aiMetadata
- `ai_analytics/{id}`: studentId, generatedAt, type weakness/strength/engagement/trend/prediction, title, description, confidence, data map, recommendations, isTeacherVisible, isStudentVisible
- `privacy_consents/{userId}`: userId, aiTutorConsent, aiArtAnalysisConsent, voiceRecordingConsent, dataCollectionConsent, analyticsConsent, cameraUsageConsent, consentedAt, encryptionKeyId

Storage:
- `ai_models/` future fine-tuned models
- `ai_voice/` voice recordings encrypted (if cloud stored)

---

## 🛡️ Privacy & Security Deep Dive Phase 4

**Permission Requests:**
- Every AI feature checks consent first: `privacy.consent?.aiTutorConsent != true` → shows consent dialog explaining encryption, no training without Data Collection consent, teacher anonymized insights only, voice optional.
- Camera, Microphone, Storage, Notifications all request via `PrivacyService.requestPermission()` which logs request with explanation, simulates permission_handler dialog, returns bool.
- Voice: `AIVoiceService.requestMicrophonePermission()` logs why needed.
- Drawing: `AIDrawingFeedbackScreen` checks `cameraUsageConsent` + `aiArtAnalysisConsent` before pick.

**Encryption:**
- `FlutterSecureStorage` stores AES key base64 + IV base64 in iOS Keychain/Android Keystore.
- Key generated `Key.fromSecureRandom(32)` IV `fromSecureRandom(16)` via encrypt package.
- `Encrypter(AES(key))` encrypts chats JSON, consent JSON, voice recordings? in this demo encryptData/decryptData base64.
- `isEncrypted` bool, fallback plain if init fails.
- At rest: SharedPreferences JSON is encrypted string, Firestore could store encrypted content (not shown but structure supports).
- In transit: HTTPS via http package.

**Teacher Review:**
- AI quizzes `teacherReviewed false` until teacher taps Approve & Publish → `teacherReviewQuiz` sets true + reviewedBy, then visible to students.
- Lesson plans `teacherApproved false` until Approve & Publish → sets true + approvedBy.
- Drawing feedback `teacher-reviewed pending badge` - in assignment submissions, teacherReviewFeedback sets teacherReviewed true.

**No Training Without Consent:**
- `dataCollectionConsent` separate toggle, off by default. If off, generic suggestions only, AI mock does not log personal data to train.
- `getPrivacySummary()` explicitly states no training without Data Collection consent.

**Delete & Export GDPR:**
- Export My Data button: gathers user data, encrypts JSON, would email in prod.
- Delete AI Data: removes prefs consent key, in prod deletes Firestore ai_* collections, Storage ai_voice.
- Revoke All: sets all consents false, deletes encryption keys, resets.

**Child Safety:**
- Mentioned parental consent for under-13 in summary.

**Low-Bandwidth Privacy:**
- Compresses locally before upload, encrypted thumbnail first, on-device STT when possible.

**Offline Privacy:**
- Offline queue stored locally encrypted, syncs when online with encrypted payload.

---

## 🎤 Voice Learning Support Details

- `flutter_tts`: setLanguage en-US, rate 0.5, volume 1.0, pitch 1.0, isSpeaking bool via setStartHandler/setCompletionHandler, speak(text, language), stopSpeaking.
- `speech_to_text`: initialize onError/onStatus, listen localeId en_US, listenFor 30s pauseFor 3s, onResult with recognizedWords + confidence, lastWords.
- `VoiceLearningScreen`: language selector en/yo/ig/ha/fr (future translation), mic card with listening animation, Start Voice calls requestMicrophonePermission + startListening onResult sends to AI Tutor (Snackbar), Test TTS speaks with selected language, examples list with play button.
- Low-bandwidth: STT on-device when possible, no cloud upload unless online.

---

## 📊 AI Analytics Details

- Student insights: weakness detection weakestModule progress <0.5 → title Focus Area + description proportion issues + recommendations Loomis 5 angles etc; engagement dip lessonsCompleted <5 → streak broken best time evenings; strength strongest >0.8 → mentor potential, competition portrait; prediction competition readiness 78% → 89% if plan followed, confidence 0.76.
- Class analytics: avgCompletion, atRisk count below 0.4, topPerformers, offlineQueueAvg, lowBandwidthPercent, cameraVerifiedPercent, insights trend (perspective drop-off 32%), engagement evening 5-7pm, prediction if 5 at-risk complete 10 min daily +12% in 2 weeks.
- UI: metric cards with progress bar, LineChart fl_chart actual vs predicted dashed, insights with color/icon, recommendations bullets.

---

## 🧪 Test Flow Phase 4

1. Home → Quick Access AI Tutor gold → AIAssistantScreen welcome with capabilities + privacy + try examples
2. Try suggestion chip "Explain Loomis head 3/4" → shows thinking indicator 3 dots → AI responds with sphere, cross, thirds, fifths, common mistake jaw long, next step practice challenge + suggestedLessons chips
3. Tap mic button → request permission dialog → consent if needed → listening animation + lastWords + after final result sends to AI Tutor
4. Home → AI Feedback purple → AIDrawingFeedbackScreen: consent dialog if aiArtAnalysis not consented → tap Camera (camera permission) or Gallery → preview 350px with Verified badge → Analyze with AI → thinking → feedback: overall 78/100 + teacher-reviewed pending, scores grid 5 types, detailed guidance per type proportion jaw 10% long, shading core shadow darker, composition rule of thirds, strengths/improvements, suggested exercises, Ask AI Tutor to Explain Feedback button
5. AI Planner blue: select goal Competition Prep, minutes 20, dates 14 days → Generate → plan card with completionRate progress, days 7 expansion tiles with tasks + aiReason why suggested (weak area perspective 30%, low-bandwidth compressed video), Start Today's Plan
6. AI Practice orange: difficulty intermediate + Generate → 3 challenges: Non-Dominant Hand 5 min daily, Lagos Market Negative Space 12 min, Complementary Color Portrait 25 min, each with AI Prompt why, tags, evaluation criteria, Camera Submit + Start Challenge
7. Voice Learning green: language selector Yo/Ig/Ha, mic card Start Voice → speaking example "Explain perspective 2-point" → AI speaks explanation, privacy safeguards box 6 bullets
8. Teacher AI Tools blue: Tab Quiz Generator → topic Loomis Head Method, difficulty medium, count 3 → Generate Quiz → list Qs with needs review orange vs reviewed green + options circles correct green + explanation italic → Approve & Publish → reviewed true → Snackbar teacher-reviewed flag
   Lesson Plan Generator: topic Loomis 3/4, age 13-17, level intermediate, duration 60 → Generate → draft card objectives/materials/steps 6 (warm-up blind contour 5m, demo 15m, guided practice 20m camera verification, AI feedback intro 5m, share & critique 10m, assignment camera upload 5m) + needs review badge → Approve & Publish
9. AI Analytics orange: metric cards Avg Completion 68%, Camera Verified 73%, At-Risk 2, Competition Readiness 78%, LineChart actual gold vs predicted purple dashed, insights 4 types weakness/engagement/strength/prediction with recommendations
10. Privacy Settings green: gold banner Encryption Active AES-256, 6 toggles AI Tutor, AI Art Analysis, Voice, Camera, Data Collection, Analytics with green border if true, permissions 4 tiles with Request button, Data Control Export/Delete/Revoke All, full privacy policy summary
11. Home bottom nav center now AI Tutor auto_awesome rounded, tap → AI Chat
12. Offline: AI features respect low-bandwidth toggle, offline banner shows pending queue, AI feedback lowBandwidth true shows note "Low-bandwidth mode - analysis on compressed thumbnail"

---

## 🚀 Deployment Notes Phase 4

- Add http, flutter_tts, speech_to_text, encrypt, flutter_secure_storage, fl_chart, record to pubspec (done)
- `flutter pub get`
- For real AI API: set API key via `AIService.setApiKey('sk-...')` stored SharedPrefs via `setApiKey`, mock mode if no key (detected in init)
- Firestore collections new 8: ai_conversations, ai_feedback, ai_study_plans, ai_challenges, ai_generated_quizzes, ai_lesson_plans, ai_analytics, privacy_consents
- Storage: ai_models/, ai_voice/
- Hive, SharedPrefs already
- TTS/STT permissions: add to AndroidManifest.xml RECORD_AUDIO, iOS Info.plist NSSpeechRecognitionUsageDescription + NSMicrophoneUsageDescription
- Encryption: FlutterSecureStorage uses Keychain/Keystore automatically

---

## ✅ Phase 4 Completion Checklist (Prompt)

- [x] AI fine art tutor answering questions & suggesting lessons (AIService mock rule-based + real API structure, AIAssistantScreen chat with suggestedLessons)
- [x] AI drawing feedback proportion/shading/composition (AIDrawingFeedbackService, AIDrawingFeedbackScreen with scores grid, detailed guidance, proportionMarkers overlay, teacher-reviewed pending)
- [x] AI study planner personalized timetables (AIStudyPlannerService generateStudyPlan goal/minutes/dates/progress/weak/lowBandwidth, AIStudyPlannerScreen form + plan view)
- [x] Practice generator quizzes & art challenges (generateChallenges 3 examples with AI prompt why, AIPracticeGeneratorScreen difficulty + Generate + cards Camera Submit)
- [x] AI chat assistant to help navigate & learn concepts (AIAssistantScreen navigation guidance for Learn/Competitions/Camera Upload/Assignments/Offline/Certificates/Teacher Portal/Exhibition)
- [x] Voice learning support (AIVoiceService TTS/STT, VoiceLearningScreen language selector, mic listening, Test TTS, examples, privacy box)
- [x] AI tools for teachers to generate quizzes & lesson plans reviewed by teachers before use (AITeacherToolsService generateQuiz/ generateLessonPlan + teacherReview, AITeacherToolsScreen 2 tabs Quiz + Lesson Plan with needs review badge + Approve & Publish sets teacherReviewed/teacherApproved)
- [x] AI analytics learning trends & engagement (AIAnalyticsService generateStudentInsights weakness/engagement/strength/prediction + class analytics, AIAnalyticsDashboardScreen metric cards + LineChart fl_chart actual vs predicted + insights with recommendations)
- [x] Privacy safeguards permission requests & encryption (PrivacyService AES-256 Secure Storage, consent model 6 bools, requestPermission, encrypt/decrypt, revoke/export/delete, PrivacySettingsScreen gold banner encryption active, 6 toggles, permissions tiles Request, GDPR data control, consent dialogs in AI screens, low-BW + offline privacy notes)
- [x] Makes app intelligent educational platform (Home v4 AI Quick Access 3 rows, AI banner gold, AI Insights card, bottom nav center AI Tutor)

Version 4.0.0 Phase 4

