import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/cms/cms_model.dart';
import '../../../services/cms/cms_service.dart';
import '../../../widgets/custom_app_bar.dart';

class CMSDashboardScreen extends StatefulWidget {
  const CMSDashboardScreen({super.key});

  @override
  State<CMSDashboardScreen> createState() => _CMSDashboardScreenState();
}

class _CMSDashboardScreenState extends State<CMSDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  final CMSService _service = CMSService();
  List<LessonDraft> _drafts = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 4, vsync: this);
    _load();
  }

  Future<void> _load() async {
    final drafts = await _service.getDrafts();
    setState(() {
      _drafts = drafts;
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
      appBar: const CustomAppBar(title: "Content Management System - Lesson Publishing", subtitle: "Draft → Review → Approved → Published • Versioning • Assets • Scheduling • Low-BW"),
      body: _loading ? const Center(child: CircularProgressIndicator(color: AppColors.primaryGold)) : Column(children: [
        Container(color: AppColors.primaryBlackLight, child: TabBar(controller: _tabCtrl, indicatorColor: AppColors.primaryGold, labelColor: AppColors.primaryGold, unselectedLabelColor: AppColors.mediumGrey, isScrollable: true, tabs: const [Tab(text: "All Drafts"), Tab(text: "In Review"), Tab(text: "Approved"), Tab(text: "Published")])),
        Expanded(child: TabBarView(controller: _tabCtrl, children: [
          _buildList(_drafts),
          _buildList(_drafts.where((d) => d.status == LessonStatus.inReview).toList()),
          _buildList(_drafts.where((d) => d.status == LessonStatus.approved).toList()),
          _buildList(_drafts.where((d) => d.status == LessonStatus.published || d.status == LessonStatus.approved).toList()),
        ])),
      ]),
      floatingActionButton: FloatingActionButton.extended(onPressed: () {}, backgroundColor: AppColors.primaryGold, foregroundColor: AppColors.primaryBlack, icon: const Icon(Icons.add), label: const Text("New Lesson")),
    );
  }

  Widget _buildList(List<LessonDraft> list) {
    if (list.isEmpty) return Center(child: Text("No drafts in this status", style: GoogleFonts.poppins(color: AppColors.mediumGrey)));
    return ListView.separated(padding: const EdgeInsets.all(16), itemCount: list.length, separatorBuilder: (_, __) => const SizedBox(height: 10), itemBuilder: (c, i) {
      final d = list[i];
      return Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(12), border: Border.all(color: _statusColor(d.status).withOpacity(0.3))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: _statusColor(d.status).withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: Text(d.status.name.toUpperCase(), style: GoogleFonts.poppins(fontSize: 8, fontWeight: FontWeight.bold, color: _statusColor(d.status)))),
          Text("v${d.version} • ${d.moduleTitle}", style: GoogleFonts.poppins(fontSize: 9, color: AppColors.mediumGrey)),
          if (d.lowBandwidthOptimized) Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.15), borderRadius: BorderRadius.circular(6)), child: Text("Low-BW", style: GoogleFonts.poppins(fontSize: 7, color: Colors.blueAccent))),
        ]),
        const SizedBox(height: 8),
        Text(d.title, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
        Text(d.description, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey), maxLines: 2),
        const SizedBox(height: 8),
        Text("By ${d.authorName} • Updated ${d.updatedAt.day}/${d.updatedAt.month} • Tags: ${d.tags.join(', ')} ${d.isForNationalCompetition ? '• National Competition' : ''}", style: GoogleFonts.poppins(fontSize: 9, color: AppColors.darkGrey)),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(child: OutlinedButton(onPressed: () {}, child: const Text("Edit", style: TextStyle(fontSize: 10)))),
          const SizedBox(width: 8),
          Expanded(child: ElevatedButton(onPressed: () {}, child: Text(d.status == LessonStatus.draft ? "Submit Review" : d.status == LessonStatus.inReview ? "Approve" : "Publish", style: const TextStyle(fontSize: 10)))),
        ]),
      ]));
    });
  }

  Color _statusColor(LessonStatus s) {
    switch (s) {
      case LessonStatus.draft: return AppColors.mediumGrey;
      case LessonStatus.inReview: return Colors.orangeAccent;
      case LessonStatus.approved: return Colors.blueAccent;
      case LessonStatus.published: return AppColors.success;
      default: return AppColors.primaryGold;
    }
  }
}
