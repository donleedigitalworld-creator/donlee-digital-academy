import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'services/auth_service.dart';
import 'services/offline_service.dart';
import 'services/ai/ai_voice_service.dart';
import 'services/ai/privacy_service.dart';
import 'services/security/security_service.dart';
import 'services/competition_service.dart' as comp_service;
import 'features/auth/screens/splash_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/lessons/screens/modules_list_screen.dart';
import 'features/lessons/screens/lesson_detail_screen.dart';
import 'features/lessons/screens/quiz_screen.dart';
import 'features/practice/screens/practice_screen.dart';
import 'features/portfolio/screens/portfolio_screen.dart';
import 'features/gallery/screens/gallery_screen.dart';
import 'features/notifications/screens/notifications_screen.dart';
import 'models/lesson_model.dart';
import 'core/constants/app_constants.dart';

// Phase 2
import 'features/teacher/screens/teacher_auth_screen.dart';
import 'features/teacher/screens/teacher_dashboard.dart';
import 'features/teacher/screens/class_management_screen.dart';
import 'features/teacher/screens/assignment_create_screen.dart';
import 'features/teacher/screens/submissions_review_screen.dart';
import 'features/teacher/screens/student_progress_screen.dart';
import 'features/teacher/screens/teacher_profile_screen.dart';
import 'features/school/screens/school_registration_screen.dart';
import 'features/school/screens/school_dashboard_screen.dart';
import 'features/assignments/screens/assignments_list_screen.dart';
import 'features/assignments/screens/assignment_detail_screen.dart';
import 'features/assignments/screens/submit_assignment_screen.dart';
import 'features/announcements/screens/announcements_screen.dart';
import 'features/certificates/screens/certificates_screen.dart';
import 'features/profile/screens/student_profile_screen.dart';
import 'features/admin/screens/admin_dashboard_screen.dart';
import 'models/assignment_model.dart';
import 'models/competition_model.dart';

// Phase 3
import 'features/competitions/screens/competitions_list_screen.dart';
import 'features/competitions/screens/competition_detail_screen.dart';
import 'features/competitions/screens/competition_registration_screen.dart';
import 'features/competitions/screens/competition_submission_screen.dart';
import 'features/competitions/screens/judging_dashboard_screen.dart';
import 'features/competitions/screens/results_rankings_screen.dart';
import 'features/competitions/screens/exhibition_scholarship_screen.dart';
import 'features/offline/screens/offline_mode_screen.dart';

// Phase 4 AI
import 'features/ai_chat/screens/ai_assistant_screen.dart';
import 'features/ai_feedback/screens/ai_drawing_feedback_screen.dart';
import 'features/ai_planner/screens/ai_study_planner_screen.dart';
import 'features/ai_practice/screens/ai_practice_generator_screen.dart';
import 'features/ai_voice/screens/voice_learning_screen.dart';
import 'features/ai_teacher/screens/ai_teacher_tools_screen.dart';
import 'features/ai_analytics/screens/ai_analytics_dashboard_screen.dart';
import 'features/privacy/screens/privacy_settings_screen.dart';

// Phase 5 National Ecosystem
import 'features/national_dashboard/screens/national_dashboard_screen.dart';
import 'features/parent_portal/screens/parent_dashboard_screen.dart';
import 'features/certificates_advanced/screens/certificate_verification_screen.dart';
import 'features/certificates_advanced/screens/certificates_gallery_screen.dart';
import 'features/resource_library/screens/resource_library_screen.dart';
import 'features/career_center/screens/career_center_screen.dart';
import 'features/community/screens/community_feed_screen.dart';
import 'features/accessibility/screens/accessibility_settings_screen.dart';
import 'features/security/screens/security_dashboard_screen.dart';
import 'features/advanced_analytics/screens/advanced_analytics_screen.dart';
import 'features/school_management/screens/school_management_portal_screen.dart';

// Phase 6 - Parent Engagement, Teacher PD, CMS, Partnerships, Scholarship, Marketplace, Research, MFA, Creative Expansion + Ministry
import 'features/ministry_portal/screens/ministry_portal_screen.dart';
import 'features/parent_engagement/screens/parent_engagement_center_screen.dart';
import 'features/teacher_pd/screens/teacher_pd_center_screen.dart';
import 'features/cms/screens/cms_dashboard_screen.dart';
import 'features/partnerships/screens/partnerships_portal_screen.dart';
import 'features/scholarship_center/screens/scholarship_center_screen.dart';
import 'features/marketplace/screens/marketplace_screen.dart';
import 'features/research_analytics/screens/research_dashboard_screen.dart';
import 'features/mfa/screens/mfa_setup_screen.dart';
import 'features/creative_expansion/screens/creative_subjects_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    debugPrint("Firebase init failed (use mock mode): $e");
  }
  runApp(const DonleeApp());
}

