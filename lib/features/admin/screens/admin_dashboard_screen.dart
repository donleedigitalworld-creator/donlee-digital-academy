import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../services/school_service.dart';
import '../../../core/offline/offline_banner.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final schools = SchoolService().getMockSchools();

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: const CustomAppBar(title: "Admin Dashboard v3", subtitle: "Users, schools, courses, competitions, offline analytics"),
      body: Column(children: [
        const OfflineBanner(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Top Stats - Phase 3 expanded
              GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.7, children: [
                _adminStat("Total Students", "1,247", Icons.people, AppColors.primaryGold, "+12% this month"),
                _adminStat("Active Teachers", "34", Icons.school, AppColors.success, "3 pending verification"),
                _adminStat("Schools", "${schools.length}", Icons.business, Colors.blueAccent, "${schools.fold(0, (p, s) => p + s.totalStudents)} total students"),
                _adminStat("Competition Entries", "529", Icons.emoji_events, Colors.purpleAccent, "342 registrations\n187 submissions"),
                _adminStat("Offline Queue", "23", Icons.wifi_off, Colors.orangeAccent, "18 pending sync\nLow-bandwidth 73%"),
                _adminStat("Exhibition Selected", "12", Icons.museum, AppColors.primaryGold, "Top 10 + 2 special\nScholarship eligible 5"),
              ]),
              const SizedBox(height: 24),
              Text("Management - Phase 3 National Competitions", style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
              const SizedBox(height: 12),
              GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 2.2, children: [
                _managementCard(Icons.group, "User Management", "Students, teachers, roles, secure photo storage", AppColors.primaryGold, () => Navigator.pushNamed(context, '/userManagement')),
                _managementCard(Icons.menu_book, "Course Management", "10 modules + offline lessons & quizzes", AppColors.success, () => Navigator.pushNamed(context, '/courseManagement')),
                _managementCard(Icons.emoji_events, "National Competitions", "Create competition, categories, judging criteria, prizes, offline + low-BW", Colors.purpleAccent, () => Navigator.pushNamed(context, '/competitions')),
                _managementCard(Icons.gavel, "Judging Dashboard", "Secure blind review, chief judge, weighted scoring", Colors.orangeAccent, () => Navigator.pushNamed(context, '/judgingDashboard', arguments: null)),
                _managementCard(Icons.leaderboard, "Results & Rankings", "Rankings, podium, certificates, exhibition flag", AppColors.primaryGold, () => Navigator.pushNamed(context, '/competitionResults', arguments: null)),
                _managementCard(Icons.museum, "Exhibition & Scholarships", "Nike Art Gallery, scholarship portal linkage, future-ready", Colors.blueAccent, () => Navigator.pushNamed(context, '/exhibitionScholarship')),
                _managementCard(Icons.business, "School Management", "Schools, classes, competition analytics, offline attention", Colors.blueAccent, () => Navigator.pushNamed(context, '/schoolDashboard')),
                _managementCard(Icons.analytics, "Analytics v3", "Competition, offline queue, low-bandwidth, teacher scoring", Colors.orangeAccent, () => Navigator.pushNamed(context, '/analytics')),
                _managementCard(Icons.wifi_off, "Offline Sync Monitor", "Smart sync, no duplicate, Hive + SharedPrefs queue", Colors.orangeAccent, () => Navigator.pushNamed(context, '/offlineMode')),
                _managementCard(Icons.security, "Security & Judging Roles", "Judge, ChiefJudge, Moderator, Admin - secure scoring", AppColors.mediumGrey, () {}),
              ]),
              const SizedBox(height: 24),
              Text("Schools Overview - Competition Engaged", style: GoogleFonts.playfairDisplay(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
              const SizedBox(height: 12),
              ...schools.map((school) => Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.primaryBlackLighter)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(width: 48, height: 48, decoration: BoxDecoration(color: AppColors.primaryGold.withOpacity(0.15), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.school, color: AppColors.primaryGold)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(school.name, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primaryWhite)),
                    Text("${school.city} • ${school.totalStudents} students • ${school.teacherIds.length} teachers • Competition: 24 regs, 18 subs", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)),
                    const SizedBox(height: 6),
                    ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: 0.75, backgroundColor: AppColors.primaryBlackLighter, color: AppColors.primaryGold, minHeight: 4)),
                  ])),
                  IconButton(icon: const Icon(Icons.more_vert, color: AppColors.mediumGrey, size: 18), onPressed: () {}),
                ]),
                const SizedBox(height: 8),
                Row(children: [
                  _smallBadge(Icons.emoji_events, "3 winners", AppColors.primaryGold),
                  const SizedBox(width: 6),
                  _smallBadge(Icons.wifi_off, "5 offline pending", Colors.orangeAccent),
                  const SizedBox(width: 6),
                  _smallBadge(Icons.museum, "2 exhibition", Colors.blueAccent),
                ]),
              ]))),
              const SizedBox(height: 24),
              Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.primaryGold.withOpacity(0.15), Colors.transparent]), borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.primaryGold.withOpacity(0.2))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [const Icon(Icons.lightbulb, color: AppColors.primaryGold, size: 18), const SizedBox(width: 8), Text("Phase 3 Complete - National Competition + Offline-first", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primaryWhite))]),
                const SizedBox(height: 8),
                Text("Implemented: National competition creation, registration, artwork submission with camera/gallery + offline queue + smart sync + low-bandwidth mode, judging dashboards with 5 weighted criteria & secure blind roles (judge, chiefJudge, moderator, admin), results with podium rankings + digital certificates, student gallery, school dashboard with offline attention, admin dashboard with competition analytics, notifications, secure storage. Future-ready: exhibitionStatus enum (pending/selected/exhibited/awarded) for Nike Art Gallery, scholarshipEligible flag linked to scholarship portal. Offline learning: lessons & quizzes downloadable, queue progress & quiz results, teacher scoring also offline-capable.", style: GoogleFonts.poppins(fontSize: 11, color: AppColors.mediumGrey, height: 1.5)),
              ])),
              const SizedBox(height: 100),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _adminStat(String label, String value, IconData icon, Color color, String sub) {
    return Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(16), border: Border.all(color: color.withOpacity(0.2))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Container(width: 32, height: 32, decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: color, size: 16)), Text(value, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryWhite))]),
      const SizedBox(height: 8),
      Text(label, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primaryWhite)),
      Text(sub, style: GoogleFonts.poppins(fontSize: 8, color: AppColors.mediumGrey), maxLines: 2),
    ]));
  }

  Widget _managementCard(IconData icon, String title, String desc, Color color, VoidCallback onTap) {
    return GestureDetector(onTap: onTap, child: Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(14), border: Border.all(color: color.withOpacity(0.2))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(width: 36, height: 36, decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: color, size: 18)),
      const SizedBox(height: 10),
      Text(title, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
      const SizedBox(height: 4),
      Text(desc, style: GoogleFonts.poppins(fontSize: 8, color: AppColors.mediumGrey), maxLines: 3, overflow: TextOverflow.ellipsis),
    ])));
  }

  Widget _smallBadge(IconData icon, String label, Color color) {
    return Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3), decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(6)), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 10, color: color), const SizedBox(width: 3), Text(label, style: GoogleFonts.poppins(fontSize: 8, color: color))]));
  }
}

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final users = [
      {'name': 'Amara Okafor', 'role': 'student', 'email': 'amara@example.com', 'progress': '82% • 3 competitions • 1 win', 'photo': true},
      {'name': 'Ms. Amara Teacher', 'role': 'teacher', 'email': 'teacher@donlee.art', 'progress': '34 students • Judge role', 'photo': true},
      {'name': 'Judge Prof. Nike', 'role': 'judge', 'email': 'judge@nikeart.com', 'progress': 'Chief Judge • 5 competitions', 'photo': true},
      {'name': 'Admin Donlee', 'role': 'admin', 'email': 'admin@donlee.art', 'progress': 'Owner • National organizer', 'photo': false},
    ];

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: const CustomAppBar(title: "User Management v3", subtitle: "Students, teachers, judges, admins - secure + competition roles", showBack: true),
      body: ListView.separated(padding: const EdgeInsets.all(16), itemCount: users.length, separatorBuilder: (_, __) => const SizedBox(height: 10), itemBuilder: (c, i) {
        final u = users[i];
        return Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(14)), child: Row(children: [
          Stack(children: [
            CircleAvatar(radius: 22, backgroundColor: AppColors.primaryGold.withOpacity(0.15), child: Text((u['name'] as String).split(' ').map((e) => e[0]).take(2).join(), style: const TextStyle(color: AppColors.primaryGold, fontSize: 12))),
            if (u['photo'] as bool) Positioned(bottom: 0, right: 0, child: Container(width: 12, height: 12, decoration: BoxDecoration(color: AppColors.success, shape: BoxShape.circle, border: Border.all(color: AppColors.cardBlack, width: 2)))),
          ]),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [Text(u['name'] as String, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primaryWhite)), const SizedBox(width: 6), Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: (u['role'] == 'teacher' ? AppColors.success : u['role'] == 'admin' ? AppColors.error : u['role'] == 'judge' ? Colors.purpleAccent : AppColors.primaryGold).withOpacity(0.15), borderRadius: BorderRadius.circular(6)), child: Text((u['role'] as String).toUpperCase(), style: GoogleFonts.poppins(fontSize: 8, fontWeight: FontWeight.bold, color: u['role'] == 'teacher' ? AppColors.success : u['role'] == 'admin' ? AppColors.error : u['role'] == 'judge' ? Colors.purpleAccent : AppColors.primaryGold)))]),
            Text(u['email'] as String, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)),
            Text(u['progress'] as String, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.primaryGold)),
          ])),
          IconButton(icon: const Icon(Icons.more_horiz, color: AppColors.mediumGrey, size: 18), onPressed: () {}),
        ]));
      }),
    );
  }
}

