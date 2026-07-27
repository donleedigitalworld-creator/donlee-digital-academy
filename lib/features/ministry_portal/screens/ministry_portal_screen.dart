import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/ministry/ministry_model.dart';
import '../../../services/ministry/ministry_service.dart';
import '../../../widgets/custom_app_bar.dart';
import '../widgets/welcome_message_widget.dart';

class MinistryPortalScreen extends StatefulWidget {
  const MinistryPortalScreen({super.key});

  @override
  State<MinistryPortalScreen> createState() => _MinistryPortalScreenState();
}

class _MinistryPortalScreenState extends State<MinistryPortalScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  final MinistryService _service = MinistryService();
  List<WelcomeMessage> _welcomes = [];
  MinistryStats? _stats;
  List<PolicyDocument> _policies = [];
  List<ApprovalRequest> _approvals = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 4, vsync: this);
    _load();
  }

  Future<void> _load() async {
    final welcomes = await _service.getWelcomeMessages();
    final stats = await _service.getMinistryStats();
    final policies = await _service.getPolicyDocuments();
    final approvals = await _service.getPendingApprovals();
    setState(() {
      _welcomes = welcomes;
      _stats = stats;
      _policies = policies;
      _approvals = approvals;
      _loading = false;
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
      appBar: const CustomAppBar(title: "Ministry of Education Portal", subtitle: "Federal Ministry - National Art Education Ecosystem - 36 states + FCT"),
      body: _loading ? const Center(child: CircularProgressIndicator(color: AppColors.primaryGold)) : Column(children: [
        Container(color: AppColors.primaryBlackLight, child: TabBar(controller: _tabCtrl, indicatorColor: AppColors.primaryGold, labelColor: AppColors.primaryGold, unselectedLabelColor: AppColors.mediumGrey, isScrollable: true, tabs: const [Tab(text: "Welcome Messages"), Tab(text: "Stats & Approvals"), Tab(text: "Policy Documents"), Tab(text: "Future Scalability")])),
        Expanded(
          child: TabBarView(controller: _tabCtrl, children: [
            _buildWelcomeTab(),
            _buildStatsTab(),
            _buildPolicyTab(),
            _buildScalabilityTab(),
          ]),
        ),
      ]),
    );
  }

  Widget _buildWelcomeTab() {
    return ListView(padding: const EdgeInsets.all(16), children: [
      Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF0A3D62), Color(0xFF079992)]), borderRadius: BorderRadius.circular(16)), child: Row(children: [
        const Icon(Icons.account_balance, color: Colors.white, size: 28),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Integrated Ministry Portal - Phase 5 Updated", style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
          Text("Welcome message section on Home + Ministry portal - 1,247 schools, 45,892 students, offline 41%, AI 73%, equity metrics", style: GoogleFonts.poppins(fontSize: 10, color: Colors.white.withOpacity(0.9))),
        ])),
      ])),
      const SizedBox(height: 16),
      ..._welcomes.map((w) => WelcomeMessageWidget(message: w)),
    ]);
  }

  Widget _buildStatsTab() {
    if (_stats == null) return const SizedBox();
    return ListView(padding: const EdgeInsets.all(16), children: [
      GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.8, children: [
        _statCard("Schools Pending Approval", "${_stats!.totalSchoolsPendingApproval}", Icons.school, Colors.orangeAccent, "NorthEast 8 highest"),
        _statCard("Competitions Pending", "${_stats!.totalCompetitionsPendingApproval}", Icons.emoji_events, Colors.purpleAccent, "National + Lagos"),
        _statCard("Active Schools", "${_stats!.totalActiveSchools}", Icons.check_circle, AppColors.success, "92% state coverage target 100%"),
        _statCard("Policy Documents", "${_stats!.totalPolicyDocuments}", Icons.description, Colors.blueAccent, "Offline + AI + Inclusive"),
      ]),
      const SizedBox(height: 20),
      Text("Pending Approvals - Ministry Review", style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
      const SizedBox(height: 12),
      ..._approvals.map((appr) => Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(12)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.orangeAccent.withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: Text(appr.type.name.toUpperCase(), style: GoogleFonts.poppins(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.orangeAccent))),
          const Spacer(),
          Text("${appr.requestedAt.day}/${appr.requestedAt.month} • ${appr.status.name}", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)),
        ]),
        const SizedBox(height: 8),
        Text(appr.title, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
        Text("${appr.requesterName} • School ${appr.schoolId}", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.primaryGold)),
        Text(appr.description, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(child: OutlinedButton(onPressed: () {}, child: const Text("Review", style: TextStyle(fontSize: 11)))),
          const SizedBox(width: 8),
          Expanded(child: ElevatedButton(onPressed: () {}, child: const Text("Approve", style: TextStyle(fontSize: 11)))),
        ]),
      ]))),
    ]);
  }

  Widget _buildPolicyTab() {
    return ListView.separated(padding: const EdgeInsets.all(16), itemCount: _policies.length, separatorBuilder: (_, __) => const SizedBox(height: 10), itemBuilder: (c, i) {
      final p = _policies[i];
      return Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(12)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: AppColors.success.withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: Text(p.status.name, style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.success))),
          const Spacer(),
          Text("${p.publishedAt.day}/${p.publishedAt.month}/${p.publishedAt.year} • ${p.publishedBy}", style: GoogleFonts.poppins(fontSize: 9, color: AppColors.mediumGrey)),
        ]),
        const SizedBox(height: 8),
        Text(p.title, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
        Text(p.summary, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)),
        const SizedBox(height: 6),
        Wrap(spacing: 6, children: p.affectedRegions.map((r) => Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppColors.primaryBlackLight, borderRadius: BorderRadius.circular(6)), child: Text(r, style: GoogleFonts.poppins(fontSize: 8, color: AppColors.mediumGrey)))).toList()),
      ]));
    });
  }

  Widget _buildScalabilityTab() {
    return ListView(padding: const EdgeInsets.all(16), children: [
      Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.primaryBlackLight, borderRadius: BorderRadius.circular(12)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("Welcome Message Section on Home - Integrated", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primaryWhite)),
        const SizedBox(height: 8),
        Text("Home screen now has WelcomeHeader + WelcomeMessageWidget from Ministry + Donlee Founder - top of feed, personalized greeting Good Morning/Afternoon/Evening + overall progress + 2 welcome messages (Ministry + Founder) with author name/title, tags, video optional, encrypted, offline downloadable. Ensures Phase 5 stable before Phase 6.", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey, height: 1.5)),
        const SizedBox(height: 12),
        Text("Ministry Portal as part of Phase 5 - Future Scalability for Phase 6", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.primaryGold)),
        const SizedBox(height: 6),
        Text("• National Dashboard already is Ministry portal - enhanced with Welcome Messages tab + approval workflow\n• Phase 6 built only after Phase 5 stable - additive, not breaking\n• Parent engagement tools, Teacher PD Center, CMS lesson publishing, Partnerships portal, Scholarship & Opportunity Center, Marketplace groundwork, Research analytics, MFA stronger security, Accessibility updates, Creative subjects expansion music/dance/drama/writing/photography/film - all feature flagged via FeatureFlag model\n• Multi-tenant, offline-first, low-bandwidth, AI teacher-reviewed, encrypted - ready for 100k+ students nationally", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey, height: 1.5)),
      ])),
    ]);
  }

  Widget _statCard(String label, String value, IconData icon, Color color, String sub) {
    return Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.2))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Container(width: 28, height: 28, decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: Icon(icon, size: 14, color: color)), Text(value, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryWhite))]),
      const SizedBox(height: 6),
      Text(label, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.primaryWhite)),
      Text(sub, style: GoogleFonts.poppins(fontSize: 8, color: AppColors.mediumGrey)),
    ]));
  }
}
