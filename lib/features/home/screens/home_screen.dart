import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../services/auth_service.dart';
import '../../../services/offline_service.dart';
import '../../../services/ai/privacy_service.dart';
import '../../../widgets/custom_bottom_nav.dart';
import '../../../features/lessons/data/lessons_data.dart';
import '../widgets/welcome_header.dart';
import '../widgets/featured_lesson_card.dart';
import '../widgets/progress_tracker.dart';
import '../../../models/teacher_model.dart';
import '../../../core/offline/offline_banner.dart';
import '../../ministry_portal/widgets/welcome_message_widget.dart';
import '../../../models/ministry/ministry_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNav = 0;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final offline = Provider.of<OfflineService>(context);
    final privacy = Provider.of<PrivacyService>(context);
    final user = auth.currentUserModel;
    final role = auth.currentRole;
    final modules = LessonsData.modules;
    final featured = LessonsData.getFeaturedLesson();

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              backgroundColor: AppColors.primaryBlack,
              title: Row(children: [
                Container(width: 36, height: 36, decoration: BoxDecoration(gradient: AppColors.goldGradient, shape: BoxShape.circle), child: const Icon(Icons.palette, size: 20, color: AppColors.primaryBlack)),
                const SizedBox(width: 10),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("DONLEE DIGITAL WORLD", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1, color: AppColors.primaryWhite)),
                  Row(children: [
                    Text("Creative Art Academy", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.primaryGold)),
                    const SizedBox(width: 6),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1), decoration: BoxDecoration(color: AppColors.primaryGold.withOpacity(0.15), borderRadius: BorderRadius.circular(6)), child: Text("${role.name.toUpperCase()} • V6 NATIONAL+MINISTRY", style: GoogleFonts.poppins(fontSize: 7, fontWeight: FontWeight.bold, color: AppColors.primaryGold))),
                    if (!offline.isOnline) Container(margin: const EdgeInsets.only(left: 4), padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1), decoration: BoxDecoration(color: Colors.orangeAccent.withOpacity(0.15), borderRadius: BorderRadius.circular(4)), child: Text("OFFLINE ${offline.pendingCount}", style: GoogleFonts.poppins(fontSize: 7, color: Colors.orangeAccent))),
                    if (privacy.consent?.aiTutorConsent == true) Container(margin: const EdgeInsets.only(left: 4), padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1), decoration: BoxDecoration(color: AppColors.success.withOpacity(0.15), borderRadius: BorderRadius.circular(4)), child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.auto_awesome, size: 8, color: AppColors.success), const SizedBox(width: 2), Text("AI ON", style: GoogleFonts.poppins(fontSize: 7, color: AppColors.success))])),
                  ]),
                ]),
              ]),
              actions: [
                IconButton(icon: const Icon(Icons.auto_awesome, size: 18, color: AppColors.primaryGold), onPressed: () => Navigator.pushNamed(context, '/aiChat')),
                IconButton(icon: Icon(offline.isOnline ? Icons.wifi : Icons.wifi_off, size: 18, color: offline.isOnline ? AppColors.success : Colors.orangeAccent), onPressed: () => Navigator.pushNamed(context, '/offlineMode')),
                PopupMenuButton<String>(icon: const Icon(Icons.more_vert, color: AppColors.primaryWhite), color: AppColors.cardBlack, onSelected: (v) {
                  switch (v) {
                    case 'ministry': Navigator.pushNamed(context, '/ministryPortal'); break;
                    case 'national': Navigator.pushNamed(context, '/nationalDashboard'); break;
                    case 'parent': Navigator.pushNamed(context, '/parentPortal'); break;
                    case 'parentEngage': Navigator.pushNamed(context, '/parentEngagement'); break;
                    case 'teacherPD': Navigator.pushNamed(context, '/teacherPD'); break;
                    case 'cms': Navigator.pushNamed(context, '/cmsDashboard'); break;
                    case 'partnerships': Navigator.pushNamed(context, '/partnershipsPortal'); break;
                    case 'scholarship': Navigator.pushNamed(context, '/scholarshipCenter'); break;
                    case 'marketplace': Navigator.pushNamed(context, '/marketplace'); break;
                    case 'research': Navigator.pushNamed(context, '/researchDashboard'); break;
                    case 'mfa': Navigator.pushNamed(context, '/mfaSetup'); break;
                    case 'creative': Navigator.pushNamed(context, '/creativeSubjects'); break;
                    case 'schoolMgmt': Navigator.pushNamed(context, '/schoolManagement'); break;
                    case 'aiTutor': Navigator.pushNamed(context, '/aiTutor'); break;
                    case 'certGallery': Navigator.pushNamed(context, '/certificateGallery'); break;
                    case 'resource': Navigator.pushNamed(context, '/resourceLibrary'); break;
                    case 'community': Navigator.pushNamed(context, '/community'); break;
                    case 'access': Navigator.pushNamed(context, '/accessibilitySettings'); break;
                    case 'security': Navigator.pushNamed(context, '/securityDashboard'); break;
                    case 'profile': Navigator.pushNamed(context, '/studentProfile'); break;
                    case 'admin': Navigator.pushNamed(context, '/adminDashboard'); break;
                    case 'privacy': Navigator.pushNamed(context, '/privacySettings'); break;
                    case 'logout': { Provider.of<AuthService>(context, listen: false).logout(); Navigator.pushReplacementNamed(context, '/login'); }
                  }
                }, itemBuilder: (c) => [
                  const PopupMenuItem(value: 'ministry', child: Text("Ministry of Education Portal - NEW")),
                  const PopupMenuItem(value: 'national', child: Text("National Education Dashboard")),
                  const PopupMenuItem(value: 'parent', child: Text("Parent Portal")),
                  const PopupMenuItem(value: 'parentEngage', child: Text("Parent Engagement Tools - NEW Phase6")),
                  const PopupMenuItem(value: 'schoolMgmt', child: Text("School Management Portal")),
                  const PopupMenuDivider(),
                  const PopupMenuItem(value: 'teacherPD', child: Text("Teacher Professional Development Center - NEW")),
                  const PopupMenuItem(value: 'cms', child: Text("CMS - Lesson Publishing - NEW")),
                  const PopupMenuItem(value: 'partnerships', child: Text("Partnerships Portal for Sponsors - NEW")),
                  const PopupMenuItem(value: 'scholarship', child: Text("Scholarship & Opportunity Center - NEW")),
                  const PopupMenuItem(value: 'marketplace', child: Text("Digital Marketplace Groundwork - NEW")),
                  const PopupMenuDivider(),
                  const PopupMenuItem(value: 'research', child: Text("Research Analytics - NEW")),
                  const PopupMenuItem(value: 'mfa', child: Text("MFA - Stronger Security - NEW")),
                  const PopupMenuItem(value: 'creative', child: Text("Creative Subjects Expansion - NEW")),
                  const PopupMenuItem(value: 'aiTutor', child: Text("AI Tutor Chat")),
                  const PopupMenuItem(value: 'certGallery', child: Text("Certificate Vault + QR Verify")),
                  const PopupMenuItem(value: 'resource', child: Text("Resource Library")),
                  const PopupMenuItem(value: 'community', child: Text("Community")),
                  const PopupMenuItem(value: 'access', child: Text("Accessibility Options")),
                  const PopupMenuItem(value: 'security', child: Text("Security & Privacy Center")),
                  const PopupMenuItem(value: 'privacy', child: Text("Privacy & AI Safeguards")),
                  const PopupMenuItem(value: 'profile', child: Text("My Profile")),
                  const PopupMenuItem(value: 'admin', child: Text("Admin Dashboard")),
                  const PopupMenuItem(value: 'logout', child: Text("Logout")),
                ]),
                const SizedBox(width: 4),
              ],
            ),
            SliverToBoxAdapter(child: const OfflineBanner()),
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  WelcomeHeader(userName: user?.displayName ?? "Artist", overallProgress: user?.overallProgress ?? 0.0),
                  const SizedBox(height: 12),
                  // Phase 5-6 Welcome Message Section - Ministry + Donlee Founder - NEW per user request
                  const WelcomeMessageHomeSection(),
                  const SizedBox(height: 8),
                  WelcomeMessageWidget(message: WelcomeMessage.ministryWelcome()),
                  const SizedBox(height: 14),
                  // Phase 6 Quick Access - 5 rows
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.primaryGold.withOpacity(0.2))),
                    child: Column(children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                        _quickAccess(Icons.account_balance, "Ministry Portal", const Color(0xFF0A3D62), () => Navigator.pushNamed(context, '/ministryPortal')),
                        _quickAccess(Icons.public, "National Dash", Colors.blueAccent, () => Navigator.pushNamed(context, '/nationalDashboard')),
                        _quickAccess(Icons.family_restroom, "Parent Portal", Colors.orangeAccent, () => Navigator.pushNamed(context, '/parentPortal')),
                        _quickAccess(Icons.family_restroom_outlined, "Parent Engage", Colors.orangeAccent, () => Navigator.pushNamed(context, '/parentEngagement')),
                      ]),
                      const SizedBox(height: 12),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                        _quickAccess(Icons.school, "Teacher PD Center", Colors.blueAccent, () => Navigator.pushNamed(context, '/teacherPD')),
                        _quickAccess(Icons.edit_note, "CMS Publish", AppColors.primaryGold, () => Navigator.pushNamed(context, '/cmsDashboard')),
                        _quickAccess(Icons.handshake, "Partnerships", Colors.green, () => Navigator.pushNamed(context, '/partnershipsPortal')),
                        _quickAccess(Icons.school_outlined, "Scholarships", Colors.purpleAccent, () => Navigator.pushNamed(context, '/scholarshipCenter')),
                      ]),
                      const SizedBox(height: 12),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                        _quickAccess(Icons.store, "Marketplace", Colors.orangeAccent, () => Navigator.pushNamed(context, '/marketplace')),
                        _quickAccess(Icons.biotech, "Research Analytics", Colors.purpleAccent, () => Navigator.pushNamed(context, '/researchDashboard')),
                        _quickAccess(Icons.security, "MFA Security", AppColors.success, () => Navigator.pushNamed(context, '/mfaSetup')),
                        _quickAccess(Icons.palette, "Creative Expand", Colors.pinkAccent, () => Navigator.pushNamed(context, '/creativeSubjects')),
                      ]),
                      const SizedBox(height: 12),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                        _quickAccess(Icons.auto_awesome, "AI Tutor", AppColors.primaryGold, () => Navigator.pushNamed(context, '/aiChat')),
                        _quickAccess(Icons.workspace_premium, "Certificate Vault", AppColors.primaryGold, () => Navigator.pushNamed(context, '/certificateGallery')),
                        _quickAccess(Icons.library_books, "Resource Lib", Colors.purpleAccent, () => Navigator.pushNamed(context, '/resourceLibrary')),
                        _quickAccess(Icons.forum, "Community", Colors.orangeAccent, () => Navigator.pushNamed(context, '/community')),
                      ]),
                    ]),
                  ),
                  const SizedBox(height: 16),
                  // National Banner
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF0A3D62), Color(0xFF079992)]), borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.blueAccent.withOpacity(0.2), blurRadius: 12)]),
                    child: Row(children: [
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)), child: Text("MINISTRY INTEGRATED • V6", style: GoogleFonts.poppins(fontSize: 8, fontWeight: FontWeight.bold, color: const Color(0xFF0A3D62)))),
                          const SizedBox(width: 6),
                          Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppColors.success, borderRadius: BorderRadius.circular(8)), child: Text("NEW PHASE 6", style: GoogleFonts.poppins(fontSize: 7, fontWeight: FontWeight.bold, color: Colors.white))),
                        ]),
                        const SizedBox(height: 8),
                        Text("Ministry of Education Portal + National Ecosystem", style: GoogleFonts.playfairDisplay(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                        Text("1,247 schools • 45k students • Parent Engagement • Teacher PD Center • CMS Lesson Publishing • Partnerships Portal • Scholarship Center • Marketplace Groundwork • Research Analytics • MFA Security • Accessibility • Creative Expansion to Music/Dance/Drama", style: GoogleFonts.poppins(fontSize: 9, color: Colors.white.withOpacity(0.9))),
                        const SizedBox(height: 12),
                        Row(children: [
                          ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFF0A3D62), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)), onPressed: () => Navigator.pushNamed(context, '/ministryPortal'), child: const Text("MINISTRY PORTAL", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold))),
                          const SizedBox(width: 6),
                          OutlinedButton(style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)), onPressed: () => Navigator.pushNamed(context, '/parentEngagement'), child: const Text("PARENT ENGAGEMENT", style: TextStyle(fontSize: 9))),
                        ]),
                      ])),
                      const SizedBox(width: 12),
                      const Icon(Icons.account_balance, size: 40, color: Colors.white),
                    ]),
                  ),
                  const SizedBox(height: 16),
                  QuickStatsWidget(lessonsCompleted: user?.totalLessonsCompleted ?? 0, artworks: user?.totalArtworksUploaded ?? 0),
                  const SizedBox(height: 16),
                  if (featured != null) ...[
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text("Featured + AI + National + Ministry", style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
                      Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: AppColors.primaryGold.withOpacity(0.15), borderRadius: BorderRadius.circular(12)), child: Text("V6 PHASE 6 NEW", style: GoogleFonts.poppins(fontSize: 8, color: AppColors.primaryGold, fontWeight: FontWeight.bold))),
                    ]),
                    const SizedBox(height: 12),
                    FeaturedLessonCard(lesson: featured, onTap: () => Navigator.pushNamed(context, '/lessonDetail', arguments: featured)),
                    const SizedBox(height: 16),
                  ],
                  ProgressTracker(moduleProgress: user?.moduleProgress ?? {}, modules: modules),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.primaryBlackLighter)),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [const Icon(Icons.auto_awesome, size: 14, color: AppColors.primaryGold), const SizedBox(width: 6), Text("Phase 6 - Parent Engagement + Teacher PD + CMS + Partnerships + Scholarship + Marketplace + Research + MFA + Creative Expansion", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 10, color: AppColors.primaryWhite))]),
                      const SizedBox(height: 8),
                      Text("• Parent Engagement: Family challenges Ministry theme Unity in Diversity, meeting scheduler AI review + exhibition visit, volunteer opportunities, parent learning resources\n• Teacher PD Center: CPD tracking bronze/silver/gold/master, courses Loomis teaching + AI tools + offline teaching + inclusive ed, mentorship Prof Nike Davies, resource sharing\n• CMS: Draft → Review → Approved → Published, versioning, asset management, approval workflow, scheduling, low-BW optimized, national competition lessons\n• Partnerships Portal: Sponsor profiles MTN Foundation title 5M NGN Nike Art Gallery gold exhibition, sponsorship packages, impact metrics students reached 45k schools 1247 artworks 12k offline kits 2340 scholarships 50 brand visibility 8.9, CSR reporting\n• Scholarship Center: Application eligibility checker doc upload recommendation letters disbursement status tracking, Top 3 + exhibition selected auto-eligible\n• Marketplace Groundwork: Student artworks national winner 150k NGN 50% charity + teacher resources Loomis worksheets 50 pages 5k NGN + commissions future Flutterwave/Paystack\n• Research Analytics: anonymized data no PII, ethics approval, studies offline-first North-East 68% + AI feedback +12% score, datasets fields no PII, future microservice\n• MFA: TOTP authenticator app + SMS OTP + Email OTP + Biometric FaceID/TouchID + Recovery Codes 8 + Trusted Devices device management + security questions + low-BW SMS offline queue\n• Accessibility Updates: text scale normal/large/extra large factor 1.0/1.15/1.3, high contrast, dyslexia font, color blind protanopia/deuteranopia/tritanopia, screen reader TalkBack, voice nav, reduce motion, subtitles, keyboard nav, preview scaled, 12% usage target 20%\n• Creative Expansion: Visual Art enabled 10 modules + Music Dance Drama Creative Writing Photography Film coming soon modular feature flagged", style: GoogleFonts.poppins(fontSize: 9, color: AppColors.mediumGrey, height: 1.4)),
                    ]),
                  ),
                  const SizedBox(height: 100),
                ]),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentNav,
        onTap: (i) {
          setState(() => _currentNav = i);
          switch (i) {
            case 0: break;
            case 1: Navigator.pushNamed(context, '/modules'); break;
            case 2: Navigator.pushNamed(context, '/ministryPortal'); break;
            case 3: Navigator.pushNamed(context, '/community'); break;
            case 4: Navigator.pushNamed(context, '/resourceLibrary'); break;
          }
        },
      ),
    );
  }

  Widget _quickAccess(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(onTap: onTap, child: Column(children: [
      Container(width: 42, height: 42, decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.2))), child: Icon(icon, color: color, size: 18)),
      const SizedBox(height: 6),
      Text(label, style: GoogleFonts.poppins(fontSize: 7, color: AppColors.primaryWhite), textAlign: TextAlign.center),
    ]));
  }
}
