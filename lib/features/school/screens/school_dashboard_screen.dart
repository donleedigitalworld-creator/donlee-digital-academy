import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../models/competition_model.dart';
import '../../../services/competition_service.dart';
import '../../../core/offline/offline_banner.dart';

class SchoolDashboardScreen extends StatelessWidget {
  const SchoolDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final competitions = CompetitionService().getMockCompetitions();
    final mockSchoolStats = {
      'students': 127,
      'competitionRegistrations': 34,
      'submissions': 28,
      'offlinePending': 5,
      'winners': 3,
      'exhibitionSelected': 2,
    };

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: const CustomAppBar(title: "School Dashboard", subtitle: "Donlee Main - Lagos • Competition + Offline Analytics"),
      body: Column(children: [
        const OfflineBanner(),
        Expanded(
          child: ListView(padding: const EdgeInsets.all(16), children: [
            // Stats grid
            GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.4, children: [
              _stat("Students", "${mockSchoolStats['students']}", Icons.people, AppColors.primaryGold),
              _stat("Competing", "${mockSchoolStats['competitionRegistrations']}", Icons.emoji_events, Colors.purpleAccent),
              _stat("Submissions", "${mockSchoolStats['submissions']}", Icons.cloud_upload, AppColors.success),
              _stat("Offline Queue", "${mockSchoolStats['offlinePending']}", Icons.wifi_off, Colors.orangeAccent),
              _stat("Winners", "${mockSchoolStats['winners']}", Icons.military_tech, AppColors.primaryGold),
              _stat("Exhibition", "${mockSchoolStats['exhibitionSelected']}", Icons.museum, Colors.blueAccent),
            ]),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text("National Competitions", style: GoogleFonts.playfairDisplay(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
              TextButton(onPressed: () => Navigator.pushNamed(context, '/competitions'), child: Text("View All", style: GoogleFonts.poppins(color: AppColors.primaryGold, fontSize: 12))),
            ]),
            ...competitions.take(2).map((comp) => Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.primaryBlackLighter)), child: Row(children: [
              Container(width: 50, height: 50, decoration: BoxDecoration(color: AppColors.primaryGold.withOpacity(0.15), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.emoji_events, color: AppColors.primaryGold)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(comp.title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primaryWhite), maxLines: 1),
                Text(comp.theme, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.primaryGold, fontStyle: FontStyle.italic), maxLines: 1),
                Text("${comp.totalRegistrations} registered • ${comp.totalSubmissions} submissions • Offline OK", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)),
              ])),
              IconButton(icon: const Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.mediumGrey), onPressed: () => Navigator.pushNamed(context, '/competitionDetail', arguments: comp)),
            ]))),
            const SizedBox(height: 20),
            Text("Students Needing Attention - Offline Areas", style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
            const SizedBox(height: 12),
            ...[
              {'name': 'Zainab Musa', 'issue': '5 offline submissions pending sync - low connectivity area', 'class': 'JSS2 Art Club', 'severity': 'high'},
              {'name': 'David Lee', 'issue': 'Low-bandwidth mode ON - 2 submissions compressed', 'class': 'Portrait Mastery', 'severity': 'low'},
            ].map((s) => Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(12), border: Border.all(color: s['severity'] == 'high' ? Colors.orangeAccent.withOpacity(0.3) : AppColors.primaryBlackLighter)), child: Row(children: [
              CircleAvatar(radius: 18, backgroundColor: AppColors.primaryGold.withOpacity(0.15), child: Text((s['name'] as String).split(' ').map((e) => e[0]).join(), style: const TextStyle(fontSize: 10, color: AppColors.primaryGold))),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(s['name'] as String, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.primaryWhite)),
                Text(s['issue'] as String, style: GoogleFonts.poppins(fontSize: 10, color: s['severity'] == 'high' ? Colors.orangeAccent : AppColors.mediumGrey)),
                Text(s['class'] as String, style: GoogleFonts.poppins(fontSize: 9, color: AppColors.darkGrey)),
              ])),
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: s['severity'] == 'high' ? Colors.orangeAccent.withOpacity(0.15) : AppColors.success.withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: Text(s['severity'] == 'high' ? "Offline" : "Low-BW", style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.bold, color: s['severity'] == 'high' ? Colors.orangeAccent : AppColors.success))),
            ]))),
            const SizedBox(height: 20),
            Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.primaryBlackLight, borderRadius: BorderRadius.circular(12)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [const Icon(Icons.analytics, color: AppColors.primaryGold, size: 16), const SizedBox(width: 8), Text("School Analytics - Competition + Offline + Teacher Scoring", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primaryWhite))]),
              const SizedBox(height: 8),
              Text("• Competition: 34 registered, 28 submitted, 5 offline queued, 3 winners, 2 exhibition\n• Offline: 73% camera verified, 27% gallery, low-bandwidth saves 60% data\n• Teacher scoring: Avg 84/100, offline scoring queued & synced\n• Security: Role-based - school admin sees own students only, judges blind", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey, height: 1.5)),
            ])),
          ]),
        ),
      ]),
    );
  }

  Widget _stat(String label, String value, IconData icon, Color color) {
    return Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.2))), child: Column(children: [
      Icon(icon, color: color, size: 18),
      const SizedBox(height: 4),
      Text(value, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primaryWhite)),
      Text(label, style: GoogleFonts.poppins(fontSize: 8, color: AppColors.mediumGrey), textAlign: TextAlign.center),
    ]));
  }
}
