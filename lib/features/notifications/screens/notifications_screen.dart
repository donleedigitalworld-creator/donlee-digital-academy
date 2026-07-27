import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../models/artwork_model.dart';
import '../../../services/firestore_service.dart';
import 'package:provider/provider.dart';
import '../../../services/auth_service.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final firestore = FirestoreService();
    final uid = auth.currentFirebaseUser?.uid ?? 'global';

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: CustomAppBar(title: "Notifications", subtitle: "New lessons & challenges", showBack: true, actions: [TextButton(onPressed: () {}, child: Text("Mark all read", style: GoogleFonts.poppins(fontSize: 12, color: AppColors.primaryGold)))]),
      body: StreamBuilder<List<NotificationModel>>(
        stream: firestore.getUserNotifications(uid),
        builder: (context, snapshot) {
          final notifications = snapshot.data ?? [
            NotificationModel(id: '1', title: 'Welcome to Donlee Academy!', body: 'Start your journey with Introduction to Fine Art. Your creativity awaits!', type: 'lesson', isRead: false, createdAt: DateTime.now().subtract(const Duration(hours: 2)), actionLink: 'intro_fine_art'),
            NotificationModel(id: '2', title: 'New Challenge: 7-Day Sketch', body: 'Challenge yourself to sketch for 7 days straight. Share in gallery!', type: 'challenge', isRead: false, createdAt: DateTime.now().subtract(const Duration(days: 1))),
            NotificationModel(id: '3', title: 'Color Theory Lesson Updated', body: 'We added new step-by-step tutorials for understanding complementary colors.', type: 'lesson', isRead: true, createdAt: DateTime.now().subtract(const Duration(days: 2)), actionLink: 'color_theory'),
          ];

          if (notifications.isEmpty) {
            return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.notifications_none, size: 64, color: AppColors.mediumGrey.withOpacity(0.5)), const SizedBox(height: 16), Text("All caught up!", style: GoogleFonts.poppins(color: AppColors.mediumGrey))]));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final n = notifications[index];
              return Container(
                decoration: BoxDecoration(color: n.isRead ? AppColors.cardBlack : AppColors.primaryBlackLight, borderRadius: BorderRadius.circular(16), border: Border.all(color: n.isRead ? Colors.transparent : AppColors.primaryGold.withOpacity(0.2))),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Container(width: 48, height: 48, decoration: BoxDecoration(color: n.type == 'challenge' ? AppColors.error.withOpacity(0.15) : n.type == 'lesson' ? AppColors.primaryGold.withOpacity(0.15) : AppColors.mediumGrey.withOpacity(0.15), shape: BoxShape.circle), child: Icon(n.type == 'challenge' ? Icons.emoji_events : n.type == 'lesson' ? Icons.school : Icons.notifications, color: n.type == 'challenge' ? AppColors.error : n.type == 'lesson' ? AppColors.primaryGold : AppColors.mediumGrey, size: 22)),
                  title: Row(children: [Expanded(child: Text(n.title, style: GoogleFonts.poppins(fontSize: 13, fontWeight: n.isRead ? FontWeight.normal : FontWeight.bold, color: AppColors.primaryWhite))), if (!n.isRead) Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primaryGold, shape: BoxShape.circle))]),
                  subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const SizedBox(height: 4),
                    Text(n.body, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.mediumGrey, height: 1.4), maxLines: 3, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 8),
                    Text(_timeAgo(n.createdAt), style: GoogleFonts.poppins(fontSize: 10, color: AppColors.darkGrey)),
                  ]),
                  onTap: () {
                    if (n.actionLink != null) {
                      Navigator.pushNamed(context, '/modules');
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return "${diff.inMinutes}m ago";
    if (diff.inHours < 24) return "${diff.inHours}h ago";
    return "${diff.inDays}d ago";
  }
}
