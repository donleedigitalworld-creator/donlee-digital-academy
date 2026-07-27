import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/competition_model.dart';

class CompetitionCard extends StatelessWidget {
  final CompetitionModel competition;
  final VoidCallback onTap;
  const CompetitionCard({super.key, required this.competition, required this.onTap});

  Color _statusColor(CompetitionStatus status) {
    switch (status) {
      case CompetitionStatus.registrationOpen: return Colors.blueAccent;
      case CompetitionStatus.submissionOpen: return AppColors.success;
      case CompetitionStatus.judging: return Colors.orangeAccent;
      case CompetitionStatus.resultsPublished: return AppColors.primaryGold;
      default: return AppColors.mediumGrey;
    }
  }

  IconData _statusIcon(CompetitionStatus status) {
    switch (status) {
      case CompetitionStatus.registrationOpen: return Icons.app_registration;
      case CompetitionStatus.submissionOpen: return Icons.cloud_upload;
      case CompetitionStatus.judging: return Icons.gavel;
      case CompetitionStatus.resultsPublished: return Icons.emoji_events;
      default: return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBlack,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _statusColor(competition.status).withOpacity(0.3), width: 1),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(children: [
            ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(20)), child: CachedNetworkImage(imageUrl: competition.coverImageUrl ?? 'https://images.unsplash.com/photo-1541961017774-22349e4a1262?w=800', height: 160, width: double.infinity, fit: BoxFit.cover, placeholder: (c, u) => Container(height: 160, color: AppColors.primaryBlackLighter), errorWidget: (c, u, e) => Container(height: 160, color: AppColors.primaryBlackLighter, child: const Icon(Icons.image)))),
            Container(height: 160, decoration: BoxDecoration(borderRadius: const BorderRadius.vertical(top: Radius.circular(20)), gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.8)]))),
            Positioned(top: 12, left: 12, right: 12, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: _statusColor(competition.status), borderRadius: BorderRadius.circular(20)), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(_statusIcon(competition.status), size: 12, color: Colors.white), const SizedBox(width: 4), Text(competition.status.name.replaceAll('_', ' ').toUpperCase(), style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white))])),
              if (competition.allowOfflineSubmission) Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.success.withOpacity(0.5))), child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.wifi_off, size: 10, color: AppColors.success), const SizedBox(width: 4), Text("OFFLINE OK", style: GoogleFonts.poppins(fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.success))])),
            ])),
            Positioned(bottom: 12, left: 12, right: 12, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(competition.title, style: GoogleFonts.playfairDisplay(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryWhite), maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Text(competition.theme, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.primaryGold, fontStyle: FontStyle.italic), maxLines: 1),
            ])),
          ]),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                _infoChip(Icons.category, "${competition.categories.length} Categories"),
                const SizedBox(width: 8),
                _infoChip(Icons.people, "${competition.totalRegistrations} Registered"),
                const Spacer(),
                if (competition.isScholarshipLinked) Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.purpleAccent.withOpacity(0.15), borderRadius: BorderRadius.circular(6)), child: Text("Scholarship", style: GoogleFonts.poppins(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.purpleAccent))),
              ]),
              const SizedBox(height: 10),
              ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: _progressValue(), backgroundColor: AppColors.primaryBlackLighter, color: _statusColor(competition.status), minHeight: 5)),
              const SizedBox(height: 8),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(_progressLabel(), style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)),
                Row(children: [
                  if (competition.lowBandwidthMode) ...[const Icon(Icons.signal_cellular_alt, size: 10, color: AppColors.success), const SizedBox(width: 2), Text("Low-Bandwidth", style: GoogleFonts.poppins(fontSize: 9, color: AppColors.success)), const SizedBox(width: 8)],
                  if (competition.isExhibitionLinked) ...[const Icon(Icons.museum, size: 10, color: AppColors.primaryGold), const SizedBox(width: 2), Text("Exhibition", style: GoogleFonts.poppins(fontSize: 9, color: AppColors.primaryGold))],
                ]),
              ]),
              const SizedBox(height: 10),
              Wrap(spacing: 6, children: competition.tags.take(3).map((t) => Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: AppColors.primaryBlackLight, borderRadius: BorderRadius.circular(12)), child: Text(t, style: GoogleFonts.poppins(fontSize: 9, color: AppColors.mediumGrey)))).toList()),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 10, color: AppColors.mediumGrey), const SizedBox(width: 4), Text(text, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey))]);
  }

  double _progressValue() {
    switch (competition.status) {
      case CompetitionStatus.draft: return 0.1;
      case CompetitionStatus.registrationOpen: return 0.3;
      case CompetitionStatus.submissionOpen: return 0.6;
      case CompetitionStatus.judging: return 0.8;
      case CompetitionStatus.resultsPublished: return 1.0;
      default: return 0.5;
    }
  }

  String _progressLabel() {
    switch (competition.status) {
      case CompetitionStatus.registrationOpen: return "Registration: ${competition.registrationEnd.difference(DateTime.now()).inDays} days left";
      case CompetitionStatus.submissionOpen: return "Submission: ${competition.submissionEnd.difference(DateTime.now()).inDays} days left • ${competition.totalSubmissions} entries";
      case CompetitionStatus.judging: return "Judging in progress • ${competition.judgeIds.length} judges";
      case CompetitionStatus.resultsPublished: return "Results published • ${competition.totalSubmissions} entries judged";
      default: return "${competition.totalRegistrations} registered";
    }
  }
}

