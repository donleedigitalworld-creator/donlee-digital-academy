import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/career/career_model.dart';
import '../../../services/national/national_dashboard_service.dart';
import '../../../widgets/custom_app_bar.dart';

class CareerCenterScreen extends StatefulWidget {
  const CareerCenterScreen({super.key});

  @override
  State<CareerCenterScreen> createState() => _CareerCenterScreenState();
}

class _CareerCenterScreenState extends State<CareerCenterScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  final CareerService _service = CareerService();
  List<CareerPath> _paths = [];
  List<OpportunityModel> _opps = [];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
    _load();
  }

  Future<void> _load() async {
    final paths = await _service.getCareerPaths();
    final opps = await _service.getOpportunities();
    setState(() {
      _paths = paths;
      _opps = opps;
    });
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: const CustomAppBar(title: "Career & Opportunity Center", subtitle: "Jobs, internships, scholarships, exhibitions, mentorship - future-ready"),
      body: Column(children: [
        Container(color: AppColors.primaryBlackLight, child: TabBar(controller: _tabCtrl, indicatorColor: AppColors.primaryGold, labelColor: AppColors.primaryGold, unselectedLabelColor: AppColors.mediumGrey, tabs: const [Tab(text: "Career Paths"), Tab(text: "Opportunities"), Tab(text: "Scholarships")])),
        Expanded(child: TabBarView(controller: _tabCtrl, children: [
          _buildPaths(),
          _buildOpps(_opps),
          _buildOpps(_opps.where((o) => o.type == OpportunityType.scholarship).toList()),
        ])),
      ]),
    );
  }

  Widget _buildPaths() {
    if (_paths.isEmpty) return const Center(child: CircularProgressIndicator(color: AppColors.primaryGold));
    return ListView.separated(padding: const EdgeInsets.all(16), itemCount: _paths.length, separatorBuilder: (_, __) => const SizedBox(height: 12), itemBuilder: (c, i) {
      final p = _paths[i];
      return Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(14)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.primaryGold.withOpacity(0.15), borderRadius: BorderRadius.circular(10)), child: Center(child: Text(p.icon, style: const TextStyle(fontSize: 20)))),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(p.title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primaryWhite)),
            Text(p.description, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)),
          ])),
        ]),
        const SizedBox(height: 10),
        Wrap(spacing: 6, children: p.requiredSkills.map((s) => Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: AppColors.primaryBlackLight, borderRadius: BorderRadius.circular(12)), child: Text(s, style: GoogleFonts.poppins(fontSize: 9, color: AppColors.mediumGrey)))).toList()),
        const SizedBox(height: 8),
        Text("Avg ${p.currency} ${p.avgSalaryRangeLow.toInt()}-${p.avgSalaryRangeHigh.toInt()} • Modules: ${p.recommendedModules.join(', ')}", style: GoogleFonts.poppins(fontSize: 9, color: AppColors.primaryGold)),
      ]));
    });
  }

  Widget _buildOpps(List<OpportunityModel> list) {
    if (list.isEmpty) return const Center(child: CircularProgressIndicator(color: AppColors.primaryGold));
    return ListView.separated(padding: const EdgeInsets.all(16), itemCount: list.length, separatorBuilder: (_, __) => const SizedBox(height: 12), itemBuilder: (c, i) {
      final opp = list[i];
      return Container(decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(14), border: Border.all(color: opp.isForNationalCompetitionWinners ? AppColors.primaryGold.withOpacity(0.3) : AppColors.primaryBlackLighter)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(14)), child: Image.network(opp.coverImageUrl ?? 'https://images.unsplash.com/photo-1541961017774-22349e4a1262?w=800', height: 120, width: double.infinity, fit: BoxFit.cover)),
        Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: _oppColor(opp.type).withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: Text(opp.type.name.toUpperCase(), style: GoogleFonts.poppins(fontSize: 8, fontWeight: FontWeight.bold, color: _oppColor(opp.type)))),
            const SizedBox(width: 6),
            if (opp.isForNationalCompetitionWinners) Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppColors.primaryGold.withOpacity(0.15), borderRadius: BorderRadius.circular(6)), child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.emoji_events, size: 10, color: AppColors.primaryGold), const SizedBox(width: 2), Text("National Winners", style: GoogleFonts.poppins(fontSize: 7, color: AppColors.primaryGold))])),
            const Spacer(),
            Text("${opp.deadline.day}/${opp.deadline.month} deadline", style: GoogleFonts.poppins(fontSize: 9, color: AppColors.mediumGrey)),
          ]),
          const SizedBox(height: 8),
          Text(opp.title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primaryWhite)),
          Text("${opp.organization} • ${opp.location} ${opp.isRemote ? '(Remote)' : ''}", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.primaryGold)),
          const SizedBox(height: 6),
          Text(opp.description, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.mediumGrey), maxLines: 2),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: OutlinedButton(onPressed: () {}, child: Text("Details", style: TextStyle(fontSize: 11)))),
            const SizedBox(width: 8),
            Expanded(child: ElevatedButton(onPressed: () {}, child: Text(opp.isScholarshipLinked ? "Apply Scholarship" : "Apply", style: TextStyle(fontSize: 11)))),
          ]),
        ])),
      ]));
    });
  }

  Color _oppColor(OpportunityType t) {
    switch (t) {
      case OpportunityType.scholarship: return Colors.purpleAccent;
      case OpportunityType.exhibition: return AppColors.primaryGold;
      case OpportunityType.job: return Colors.blueAccent;
      case OpportunityType.mentorship: return AppColors.success;
      default: return AppColors.mediumGrey;
    }
  }
}
