import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/cms/cms_model.dart';
import '../../../widgets/custom_app_bar.dart';

class AssetManagerScreen extends StatelessWidget {
  const AssetManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final assets = [
      LessonAsset(id: 'a1', name: 'Loomis Head Diagram - Front View', type: AssetType.image, url: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800', sizeKB: 342, isOfflineAvailable: true, uploadedAt: DateTime.now().subtract(const Duration(days: 2)), uploadedBy: 'Ms. Amara Teacher'),
      LessonAsset(id: 'a2', name: 'Value Scale 9 Steps - Printable PDF', type: AssetType.pdf, url: '', sizeKB: 1200, isOfflineAvailable: true, uploadedAt: DateTime.now().subtract(const Duration(days: 5)), uploadedBy: 'Donlee Admin'),
      LessonAsset(id: 'a3', name: 'Perspective 2-Point Grid Template', type: AssetType.template, url: '', sizeKB: 560, isOfflineAvailable: true, uploadedAt: DateTime.now().subtract(const Duration(days: 1)), uploadedBy: 'Teacher PD Center'),
    ];

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: const CustomAppBar(title: "CMS Asset Manager", subtitle: "Images, videos, PDFs, templates - offline available, versioned - Phase 6"),
      body: ListView.separated(padding: const EdgeInsets.all(16), itemCount: assets.length, separatorBuilder: (_, __) => const SizedBox(height: 10), itemBuilder: (c, i) {
        final asset = assets[i];
        return Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(12)), child: Row(children: [
          Container(width: 40, height: 40, decoration: BoxDecoration(color: _typeColor(asset.type).withOpacity(0.15), borderRadius: BorderRadius.circular(10)), child: Icon(_typeIcon(asset.type), color: _typeColor(asset.type), size: 18)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(asset.name, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
            Text("${asset.type.name} • ${asset.sizeKB} KB • ${asset.isOfflineAvailable ? 'Offline DL OK' : 'Online only'} • by ${asset.uploadedBy} • ${asset.uploadedAt.day}/${asset.uploadedAt.month}", style: GoogleFonts.poppins(fontSize: 9, color: AppColors.mediumGrey)),
          ])),
          IconButton(icon: const Icon(Icons.more_vert, size: 16, color: AppColors.mediumGrey), onPressed: () {}),
        ]));
      }),
    );
  }

  Color _typeColor(AssetType t) {
    switch (t) {
      case AssetType.image: return Colors.blueAccent;
      case AssetType.video: return Colors.purpleAccent;
      case AssetType.pdf: return AppColors.error;
      case AssetType.template: return AppColors.primaryGold;
      default: return AppColors.mediumGrey;
    }
  }

  IconData _typeIcon(AssetType t) {
    switch (t) {
      case AssetType.image: return Icons.image;
      case AssetType.video: return Icons.video_library;
      case AssetType.pdf: return Icons.picture_as_pdf;
      case AssetType.template: return Icons.grid_view;
      default: return Icons.attachment;
    }
  }
}

class ReviewQueueScreen extends StatelessWidget {
  const ReviewQueueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: const CustomAppBar(title: "CMS Review Queue", subtitle: "Teacher review, approval workflow, versioning, scheduling - Phase 6"),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.primaryGold.withOpacity(0.08), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.primaryGold.withOpacity(0.2))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [const Icon(Icons.security, size: 14, color: AppColors.primaryGold), const SizedBox(width: 6), Text("Approval Workflow - Teacher Reviewed Before Publishing", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryWhite))]),
          const SizedBox(height: 6),
          Text("Draft → In Review (teacher reviewer assigned) → Approved (teacher-approved flag) → Published (scheduled publish supported) → Archived. Each version increments version number, assets versioned, comments thread for feedback. Low-BW optimized flag ensures compressed images for rural areas. National competition lessons flagged isForNationalCompetition.", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey, height: 1.4)),
        ])),
        const SizedBox(height: 20),
        ...List.generate(3, (i) => Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.orangeAccent.withOpacity(0.3))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text("Draft #${i + 1}: Loomis Head - Common Mistakes", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.orangeAccent.withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: Text("In Review", style: GoogleFonts.poppins(fontSize: 9, color: Colors.orangeAccent))),
          ]),
          const SizedBox(height: 8),
          Text("Reviewer: Prof. Nike Davies • 2 comments • Version 2 • Low-BW optimized", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)),
          const SizedBox(height: 10),
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.primaryBlackLight, borderRadius: BorderRadius.circular(8)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Comment from Prof. Nike:", style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primaryGold)),
            Text("Add more on jaw 10% long common mistake - use AI analytics data (32% students struggle). Also mention camera verification for original work.", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)),
          ])),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: OutlinedButton(onPressed: () {}, child: const Text("View Draft", style: TextStyle(fontSize: 10)))),
            const SizedBox(width: 8),
            Expanded(child: ElevatedButton(onPressed: () {}, child: const Text("Approve & Publish", style: TextStyle(fontSize: 10)))),
          ]),
        ]))),
      ]),
    );
  }
}