class CourseManagementScreen extends StatelessWidget {
  const CourseManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: const CustomAppBar(title: "Course Management v3", subtitle: "10 modules + assignments + competitions + offline", showBack: true),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        ...[
          {'title': 'Introduction to Fine Art', 'lessons': 3, 'students': 342, 'status': 'Published • Offline DL OK'},
          {'title': 'Elements of Art', 'lessons': 4, 'students': 298, 'status': 'Published • Low-BW Ready'},
          {'title': 'National Competition Module', 'lessons': 2, 'students': 529, 'status': 'Featured • Exhibition Linked'},
        ].map((course) => Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(14)), child: Row(children: [
          Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.primaryGold.withOpacity(0.15), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.menu_book, color: AppColors.primaryGold, size: 20)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(course['title'] as String, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primaryWhite)),
            Text("${course['lessons']} lessons • ${course['students']} enrolled • ${course['status']}", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)),
          ])),
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: AppColors.success.withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: Text("Published", style: const TextStyle(color: AppColors.success, fontSize: 10))),
        ]))),
      ]),
    );
  }
}

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: const CustomAppBar(title: "Analytics v3", subtitle: "Competition, offline, low-BW, teacher scoring, exhibition", showBack: true),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        Row(children: [Expanded(child: _metric("Competition Entries", "529", "342 regs, 187 subs\n5 offline queue", AppColors.primaryGold)), const SizedBox(width: 12), Expanded(child: _metric("Camera Verified", "73%", "27% gallery\nLow-BW 60% saved", AppColors.success))]),
        const SizedBox(height: 12),
        Row(children: [Expanded(child: _metric("Avg Judge Score", "84/100", "3 judges + chief\nBlind, secure", Colors.blueAccent)), const SizedBox(width: 12), Expanded(child: _metric("Exhibition Selected", "12 works", "Top 10 + 2 special\n5 scholarship eligible", Colors.purpleAccent))]),
        const SizedBox(height: 12),
        Row(children: [Expanded(child: _metric("Offline Queue", "23 pending", "Smart sync\nNo duplicate", Colors.orangeAccent)), const SizedBox(width: 12), Expanded(child: _metric("Low-BW Users", "41%", "Rural areas\nData saver ON", Colors.orangeAccent))]),
        const SizedBox(height: 24),
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(16)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Competition Drop-off & Conversion", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
          const SizedBox(height: 12),
          ...[
            {'name': 'Viewed Competition', 'rate': 1.0, 'count': '1,247'},
            {'name': 'Registered', 'rate': 0.42, 'count': '529 submitted? Wait 342'},
            {'name': 'Submitted Artwork (incl offline queued)', 'rate': 0.35, 'count': '187 + 23 offline'},
            {'name': 'Judged', 'rate': 0.32, 'count': '187 judged'},
            {'name': 'Exhibition Selected', 'rate': 0.02, 'count': '12 selected'},
          ].map((m) => Padding(padding: const EdgeInsets.only(bottom: 10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(m['name'] as String, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.primaryWhite)), Text("${m['count'] as String}", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey))]), const SizedBox(height: 4), ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: m['rate'] as double, backgroundColor: AppColors.primaryBlackLighter, color: (m['rate'] as double) < 0.3 ? AppColors.error : AppColors.primaryGold, minHeight: 6))]))),
        ])),
      ]),
    );
  }

  Widget _metric(String label, String value, String sub, Color color) {
    return Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(14), border: Border.all(color: color.withOpacity(0.2))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)), const SizedBox(height: 6), Text(value, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)), Text(sub, style: GoogleFonts.poppins(fontSize: 8, color: color)),]));
  }
}
