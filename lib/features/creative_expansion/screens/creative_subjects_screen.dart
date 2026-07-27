import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/creative/creative_subject_model.dart';
import '../../../widgets/custom_app_bar.dart';

class CreativeSubjectsExpansionScreen extends StatelessWidget {
  const CreativeSubjectsExpansionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final subjects = CreativeSubject.allSubjects();

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: const CustomAppBar(title: "Future Expansion - Other Creative Subjects", subtitle: "Visual Art + Music + Dance + Drama + Writing + Photography + Film - modular, feature flagged"),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.purpleAccent.withOpacity(0.2), Colors.blueAccent.withOpacity(0.2)]), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.purpleAccent.withOpacity(0.2))), child: Row(children: [
          const Icon(Icons.rocket_launch, color: Colors.purpleAccent, size: 24),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Future Expansion into Other Creative Subjects - Phase 6 Vision", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primaryWhite)),
            Text("Phase 1-6 built modular lib/features/* independent provider injection easy to extract to microservice. Feature flags enable new subjects per role. Visual Art foundation 10 modules completed stable. Now modular expansion to music, dance, drama, writing, photography, film - each with own modules, offline, AI, competition, certificates, resource library, career center.", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)),
          ])),
        ])),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.9),
          itemCount: subjects.length,
          itemBuilder: (c, i) {
            final subj = subjects[i];
            return Container(decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(16), border: Border.all(color: subj.isEnabled ? AppColors.primaryGold.withOpacity(0.3) : AppColors.primaryBlackLighter)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Stack(children: [
                ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(16)), child: Image.network(subj.thumbnailUrl ?? 'https://images.unsplash.com/photo-1513364776144-60967b0f800f?w=800', height: 100, width: double.infinity, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(height: 100, color: AppColors.primaryBlackLighter))),
                Positioned(top: 8, left: 8, child: Container(width: 32, height: 32, decoration: BoxDecoration(color: subj.isEnabled ? AppColors.primaryGold : Colors.black.withOpacity(0.6), shape: BoxShape.circle), child: Center(child: Text(subj.icon, style: const TextStyle(fontSize: 18))))),
                if (subj.isComingSoon) Positioned(top: 8, right: 8, child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.orangeAccent, borderRadius: BorderRadius.circular(8)), child: Text("Coming Soon", style: GoogleFonts.poppins(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.white)))),
                if (subj.isEnabled) Positioned(bottom: 6, right: 6, child: Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppColors.success, borderRadius: BorderRadius.circular(8)), child: Text("${subj.moduleCount} modules", style: GoogleFonts.poppins(fontSize: 8, color: Colors.white)))),
              ]),
              Padding(padding: const EdgeInsets.all(10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(subj.name, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: subj.isEnabled ? AppColors.primaryGold : AppColors.primaryWhite)),
                const SizedBox(height: 4),
                Text(subj.description, style: GoogleFonts.poppins(fontSize: 9, color: AppColors.mediumGrey), maxLines: 3, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 8),
                SizedBox(width: double.infinity, child: OutlinedButton(onPressed: subj.isEnabled ? () {} : null, child: Text(subj.isEnabled ? "Open" : "Notify Me", style: const TextStyle(fontSize: 10)))),
              ])),
            ]));
          },
        ),
        const SizedBox(height: 20),
        Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.primaryBlackLight, borderRadius: BorderRadius.circular(12)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Architecture for Expansion", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.primaryWhite)),
          const SizedBox(height: 6),
          Text("• Modular: Each creative subject is a feature module lib/features/creative_xxx with own models/services/screens - independent, provider injection\n• Feature Flags: creative_subjects map flag per domain visualArt/music/dance etc enabledForRoles, nationalAdmin toggles\n• Shared Core: core/theme, core/offline, core/ai, services/ai, services/offline etc reused across subjects\n• Offline: Each subject offline downloadable, low-bandwidth compressed, smart sync\n• AI: AI Tutor extended to music theory, drama dialogue, writing, photography composition - teacher-reviewed\n• Competition: National competition framework reusable for music/dance contests with same judging + offline + exhibition/scholarship Future-ready\n• Resource Library: Already supports video/article/ebook/template - easily add music audio, dance video etc\n• Scalability: Multi-tenant schoolId, regional sharding, API v5, CDN 89%, localization 5 languages, auto-scale designed 100k+ students per subject", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey, height: 1.4)),
        ])),
      ]),
    );
  }
}
