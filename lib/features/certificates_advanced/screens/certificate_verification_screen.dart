import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/certificate/certificate_advanced_model.dart';
import '../../../widgets/custom_app_bar.dart';

class CertificateVerificationScreen extends StatefulWidget {
  const CertificateVerificationScreen({super.key});

  @override
  State<CertificateVerificationScreen> createState() => _CertificateVerificationScreenState();
}

class _CertificateVerificationScreenState extends State<CertificateVerificationScreen> {
  final _controller = TextEditingController(text: 'DON-NAC-2025-A1B2C3');
  CertificateVerificationResult? _result;
  bool _verifying = false;

  Future<void> _verify() async {
    setState(() => _verifying = true);
    await Future.delayed(const Duration(milliseconds: 800));
    // Mock verification
    if (_controller.text.contains('DON')) {
      setState(() {
        _result = CertificateVerificationResult(
          certificateNumber: _controller.text,
          status: VerificationStatus.valid,
          certificate: DigitalCertificateAdvanced.mockNational(),
          verifiedAt: DateTime.now(),
        );
        _verifying = false;
      });
    } else {
      setState(() {
        _result = CertificateVerificationResult(certificateNumber: _controller.text, status: VerificationStatus.notFound, verifiedAt: DateTime.now(), error: 'Certificate not found');
        _verifying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: const CustomAppBar(title: "Certificate Verification", subtitle: "QR + Blockchain mock hash + revocation check", showBack: true),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(gradient: AppColors.goldGradient, borderRadius: BorderRadius.circular(16)), child: Row(children: [
          const Icon(Icons.qr_code_scanner, color: AppColors.primaryBlack, size: 32),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Verify Donlee Certificates", style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryBlack)),
            Text("QR scan + blockchain hash future-ready + revocation check. Share to LinkedIn/Twitter. Offline verification via cached blockchain hash.", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.primaryBlack.withOpacity(0.8))),
          ])),
        ])),
        const SizedBox(height: 20),
        Row(children: [
          Expanded(child: TextField(controller: _controller, style: const TextStyle(color: AppColors.primaryWhite), decoration: InputDecoration(labelText: 'Certificate Number', hintText: 'DON-NAC-2025-XXXX', prefixIcon: const Icon(Icons.workspace_premium, color: AppColors.primaryGold), suffixIcon: IconButton(icon: const Icon(Icons.qr_code_scanner, color: AppColors.primaryGold), onPressed: () {})))),
          const SizedBox(width: 12),
          ElevatedButton(onPressed: _verifying ? null : _verify, child: _verifying ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Text("Verify")),
        ]),
        const SizedBox(height: 20),
        if (_result != null) ...[
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: _result!.status == VerificationStatus.valid ? AppColors.success.withOpacity(0.1) : AppColors.error.withOpacity(0.1), borderRadius: BorderRadius.circular(16), border: Border.all(color: _result!.status == VerificationStatus.valid ? AppColors.success.withOpacity(0.3) : AppColors.error.withOpacity(0.3))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Icon(_result!.status == VerificationStatus.valid ? Icons.check_circle : Icons.error, color: _result!.status == VerificationStatus.valid ? AppColors.success : AppColors.error),
              const SizedBox(width: 8),
              Text("Status: ${_result!.status.name.toUpperCase()}", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: _result!.status == VerificationStatus.valid ? AppColors.success : AppColors.error)),
              const Spacer(),
              Text("Verified ${ _result!.verifiedAt.hour}:${_result!.verifiedAt.minute}", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)),
            ]),
            if (_result!.certificate != null) ...[
              const SizedBox(height: 12),
              Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(12)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Expanded(child: Text(_result!.certificate!.title, style: GoogleFonts.playfairDisplay(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primaryWhite))),
                  QrImageView(data: _result!.certificate!.qrCodeData, version: QrVersions.auto, size: 60, backgroundColor: Colors.white),
                ]),
                const SizedBox(height: 8),
                Text(_result!.certificate!.description, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.mediumGrey)),
                const SizedBox(height: 8),
                Text("Student: ${_result!.certificate!.studentName} • Issued: ${_result!.certificate!.issuedAt.day}/${_result!.certificate!.issuedAt.month}/${_result!.certificate!.issuedAt.year} by ${_result!.certificate!.issuedBy}", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.primaryGold)),
                const SizedBox(height: 8),
                Text("Blockchain Hash: ${_result!.certificate!.blockchainHash}", style: GoogleFonts.poppins(fontSize: 9, color: AppColors.darkGrey)),
                const SizedBox(height: 8),
                Wrap(spacing: 6, children: _result!.certificate!.skills.map((s) => Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: AppColors.primaryGold.withOpacity(0.15), borderRadius: BorderRadius.circular(12)), child: Text(s, style: GoogleFonts.poppins(fontSize: 9, color: AppColors.primaryGold)))).toList()),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.share, size: 14), label: const Text("Share", style: TextStyle(fontSize: 11)))),
                  const SizedBox(width: 8),
                  Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.download, size: 14), label: const Text("PDF", style: TextStyle(fontSize: 11)))),
                  const SizedBox(width: 8),
                  Expanded(child: ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.link, size: 14), label: const Text("LinkedIn", style: TextStyle(fontSize: 11)))),
                ]),
              ])),
            ],
            if (_result!.error != null) Text("Error: ${_result!.error}", style: GoogleFonts.poppins(color: AppColors.error)),
          ])),
          const SizedBox(height: 20),
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.primaryBlackLight, borderRadius: BorderRadius.circular(12)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [const Icon(Icons.security, size: 14, color: AppColors.success), const SizedBox(width: 6), Text("Security & Future Scalability", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.primaryWhite))]),
            const SizedBox(height: 6),
            Text("• QR: verification URL https://donlee.art/verify/{number} with offline cache\n• Blockchain mock hash 0x... future-ready for real blockchain\n• Revocation: if isRevoked true + revokedReason, verification shows revoked\n• Template: classicGold, modernMinimal, nationalChampionship, exhibition, scholarship, completion\n• Share: LinkedIn, Twitter, WhatsApp, Email, PDF via share_plus + printing\n• Encryption: certificate data encrypted at rest, QR contains hash not PII\n• National scale: 8,934 certificates, verifiable nationally", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)),
          ])),
        ],
        const SizedBox(height: 100),
      ]),
    );
  }
}
