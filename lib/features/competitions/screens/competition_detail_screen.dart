import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/competition_model.dart';
import '../widgets/competition_card.dart';

class CompetitionDetailScreen extends StatelessWidget {
  final CompetitionModel competition;
  const CompetitionDetailScreen({super.key, required this.competition});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.primaryBlack,
            leading: IconButton(icon: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), shape: BoxShape.circle), child: const Icon(Icons.arrow_back_ios, size: 16, color: Colors.white)), onPressed: () => Navigator.pop(context)),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(fit: StackFit.expand, children: [
                CachedNetworkImage(imageUrl: competition.coverImageUrl ?? '', fit: BoxFit.cover, placeholder: (c, u) => Container(color: AppColors.primaryBlackLighter), errorWidget: (c, u, e) => Container(color: AppColors.primaryBlackLighter)),
                Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.6), AppColors.primaryBlack]))),
                Positioned(bottom: 20, left: 20, right: 20, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: AppColors.primaryGold, borderRadius: BorderRadius.circular(20)), child: Text(competition.status.name.replaceAll('_', ' ').toUpperCase(), style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primaryBlack))),
                  const SizedBox(height: 10),
                  Text(competition.title, style: GoogleFonts.playfairDisplay(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
                  const SizedBox(height: 6),
                  Text(competition.theme, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.primaryGold, fontStyle: FontStyle.italic)),
                  const SizedBox(height: 8),
                  Row(children: [
                    Icon(Icons.people, size: 12, color: AppColors.offWhite.withOpacity(0.7)),
                    const SizedBox(width: 4),
                    Text("${competition.totalRegistrations} registered • ${competition.totalSubmissions} submissions", style: GoogleFonts.poppins(fontSize: 11, color: AppColors.offWhite)),
                  ]),
                ])),
              ]),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(child: _infoBox(Icons.calendar_today, "Registration", "${competition.registrationStart.day}/${competition.registrationStart.month} - ${competition.registrationEnd.day}/${competition.registrationEnd.month}")),
                  const SizedBox(width: 12),
                  Expanded(child: _infoBox(Icons.upload, "Submission", "${competition.submissionStart.day}/${competition.submissionStart.month} - ${competition.submissionEnd.day}/${competition.submissionEnd.month}")),
                ]),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: _infoBox(Icons.gavel, "Judging", "${competition.judgingStart.day}/${competition.judgingStart.month} - ${competition.judgingEnd.day}/${competition.judgingEnd.month}")),
                  const SizedBox(width: 12),
                  Expanded(child: _infoBox(Icons.emoji_events, "Results", "${competition.resultsDate.day}/${competition.resultsDate.month}/${competition.resultsDate.year}")),
                ]),
                const SizedBox(height: 20),
                Text("About Competition", style: GoogleFonts.playfairDisplay(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
                const SizedBox(height: 8),
                Text(competition.description, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.mediumGrey, height: 1.6)),
                const SizedBox(height: 20),
                Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.primaryGold.withOpacity(0.2))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [const Icon(Icons.emoji_events, color: AppColors.primaryGold, size: 18), const SizedBox(width: 8), Text("Prizes & Opportunities - Future Ready", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primaryWhite))]),
                  const SizedBox(height: 12),
                  ...competition.prizes.entries.map((e) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(margin: const EdgeInsets.only(top: 4), width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.primaryGold, shape: BoxShape.circle)), const SizedBox(width: 8), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(e.key, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryGold)), Text(e.value.toString(), style: GoogleFonts.poppins(fontSize: 11, color: AppColors.offWhite))] )] ))),
                  const SizedBox(height: 12),
                  Row(children: [
                    if (competition.isExhibitionLinked) _badge(Icons.museum, "Exhibition at Nike Art Gallery", AppColors.primaryGold),
                    const SizedBox(width: 8),
                    if (competition.isScholarshipLinked) _badge(Icons.school, "Scholarship Eligible", Colors.purpleAccent),
                  ]),
                ])),
                const SizedBox(height: 20),
                Text("Categories (${competition.categories.length})", style: GoogleFonts.playfairDisplay(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
                const SizedBox(height: 12),
                ...competition.categories.map((cat) => Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(12)), child: Row(children: [
                  Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.primaryGold.withOpacity(0.15), borderRadius: BorderRadius.circular(10)), child: Icon(_categoryIcon(cat.type), color: AppColors.primaryGold, size: 20)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(cat.name, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primaryWhite)), Text(cat.description, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)), Text("Age: ${cat.ageGroup} • Max ${cat.maxSubmissionsPerStudent} entries", style: GoogleFonts.poppins(fontSize: 9, color: AppColors.darkGrey))])),
                ]))),
                const SizedBox(height: 20),
                Text("Judging Criteria - Secure & Fair", style: GoogleFonts.playfairDisplay(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
                const SizedBox(height: 8),
                Text("Judging roles: Chief Judge, Judges, Moderator, Admin. Secure storage of scores, no judge sees others until final. Future-ready for exhibition & scholarships.", style: GoogleFonts.poppins(fontSize: 11, color: AppColors.mediumGrey)),
                const SizedBox(height: 12),
                ...competition.judgingCriteria.map((crit) => Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.primaryBlackLight, borderRadius: BorderRadius.circular(10)), child: Row(children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(crit.name, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12, color: AppColors.primaryWhite)), Text(crit.description, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey))])),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: AppColors.primaryGold.withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: Text("${crit.maxScore} pts • ${crit.weight*100}%", style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.primaryGold))),
                ]))),
                const SizedBox(height: 20),
                Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.success.withOpacity(0.08), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.success.withOpacity(0.2))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [const Icon(Icons.wifi_off, color: AppColors.success, size: 16), const SizedBox(width: 8), Text("Offline Submission Support", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primaryWhite))]),
                  const SizedBox(height: 8),
                  Text("Students in low-connectivity areas can prepare offline. Camera/gallery capture saved locally, queued, auto-synced when online. Low-bandwidth mode compresses images, uses thumbnails first. Smart syncing ensures no duplicate submissions. Offline learning: lessons & quizzes also work offline and sync progress later.", style: GoogleFonts.poppins(fontSize: 11, color: AppColors.mediumGrey, height: 1.5)),
                ])),
                const SizedBox(height: 30),
                SizedBox(width: double.infinity, height: 52, child: ElevatedButton.icon(onPressed: () {
                  if (competition.isRegistrationOpen) {
                    Navigator.pushNamed(context, '/competitionRegister', arguments: competition);
                  } else if (competition.isSubmissionOpen) {
                    Navigator.pushNamed(context, '/competitionSubmit', arguments: competition);
                  } else if (competition.status == CompetitionStatus.resultsPublished) {
                    Navigator.pushNamed(context, '/competitionResults', arguments: competition);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Current status: ${competition.status.name}"), backgroundColor: AppColors.primaryBlackLight));
                  }
                }, icon: Icon(competition.isRegistrationOpen ? Icons.app_registration : competition.isSubmissionOpen ? Icons.cloud_upload : Icons.emoji_events), label: Text(_actionLabel(), style: const TextStyle(fontWeight: FontWeight.bold)))),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: OutlinedButton.icon(onPressed: () => Navigator.pushNamed(context, '/competitionSubmissions', arguments: competition), icon: const Icon(Icons.photo_library, size: 16), label: const Text("View Gallery", style: TextStyle(fontSize: 12)))),
                  const SizedBox(width: 12),
                  Expanded(child: OutlinedButton.icon(onPressed: () => Navigator.pushNamed(context, '/judgingDashboard', arguments: competition), icon: const Icon(Icons.gavel, size: 16), label: const Text("Judging Dashboard", style: TextStyle(fontSize: 12)))),
                ]),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoBox(IconData icon, String title, String value) {
    return Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(12)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Icon(icon, size: 12, color: AppColors.primaryGold), const SizedBox(width: 4), Text(title, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey))]), const SizedBox(height: 4), Text(value, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primaryWhite))]));
  }

  Widget _badge(IconData icon, String label, Color color) {
    return Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(8), border: Border.all(color: color.withOpacity(0.3))), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 10, color: color), const SizedBox(width: 4), Text(label, style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.bold, color: color))]));
  }

  String _actionLabel() {
    switch (competition.status) {
      case CompetitionStatus.registrationOpen: return "REGISTER NOW - OFFLINE OK";
      case CompetitionStatus.submissionOpen: return "SUBMIT ARTWORK - CAMERA/GALLERY";
      case CompetitionStatus.judging: return "JUDGING IN PROGRESS";
      case CompetitionStatus.resultsPublished: return "VIEW RESULTS & RANKINGS";
      default: return "LEARN MORE";
    }
  }

  IconData _categoryIcon(CompetitionCategoryType type) {
    switch (type) {
      case CompetitionCategoryType.drawing: return Icons.draw;
      case CompetitionCategoryType.painting: return Icons.palette;
      case CompetitionCategoryType.digitalArt: return Icons.tablet_mac;
      case CompetitionCategoryType.sculpture: return Icons.view_in_ar;
      case CompetitionCategoryType.portrait: return Icons.person;
      case CompetitionCategoryType.landscape: return Icons.landscape;
      case CompetitionCategoryType.stillLife: return Icons.apple;
      default: return Icons.category;
    }
  }
}
