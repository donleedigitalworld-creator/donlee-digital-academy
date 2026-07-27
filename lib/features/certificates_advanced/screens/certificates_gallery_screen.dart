import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/certificate/certificate_advanced_model.dart';
import '../../../widgets/custom_app_bar.dart';

class CertificatesGalleryScreen extends StatelessWidget {
  const CertificatesGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final certs = [DigitalCertificateAdvanced.mockNational(), DigitalCertificateAdvanced.mockModule(), DigitalCertificateAdvanced.mockNational().copyWith(certificateNumber: 'DON-2024-Z9Y8X7', title: 'Exhibition Selected - Nike Art Gallery', template: CertificateTemplate.exhibition)];

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: const CustomAppBar(title: "Digital Certificate Vault", subtitle: "Verifiable QR + Blockchain hash + PDF + LinkedIn sharing + revocation", showBack: true),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1, childAspectRatio: 1.6, mainAxisSpacing: 16),
        itemCount: certs.length,
        itemBuilder: (c, i) {
          final cert = certs[i];
          return Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.cardBlack, AppColors.primaryBlackLight]), borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.primaryGold.withOpacity(0.3))), child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: AppColors.primaryGold, borderRadius: BorderRadius.circular(8)), child: Text(cert.template.name.toUpperCase(), style: GoogleFonts.poppins(fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.primaryBlack))),
              Row(children: [
                Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppColors.success.withOpacity(0.15), borderRadius: BorderRadius.circular(6)), child: Text(cert.verificationStatus.name, style: GoogleFonts.poppins(fontSize: 8, color: AppColors.success))),
                const SizedBox(width: 6),
                const Icon(Icons.qr_code, size: 16, color: AppColors.mediumGrey),
              ]),
            ]),
            const SizedBox(height: 12),
            Text(cert.title, style: GoogleFonts.playfairDisplay(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
            Text(cert.certificateNumber, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.primaryGold)),
            const SizedBox(height: 6),
            Text(cert.description, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey), maxLines: 2),
            const Spacer(),
            Row(children: [
              Expanded(child: OutlinedButton(onPressed: () => Navigator.pushNamed(context, '/certificateVerify'), child: const Text("Verify QR", style: TextStyle(fontSize: 10)))),
              const SizedBox(width: 8),
              Expanded(child: ElevatedButton(onPressed: () {}, child: const Text("Share LinkedIn", style: TextStyle(fontSize: 10)))),
            ]),
          ])));
        },
      ),
    );
  }
}

extension CertCopy on DigitalCertificateAdvanced {
  DigitalCertificateAdvanced copyWith({String? certificateNumber, String? title, CertificateTemplate? template}) {
    return DigitalCertificateAdvanced(
      id: id,
      certificateNumber: certificateNumber ?? this.certificateNumber,
      template: template ?? this.template,
      studentId: studentId,
      studentName: studentName,
      studentPhotoUrl: studentPhotoUrl,
      title: title ?? this.title,
      description: description,
      issuedBy: issuedBy,
      issuedById: issuedById,
      schoolId: schoolId,
      schoolName: schoolName,
      competitionId: competitionId,
      moduleId: moduleId,
      issuedAt: issuedAt,
      score: score,
      grade: grade,
      qrCodeData: qrCodeData,
      blockchainHash: blockchainHash,
      skills: skills,
    );
  }
}
