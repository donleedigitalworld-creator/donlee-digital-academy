import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../services/teacher_service.dart';
import '../../../services/auth_service.dart';
import '../../../models/school_model.dart';
import '../../../models/assignment_model.dart';
import '../../../widgets/custom_app_bar.dart';

class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({super.key});

  @override
  State<TeacherDashboardScreen> createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final teacherService = TeacherService();
    final teacherId = auth.currentFirebaseUser?.uid ?? 't1';
    final mockClasses = teacherService.getMockClasses(teacherId);

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: CustomAppBar(
        title: "Teacher Portal",
        subtitle: "Welcome, ${auth.currentUserModel?.displayName ?? 'Instructor'}",
        actions: [
          IconButton(icon: const Icon(Icons.notifications, color: AppColors.primaryGold), onPressed: () => Navigator.pushNamed(context, '/announcements')),
          IconButton(icon: const Icon(Icons.person, color: AppColors.primaryWhite), onPressed: () => Navigator.pushNamed(context, '/teacherProfile')),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Stats Row
          Row(children: [
            Expanded(child: _statCard("${mockClasses.fold(0, (p, c) => p + c.studentIds.length)}", "Students", Icons.groups, AppColors.primaryGold)),
            const SizedBox(width: 12),
            Expanded(child: _statCard("${mockClasses.length}", "Classes", Icons.class_, AppColors.success)),
            const SizedBox(width: 12),
            Expanded(child: _statCard("23", "Pending Reviews", Icons.rate_review, AppColors.error)),
          ]),
          const SizedBox(height: 20),
          // Quick Actions
          Text("Quick Actions", style: GoogleFonts.playfairDisplay(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.2,
            children: [
              _actionCard(Icons.add_box, "Create Assignment", "New task for class", AppColors.primaryGold, () => Navigator.pushNamed(context, '/createAssignment')),
              _actionCard(Icons.announcement, "Send Announcement", "Notify students", AppColors.success, () => Navigator.pushNamed(context, '/createAnnouncement')),
              _actionCard(Icons.assessment, "Track Progress", "View student analytics", Colors.blueAccent, () => Navigator.pushNamed(context, '/studentProgress')),
              _actionCard(Icons.school, "Manage Classes", "Add students, schedule", Colors.purpleAccent, () => Navigator.pushNamed(context, '/classManagement')),
            ],
          ),
          const SizedBox(height: 20),
          // Classes
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text("My Classes", style: GoogleFonts.playfairDisplay(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
            TextButton(onPressed: () => Navigator.pushNamed(context, '/classManagement'), child: Text("View All", style: GoogleFonts.poppins(color: AppColors.primaryGold, fontSize: 12))),
          ]),
          const SizedBox(height: 8),
          ...mockClasses.map((cls) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.primaryBlackLighter)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(child: Text(cls.name, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite))),
                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: cls.level == 'advanced' ? AppColors.error.withOpacity(0.15) : AppColors.success.withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: Text(cls.level.toUpperCase(), style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.bold, color: cls.level == 'advanced' ? AppColors.error : AppColors.success))),
              ]),
              const SizedBox(height: 6),
              Text(cls.description ?? '', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.mediumGrey), maxLines: 2),
              const SizedBox(height: 12),
              Row(children: [
                _smallInfo(Icons.people, "${cls.studentIds.length}/${cls.maxStudents}"),
                const SizedBox(width: 12),
                _smallInfo(Icons.schedule, cls.schedule ?? 'TBD'),
                const Spacer(),
                Container(width: 50, height: 6, decoration: BoxDecoration(color: AppColors.primaryBlackLighter, borderRadius: BorderRadius.circular(4)), child: FractionallySizedBox(alignment: Alignment.centerLeft, widthFactor: cls.occupancy, child: Container(decoration: BoxDecoration(color: AppColors.primaryGold, borderRadius: BorderRadius.circular(4))))),
              ]),
            ]),
          )),
          const SizedBox(height: 20),
          // Recent Submissions to Review - teacher camera review
          Text("Submissions to Review", style: GoogleFonts.playfairDisplay(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
          const SizedBox(height: 12),
          ...List.generate(3, (i) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(14)),
            child: ListTile(
              leading: CircleAvatar(backgroundColor: AppColors.primaryGold.withOpacity(0.2), child: Text(["AO", "TA", "CN"][i], style: GoogleFonts.poppins(fontSize: 10, color: AppColors.primaryGold))),
              title: Text(["Amara's Loomis Heads - Camera Upload", "Tunde's Value Sphere - Gallery Upload", "Chioma's Gesture Set"][i], style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryWhite)),
              subtitle: Text(["Submitted 2h ago • 5 photos (camera)", "Submitted 5h ago • 1 photo + notes", "Submitted 1d ago • Needs feedback"][i], style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)),
              trailing: ElevatedButton(style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), backgroundColor: AppColors.primaryGold, foregroundColor: AppColors.primaryBlack, minimumSize: Size.zero, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), onPressed: () => Navigator.pushNamed(context, '/submissionsReview'), child: const Text("REVIEW", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
            ),
          )),
          const SizedBox(height: 80),
        ]),
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: () => Navigator.pushNamed(context, '/createAssignment'), backgroundColor: AppColors.primaryGold, foregroundColor: AppColors.primaryBlack, icon: const Icon(Icons.add), label: const Text("New Assignment")),
    );
  }

  Widget _statCard(String value, String label, IconData icon, Color color) {
    return Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.primaryBlackLighter)), child: Column(children: [Icon(icon, color: color, size: 22), const SizedBox(height: 6), Text(value, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)), Text(label, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey), textAlign: TextAlign.center)]));
  }

  Widget _actionCard(IconData icon, String title, String subtitle, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(14), border: Border.all(color: color.withOpacity(0.2))), child: Row(children: [Container(width: 40, height: 40, decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: color, size: 20)), const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryWhite), maxLines: 1), Text(subtitle, style: GoogleFonts.poppins(fontSize: 9, color: AppColors.mediumGrey), maxLines: 1)]))])),
    );
  }

  Widget _smallInfo(IconData icon, String text) {
    return Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 12, color: AppColors.primaryGold), const SizedBox(width: 4), Text(text, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey))]);
  }
}
