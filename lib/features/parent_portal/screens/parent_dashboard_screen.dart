import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/parent/parent_model.dart';
import '../../../services/national/national_dashboard_service.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../core/offline/offline_banner.dart';

class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
  final ParentService _service = ParentService();
  ParentProfile? _parent;
  List<ChildProgressSummary> _childrenProgress = [];
  List<ParentNotification> _notifications = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await _service.getParentProfile('parent1');
    final prog = await _service.getChildrenProgress('parent1');
    final notifs = await _service.getParentNotifications('parent1');
    setState(() {
      _parent = p;
      _childrenProgress = prog;
      _notifications = notifs;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: const CustomAppBar(title: "Parent Portal", subtitle: "Monitor child progress, consents, competitions, offline queue"),
      body: _loading ? const Center(child: CircularProgressIndicator(color: AppColors.primaryGold)) : Column(children: [
        const OfflineBanner(),
        Expanded(
          child: ListView(padding: const EdgeInsets.all(16), children: [
            // Parent header
            Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(gradient: AppColors.cardGradient, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.primaryGold.withOpacity(0.2))), child: Row(children: [
              CircleAvatar(radius: 28, backgroundColor: AppColors.primaryGold.withOpacity(0.15), child: Text(_parent!.name.split(' ').map((e) => e[0]).join(), style: const TextStyle(color: AppColors.primaryGold))),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(_parent!.name, style: GoogleFonts.playfairDisplay(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
                Text(_parent!.email, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.mediumGrey)),
                const SizedBox(height: 4),
                Row(children: [
                  _consentChip("AI ${ _parent!.hasConsentedAI ? '✓' : '✗'}", _parent!.hasConsentedAI),
                  const SizedBox(width: 4),
                  _consentChip("Competition ${ _parent!.hasConsentedCompetition ? '✓' : '✗'}", _parent!.hasConsentedCompetition),
                  const SizedBox(width: 4),
                  _consentChip("Exhibition ${ _parent!.hasConsentedExhibition ? '✓' : '✗'}", _parent!.hasConsentedExhibition),
                ]),
              ])),
              IconButton(icon: const Icon(Icons.settings, color: AppColors.mediumGrey, size: 18), onPressed: () => Navigator.pushNamed(context, '/privacySettings')),
            ])),
            const SizedBox(height: 20),
            Text("My Children - Linked Accounts", style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
            const SizedBox(height: 12),
            ..._childrenProgress.map((child) => Container(margin: const EdgeInsets.only(bottom: 14), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.primaryBlackLighter)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ListTile(
                leading: Stack(children: [
                  CircleAvatar(radius: 24, backgroundColor: AppColors.primaryGold.withOpacity(0.15), child: Text(child.childName.split(' ').map((e) => e[0]).join(), style: const TextStyle(color: AppColors.primaryGold, fontSize: 12))),
                  if (child.offlinePendingCount > 0) Positioned(bottom: 0, right: 0, child: Container(width: 16, height: 16, decoration: BoxDecoration(color: Colors.orangeAccent, shape: BoxShape.circle, border: Border.all(color: AppColors.cardBlack, width: 1)), child: Center(child: Text("${child.offlinePendingCount}", style: const TextStyle(fontSize: 8, color: Colors.white))))),
                ]),
                title: Text(child.childName, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primaryWhite)),
                subtitle: Text("${child.lessonsCompleted} lessons • ${child.assignmentsSubmitted} assignments • ${child.competitionsParticipated} competitions • ${child.certificatesEarned} certificates • Avg ${child.avgScore}%", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)),
                trailing: Column(children: [
                  Text("${(child.overallProgress * 100).toInt()}%", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.primaryGold)),
                  if (child.lowBandwidthActive) Container(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1), decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.15), borderRadius: BorderRadius.circular(4)), child: Text("Low-BW", style: GoogleFonts.poppins(fontSize: 7, color: Colors.blueAccent))),
                ]),
              ),
              Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: child.overallProgress, backgroundColor: AppColors.primaryBlackLighter, color: AppColors.primaryGold, minHeight: 6)),
                const SizedBox(height: 10),
                Wrap(spacing: 6, children: [
                  _smallStat(Icons.star, child.strongestModule ?? 'Elements 82%', AppColors.success),
                  _smallStat(Icons.warning, child.weakestModule ?? 'Perspective 30%', Colors.orangeAccent),
                  if (child.offlinePendingCount > 0) _smallStat(Icons.wifi_off, "${child.offlinePendingCount} offline pending sync", Colors.orangeAccent),
                ]),
                const SizedBox(height: 10),
                if (child.aiInsight != null) Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.primaryGold.withOpacity(0.08), borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.primaryGold.withOpacity(0.2))), child: Row(children: [
                  const Icon(Icons.auto_awesome, size: 12, color: AppColors.primaryGold),
                  const SizedBox(width: 6),
                  Expanded(child: Text("AI Insight: ${child.aiInsight}", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.goldLight))),
                ])),
                const SizedBox(height: 10),
                Text("Recent Achievements", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
                const SizedBox(height: 6),
                ...child.recentAchievements.map((ach) => Padding(padding: const EdgeInsets.only(bottom: 4), child: Row(children: [Container(width: 4, height: 4, decoration: const BoxDecoration(color: AppColors.primaryGold, shape: BoxShape.circle)), const SizedBox(width: 6), Expanded(child: Text(ach, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.offWhite)))]))),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.visibility, size: 14), label: const Text("View Progress", style: TextStyle(fontSize: 10)))),
                  const SizedBox(width: 8),
                  Expanded(child: ElevatedButton.icon(onPressed: () => Navigator.pushNamed(context, '/aiAnalytics'), icon: const Icon(Icons.insights, size: 14), label: const Text("AI Analytics", style: TextStyle(fontSize: 10)))),
                ]),
              ])),
            ]))),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text("Notifications for Parents", style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
              TextButton(onPressed: () {}, child: Text("Mark all read", style: GoogleFonts.poppins(fontSize: 11, color: AppColors.primaryGold))),
            ]),
            const SizedBox(height: 8),
            ..._notifications.map((n) => Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: n.isRead ? AppColors.cardBlack : AppColors.primaryBlackLight, borderRadius: BorderRadius.circular(12), border: Border.all(color: n.isRead ? Colors.transparent : AppColors.primaryGold.withOpacity(0.2))), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(width: 36, height: 36, decoration: BoxDecoration(color: _notifColor(n.type).withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: Icon(_notifIcon(n.type), size: 16, color: _notifColor(n.type))),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(n.title, style: GoogleFonts.poppins(fontSize: 11, fontWeight: n.isRead ? FontWeight.normal : FontWeight.bold, color: AppColors.primaryWhite)),
                Text(n.body, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey), maxLines: 2),
                Text("${n.createdAt.day}/${n.createdAt.month} • ${n.type.name}", style: GoogleFonts.poppins(fontSize: 9, color: AppColors.darkGrey)),
              ])),
              if (!n.isRead) Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primaryGold, shape: BoxShape.circle)),
            ]))),
            const SizedBox(height: 20),
            Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.primaryBlackLight, borderRadius: BorderRadius.circular(12)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [const Icon(Icons.security, size: 14, color: AppColors.success), const SizedBox(width: 6), Text("Parental Consent & Security - Phase 5", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.primaryWhite))]),
              const SizedBox(height: 6),
              Text("• Parental consent required for AI, Competition, Exhibition - managed via parent portal\n• Child data encryption AES-256, role-based parent sees only own children (schoolId + childId linkage)\n• Offline queue: parent sees child's offline pending count, low-bandwidth mode status\n• AI analytics visible to parent with child consent\n• Communication: secure messaging teacher-parent, announcements filtered per child\n• Future: Fee management, attendance tracking, career guidance consent", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey, height: 1.4)),
            ])),
            const SizedBox(height: 100),
          ]),
        ),
      ]),
    );
  }

  Widget _consentChip(String label, bool granted) {
    return Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: granted ? AppColors.success.withOpacity(0.15) : AppColors.error.withOpacity(0.15), borderRadius: BorderRadius.circular(6)), child: Text(label, style: GoogleFonts.poppins(fontSize: 8, fontWeight: FontWeight.bold, color: granted ? AppColors.success : AppColors.error)));
  }

  Widget _smallStat(IconData icon, String label, Color color) {
    return Container(margin: const EdgeInsets.only(right: 6, bottom: 4), padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 10, color: color), const SizedBox(width: 4), Text(label, style: GoogleFonts.poppins(fontSize: 9, color: color))]));
  }

  Color _notifColor(type) {
    switch (type) {
      case CommunicationType.progressUpdate: return Colors.blueAccent;
      case CommunicationType.competitionAlert: return Colors.purpleAccent;
      case CommunicationType.announcement: return AppColors.primaryGold;
      default: return AppColors.mediumGrey;
    }
  }

  IconData _notifIcon(type) {
    switch (type) {
      case CommunicationType.progressUpdate: return Icons.trending_up;
      case CommunicationType.competitionAlert: return Icons.emoji_events;
      case CommunicationType.announcement: return Icons.announcement;
      default: return Icons.notifications;
    }
  }
}
