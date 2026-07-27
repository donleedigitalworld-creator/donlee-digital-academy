import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/community/community_model.dart';
import '../../../services/national/national_dashboard_service.dart';
import '../../../widgets/custom_app_bar.dart';

class CommunityFeedScreen extends StatefulWidget {
  const CommunityFeedScreen({super.key});

  @override
  State<CommunityFeedScreen> createState() => _CommunityFeedScreenState();
}

class _CommunityFeedScreenState extends State<CommunityFeedScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  final CommunityService _service = CommunityService();
  List<CommunityPost> _posts = [];
  List<ForumTopic> _forums = [];
  List<CommunityEvent> _events = [];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
    _load();
  }

  Future<void> _load() async {
    final posts = await _service.getFeed();
    final forums = await _service.getForumTopics();
    final events = await _service.getEvents();
    setState(() {
      _posts = posts;
      _forums = forums;
      _events = events;
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
      appBar: const CustomAppBar(title: "Community - Critique, Clubs, Events", subtitle: "Forums, peer review, national events - secure & moderated"),
      body: Column(children: [
        Container(color: AppColors.primaryBlackLight, child: TabBar(controller: _tabCtrl, indicatorColor: AppColors.primaryGold, labelColor: AppColors.primaryGold, unselectedLabelColor: AppColors.mediumGrey, tabs: const [Tab(text: "Feed"), Tab(text: "Forums"), Tab(text: "Events")])),
        Expanded(child: TabBarView(controller: _tabCtrl, children: [_buildFeed(), _buildForums(), _buildEvents()])),
      ]),
      floatingActionButton: FloatingActionButton.extended(onPressed: () {}, backgroundColor: AppColors.primaryGold, foregroundColor: AppColors.primaryBlack, icon: const Icon(Icons.add), label: const Text("New Post")),
    );
  }

  Widget _buildFeed() {
    if (_posts.isEmpty) return const Center(child: CircularProgressIndicator(color: AppColors.primaryGold));
    return ListView.separated(padding: const EdgeInsets.all(16), itemCount: _posts.length, separatorBuilder: (_, __) => const SizedBox(height: 12), itemBuilder: (c, i) {
      final post = _posts[i];
      return Container(decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(14), border: Border.all(color: post.isFeatured ? AppColors.primaryGold.withOpacity(0.3) : AppColors.primaryBlackLighter)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ListTile(
          leading: CircleAvatar(radius: 18, backgroundColor: AppColors.primaryGold.withOpacity(0.15), child: Text(post.authorName.split(' ').map((e) => e[0]).join(), style: const TextStyle(fontSize: 10, color: AppColors.primaryGold))),
          title: Text(post.authorName, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
          subtitle: Text("${post.schoolName} • ${_timeAgo(post.createdAt)} • ${post.type.name}", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)),
          trailing: Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: post.isForCritique ? Colors.orangeAccent.withOpacity(0.15) : AppColors.primaryBlackLight, borderRadius: BorderRadius.circular(6)), child: Text(post.isForCritique ? "Critique Request" : post.type.name, style: GoogleFonts.poppins(fontSize: 8, color: post.isForCritique ? Colors.orangeAccent : AppColors.mediumGrey))),
        ),
        Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 8), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(post.title, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
          const SizedBox(height: 4),
          Text(post.content, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.mediumGrey), maxLines: 3),
        ])),
        if (post.imageUrls.isNotEmpty) ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(post.imageUrls.first, width: double.infinity, height: 180, fit: BoxFit.cover)),
        Padding(padding: const EdgeInsets.all(12), child: Row(children: [
          _reaction(Icons.favorite, "${post.likes} likes", AppColors.error),
          const SizedBox(width: 12),
          _reaction(Icons.comment, "${post.commentsCount} comments", Colors.blueAccent),
          const Spacer(),
          const Icon(Icons.share, size: 14, color: AppColors.mediumGrey),
        ])),
      ]));
    });
  }

  Widget _buildForums() {
    if (_forums.isEmpty) return const Center(child: CircularProgressIndicator(color: AppColors.primaryGold));
    return ListView.separated(padding: const EdgeInsets.all(16), itemCount: _forums.length, separatorBuilder: (_, __) => const SizedBox(height: 10), itemBuilder: (c, i) {
      final f = _forums[i];
      return Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(12)), child: Row(children: [
        Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.primaryGold.withOpacity(0.15), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.forum, color: AppColors.primaryGold, size: 18)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(f.title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primaryWhite)),
          Text(f.description, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey), maxLines: 2),
          Text("${f.postCount} posts • ${f.memberCount} members • Last by ${f.lastActivityBy}", style: GoogleFonts.poppins(fontSize: 9, color: AppColors.darkGrey)),
        ])),
      ]));
    });
  }

  Widget _buildEvents() {
    if (_events.isEmpty) return const Center(child: CircularProgressIndicator(color: AppColors.primaryGold));
    return ListView.separated(padding: const EdgeInsets.all(16), itemCount: _events.length, separatorBuilder: (_, __) => const SizedBox(height: 12), itemBuilder: (c, i) {
      final e = _events[i];
      return Container(decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(14)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(14)), child: Image.network(e.imageUrl ?? 'https://images.unsplash.com/photo-1541961017774-22349e4a1262?w=800', height: 120, width: double.infinity, fit: BoxFit.cover)),
        Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: e.isNational ? AppColors.primaryGold.withOpacity(0.15) : Colors.blueAccent.withOpacity(0.15), borderRadius: BorderRadius.circular(6)), child: Text(e.isNational ? "National" : "Local", style: GoogleFonts.poppins(fontSize: 8, fontWeight: FontWeight.bold, color: e.isNational ? AppColors.primaryGold : Colors.blueAccent))),
            const SizedBox(width: 6),
            if (e.isVirtual) Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppColors.success.withOpacity(0.15), borderRadius: BorderRadius.circular(6)), child: Text("Virtual", style: GoogleFonts.poppins(fontSize: 8, color: AppColors.success))),
          ]),
          const SizedBox(height: 8),
          Text(e.title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primaryWhite)),
          Text(e.description, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey), maxLines: 2),
          const SizedBox(height: 6),
          Text("${e.date.day}/${e.date.month} • ${e.location} • ${e.attendees} attendees", style: GoogleFonts.poppins(fontSize: 9, color: AppColors.darkGrey)),
        ])),
      ]));
    });
  }

  Widget _reaction(IconData icon, String label, Color color) {
    return Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 14, color: color), const SizedBox(width: 4), Text(label, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey))]);
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inHours < 24) return "${diff.inHours}h ago";
    return "${diff.inDays}d ago";
  }
}
