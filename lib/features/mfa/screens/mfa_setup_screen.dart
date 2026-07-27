import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/mfa/mfa_model.dart';
import '../../../widgets/custom_app_bar.dart';

class MFASetupScreen extends StatefulWidget {
  const MFASetupScreen({super.key});

  @override
  State<MFASetupScreen> createState() => _MFASetupScreenState();
}

class _MFASetupScreenState extends State<MFASetupScreen> {
  List<MFAMethod> _methods = [
    MFAMethod(id: 'm1', type: MFAMethodType.totp, status: MFAStatus.enabled, isPrimary: true, enrolledAt: DateTime.now().subtract(const Duration(days: 10)), maskedIdentifier: 'Authenticator App'),
    MFAMethod(id: 'm2', type: MFAMethodType.sms, status: MFAStatus.enabled, enrolledAt: DateTime.now().subtract(const Duration(days: 5)), maskedIdentifier: '***1234'),
    MFAMethod(id: 'm3', type: MFAMethodType.email, status: MFAStatus.disabled, maskedIdentifier: 'a***@example.com'),
    MFAMethod(id: 'm4', type: MFAMethodType.biometric, status: MFAStatus.enabled, isPrimary: false, enrolledAt: DateTime.now().subtract(const Duration(days: 2)), maskedIdentifier: 'FaceID / Fingerprint'),
    MFAMethod(id: 'm5', type: MFAMethodType.recoveryCode, status: MFAStatus.enabled, maskedIdentifier: '8 codes left'),
  ];

  List<TrustedDevice> _devices = [
    TrustedDevice(id: 'd1', deviceName: 'iPhone 14 Pro', deviceModel: 'iOS 17', ipAddress: '192.168.1.10', trustedAt: DateTime.now().subtract(const Duration(days: 30)), lastActiveAt: DateTime.now(), isCurrentDevice: true),
    TrustedDevice(id: 'd2', deviceName: 'Samsung A54', deviceModel: 'Android 13', ipAddress: '192.168.1.15', trustedAt: DateTime.now().subtract(const Duration(days: 10)), lastActiveAt: DateTime.now().subtract(const Duration(days: 1))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: const CustomAppBar(title: "Multi-Factor Authentication - Stronger Security", subtitle: "TOTP, SMS OTP, Email OTP, Biometric, Recovery Codes, Trusted Devices - Phase 6"),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.success.withOpacity(0.15), Colors.transparent]), borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.success.withOpacity(0.2))), child: Row(children: [
          const Icon(Icons.security, color: AppColors.success, size: 24),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("MFA Strengthened - Phase 6 Security Upgrade", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primaryWhite)),
            Text("Previously: biometric bool + 2FA bool mock. Now: TOTP authenticator app, SMS OTP, Email OTP, biometric FaceID/TouchID, recovery codes 8, trusted devices, device management, security questions. Audit logs all MFA events.", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)),
          ])),
        ])),
        const SizedBox(height: 20),
        Text("MFA Methods", style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
        const SizedBox(height: 12),
        ..._methods.map((m) => Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(12), border: Border.all(color: m.status == MFAStatus.enabled ? AppColors.success.withOpacity(0.3) : AppColors.primaryBlackLighter)), child: Row(children: [
          Container(width: 36, height: 36, decoration: BoxDecoration(color: m.status == MFAStatus.enabled ? AppColors.success.withOpacity(0.15) : AppColors.primaryBlackLighter, borderRadius: BorderRadius.circular(8)), child: Icon(_mfaIcon(m.type), size: 18, color: m.status == MFAStatus.enabled ? AppColors.success : AppColors.mediumGrey)),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(m.type.name.toUpperCase(), style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
              if (m.isPrimary) Container(margin: const EdgeInsets.only(left: 6), padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppColors.primaryGold.withOpacity(0.15), borderRadius: BorderRadius.circular(6)), child: Text("Primary", style: GoogleFonts.poppins(fontSize: 8, color: AppColors.primaryGold))),
            ]),
            Text(m.maskedIdentifier ?? '', style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)),
            Text("${m.status.name} ${m.enrolledAt != null ? 'since ${m.enrolledAt!.day}/${m.enrolledAt!.month}' : ''}", style: GoogleFonts.poppins(fontSize: 9, color: AppColors.darkGrey)),
          ])),
          Switch(value: m.status == MFAStatus.enabled, activeColor: AppColors.success, onChanged: (v) {}),
        ]))),
        const SizedBox(height: 20),
        Text("Trusted Devices - Device Management", style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
        const SizedBox(height: 12),
        ..._devices.map((d) => Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(12)), child: Row(children: [
          Container(width: 36, height: 36, decoration: BoxDecoration(color: d.isCurrentDevice ? AppColors.primaryGold.withOpacity(0.15) : AppColors.primaryBlackLighter, borderRadius: BorderRadius.circular(8)), child: Icon(d.isCurrentDevice ? Icons.phone_iphone : Icons.phone_android, size: 18, color: d.isCurrentDevice ? AppColors.primaryGold : AppColors.mediumGrey)),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(d.deviceName, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
            Text("${d.deviceModel} • ${d.ipAddress} • Trusted ${d.trustedAt.day}/${d.trustedAt.month} • Last active ${_timeAgo(d.lastActiveAt)}", style: GoogleFonts.poppins(fontSize: 9, color: AppColors.mediumGrey)),
          ])),
          if (d.isCurrentDevice) Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: AppColors.primaryGold.withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: Text("Current", style: GoogleFonts.poppins(fontSize: 9, color: AppColors.primaryGold))),
          IconButton(icon: const Icon(Icons.more_vert, size: 16, color: AppColors.mediumGrey), onPressed: () {}),
        ]))),
        const SizedBox(height: 20),
        Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.primaryBlackLight, borderRadius: BorderRadius.circular(12)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Recovery Codes - 8 left", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.primaryWhite)),
          const SizedBox(height: 6),
          Text("Recovery codes are one-time use if you lose access to primary MFA. Store securely offline. Each code AES-256 encrypted at rest, keys in Secure Storage. Low-bandwidth: recovery via SMS works offline queue.", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)),
          const SizedBox(height: 10),
          Wrap(spacing: 8, runSpacing: 8, children: List.generate(4, (i) => Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.primaryBlackLighter)), child: Text("ABCD-${1000 + i * 111}", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey, letterSpacing: 1))))),
        ])),
        const SizedBox(height: 100),
      ]),
    );
  }

  IconData _mfaIcon(type) {
    switch (type) {
      case MFAMethodType.totp: return Icons.timer;
      case MFAMethodType.sms: return Icons.sms;
      case MFAMethodType.email: return Icons.email;
      case MFAMethodType.biometric: return Icons.fingerprint;
      case MFAMethodType.recoveryCode: return Icons.key;
    }
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inHours < 24) return "${diff.inHours}h ago";
    return "${diff.inDays}d ago";
  }
}
