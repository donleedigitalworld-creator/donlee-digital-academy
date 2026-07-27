import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/competition_model.dart';
import '../../../services/competition_service.dart';
import '../../../widgets/custom_app_bar.dart';
import '../widgets/competition_card.dart';
import '../../../core/offline/offline_banner.dart';

class CompetitionsListScreen extends StatefulWidget {
  const CompetitionsListScreen({super.key});

  @override
  State<CompetitionsListScreen> createState() => _CompetitionsListScreenState();
}

class _CompetitionsListScreenState extends State<CompetitionsListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  final CompetitionService _service = CompetitionService();
  String _filter = 'All';

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final competitions = _service.getMockCompetitions();

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: CustomAppBar(title: "National Art Competitions", subtitle: "Compete, exhibit, win scholarships - Offline OK", actions: [IconButton(icon: const Icon(Icons.add, color: AppColors.primaryGold), onPressed: () => Navigator.pushNamed(context, '/competitionCreate')), IconButton(icon: const Icon(Icons.offline_bolt, color: AppColors.success), onPressed: () => Navigator.pushNamed(context, '/offlineMode'))]),
      body: Column(children: [
        const OfflineBanner(),
        Container(
          color: AppColors.primaryBlackLight,
          child: TabBar(controller: _tabCtrl, indicatorColor: AppColors.primaryGold, labelColor: AppColors.primaryGold, unselectedLabelColor: AppColors.mediumGrey, isScrollable: true, tabs: const [Tab(text: "All"), Tab(text: "Open for Registration"), Tab(text: "Submission Open"), Tab(text: "Results")]),
        ),
        Expanded(
          child: TabBarView(controller: _tabCtrl, children: [
            _buildGrid(competitions),
            _buildGrid(competitions.where((c) => c.status == CompetitionStatus.registrationOpen).toList()),
            _buildGrid(competitions.where((c) => c.status == CompetitionStatus.submissionOpen).toList()),
            _buildGrid(competitions.where((c) => c.status == CompetitionStatus.resultsPublished).toList()),
          ]),
        ),
      ]),
      floatingActionButton: FloatingActionButton.extended(onPressed: () => Navigator.pushNamed(context, '/competitionCreate'), backgroundColor: AppColors.primaryGold, foregroundColor: AppColors.primaryBlack, icon: const Icon(Icons.emoji_events), label: const Text("Create Competition")),
    );
  }

  Widget _buildGrid(List<CompetitionModel> list) {
    if (list.isEmpty) {
      return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.emoji_events_outlined, size: 64, color: AppColors.mediumGrey.withOpacity(0.3)), const SizedBox(height: 12), Text("No competitions in this category", style: GoogleFonts.poppins(color: AppColors.mediumGrey)), Text("Check back soon or create one as admin", style: GoogleFonts.poppins(fontSize: 11, color: AppColors.darkGrey))]));
    }
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1, childAspectRatio: 1.1, mainAxisSpacing: 16),
      itemCount: list.length,
      itemBuilder: (c, i) => CompetitionCard(competition: list[i], onTap: () => Navigator.pushNamed(context, '/competitionDetail', arguments: list[i])),
    );
  }
}