class DonleeApp extends StatelessWidget {
  const DonleeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => OfflineService()..init()),
        ChangeNotifierProvider(create: (_) => AIVoiceService()),
        ChangeNotifierProvider(create: (_) => PrivacyService()),
        ChangeNotifierProvider(create: (_) => SecurityService()..init()),
        ChangeNotifierProvider(create: (_) => AccessibilityService()),
      ],
      child: MaterialApp(
        title: AppConstants.appFullName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        initialRoute: '/splash',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/splash': return MaterialPageRoute(builder: (_) => const SplashScreen());
            case '/login': return MaterialPageRoute(builder: (_) => const LoginScreen());
            case '/register': return MaterialPageRoute(builder: (_) => const RegisterScreen());
            case '/home': return MaterialPageRoute(builder: (_) => const HomeScreen());
            case '/modules': return MaterialPageRoute(builder: (_) => const ModulesListScreen());
            case '/lessonDetail': final lesson = settings.arguments as LessonModel; return MaterialPageRoute(builder: (_) => LessonDetailScreen(lesson: lesson));
            case '/quiz': final lesson = settings.arguments as LessonModel; return MaterialPageRoute(builder: (_) => QuizScreen(lesson: lesson));
            case '/practice': return MaterialPageRoute(builder: (_) => const PracticeScreen());
            case '/portfolio': return MaterialPageRoute(builder: (_) => const PortfolioScreen());
            case '/gallery': return MaterialPageRoute(builder: (_) => const GalleryScreen());
            case '/notifications': return MaterialPageRoute(builder: (_) => const NotificationsScreen());
            case '/teacherAuth': return MaterialPageRoute(builder: (_) => const TeacherAuthScreen());
            case '/teacherDashboard': return MaterialPageRoute(builder: (_) => const TeacherDashboardScreen());
            case '/teacherProfile': return MaterialPageRoute(builder: (_) => const TeacherProfileScreen());
            case '/classManagement': return MaterialPageRoute(builder: (_) => const ClassManagementScreen());
            case '/createAssignment': return MaterialPageRoute(builder: (_) => const AssignmentCreateScreen());
            case '/submissionsReview': return MaterialPageRoute(builder: (_) => const SubmissionsReviewScreen());
            case '/studentProgress': return MaterialPageRoute(builder: (_) => const StudentProgressScreen());
            case '/schoolRegistration': return MaterialPageRoute(builder: (_) => const SchoolRegistrationScreen());
            case '/schoolDashboard': return MaterialPageRoute(builder: (_) => const SchoolDashboardScreen());
            case '/schoolManagement': return MaterialPageRoute(builder: (_) => const SchoolManagementPortalScreen());
            case '/assignments': return MaterialPageRoute(builder: (_) => const AssignmentsListScreen());
            case '/assignmentDetail': final assignment = settings.arguments as AssignmentModel; return MaterialPageRoute(builder: (_) => AssignmentDetailScreen(assignment: assignment));
            case '/submitAssignment': final assignment = settings.arguments as AssignmentModel; return MaterialPageRoute(builder: (_) => SubmitAssignmentScreen(assignment: assignment));
            case '/announcements': return MaterialPageRoute(builder: (_) => const AnnouncementsScreen());
            case '/createAnnouncement': return MaterialPageRoute(builder: (_) => const CreateAnnouncementScreen());
            case '/certificates': return MaterialPageRoute(builder: (_) => const CertificatesScreen());
            case '/studentProfile': return MaterialPageRoute(builder: (_) => const StudentProfileScreen());
            case '/adminDashboard': return MaterialPageRoute(builder: (_) => const AdminDashboardScreen());
            case '/userManagement': return MaterialPageRoute(builder: (_) => const UserManagementScreen());
            case '/courseManagement': return MaterialPageRoute(builder: (_) => const CourseManagementScreen());
            case '/analytics': return MaterialPageRoute(builder: (_) => const AnalyticsScreen());
            case '/competitions': return MaterialPageRoute(builder: (_) => const CompetitionsListScreen());
            case '/competitionDetail': final comp = settings.arguments as CompetitionModel? ?? comp_service.CompetitionService().getMockCompetitions().first; return MaterialPageRoute(builder: (_) => CompetitionDetailScreen(competition: comp));
            case '/competitionCreate': return MaterialPageRoute(builder: (_) => const CompetitionCreateScreen());
            case '/competitionRegister': final compReg = settings.arguments as CompetitionModel; return MaterialPageRoute(builder: (_) => CompetitionRegistrationScreen(competition: compReg));
            case '/competitionSubmit': final compSub = settings.arguments as CompetitionModel; return MaterialPageRoute(builder: (_) => CompetitionSubmissionScreen(competition: compSub));
            case '/competitionSubmissions': final compGallery = settings.arguments as CompetitionModel? ?? comp_service.CompetitionService().getMockCompetitions().first; return MaterialPageRoute(builder: (_) => CompetitionDetailScreen(competition: compGallery));
            case '/judgingDashboard': final compJudge = settings.arguments as CompetitionModel? ?? comp_service.CompetitionService().getMockCompetitions().first; return MaterialPageRoute(builder: (_) => JudgingDashboardScreen(competition: compJudge));
            case '/competitionResults': final compRes = settings.arguments as CompetitionModel? ?? comp_service.CompetitionService().getMockCompetitions().first; return MaterialPageRoute(builder: (_) => ResultsRankingsScreen(competition: compRes));
            case '/exhibitionScholarship': return MaterialPageRoute(builder: (_) => const ExhibitionScholarshipScreen());
            case '/offlineMode': return MaterialPageRoute(builder: (_) => const OfflineModeScreen());
            case '/syncStatus': return MaterialPageRoute(builder: (_) => const OfflineModeScreen());
            case '/aiTutor': final topic = settings.arguments as String?; return MaterialPageRoute(builder: (_) => AIAssistantScreen(initialTopic: topic));
            case '/aiChat': return MaterialPageRoute(builder: (_) => const AIAssistantScreen());
            case '/aiFeedback': return MaterialPageRoute(builder: (_) => const AIDrawingFeedbackScreen());
            case '/aiPlanner': return MaterialPageRoute(builder: (_) => const AIStudyPlannerScreen());
            case '/aiPractice': return MaterialPageRoute(builder: (_) => const AIPracticeGeneratorScreen());
            case '/aiVoice': return MaterialPageRoute(builder: (_) => const VoiceLearningScreen());
            case '/aiTeacherTools': return MaterialPageRoute(builder: (_) => const AITeacherToolsScreen());
            case '/aiAnalytics': return MaterialPageRoute(builder: (_) => const AIAnalyticsDashboardScreen());
            case '/privacySettings': return MaterialPageRoute(builder: (_) => const PrivacySettingsScreen());
            case '/nationalDashboard': return MaterialPageRoute(builder: (_) => const NationalDashboardScreen());
            case '/parentPortal': return MaterialPageRoute(builder: (_) => const ParentDashboardScreen());
            case '/certificateVerify': return MaterialPageRoute(builder: (_) => const CertificateVerificationScreen());
            case '/certificateGallery': return MaterialPageRoute(builder: (_) => const CertificatesGalleryScreen());
            case '/resourceLibrary': return MaterialPageRoute(builder: (_) => const ResourceLibraryScreen());
            case '/careerCenter': return MaterialPageRoute(builder: (_) => const CareerCenterScreen());
            case '/community': return MaterialPageRoute(builder: (_) => const CommunityFeedScreen());
            case '/accessibilitySettings': return MaterialPageRoute(builder: (_) => const AccessibilitySettingsScreen());
            case '/securityDashboard': return MaterialPageRoute(builder: (_) => const SecurityDashboardScreen());
            case '/advancedAnalytics': return MaterialPageRoute(builder: (_) => const AdvancedAnalyticsScreen());
            // Phase 6
            case '/ministryPortal': return MaterialPageRoute(builder: (_) => const MinistryPortalScreen());
            case '/parentEngagement': return MaterialPageRoute(builder: (_) => const ParentEngagementCenterScreen());
            case '/teacherPD': return MaterialPageRoute(builder: (_) => const TeacherPDCenterScreen());
            case '/cmsDashboard': return MaterialPageRoute(builder: (_) => const CMSDashboardScreen());
            case '/partnershipsPortal': return MaterialPageRoute(builder: (_) => const PartnershipsPortalScreen());
            case '/scholarshipCenter': return MaterialPageRoute(builder: (_) => const ScholarshipCenterScreen());
            case '/marketplace': return MaterialPageRoute(builder: (_) => const MarketplaceScreen());
            case '/researchDashboard': return MaterialPageRoute(builder: (_) => const ResearchDashboardScreen());
            case '/mfaSetup': return MaterialPageRoute(builder: (_) => const MFASetupScreen());
            case '/creativeSubjects': return MaterialPageRoute(builder: (_) => const CreativeSubjectsExpansionScreen());
            default: return MaterialPageRoute(builder: (_) => const SplashScreen());
          }
        },
      ),
    );
  }
}
