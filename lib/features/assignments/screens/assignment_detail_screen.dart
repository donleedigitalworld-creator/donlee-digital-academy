import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/assignment_model.dart';
import '../../../widgets/custom_app_bar.dart';

class AssignmentDetailScreen extends StatelessWidget {
  final AssignmentModel assignment;
  const AssignmentDetailScreen({super.key, required this.assignment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: CustomAppBar(title: assignment.title, subtitle: "By ${assignment.teacherName} • Due in ${assignment.daysLeft} days", showBack: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: AppColors.primaryGold.withOpacity(0.15), borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.primaryGold.withOpacity(0.3))), child: Text(assignment.moduleId?.toUpperCase() ?? 'GENERAL', style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primaryGold))),
            const SizedBox(width: 8),
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(20)), child: Text("${assignment.maxScore} Points", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey))),
            if (assignment.requireCameraPhoto) ...[const SizedBox(width: 8), Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: AppColors.success.withOpacity(0.15), borderRadius: BorderRadius.circular(20)), child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.camera_alt, size: 12, color: AppColors.success), const SizedBox(width: 4), Text("Camera Capture Required", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.success))] ))],
          ]),
          const SizedBox(height: 20),
          Text("Description", style: GoogleFonts.playfairDisplay(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
          const SizedBox(height: 8),
          Text(assignment.description, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.offWhite, height: 1.5)),
          const SizedBox(height: 20),
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.primaryBlackLighter)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [const Icon(Icons.list_alt, size: 16, color: AppColors.primaryGold), const SizedBox(width: 8), Text("Instructions", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primaryWhite))]),
            const SizedBox(height: 12),
            Text(assignment.instructions, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.mediumGrey, height: 1.6)),
          ])),
          const SizedBox(height: 20),
          if (assignment.referenceImageUrls.isNotEmpty) ...[
            Text("Reference Images", style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
            const SizedBox(height: 10),
            SizedBox(height: 100, child: ListView.separated(scrollDirection: Axis.horizontal, itemCount: assignment.referenceImageUrls.length, separatorBuilder: (_, __) => const SizedBox(width: 10), itemBuilder: (c, i) => ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(assignment.referenceImageUrls[i], width: 100, height: 100, fit: BoxFit.cover)))),
            const SizedBox(height: 20),
          ],
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.primaryGold.withOpacity(0.08), borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.primaryGold.withOpacity(0.2))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [const Icon(Icons.camera_alt, color: AppColors.primaryGold, size: 18), const SizedBox(width: 8), Text("How to Submit - Phase 2 Camera Upload", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primaryWhite))]),
            const SizedBox(height: 10),
            Text("1. Complete drawing on paper\n2. Use CAMERA button to capture drawing - secure verification\n3. Or upload from GALLERY if allowed\n4. Add notes on what you learned\n5. Submit - teacher will review, annotate & score", style: GoogleFonts.poppins(fontSize: 11, color: AppColors.mediumGrey, height: 1.6)),
            const SizedBox(height: 12),
            Row(children: [Icon(Icons.security, size: 14, color: AppColors.primaryGold.withOpacity(0.7)), const SizedBox(width: 6), Expanded(child: Text("All photos stored securely in Firebase Storage with role-based access. Profile photos private. Future: AI will suggest proportion/shading feedback to assist teacher.", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.goldLight, fontStyle: FontStyle.italic)))]),
          ])),
          const SizedBox(height: 30),
          SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: () => Navigator.pushNamed(context, '/submitAssignment', arguments: assignment), icon: const Icon(Icons.cloud_upload), label: const Text("SUBMIT ASSIGNMENT"))),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.help_outline, size: 18), label: const Text("Ask Teacher Question"))),
          const SizedBox(height: 100),
        ]),
      ),
    );
  }
}
