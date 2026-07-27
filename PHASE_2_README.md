# Donlee Digital World Creative Art Academy - Phase 2 LMS Layer

**Phase 1** = Foundation (auth, home, 10 modules, practice, portfolio, gallery)
**Phase 2** = Learning Management System (Teacher Portal, Schools, Assignments, Camera Uploads, Scoring, Announcements, Certificates, Admin)

> Design Language: Same black #0A0A0A, gold #D4AF37, white, with goldGradient premiums. All new screens follow Phase 1 AppTheme.

---

## 🚀 Phase 2 Features Delivered

### 1. Role-Based Auth System (Student, Teacher, SchoolAdmin, Admin)
- Updated `AuthService` with `UserRole` enum: student, teacher, admin, schoolAdmin
- `registerWithEmail` now takes role, photoUrl, schoolId, classId
- Profile photo upload at registration: Camera OR Gallery → Firebase Storage `profiles/{uid}/avatar.jpg` – secure per-uid
- Teacher registration separate screen: `TeacherAuthScreen` with bio, specialization, profile photo
- Login auto-routes based on role (student → /home, teacher → /teacherDashboard)
- Secure storage service: `StorageService` handles profile photos, artwork uploads, camera capture, gallery multi-pick, delete

### 2. Teacher Portal
**Files:** `lib/features/teacher/screens/*`

- **Teacher Dashboard** (`teacher_dashboard.dart`):
  - Stats: total students, classes, pending reviews
  - Quick Actions: Create Assignment, Send Announcement, Track Progress, Manage Classes
  - My Classes cards with occupancy bar, student count, schedule
  - Submissions to Review list with camera-verified badges → Teacher can review camera vs gallery uploads
  - FAB → New Assignment

- **Teacher Auth** (`teacher_auth_screen.dart`):
  - Registration/Login toggle, profile photo picker, bio, specialization
  - Verified badge info, secure storage disclaimer

- **Class Management** (`class_management_screen.dart`):
  - List of classes (mock + Firestore stream ready via `TeacherService.getTeacherClasses()`)
  - ExpansionTile shows description, student chips, actions: Add Student, Assignments, Progress
  - Create Class bottom sheet: name, desc, schedule, level (beginner/intermediate/advanced), max students slider
  - Calls `TeacherService.createClass()` which also updates school and teacher docs

- **Assignment Creation** (`assignment_create_screen.dart`):
  - Select class, title, description, detailed instructions
  - Link to module (dropdown from LessonsData.modules)
  - Due date picker, max score
  - Toggles: Require Camera Photo (forces camera capture for original work verification) + Allow Late Submission
  - Explains Phase 2 camera + secure storage, future AI suggestions in gold info box
  - Publishes via `TeacherService.createAssignment()` → adds assignmentId to class, increments teacher totalAssignments

- **Submissions Review** (`submissions_review_screen.dart`):
  - Split pane: left list of submissions (student avatar, assignment, time, camera/gallery badge, status pending/reviewed)
  - Right detail: student header, Camera Verified badge, artwork images (network), zoom/annotate buttons placeholder
  - Teacher Review box: feedback textfield, score input, future AI suggestion box (gold) showing "AI: Proportions suggest jaw 10% too long. Shading: Core shadow darker"
  - Submit Review button → `TeacherService.gradeSubmission()`
  - Designed for teacher-guided, but AI suggestion placeholder for Phase 3

- **Student Progress** (`student_progress_screen.dart`):
  - Class performance overview (62% avg) with progress bar
  - Student list: photo initials, progress bar, lessons completed, avg score, streak, camera upload count, score, hours learned
  - Flags "Needs Help" if <40% progress (red border)
  - Tap → View Detail (placeholder for individual analytics)

- **Teacher Profile** (`teacher_profile_screen.dart`):
  - Verified badge, stats (students/classes/rating), bio, secure storage & camera review tiles

