import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/competition_model.dart';
import '../../../services/competition_service.dart';
import '../widgets/competition_card.dart';
import '../../../widgets/custom_app_bar.dart';

class ResultsRankingsScreen extends StatelessWidget {
  final CompetitionModel competition;
  const ResultsRankingsScreen({super.key, required this.competition});

  @override
  Widget build(BuildContext context) {
    final results = CompetitionService().getMockResults(competition.id);
    final categories = competition.categories;

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: CustomAppBar(title: "Results & Rankings", subtitle: "${competition.title} - National", showBack: true),
      body: DefaultTabController(
        length: categories.length + 1,
        child: Column(children: [
          Container(color: AppColors.primaryBlackLight, child: TabBar(isScrollable: true, indicatorColor: AppColors.primaryGold, labelColor: AppColors.primaryGold, unselectedLabelColor: AppColors.mediumGrey, tabs: [const Tab(text: "Overall Top 10")] + categories.map((c) => Tab(text: c.name)).toList())),
          Expanded(
            child: TabBarView(children: [
              _buildResultsList(results, isOverall: true, competition: competition),
              ...categories.map((cat) => _buildResultsList(results.where((r) => r.categoryId == cat.id).toList().isEmpty ? results.take(2).toList() : results.where((r) => r.categoryId == cat.id).toList(), categoryName: cat.name, competition: competition)),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _buildResultsList(List<CompetitionResult> list, {bool isOverall = false, String? categoryName, required CompetitionModel competition}) {
    if (list.isEmpty) {
      return Center(child: Text("No results yet for ${categoryName ?? 'overall'}", style: GoogleFonts.poppins(color: AppColors.mediumGrey)));
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (isOverall) ...[
          RankingPodiumWidget(results: list),
          const SizedBox(height: 20),
          Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(gradient: AppColors.goldGradient, borderRadius: BorderRadius.circular(16)), child: Row(children: [
            const Icon(Icons.emoji_events, color: AppColors.primaryBlack, size: 28),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("National Champions 2025", style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryBlack)),
              Text("${list.length} finalists • Judged by ${competition.judgeIds.length} judges + Chief Judge • Secure blind review", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.primaryBlack.withOpacity(0.8))),
            ])),
          ])),
          const SizedBox(height: 16),
        ],
        Text(isOverall ? "Full Rankings" : "Rankings - $categoryName", style: GoogleFonts.playfairDisplay(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
        const SizedBox(height: 12),
        ...list.asMap().entries.map((entry) {
          final idx = entry.key;
          final res = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(16), border: Border.all(color: res.rank <= 3 ? AppColors.primaryGold.withOpacity(0.4) : AppColors.primaryBlackLighter)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(14),
              leading: Stack(alignment: Alignment.center, children: [
                Container(width: 56, height: 56, decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), image: DecorationImage(image: NetworkImage(res.imageUrl), fit: BoxFit.cover))),
                if (res.rank <= 3) Positioned(bottom: 0, right: 0, child: Container(width: 20, height: 20, decoration: BoxDecoration(color: res.rank == 1 ? AppColors.primaryGold : res.rank == 2 ? Colors.grey : const Color(0xFFCD7F32), shape: BoxShape.circle, border: Border.all(color: AppColors.primaryBlack, width: 2)), child: Center(child: Text("${res.rank}", style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white))))),
              ]),
              title: Row(children: [
                Expanded(child: Text(res.title, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryWhite), maxLines: 1)),
                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: res.rank == 1 ? AppColors.primaryGold : AppColors.primaryBlackLighter, borderRadius: BorderRadius.circular(8)), child: Text("#${res.rank} • ${res.finalScore.toStringAsFixed(1)}", style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: res.rank == 1 ? AppColors.primaryBlack : AppColors.primaryWhite))),
              ]),
              subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: 4),
                Text("${res.studentName} • ${res.schoolName}", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.primaryGold)),
                const SizedBox(height: 4),
                Row(children: [
                  if (res.exhibitionSelected) Container(margin: const EdgeInsets.only(right: 6), padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppColors.primaryGold.withOpacity(0.15), borderRadius: BorderRadius.circular(6)), child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.museum, size: 8, color: AppColors.primaryGold), const SizedBox(width: 2), Text("Exhibition", style: GoogleFonts.poppins(fontSize: 8, color: AppColors.primaryGold))])),
                  if (res.scholarshipEligible) Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.purpleAccent.withOpacity(0.15), borderRadius: BorderRadius.circular(6)), child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.school, size: 8, color: Colors.purpleAccent), const SizedBox(width: 2), Text("Scholarship", style: GoogleFonts.poppins(fontSize: 8, color: Colors.purpleAccent))])),
                ]),
                const SizedBox(height: 4),
                Text("Prize: ${res.prize['details'] ?? res.prize['title'] ?? 'Certificate'} • ${res.totalJudges} judges", style: GoogleFonts.poppins(fontSize: 9, color: AppColors.mediumGrey)),
              ]),
              trailing: IconButton(icon: const Icon(Icons.workspace_premium, color: AppColors.primaryGold), onPressed: () {}),
            ),
          );
        }),
        const SizedBox(height: 20),
        Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.primaryBlackLight, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.primaryGold.withOpacity(0.15))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [const Icon(Icons.museum, color: AppColors.primaryGold, size: 16), const SizedBox(width: 8), Text("Future-Ready: Exhibition & Scholarships", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primaryWhite))]),
          const SizedBox(height: 8),
          Text("Top 10 works selected for exhibition at Nike Art Gallery, Lagos (exhibitionStatus: selected/exhibited/awarded). Winners flagged scholarshipEligible → linked to scholarship portal for Donlee scholarships. Certificates auto-generated: DON-NAC-2025-XXXXXX with QR verification. Low-bandwidth winners' images available in high-res on demand. Offline submissions that were queued & synced are marked with offline badge but judged equally.", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey, height: 1.5)),
        ])),
        const SizedBox(height: 100),
      ],
    );
  }
}
