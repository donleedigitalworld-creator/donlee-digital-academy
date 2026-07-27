import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/announcement_model.dart';
import '../../../widgets/custom_app_bar.dart';

class AnnouncementsScreen extends StatelessWidget {
  const AnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final announcements = [
      AnnouncementModel(id: '1', title: 'New Assignment: Loomis Heads Due Friday', body: 'All beginner classes - Please submit 5 angles. Camera capture required for verification. Teacher will review proportions and give feedback.', authorId: 't1', authorName: 'Ms. Amara', createdAt: DateTime.now().subtract(const Duration(hours: 3)), priority: AnnouncementPriority.high, audience: AnnouncementAudience.class_, classId: 'c1'),
      AnnouncementModel(id: '2', title: 'Live Q&A - Portrait Tips - Tomorrow 6PM WAT', body: 'Join Google Meet for live demo on eye drawing. Link will be shared in class group. Bring your sketchbooks!', authorId: 't1', authorName: 'Donlee Academy', createdAt: DateTime.now().subtract(const Duration(days: 1)), priority: AnnouncementPriority.urgent, imageUrl: 'https://images.unsplash.com/photo-1541961017774-22349e4a1262?w=800'),
      AnnouncementModel(id: '3', title: 'Certificate Issued - Color Theory Module', body: 'Congratulations to 12 students who completed Color Theory. Certificates available in portfolio > certificates. Donlee Gold standard!', authorId: 'admin1', authorName: 'Donlee Admin', createdAt: DateTime.now().subtract(const Duration(days: 2)), priority: AnnouncementPriority.normal),
    ];

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: CustomAppBar(title: "Announcements", subtitle: "From teachers & academy", showBack: true, actions: [IconButton(icon: const Icon(Icons.add, color: AppColors.primaryGold), onPressed: () => Navigator.pushNamed(context, '/createAnnouncement'))]),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: announcements.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (c, i) {
          final ann = announcements[i];
          return Container(
            decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(16), border: Border.all(color: ann.priority == AnnouncementPriority.urgent ? AppColors.error.withOpacity(0.3) : ann.priority == AnnouncementPriority.high ? AppColors.primaryGold.withOpacity(0.3) : Colors.transparent)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (ann.imageUrl != null) ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(16)), child: Image.network(ann.imageUrl!, height: 140, width: double.infinity, fit: BoxFit.cover)),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: ann.priority == AnnouncementPriority.urgent ? AppColors.error.withOpacity(0.15) : AppColors.primaryGold.withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: Text(ann.priority.name.toUpperCase(), style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.bold, color: ann.priority == AnnouncementPriority.urgent ? AppColors.error : AppColors.primaryGold))),
                    const SizedBox(width: 8),
                    Text("${ann.createdAt.day}/${ann.createdAt.month} • by ${ann.authorName}", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)),
                  ]),
                  const SizedBox(height: 10),
                  Text(ann.title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
                  const SizedBox(height: 6),
                  Text(ann.body, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.mediumGrey, height: 1.5)),
                ]),
              ),
            ]),
          );
        },
      ),
    );
  }
}

class CreateAnnouncementScreen extends StatefulWidget {
  const CreateAnnouncementScreen({super.key});

  @override
  State<CreateAnnouncementScreen> createState() => _CreateAnnouncementScreenState();
}

class _CreateAnnouncementScreenState extends State<CreateAnnouncementScreen> {
  final _titleCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();
  AnnouncementPriority _priority = AnnouncementPriority.normal;
  AnnouncementAudience _audience = AnnouncementAudience.class_;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(backgroundColor: AppColors.primaryBlack, leading: IconButton(icon: const Icon(Icons.close, color: AppColors.primaryWhite), onPressed: () => Navigator.pop(context)), title: Text("New Announcement", style: GoogleFonts.playfairDisplay(color: AppColors.primaryWhite, fontWeight: FontWeight.bold))),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        TextField(controller: _titleCtrl, style: const TextStyle(color: AppColors.primaryWhite), decoration: const InputDecoration(labelText: 'Title *', prefixIcon: Icon(Icons.title, color: AppColors.primaryGold))),
        const SizedBox(height: 12),
        TextField(controller: _bodyCtrl, maxLines: 5, style: const TextStyle(color: AppColors.primaryWhite), decoration: const InputDecoration(labelText: 'Message *', alignLabelWithHint: true)),
        const SizedBox(height: 16),
        DropdownButtonFormField<AnnouncementPriority>(value: _priority, decoration: const InputDecoration(labelText: 'Priority'), dropdownColor: AppColors.cardBlack, style: const TextStyle(color: AppColors.primaryWhite), items: AnnouncementPriority.values.map((p) => DropdownMenuItem(value: p, child: Text(p.name.toUpperCase()))).toList(), onChanged: (v) => setState(() => _priority = v!)),
        const SizedBox(height: 12),
        DropdownButtonFormField<AnnouncementAudience>(value: _audience, decoration: const InputDecoration(labelText: 'Audience'), dropdownColor: AppColors.cardBlack, style: const TextStyle(color: AppColors.primaryWhite), items: AnnouncementAudience.values.map((a) => DropdownMenuItem(value: a, child: Text(a.name.replaceAll('_', ' ').toUpperCase()))).toList(), onChanged: (v) => setState(() => _audience = v!)),
        const SizedBox(height: 24),
        SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: () { Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Announcement sent to students!"), backgroundColor: AppColors.success)); }, icon: const Icon(Icons.send), label: const Text("SEND ANNOUNCEMENT"))),
      ]),
    );
  }
}
