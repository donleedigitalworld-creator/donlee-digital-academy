import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/certificate_model.dart';

class CertificateWidget extends StatelessWidget {
  final CertificateModel certificate;
  const CertificateWidget({super.key, required this.certificate});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF121212), Color(0xFF1E1E1E), Color(0xFF121212)]),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryGold, width: 2),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(width: 50, height: 50, decoration: BoxDecoration(gradient: AppColors.goldGradient, shape: BoxShape.circle), child: const Icon(Icons.palette, color: AppColors.primaryBlack)),
            Column(children: [Text("DONLEE DIGITAL WORLD", style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1, color: AppColors.primaryWhite)), Text("Creative Art Academy", style: GoogleFonts.poppins(fontSize: 9, color: AppColors.primaryGold))]),
            Container(width: 50, height: 50, decoration: BoxDecoration(color: AppColors.primaryGold.withOpacity(0.15), shape: BoxShape.circle), child: const Icon(Icons.workspace_premium, color: AppColors.primaryGold)),
          ]),
          const SizedBox(height: 16),
          Container(width: 80, height: 2, color: AppColors.primaryGold),
          const SizedBox(height: 16),
          Text("CERTIFICATE", style: GoogleFonts.playfairDisplay(fontSize: 10, letterSpacing: 4, color: AppColors.mediumGrey)),
          Text("OF ACHIEVEMENT", style: GoogleFonts.playfairDisplay(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primaryWhite, letterSpacing: 1)),
          const SizedBox(height: 16),
          Text("This certificate is proudly presented to", style: GoogleFonts.poppins(fontSize: 11, color: AppColors.mediumGrey)),
          const SizedBox(height: 12),
          Text(certificate.studentName, style: GoogleFonts.playfairDisplay(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primaryGold)),
          const SizedBox(height: 12),
          Text(certificate.description, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.offWhite, height: 1.5), textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), decoration: BoxDecoration(color: AppColors.primaryBlackLight, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.primaryGold.withOpacity(0.2))), child: Column(children: [
            Text(certificate.title, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryWhite), textAlign: TextAlign.center),
            if (certificate.score != null) ...[const SizedBox(height: 4), Text("Score: ${certificate.score}% - Excellence", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.success))],
          ])),
          const SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(certificate.issuedBy, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
              Container(width: 80, height: 1, color: AppColors.mediumGrey),
              Text("Instructor Signature", style: GoogleFonts.poppins(fontSize: 9, color: AppColors.mediumGrey)),
            ]),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text("${certificate.issuedAt.day}/${certificate.issuedAt.month}/${certificate.issuedAt.year}", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
              Container(width: 80, height: 1, color: AppColors.mediumGrey),
              Text("Date Issued", style: GoogleFonts.poppins(fontSize: 9, color: AppColors.mediumGrey)),
            ]),
          ]),
          const SizedBox(height: 16),
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: AppColors.primaryBlackLight, borderRadius: BorderRadius.circular(20)), child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.qr_code, size: 14, color: AppColors.mediumGrey), const SizedBox(width: 6), Text(certificate.certificateNumber, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey, letterSpacing: 1))])),
          const SizedBox(height: 12),
          Text("Verify at donlee.art/verify • Empowering Creativity Through Digital Fine Art Education", style: GoogleFonts.poppins(fontSize: 8, color: AppColors.darkGrey), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
