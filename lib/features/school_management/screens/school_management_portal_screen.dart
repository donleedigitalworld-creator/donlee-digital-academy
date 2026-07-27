import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/custom_app_bar.dart';

class SchoolManagementPortalScreen extends StatelessWidget {
  const SchoolManagementPortalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: const CustomAppBar(title: "School Management Portal", subtitle: "Roster, attendance, timetable, staff, fees, resources, analytics - Phase 5"),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.8, children: [
          _card(Icons.people, "Student Roster", "127 students • 6 classes • Parent linked 92%", AppColors.primaryGold, context, '/parentPortal'),
          _card(Icons.person, "Staff Management", "12 teachers • 3 pending verification • Judge roles", Colors.blueAccent, context, '/teacherDashboard'),
          _card(Icons.calendar_month, "Timetable & Attendance", "Avg attendance 89% • Low-BW mode", AppColors.success, context, ''),
          _card(Icons.assignment, "Fee Management", "Future: fees, scholarships, grants", Colors.orangeAccent, context, ''),
          _card(Icons.library_books, "Resource Allocation", "34 offline kits • Power/internet tracking", Colors.purpleAccent, context, '/resourceLibrary'),
          _card(Icons.analytics, "School Analytics", "Completion 74% • Competition 3 winners • Offline 5 pending", AppColors.primaryGold, context, '/advancedAnalytics'),
        ]),
        const SizedBox(height: 20),
        Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(12)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Infrastructure Tracking - Low-Connectivity Ready", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primaryWhite)),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Power: 60% Stable", style: GoogleFonts.poppins(fontSize: 11, color: AppColors.mediumGrey)), ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: 0.6, backgroundColor: AppColors.primaryBlackLighter, color: AppColors.primaryGold, minHeight: 4))])),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Internet: Medium (3G)", style: GoogleFonts.poppins(fontSize: 11, color: AppColors.mediumGrey)), ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: 0.5, backgroundColor: AppColors.primaryBlackLighter, color: Colors.orangeAccent, minHeight: 4))])),
          ]),
          const SizedBox(height: 8),
          Text("Future: Resource Allocation - offline kits for low-connectivity, teacher training for AI tools, exhibition transport for top 10", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.darkGrey)),
        ])),
      ]),
    );
  }

  Widget _card(IconData icon, String title, String desc, Color color, BuildContext context, String route) {
    return GestureDetector(onTap: () => route.isNotEmpty ? Navigator.pushNamed(context, route) : null, child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.2))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(width: 36, height: 36, decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(10)), child: Icon(icon, size: 18, color: color)),
      const SizedBox(height: 10),
      Text(title, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
      Text(desc, style: GoogleFonts.poppins(fontSize: 9, color: AppColors.mediumGrey), maxLines: 3),
    ])));
  }
}
