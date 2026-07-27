import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../lessons/data/lessons_data.dart';

class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final exercises = [
      {"title": "Blind Contour", "desc": "Draw without looking at paper - trains hand-eye", "time": "5 min", "icon": Icons.visibility_off},
      {"title": "Gesture Drawing", "desc": "30-second poses to capture movement & energy", "time": "10 min", "icon": Icons.sports_gymnastics},
      {"title": "Value Study", "desc": "Render sphere with 5 values - light to shadow", "time": "15 min", "icon": Icons.contrast},
      {"title": "Non-dominant Hand", "desc": "Draw with opposite hand - breaks perfectionism", "time": "7 min", "icon": Icons.back_hand},
      {"title": "Upside Down Drawing", "desc": "Copy reference upside down - see shapes not symbols", "time": "20 min", "icon": Icons.flip},
      {"title": "Negative Space", "desc": "Draw spaces BETWEEN objects, not objects themselves", "time": "12 min", "icon": Icons.space_bar},
    ];

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: const CustomAppBar(title: "Practice Studio", subtitle: "Daily exercises to level up"),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(gradient: AppColors.cardGradient, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.primaryGold.withOpacity(0.2))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(width: 48, height: 48, decoration: BoxDecoration(gradient: AppColors.goldGradient, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.timer, color: AppColors.primaryBlack)),
                const SizedBox(width: 12),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("Today's Focus", style: GoogleFonts.poppins(fontSize: 12, color: AppColors.primaryGold, letterSpacing: 1)),
                  Text("Elements of Art - Line", style: GoogleFonts.playfairDisplay(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
                ]),
              ]),
              const SizedBox(height: 16),
              Text("Complete 3 exercises today to maintain your 5-day streak! Each exercise is designed by Donlee instructors based on foundation principles.", style: GoogleFonts.poppins(fontSize: 12, color: AppColors.mediumGrey, height: 1.5)),
              const SizedBox(height: 16),
              SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.play_arrow, size: 18), label: const Text("START TIMED SESSION"))),
            ]),
          ),
          const SizedBox(height: 24),
          Text("Drawing Exercises", style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
          const SizedBox(height: 12),
          ...exercises.map((ex) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(14),
              leading: Container(width: 48, height: 48, decoration: BoxDecoration(color: AppColors.primaryBlackLighter, borderRadius: BorderRadius.circular(12)), child: Icon(ex["icon"] as IconData, color: AppColors.primaryGold)),
              title: Text(ex["title"] as String, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primaryWhite)),
              subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: 2),
                Text(ex["desc"] as String, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.mediumGrey), maxLines: 2),
                const SizedBox(height: 6),
                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: AppColors.primaryBlackLight, borderRadius: BorderRadius.circular(12)), child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.access_time, size: 10, color: AppColors.mediumGrey), const SizedBox(width: 4), Text(ex["time"] as String, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey))])),
              ]),
              trailing: const Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.mediumGrey),
              onTap: () => _showExerciseSheet(context, ex),
            ),
          )),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.primaryBlackLight, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.primaryBlackLighter)),
            child: Column(children: [
              Text("Want to save your work?", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primaryWhite)),
              const SizedBox(height: 8),
              Text("Upload to your portfolio after each practice session to track progress over time.", style: GoogleFonts.poppins(fontSize: 11, color: AppColors.mediumGrey), textAlign: TextAlign.center),
              const SizedBox(height: 12),
              OutlinedButton.icon(onPressed: () => Navigator.pushNamed(context, '/portfolio'), icon: const Icon(Icons.cloud_upload_outlined, size: 18), label: const Text("GO TO PORTFOLIO")),
            ]),
          ),
        ],
      ),
    );
  }

  void _showExerciseSheet(BuildContext context, Map<String, dynamic> ex) {
    showModalBottomSheet(context: context, backgroundColor: AppColors.cardBlack, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))), builder: (c) => Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
      Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.mediumGrey.withOpacity(0.3), borderRadius: BorderRadius.circular(4)))),
      const SizedBox(height: 20),
      Text(ex["title"] as String, style: GoogleFonts.playfairDisplay(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
      const SizedBox(height: 8),
      Text(ex["desc"] as String, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.mediumGrey)),
      const SizedBox(height: 20),
      Text("Instructions:", style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primaryGold)),
      const SizedBox(height: 8),
      Text("1. Set timer for ${ex["time"]}.\n2. No erasing allowed - embrace mistakes.\n3. Focus on process, not final result.\n4. After finishing, upload to portfolio with tag '${ex["title"]}'.", style: GoogleFonts.poppins(fontSize: 12, color: AppColors.offWhite, height: 1.6)),
      const SizedBox(height: 20),
      SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text("START EXERCISE"))),
    ])));
  }
}
