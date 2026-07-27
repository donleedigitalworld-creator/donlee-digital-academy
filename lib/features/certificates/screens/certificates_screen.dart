import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/certificate_model.dart';
import '../../../widgets/custom_app_bar.dart';
import '../widgets/certificate_widget.dart';

class CertificatesScreen extends StatelessWidget {
  const CertificatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final certificates = [
      CertificateModel(id: 'cert1', studentId: 's1', studentName: 'Amara Okafor', studentPhotoUrl: '', type: CertificateType.moduleCompletion, title: 'Elements of Art - Mastery Certificate', description: 'Has successfully completed Elements of Art module with distinction', moduleId: 'elements_of_art', issuedBy: 'Ms. Amara - Donlee Academy', issuedById: 't1', issuedAt: DateTime.now().subtract(const Duration(days: 5)), certificateNumber: 'DON-2024-A1B2C3', score: 92),
      CertificateModel(id: 'cert2', studentId: 's1', studentName: 'Amara Okafor', studentPhotoUrl: '', type: CertificateType.assignmentExcellence, title: 'Portrait Excellence Award', description: 'Outstanding performance in Loomis Head assignment - Top 5% of class', assignmentId: 'a1', issuedBy: 'Donlee Academy', issuedById: 'admin1', issuedAt: DateTime.now().subtract(const Duration(days: 12)), certificateNumber: 'DON-2024-X9Y8Z7', score: 98),
    ];

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: const CustomAppBar(title: "My Certificates", subtitle: "Verified Donlee achievements", showBack: true),
      body: certificates.isEmpty ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.workspace_premium_outlined, size: 80, color: AppColors.mediumGrey.withOpacity(0.3)), const SizedBox(height: 16), Text("No certificates yet", style: GoogleFonts.poppins(color: AppColors.mediumGrey)), Text("Complete modules & excel in assignments to earn", style: GoogleFonts.poppins(fontSize: 12, color: AppColors.darkGrey))])) : ListView.separated(padding: const EdgeInsets.all(16), itemCount: certificates.length, separatorBuilder: (_, __) => const SizedBox(height: 16), itemBuilder: (c, i) {
        final cert = certificates[i];
        return GestureDetector(onTap: () => showDialog(context: context, builder: (_) => Dialog(backgroundColor: Colors.transparent, insetPadding: const EdgeInsets.all(16), child: CertificateWidget(certificate: cert))), child: Container(decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.primaryGold.withOpacity(0.3))), child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
          Row(children: [
            Container(width: 48, height: 48, decoration: BoxDecoration(gradient: AppColors.goldGradient, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.workspace_premium, color: AppColors.primaryBlack)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(cert.title, style: GoogleFonts.playfairDisplay(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)), Text(cert.certificateNumber, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.primaryGold)), Text("Issued ${cert.issuedAt.day}/${cert.issuedAt.month}/${cert.issuedAt.year} by ${cert.issuedBy}", style: GoogleFonts.poppins(fontSize: 9, color: AppColors.mediumGrey))])),
            const Icon(Icons.qr_code_2, color: AppColors.mediumGrey),
          ]),
          const SizedBox(height: 12),
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.primaryBlackLight, borderRadius: BorderRadius.circular(10)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Score: ${cert.score ?? 'N/A'}%", style: GoogleFonts.poppins(fontSize: 11, color: AppColors.primaryWhite)), Text("Tap to view full certificate →", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.primaryGold))])),
        ]))));
      }),
    );
  }
}
