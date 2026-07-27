import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/parent_engagement/parent_engagement_model.dart';
import '../../../services/parent_engagement/parent_engagement_service.dart';
import '../../../widgets/custom_app_bar.dart';

class ParentEngagementCenterScreen extends StatefulWidget {
  const ParentEngagementCenterScreen({super.key});

  @override
  State<ParentEngagementCenterScreen> createState() => _ParentEngagementCenterScreenState();
}

class _ParentEngagementCenterScreenState extends State<ParentEngagementCenterScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  final ParentEngagementService _service = ParentEngagementService();
  List<FamilyArtChallenge> _challenges = [];
  List<MeetingSchedule> _meetings = [];
  List<ParentLearningResource> _resources = [];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 4, vsync: this);
    _load();
  }

  Future<void> _load() async {
    final c = await _service.getFamilyChallenges();
    final m = await _service.getMeetings('parent1');
    final r = await _service.getParentResources();
    setState(() {
      _challenges = c;
      _meetings = m;
      _resources = r;
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
      appBar: const CustomAppBar(title: "Parent Engagement Tools", subtitle: "Family challenges, meetings, volunteer, learning resources - Phase 6"),
      body: Column(children: [
        Container(color: AppColors.primaryBlackLight, child: TabBar(controller: _tabCtrl, indicatorColor: AppColors.primaryGold, labelColor: AppColors.primaryGold, unselectedLabelColor: AppColors.mediumGrey, isScrollable: true, tabs: const [Tab(text: "Family Challenges"), Tab(text: "Meetings"), Tab(text: "Volunteer"), Tab(text: "Learning")])),
        Expanded(child: TabBarView(controller: _tabCtrl, children: [_buildChallenges(), _buildMeetings(), _buildVolunteer(), _buildLearning()])),
      ]),
    );
  }

  Widget _buildChallenges() {
    return ListView.separated(padding: const EdgeInsets.all(16), itemCount: _challenges.length, separatorBuilder: (_, __) => const SizedBox(height: 12), itemBuilder: (c, i) {
      final ch = _challenges[i];
      return Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.primaryGold.withOpacity(0.2))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.primaryGold.withOpacity(0.15), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.family_restroom, color: AppColors.primaryGold)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(ch.title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primaryWhite)),
            Text("${ch.participatingFamilies} families • ${ch.startDate.day}/${ch.startDate.month} - ${ch.endDate.day}/${ch.endDate.month}", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)),
          ])),
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: ch.isActive ? AppColors.success.withOpacity(0.15) : AppColors.primaryBlackLighter, borderRadius: BorderRadius.circular(8)), child: Text(ch.isActive ? "Active" : "Ended", style: GoogleFonts.poppins(fontSize: 9, color: ch.isActive ? AppColors.success : AppColors.mediumGrey))),
        ]),
        const SizedBox(height: 10),
        Text(ch.description, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.mediumGrey)),
        const SizedBox(height: 10),
        ...ch.tasks.map((t) => Padding(padding: const EdgeInsets.only(bottom: 4), child: Row(children: [Container(width: 4, height: 4, decoration: const BoxDecoration(color: AppColors.primaryGold, shape: BoxShape.circle)), const SizedBox(width: 8), Expanded(child: Text(t, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.offWhite)))]))),
        const SizedBox(height: 12),
        SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () {}, child: const Text("Join Family Challenge", style: TextStyle(fontSize: 11)))),
      ]));
    });
  }

  Widget _buildMeetings() {
    return ListView.separated(padding: const EdgeInsets.all(16), itemCount: _meetings.length, separatorBuilder: (_, __) => const SizedBox(height: 10), itemBuilder: (c, i) {
      final m = _meetings[i];
      return Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(14), border: Border.all(color: m.status == MeetingStatus.scheduled ? AppColors.primaryGold.withOpacity(0.2) : AppColors.primaryBlackLighter)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: _meetingColor(m.type).withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: Text(m.type.name, style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.bold, color: _meetingColor(m.type)))),
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: m.status == MeetingStatus.scheduled ? AppColors.success.withOpacity(0.15) : AppColors.primaryBlackLighter, borderRadius: BorderRadius.circular(8)), child: Text(m.status.name, style: GoogleFonts.poppins(fontSize: 9, color: m.status == MeetingStatus.scheduled ? AppColors.success : AppColors.mediumGrey))),
        ]),
        const SizedBox(height: 8),
        Text("${m.childName} • ${m.teacherName}", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
        Text("${m.scheduledAt.day}/${m.scheduledAt.month} ${m.scheduledAt.hour}:${m.scheduledAt.minute} • ${m.durationMinutes} min • ${m.isVirtual ? 'Virtual: ${m.location}' : m.location}", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)),
        const SizedBox(height: 6),
        Text(m.notes ?? '', style: GoogleFonts.poppins(fontSize: 10, color: AppColors.goldLight, fontStyle: FontStyle.italic)),
      ]));
    });
  }

  Widget _buildVolunteer() {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.volunteer_activism, size: 60, color: AppColors.mediumGrey.withOpacity(0.3)),
      const SizedBox(height: 12),
      Text("Volunteer Opportunities", style: GoogleFonts.poppins(color: AppColors.mediumGrey)),
      Text("Help organize National Exhibition, offline kits distribution", style: GoogleFonts.poppins(fontSize: 11, color: AppColors.darkGrey)),
    ]));
  }

  Widget _buildLearning() {
    return ListView.separated(padding: const EdgeInsets.all(16), itemCount: _resources.length, separatorBuilder: (_, __) => const SizedBox(height: 10), itemBuilder: (c, i) {
      final r = _resources[i];
      return Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(12)), child: Row(children: [
        Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.primaryGold.withOpacity(0.15), borderRadius: BorderRadius.circular(10)), child: Icon(r.type == 'video' ? Icons.video_library : Icons.article, color: AppColors.primaryGold, size: 18)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(r.title, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
          Text(r.description, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey), maxLines: 2),
          Text("${r.durationMinutes} min • ${r.isOfflineAvailable ? 'Offline DL OK' : 'Online only'}", style: GoogleFonts.poppins(fontSize: 9, color: AppColors.darkGrey)),
        ])),
      ]));
    });
  }

  Color _meetingColor(type) {
    switch (type) {
      case MeetingType.aiReview: return Colors.purpleAccent;
      case MeetingType.exhibitionVisit: return AppColors.primaryGold;
      default: return Colors.blueAccent;
    }
  }
}
