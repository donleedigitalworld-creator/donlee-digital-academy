import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../services/offline_service.dart';
import '../../../services/sync_service.dart';
import '../../../widgets/custom_app_bar.dart';

class OfflineModeScreen extends StatefulWidget {
  const OfflineModeScreen({super.key});

  @override
  State<OfflineModeScreen> createState() => _OfflineModeScreenState();
}

class _OfflineModeScreenState extends State<OfflineModeScreen> {
  final SyncService _syncService = SyncService();

  @override
  void initState() {
    super.initState();
    Provider.of<OfflineService>(context, listen: false).init();
  }

  @override
  Widget build(BuildContext context) {
    final offline = Provider.of<OfflineService>(context);
    final pending = offline.pendingQueue;

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: const CustomAppBar(title: "Offline Mode & Smart Sync", subtitle: "Low-bandwidth, offline learning, queue", showBack: true),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: offline.isOnline ? AppColors.success.withOpacity(0.1) : Colors.orangeAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(16), border: Border.all(color: offline.isOnline ? AppColors.success.withOpacity(0.3) : Colors.orangeAccent.withOpacity(0.3))), child: Row(children: [
            Icon(offline.isOnline ? Icons.wifi : Icons.wifi_off, color: offline.isOnline ? AppColors.success : Colors.orangeAccent),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(offline.isOnline ? "Online - Smart Sync Active" : "Offline - Queue Mode Active", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13, color: offline.isOnline ? AppColors.success : Colors.orangeAccent)),
              Text(offline.isOnline ? "${pending.length} items pending sync • Auto-sync when back online" : "Your submissions saved locally • Will auto-sync when internet returns • No duplicate", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)),
            ])),
          ])),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(child: _toggleCard("Low-Bandwidth Mode", "Compress images, thumbnail-first", Icons.signal_cellular_alt, offline.lowBandwidthMode, (v) => offline.setLowBandwidthMode(v))),
            const SizedBox(width: 12),
            Expanded(child: _toggleCard("Offline Learning", "Download lessons, quizzes offline", Icons.download, offline.offlineModeEnabled, (v) => offline.setOfflineModeEnabled(v))),
          ]),
          const SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text("Sync Queue (${pending.length})", style: GoogleFonts.playfairDisplay(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
            if (pending.isNotEmpty) ElevatedButton.icon(onPressed: offline.isOnline ? () async { final result = await _syncService.syncQueue(offline); if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Synced ${result.synced}, failed ${result.failed}"), backgroundColor: result.isSuccess ? AppColors.success : AppColors.error)); } : null, icon: const Icon(Icons.sync, size: 16), label: const Text("Sync Now", style: TextStyle(fontSize: 12)), style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryGold, foregroundColor: AppColors.primaryBlack)),
          ]),
          const SizedBox(height: 12),
          if (pending.isEmpty) Container(padding: const EdgeInsets.all(24), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(16)), child: Column(children: [Icon(Icons.cloud_done, size: 48, color: AppColors.mediumGrey.withOpacity(0.5)), const SizedBox(height: 12), Text("All synced! No pending offline work", style: GoogleFonts.poppins(color: AppColors.mediumGrey)), Text("Camera/gallery uploads, lesson progress, quiz results all up to date", style: GoogleFonts.poppins(fontSize: 11, color: AppColors.darkGrey), textAlign: TextAlign.center)]))
          else ...pending.map((item) => Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(12), border: Border.all(color: item.syncStatus == SyncStatus.failed ? AppColors.error.withOpacity(0.3) : AppColors.primaryBlackLighter)), child: Row(children: [
            Container(width: 36, height: 36, decoration: BoxDecoration(color: _actionColor(item.actionType).withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: Icon(_actionIcon(item.actionType), color: _actionColor(item.actionType), size: 18)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("${item.actionType.name} • ${item.competitionId ?? item.assignmentId ?? ''}", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
              Text(item.payload['title'] ?? item.payload['lessonId'] ?? item.localId, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey), maxLines: 1),
              const SizedBox(height: 4),
              Row(children: [
                Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: _statusColor(item.syncStatus).withOpacity(0.15), borderRadius: BorderRadius.circular(6)), child: Text(item.syncStatus.name, style: GoogleFonts.poppins(fontSize: 8, color: _statusColor(item.syncStatus)))),
                const SizedBox(width: 6),
                Text("${item.localImagePaths.length} photos • ${item.createdAt.day}/${item.createdAt.month}", style: GoogleFonts.poppins(fontSize: 9, color: AppColors.darkGrey)),
                if (item.lowBandwidthMode) ...[const SizedBox(width: 6), Container(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1), decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.15), borderRadius: BorderRadius.circular(4)), child: Text("Low-BW", style: GoogleFonts.poppins(fontSize: 7, color: Colors.blueAccent)))],
              ]),
            ])),
            IconButton(icon: const Icon(Icons.delete_outline, size: 16, color: AppColors.mediumGrey), onPressed: () => offline.removeFromQueue(item.localId)),
          ]))),
          const SizedBox(height: 20),
          Text("Offline Learning", style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
          const SizedBox(height: 12),
          Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(12)), child: Column(children: [
            _offlineLessonTile("Elements of Art - Line & Shape", "12 min • 3 steps • Quiz 2 Qs", true),
            const Divider(color: AppColors.primaryBlackLighter),
            _offlineLessonTile("Loomis Head Method", "30 min • 4 steps • Offline quiz pending sync", false, isPending: true),
            const Divider(color: AppColors.primaryBlackLighter),
            _offlineLessonTile("Color Theory - Color Wheel", "22 min • Not downloaded", false, isDownloaded: false),
          ])),
          const SizedBox(height: 20),
          Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.primaryBlackLight, borderRadius: BorderRadius.circular(12)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("How Offline + Smart Sync Works - Phase 3", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primaryWhite)),
            const SizedBox(height: 8),
            Text("1. Student prepares competition artwork in low-connectivity area\n2. Camera/gallery capture → saved locally with UUID localId, no duplicate\n3. OfflineQueueItem stored in SharedPreferences (payload + localImagePaths)\n4. When online detected (Connectivity Plus), SyncService uploads images to Firebase Storage (compressed if low-bandwidth), creates Firestore docs\n5. For assignments/lessons: lessonProgress and quizResult also queued\n6. Low-bandwidth mode: 40% quality, maxWidth 800, thumbnail-first judging\n7. Secure: local queue encrypted at rest via Hive optional, role-based after sync\n8. Teacher scoring also works offline, queued similarly", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey, height: 1.5)),
          ])),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _toggleCard(String title, String sub, IconData icon, bool value, Function(bool) onChanged) {
    return Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(12), border: Border.all(color: value ? AppColors.primaryGold.withOpacity(0.3) : AppColors.primaryBlackLighter)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Icon(icon, size: 16, color: value ? AppColors.primaryGold : AppColors.mediumGrey), const Spacer(), Switch(value: value, activeColor: AppColors.primaryGold, materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, onChanged: onChanged)]),
      const SizedBox(height: 8),
      Text(title, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
      Text(sub, style: GoogleFonts.poppins(fontSize: 9, color: AppColors.mediumGrey)),
    ]));
  }

  Widget _offlineLessonTile(String title, String sub, bool isDownloaded, {bool isPending = false, bool isDownloadedFlag = true}) {
    return Row(children: [
      Container(width: 36, height: 36, decoration: BoxDecoration(color: isDownloadedFlag ? AppColors.success.withOpacity(0.15) : AppColors.primaryBlackLighter, borderRadius: BorderRadius.circular(8)), child: Icon(isDownloadedFlag ? Icons.download_done : Icons.download, color: isDownloadedFlag ? AppColors.success : AppColors.mediumGrey, size: 18)),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
        Text(sub, style: GoogleFonts.poppins(fontSize: 9, color: AppColors.mediumGrey)),
        if (isPending) Container(margin: const EdgeInsets.only(top: 4), padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.orangeAccent.withOpacity(0.15), borderRadius: BorderRadius.circular(6)), child: Text("Quiz pending sync", style: GoogleFonts.poppins(fontSize: 8, color: Colors.orangeAccent))),
      ])),
      if (!isDownloadedFlag) OutlinedButton(onPressed: () {}, child: const Text("Download", style: TextStyle(fontSize: 10))),
    ]);
  }

  Color _actionColor(action) {
    switch (action) {
      case OfflineActionType.competitionSubmission: return Colors.purpleAccent;
      case OfflineActionType.assignmentSubmission: return AppColors.primaryGold;
      case OfflineActionType.lessonProgress: return Colors.blueAccent;
      default: return AppColors.mediumGrey;
    }
  }

  IconData _actionIcon(action) {
    switch (action) {
      case OfflineActionType.competitionSubmission: return Icons.emoji_events;
      case OfflineActionType.assignmentSubmission: return Icons.assignment;
      case OfflineActionType.lessonProgress: return Icons.school;
      case OfflineActionType.quizResult: return Icons.quiz;
      default: return Icons.cloud;
    }
  }

  Color _statusColor(SyncStatus s) {
    switch (s) {
      case SyncStatus.synced: return AppColors.success;
      case SyncStatus.failed: return AppColors.error;
      case SyncStatus.syncing: return Colors.blueAccent;
      default: return Colors.orangeAccent;
    }
  }
}