class JudgingCriteriaWidget extends StatelessWidget {
  final JudgingCriteria criteria;
  final int? selectedScore;
  final Function(int) onScoreSelected;
  const JudgingCriteriaWidget({super.key, required this.criteria, this.selectedScore, required this.onScoreSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.primaryBlackLighter)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(criteria.name, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primaryWhite)),
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: AppColors.primaryGold.withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: Text("${criteria.weight * 100}% weight • max ${criteria.maxScore}", style: GoogleFonts.poppins(fontSize: 9, color: AppColors.primaryGold))),
        ]),
        const SizedBox(height: 4),
        Text(criteria.description, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)),
        const SizedBox(height: 12),
        Row(children: List.generate(criteria.maxScore + 1, (i) {
          final isSelected = i == selectedScore;
          return Expanded(child: GestureDetector(onTap: () => onScoreSelected(i), child: Container(margin: const EdgeInsets.symmetric(horizontal: 2), height: 36, decoration: BoxDecoration(color: isSelected ? AppColors.primaryGold : AppColors.primaryBlackLighter, borderRadius: BorderRadius.circular(8), border: Border.all(color: isSelected ? AppColors.primaryGold : Colors.transparent)), child: Center(child: Text("$i", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: isSelected ? AppColors.primaryBlack : AppColors.mediumGrey))))));
        })),
      ]),
    );
  }
}

class RankingPodiumWidget extends StatelessWidget {
  final List<CompetitionResult> results;
  const RankingPodiumWidget({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    if (results.length < 3) return const SizedBox();
    final sorted = [...results]..sort((a, b) => a.rank.compareTo(b.rank));
    final top3 = sorted.take(3).toList();

    return Container(
      height: 220,
      padding: const EdgeInsets.all(16),
      child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        // 2nd
        Expanded(child: _podiumItem(top3[1], 2, 120, Colors.grey)),
        // 1st
        Expanded(child: _podiumItem(top3[0], 1, 160, AppColors.primaryGold)),
        // 3rd
        Expanded(child: _podiumItem(top3[2], 3, 100, const Color(0xFFCD7F32))),
      ]),
    );
  }

  Widget _podiumItem(CompetitionResult res, int rank, double height, Color color) {
    return Column(children: [
      Stack(children: [
        CircleAvatar(radius: 28, backgroundColor: color.withOpacity(0.2), backgroundImage: NetworkImage(res.imageUrl), onBackgroundImageError: (_, __) {}),
        Positioned(bottom: 0, right: 0, child: Container(width: 22, height: 22, decoration: BoxDecoration(color: color, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)), child: Center(child: Text("$rank", style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white))))),
      ]),
      const SizedBox(height: 8),
      Text(res.studentName, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primaryWhite), maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
      Text(res.schoolName, style: GoogleFonts.poppins(fontSize: 8, color: AppColors.mediumGrey), maxLines: 1, overflow: TextOverflow.ellipsis),
      const SizedBox(height: 8),
      Container(height: height, width: double.infinity, decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: const BorderRadius.vertical(top: Radius.circular(8)), border: Border.all(color: color)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(rank == 1 ? Icons.emoji_events : Icons.military_tech, color: color, size: 20), const SizedBox(height: 4), Text("#$rank", style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold, color: color)), Text("${res.finalScore.toStringAsFixed(1)}", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.primaryWhite))])),
    ]);
  }
}
