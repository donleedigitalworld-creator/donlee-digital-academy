import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/custom_app_bar.dart';

class StudentProgressScreen extends StatelessWidget {
  const StudentProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final students = [
      {'name': 'Amara Okafor', 'photo': 'AO', 'progress': 0.82, 'completed': 18, 'avgScore': 88, 'streak': 12},
      {'name': 'Tunde Adebayo', 'photo': 'TA', 'progress': 0.65, 'completed': 14, 'avgScore': 76, 'streak': 5},
      {'name': 'Chioma Nwosu', 'photo': 'CN', 'progress': 0.45, 'completed': 9, 'avgScore': 92, 'streak': 8},
      {'name': 'David Lee', 'photo': 'DL', 'progress': 0.91, 'completed': 21, 'avgScore': 89, 'streak': 20},
      {'name': 'Zainab Musa', 'photo': 'ZM', 'progress': 0.30, 'completed': 6, 'avgScore': 70, 'streak': 2},
    ];

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: const CustomAppBar(title: "Student Progress Analytics", subtitle: "Track learning & engagement", showBack: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(gradient: AppColors.cardGradient, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.primaryGold.withOpacity(0.2))), child: Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Class Performance Overview", style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
              const SizedBox(height: 8),
              Text("Average progress 62% • 12 active • 2 need attention (below 40%)", style: GoogleFonts.poppins(fontSize: 11, color: AppColors.mediumGrey)),
              const SizedBox(height: 12),
              ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: 0.62, backgroundColor: AppColors.primaryBlackLighter, color: AppColors.primaryGold, minHeight: 6)),
            ])),
            const SizedBox(width: 16),
            Container(width: 60, height: 60, decoration: BoxDecoration(color: AppColors.primaryGold.withOpacity(0.15), shape: BoxShape.circle), child: Center(child: Text("62%", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.primaryGold)))),
          ])),
          const SizedBox(height: 20),
          ...students.map((s) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(14), border: Border.all(color: (s['progress'] as double) < 0.4 ? AppColors.error.withOpacity(0.3) : Colors.transparent)),
            child: Column(children: [
              Row(children: [
                CircleAvatar(radius: 22, backgroundColor: AppColors.primaryGold.withOpacity(0.15), child: Text(s['photo'] as String, style: const TextStyle(color: AppColors.primaryGold, fontWeight: FontWeight.bold, fontSize: 12))),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(s['name'] as String, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
                  Text("${s['completed']} lessons • Avg ${s['avgScore']}% • 🔥 ${s['streak']} day streak", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)),
                  const SizedBox(height: 6),
                  ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: s['progress'] as double, backgroundColor: AppColors.primaryBlackLighter, color: (s['progress'] as double) < 0.4 ? AppColors.error : AppColors.primaryGold, minHeight: 4)),
                ])),
                const SizedBox(width: 8),
                Column(children: [Text("${((s['progress'] as double)*100).toInt()}%", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.primaryWhite, fontSize: 12)), if ((s['progress'] as double) < 0.4) Container(margin: const EdgeInsets.only(top: 4), padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppColors.error.withOpacity(0.15), borderRadius: BorderRadius.circular(6)), child: Text("Needs Help", style: GoogleFonts.poppins(fontSize: 8, color: AppColors.error)))]),
              ]),
              const SizedBox(height: 10),
              Row(children: [
                _miniStat(Icons.camera_alt, "12 uploads", AppColors.primaryGold),
                const SizedBox(width: 12),
                _miniStat(Icons.score, "${s['avgScore']}% avg", AppColors.success),
                const SizedBox(width: 12),
                _miniStat(Icons.timer, "15h learned", AppColors.mediumGrey),
                const Spacer(),
                GestureDetector(onTap: () {}, child: Text("View Detail →", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.primaryGold, fontWeight: FontWeight.bold))),
              ]),
            ]),
          )),
        ],
      ),
    );
  }

  Widget _miniStat(IconData icon, String label, Color color) {
    return Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 10, color: color), const SizedBox(width: 3), Text(label, style: GoogleFonts.poppins(fontSize: 9, color: AppColors.mediumGrey))]);
  }
}
