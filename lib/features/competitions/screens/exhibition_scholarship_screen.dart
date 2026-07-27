import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../models/competition_model.dart';

class ExhibitionScholarshipScreen extends StatelessWidget {
  const ExhibitionScholarshipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: const CustomAppBar(title: "Exhibition & Scholarships", subtitle: "Future-ready - Nike Art Gallery + Donlee Scholarship Portal", showBack: true),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(gradient: AppColors.goldGradient, borderRadius: BorderRadius.circular(16)),
            child: Row(children: [
              Container(width: 60, height: 60, decoration: BoxDecoration(color: AppColors.primaryBlack, borderRadius: BorderRadius.circular(16)), child: const Icon(Icons.museum, color: AppColors.primaryGold, size: 32)),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("Nike Art Gallery Lagos Exhibition", style: GoogleFonts.playfairDisplay(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primaryBlack)),
                const SizedBox(height: 4),
                Text("Top 10 national artworks exhibited physical + virtual tour. ExhibitionStatus: pending → selected → exhibited → awarded", style: GoogleFonts.poppins(fontSize: 11, color: AppColors.primaryBlack.withOpacity(0.8))),
              ])),
            ]),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.purpleAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.purpleAccent.withOpacity(0.2))),
            child: Row(children: [
              Container(width: 60, height: 60, decoration: BoxDecoration(color: Colors.purpleAccent.withOpacity(0.2), borderRadius: BorderRadius.circular(16)), child: const Icon(Icons.school, color: Colors.purpleAccent, size: 32)),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("Donlee Scholarship Portal Linked", style: GoogleFonts.playfairDisplay(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
                const SizedBox(height: 4),
                Text("Rank 1-3 + exhibition selected = scholarshipEligible flag → auto-linked to scholarship application, portfolio review, mentorship", style: GoogleFonts.poppins(fontSize: 11, color: AppColors.mediumGrey)),
              ])),
            ]),
          ),
          const SizedBox(height: 24),
          Text("Selected for Exhibition (Top 10)", style: GoogleFonts.playfairDisplay(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.8),
            itemCount: 6,
            itemBuilder: (c, i) => Container(
              decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.primaryGold.withOpacity(0.2))),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(child: Stack(children: [
                  ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(16)), child: Image.network(['https://images.unsplash.com/photo-1578301978693-85fa9c0320b9?w=800', 'https://images.unsplash.com/photo-1579783902614-a3fb3927b6a5?w=800', 'https://images.unsplash.com/photo-1513364776144-60967b0f800f?w=800'][i % 3], width: double.infinity, height: double.infinity, fit: BoxFit.cover)),
                  Positioned(top: 8, left: 8, child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: AppColors.primaryGold, borderRadius: BorderRadius.circular(20)), child: Text("Rank #${i + 1}", style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.primaryBlack)))),
                  Positioned(top: 8, right: 8, child: Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4), decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(12)), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(ExhibitionStatus.values[i % 4] == ExhibitionStatus.exhibited ? Icons.check_circle : Icons.schedule, size: 10, color: AppColors.primaryGold), const SizedBox(width: 2), Text(ExhibitionStatus.values[i % 4].name, style: GoogleFonts.poppins(fontSize: 8, color: Colors.white))])),
                ])),
                Padding(padding: const EdgeInsets.all(10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(["Unity Mask", "Danfo Dreams", "Grandmothers Hands", "Lagos Market", "Portrait Study", "Still Life Ode"][i], style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.primaryWhite)),
                  Text(["Amara Okafor - Donlee Main", "Tunde Adebayo - Greensprings", "Chioma Nwosu - Abuja Hub"][i % 3], style: GoogleFonts.poppins(fontSize: 9, color: AppColors.primaryGold)),
                  const SizedBox(height: 4),
                  Row(children: [
                    Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.purpleAccent.withOpacity(0.15), borderRadius: BorderRadius.circular(6)), child: Text("Scholarship Eligible", style: GoogleFonts.poppins(fontSize: 7, color: Colors.purpleAccent))),
                  ]),
                ])),
              ]),
            ),
          ),
          const SizedBox(height: 20),
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(16)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("How Future-Ready Works", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
            const SizedBox(height: 12),
            ...[
              "CompetitionResult.exhibitionSelected bool → true for top 10 → auto appears in exhibition screen",
              "ExhibitionStatus enum: pending → selected (judges choose) → exhibited (physical at Nike Art Gallery) → awarded",
              "ScholarshipEligible bool if rank <=3 or exhibition + high score → linked to scholarship portal",
              "Certificate auto-generated with DON-NAC number, QR, and scholarship note if eligible",
              "Notifications sent: student gallery, school dashboard, admin dashboard when status changes",
              "Low-bandwidth: exhibition virtual tour uses thumbnails, tap for high-res",
              "Offline: exhibition data cached via OfflineLesson model, viewable offline",
            ].map((e) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(margin: const EdgeInsets.only(top: 4), width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.primaryGold, shape: BoxShape.circle)), const SizedBox(width: 8), Expanded(child: Text(e, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.mediumGrey)))]))),
          ])),
        ],
      ),
    );
  }
}