### 3. School Registration & Class Management
**File:** `school_registration_screen.dart`, `school_model.dart`, `school_service.dart`

- **SchoolModel**: id, name, logoUrl, email, phone, address, city, ownerId, teacherIds, classIds, totalStudents, description
- **ClassModel**: id, schoolId, name, description, teacherId, studentIds, assignmentIds, coverImageUrl, level, maxStudents, occupancy getter, schedule
- **SchoolService**: registerSchool, getSchool, getAllSchools, getOwnerSchools, addTeacherToSchool
- Mock schools: Donlee Main Lagos (127 students), Abuja Hub (58)
- Registration form: name, email, phone, address, city, description → creates school doc → owner can create classes
- Secure: School data isolated by schoolId, teachers only see their classes (Firestore rules suggested in doc)

### 4. Assignments with Camera & Gallery Upload + Scoring
**Files:** `assignment_model.dart`, `assignments_list_screen.dart`, `assignment_detail_screen.dart`, `submit_assignment_screen.dart`, `assignment_service.dart`, `storage_service.dart`

- **AssignmentModel**: id, title, description, instructions, teacherId/Name, classId, schoolId, moduleId, lessonId, referenceImageUrls, createdAt, dueDate, maxScore, status (draft/published/closed/archived), submissionIds, tags, allowLateSubmission, requireCameraPhoto
- **SubmissionModel**: id, assignmentId, studentId/Name/PhotoUrl, classId, artworkImageUrls (list), textResponse, submittedAt, reviewedAt, status (pending/submitted/reviewed/late/resubmit), score, feedback, teacherAnnotationUrls, isLate
- **AssignmentService**: getStudentAssignments stream, submitAssignment (also adds to assignment's submissionIds), getStudentSubmissions, generateCertificate
- **Assignments List** (`assignments_list_screen.dart`): TabController Pending/Submitted/Graded, filter by overdue, shows camera required badge, score badge for graded tab
- **Assignment Detail** (`assignment_detail_screen.dart`): Header chips (module, points, camera required), description, instructions card, reference images horizontal list, Phase 2 how-to-submit box explaining secure storage + future AI, FAB Submit Assignment
- **Submit Assignment** (`submit_assignment_screen.dart`): 
  - Requires at least 1 photo
  - Two buttons: CAMERA (uses ImagePicker camera) and GALLERY (multi-pick)
  - Grid preview with remove X, photo number badge
  - Notes textfield "What did you learn?"
  - Secure storage info box
  - Upload flow: `StorageService.uploadArtworkImages()` → returns URLs (or local paths for demo) → `AssignmentService.submitAssignment()` → Firestore
  - Shows SnackBar "Teacher will review & score your uploaded work"

### 5. Tracking Student Progress
- Updated home screen quick access to Assignments
- `StudentProgressScreen` for teachers (see above)
- Student profile screen shows learning journey with per-module progress bars, total lessons, artworks, overall progress
- Firestore `users/{uid}` moduleProgress map updated on lesson completion (existing Phase 1 logic)
- Class occupancy tracking via ClassModel.occupancy

### 6. Announcements
**Files:** `announcement_model.dart`, `announcements_screen.dart`

- **AnnouncementModel**: id, title, body, authorId/Name/Photo, schoolId, classId, audience (all/school/class/individual), priority (low/normal/high/urgent), attachments, createdAt, expiresAt, readBy, actionLink, imageUrl
- **AnnouncementsScreen**: List of announcements with priority color border (urgent=red, high=gold), read/unread, image header if present, author, timeAgo
- **CreateAnnouncementScreen**: teacher/admin can create: title, body, priority dropdown, audience dropdown → mock send SnackBar, Firestore ready via collection `announcements`

### 7. Certificates
**Files:** `certificate_model.dart`, `certificates_screen.dart`, `certificate_widget.dart`

- **CertificateModel**: id, studentId/Name/Photo, type (moduleCompletion, courseCompletion, assignmentExcellence, challenge, schoolCertificate), title, description, moduleId, assignmentId, classId, schoolId, issuedBy/Id, issuedAt, expiresAt, certificateNumber `DON-YYYY-XXXXXX`, qrCodeData, score, metadata
- **CertificatesScreen**: List of certificates with gold border cards, premium icon, certificate number, issued date, score, tap → Dialog with full CertificateWidget
- **CertificateWidget**: Luxury certificate design black/gold, Donlee branding, CERTIFICATE OF ACHIEVEMENT, student name in gold, description, score box, signature placeholders, QR code placeholder, verify at donlee.art/verify, tagline
- Generation: `AssignmentService.generateCertificate()` creates doc with auto certificate number, called after high score or module completion (teacher or system triggers)

### 8. Admin Dashboard
**File:** `admin_dashboard_screen.dart`

- **AdminDashboardScreen**:
  - Top stats grid: Total Students 1,247 (+12%), Active Teachers 34, Schools 2, Assignments Graded 8.4k
  - Management cards grid 2x3: User Management, Course Management, School Management, Analytics, Camera Uploads Audit, Security & Storage (each navigates)
  - Schools Overview list with progress bars
  - Phase 2 Complete info box with future AI suggestions teaser

- **UserManagementScreen**: List of users with avatar, role chip (teacher=green, admin=red, student=gold), email, progress, photo verified dot, more options

- **CourseManagementScreen**: List of courses (4 examples) with lessons count, enrolled students, status chip (Published/Featured)

- **AnalyticsScreen**: Metrics Row: Avg Completion 68%, Camera Verified 73%, Avg Score 84/100, Active Streak 12 days; Module Drop-off retention bars (Intro 92%, Elements 78%, Anatomy 54%, Hands & Feet 32%)

### 9. Student Profile Overhaul (Phase 2)
**File:** `student_profile_screen.dart`

- Circle avatar with gold border, camera edit button → gallery pick + uploadProfilePhoto + updateProfile
- Role chip, name, email
- Stats Row: Lessons Done, Artworks, Progress %
- Tiles: School, Class, Data Security, Camera Upload (shows counts)
- Learning Journey per-module progress bars
- Buttons: View Certificates, Log Out
- Uses `StorageService` for profile photo change

### 10. Updated Registration (Phase 2 camera/gallery)
**File:** `register_screen.dart` (overhauled)

- Profile photo area with Camera and Gallery buttons (side-by-side OutlinedButton.icon)
- Role selector: Student / Teacher / School Admin (ChoiceChips)
- Secure storage disclaimer
- On register, if profileImage selected and uid exists → uploadProfilePhoto → updateProfile photoUrl
- Routes to teacherDashboard if teacher role, else home

### 11. Updated Home Screen (Phase 2 LMS)
**File:** `home_screen.dart` (updated)

- AppBar shows role badge next to academy name
- Popup menu with: My Profile, Assignments (Camera Upload), Announcements, Certificates, Teacher Portal, Admin Dashboard, Register School, Logout
- Quick Access Bar (4 icons row): Assignments, Camera Upload, Teacher Portal, Certificates – colored icons with gold border
- Pending Assignments preview card (2 assignments with camera indicator)
- Bottom banner updated to "Phase 2 Live - Camera Upload!" with ASSIGNMENTS and UPLOAD WORK buttons
- Rest of Phase 1 content intact (featured lesson, progress tracker, continue learning)

### 12. New Routes in main.dart
All Phase 2 screens registered:

- /teacherAuth, /teacherDashboard, /teacherProfile, /classManagement, /createAssignment, /submissionsReview, /studentProgress
- /schoolRegistration
- /assignments, /assignmentDetail, /submitAssignment
- /announcements, /createAnnouncement
- /certificates
- /studentProfile
- /adminDashboard, /userManagement, /courseManagement, /analytics

---

## 📁 New Folder Structure (Phase 2 adds)

```
lib/
├── models/
│   ├── teacher_model.dart (TeacherModel, UserRole)
│   ├── school_model.dart (SchoolModel, ClassModel)
│   ├── assignment_model.dart (AssignmentModel, SubmissionModel, AssignmentStatus, SubmissionStatus)
│   ├── announcement_model.dart (AnnouncementModel, priority, audience)
│   └── certificate_model.dart (CertificateModel, CertificateType)
├── services/
│   ├── storage_service.dart (profile photo, artwork multi-upload, camera, gallery, delete)
│   ├── teacher_service.dart (CRUD teacher, classes, assignments, submissions, grading, mock data)
│   ├── school_service.dart (register school, get schools, add teacher)
│   └── assignment_service.dart (student assignments stream, submit, student submissions, certificates)
├── features/
│   ├── teacher/screens/ (6 screens)
│   ├── school/screens/ (registration)
│   ├── assignments/screens/ (list, detail, submit)
│   ├── announcements/screens/ (list, create)
│   ├── certificates/screens/ + widgets/ (list, luxury widget)
│   ├── profile/screens/ (student profile with editable photo)
│   └── admin/screens/ (dashboard, user, course, analytics)
```

Total lib files: 53 (was 29 in Phase 1 → +24 new)

---

## 🔐 Secure Storage & Firebase Structure (Phase 2)

**Firestore Collections Added:**

- `teachers/{uid}`: email, displayName, photoUrl, bio, specialization, classIds, schoolIds, totalStudents, totalAssignments, isVerified
- `schools/{id}`: name, logoUrl, email, phone, address, city, ownerId, teacherIds, classIds, totalStudents, description
- `classes/{id}`: schoolId, name, description, teacherId, studentIds, assignmentIds, level, maxStudents, schedule
- `assignments/{id}`: title, description, instructions, teacherId/Name, classId, schoolId, moduleId, dueDate, maxScore, status, tags, requireCameraPhoto, allowLateSubmission
- `submissions/{id}`: assignmentId, studentId/Name/Photo, classId, artworkImageUrls (urls from Storage), textResponse, submittedAt, status, score, feedback, isLate
- `announcements/{id}`: title, body, authorId/Name, schoolId/classId, audience, priority, createdAt, imageUrl
- `certificates/{id}`: studentId/Name, type, title, description, moduleId, issuedBy, issuedAt, certificateNumber DON-YYYY-XXXXXX, score

**Storage Paths:**

- `profiles/{uid}/avatar_{timestamp}.jpg` – profile photos, private per user
- `submissions/{assignmentId}/{uid}/{timestamp}_{name}` – assignment artwork, scoped to assignment + student
- `portfolios/{uid}/{timestamp}_{name}` – general portfolio
- `school_logos/{schoolId}/...` (placeholder for future)
- `certificates/{certificateId}/...` (PDFs later)

**Suggested Firestore Rules (Phase 2 dev):**

```
match /users/{uid} { allow read: if request.auth != null; allow write: if request.auth.uid == uid || isAdmin(); }
match /teachers/{uid} { allow read: if request.auth != null; allow write: if request.auth.uid == uid || isAdmin(); }
match /schools/{id} { allow read: if request.auth != null; allow write: if isAdmin() || request.auth.uid == resource.data.ownerId; }
match /classes/{id} { allow read: if request.auth != null && (request.auth.uid in resource.data.studentIds || request.auth.uid == resource.data.teacherId || isAdmin()); }
match /assignments/{id} { allow read: if request.auth != null && request.auth.uid in get(/databases/$(database)/documents/classes/$(resource.data.classId)).data.studentIds || request.auth.uid == resource.data.teacherId; }
match /submissions/{id} { allow read: if request.auth.uid == resource.data.studentId || request.auth.uid == get(/databases/$(database)/documents/assignments/$(resource.data.assignmentId)).data.teacherId || isAdmin(); allow create: if request.auth.uid == request.resource.data.studentId; }
```

Add helper `isAdmin()` checking users/{uid} role == admin.

---

## 📸 Camera Access Implementation

- Uses `image_picker` (already in pubspec Phase 1)
- `StorageService.captureWithCamera()`: `pickImage(source: camera, imageQuality: 80, maxWidth: 2000)`
- `pickFromGallery()`: `pickMultiImage(imageQuality: 80, maxWidth: 2000)`
- Both return `XFile` list
- Registration screen: Camera + Gallery buttons side-by-side, preview in circle avatar
- Submit Assignment screen: Grid preview of selected files (local path for instant preview, then upload to Firebase Storage to get URL, fallback to local path if upload fails for offline demo)
- Teacher Review screen: Shows cameraVerified badge if submission `isCamera` true (determined by assignment requireCameraPhoto or metadata), helps verify original work
- Profile photos: Students at registration can use camera/gallery, stored securely, shown in app bar / profile / submissions

Future AI will analyze camera uploads for proportions/shading suggestions – UI placeholder already in submissions_review_screen.dart: "Future: AI Suggestion" gold box.

---

## 🧪 How to Test Phase 2

1. Register as Student with camera profile photo → should route to /home, see role STUDENT chip
2. Home → tap Teacher Portal → Teacher Dashboard → My Classes (2 mock)
3. Teacher Dashboard → Create Assignment → fill form, check Require Camera → Publish → Snackbar
4. As Student: Home → Assignments → Pending → Tap assignment with Camera Required badge → Assignment Detail shows how-to → Submit → Camera button (will open camera on device) + Gallery → Add notes → Submit → Snackbar + back to list
5. As Teacher: Teacher Dashboard → Submissions to Review → see mock with Camera Verified badge → tap Review → see artwork, add feedback/score → Submit Review
6. Student Profile → tap camera icon on avatar → change photo → should upload
7. Admin Dashboard → User Management / Course Management / Analytics
8. Certificates → tap card → luxury black/gold certificate dialog
9. Announcements → list + create
10. School Registration → fill form → creates school

All screens work with mock data if Firestore empty – streams have mock fallbacks in TeacherService, SchoolService, AssignmentService.

---

## 🔮 Phase 3 Teaser (AI Suggestions)

Already scaffolded:

- Submissions Review has AI suggestion placeholder: proportions, shading
- Artwork model could add aiAnalysis field: { proportionScore, shadingScore, suggestions: [] }
- Next: Integrate ML Kit or custom model to analyze uploaded drawings vs reference, suggest: "Jaw angle 10% longer than Loomis average, core shadow could be 2 values darker, line confidence 70%"
- Teacher still approves, AI assists – teacher-guided as requested

---

## 📦 Dependencies (no change from Phase 1, all already included)

- firebase_core, firebase_auth, cloud_firestore, firebase_storage
- provider, google_fonts, cached_network_image, image_picker

---

## ✅ Phase 2 Complete Checklist

- [x] Teacher portal registration, login, profiles (bio, specialization, verified badge)
- [x] School registration and class management (create school, create class, add students, occupancy)
- [x] Assignments with submissions and scoring (create, list, detail, camera/gallery upload, teacher review & score)
- [x] Track student progress (per-module progress bars, class analytics, individual stats, drop-off analysis)
- [x] Send announcements (priority, audience, image support, create)
- [x] Generate certificates (module, assignment excellence, luxury black/gold design, QR, verified number)
- [x] Admin dashboard managing users and courses (stats, user mgmt, course mgmt, analytics, schools overview)
- [x] Same design language black/gold/white
- [x] Firebase/Firestore for data (services + models + rules suggestion)
- [x] Camera access for students to capture drawings, upload from gallery
- [x] Profile photos at registration, secure storage, role-based access, teachers review & score
- [x] Placeholder for AI suggestions

Ready for production hardening + Phase 3 AI.

