import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/ai/ai_models.dart';
import '../../../services/ai/privacy_service.dart';
import '../../../services/auth_service.dart';
import '../../../widgets/custom_app_bar.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthService>(context, listen: false);
    final privacy = Provider.of<PrivacyService>(context, listen: false);
    privacy.init(auth.currentFirebaseUser?.uid ?? 'user');
  }

  @override
  Widget build(BuildContext context) {
    final privacy = Provider.of<PrivacyService>(context);
    final auth = Provider.of<AuthService>(context);
    final consent = privacy.consent;

    if (consent == null) {
      return Scaffold(backgroundColor: AppColors.primaryBlack, appBar: const CustomAppBar(title: "Privacy Settings", subtitle: "AI safeguards, permissions, encryption", showBack: true), body: const Center(child: CircularProgressIndicator(color: AppColors.primaryGold)));
    }

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: const CustomAppBar(title: "Privacy & AI Safeguards", subtitle: "Permissions, encryption, data control - GDPR", showBack: true),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(gradient: AppColors.goldGradient, borderRadius: BorderRadius.circular(16)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [const Icon(Icons.security, color: AppColors.primaryBlack), const SizedBox(width: 8), Text("Your Data is Encrypted & Secure", style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryBlack))]),
          const SizedBox(height: 8),
          Text("All AI chats, artwork analysis, voice recordings encrypted AES-256, keys in Secure Storage (iOS Keychain/Android Keystore). HTTPS in transit. No training without Data Collection consent. Teacher review required for AI quizzes/lesson plans. Low-bandwidth compresses locally.", style: GoogleFonts.poppins(fontSize: 11, color: AppColors.primaryBlack.withOpacity(0.8))),
          const SizedBox(height: 8),
          Row(children: [Icon(privacy.isEncrypted ? Icons.lock : Icons.lock_open, size: 12, color: AppColors.primaryBlack), const SizedBox(width: 4), Text(privacy.isEncrypted ? "Encryption Active • AES-256" : "Encryption Inactive", style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primaryBlack))]),
        ])),
        const SizedBox(height: 20),
        Text("AI Feature Consents - Toggle Each Separately", style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
        const SizedBox(height: 12),
        _consentTile("AI Tutor Chat", "AI answers questions, suggests lessons. Chats encrypted, not used to train without Data Collection consent", Icons.chat_bubble, consent.aiTutorConsent, (v) => _updateConsent(consent.copyWith(aiTutor: v))),
        _consentTile("AI Art Analysis", "AI analyzes drawings for proportion/shading/composition. Teacher-reviewed. Images encrypted. Low-BW thumbnail first", Icons.auto_awesome, consent.aiArtAnalysisConsent, (v) => _updateConsent(consent.copyWith(artAnalysis: v))),
        _consentTile("Voice Recording", "Microphone for voice learning, speech-to-text, text-to-speech. On-device when possible. Recordings encrypted", Icons.mic, consent.voiceRecordingConsent, (v) => _updateConsent(consent.copyWith(voice: v))),
        _consentTile("Camera Usage", "Camera for capturing drawings, profile photos. Camera verification for national competition original work proof", Icons.camera_alt, consent.cameraUsageConsent, (v) => _updateConsent(consent.copyWith(camera: v))),
        _consentTile("Data Collection (for personalization)", "Allow AI to use your progress to personalize suggestions? If off, generic suggestions only. No training without this.", Icons.person_search, consent.dataCollectionConsent, (v) => _updateConsent(consent.copyWith(data: v))),
        _consentTile("Analytics (learning trends)", "Allow anonymized analytics for teacher to see class trends (e.g., perspective drop-off)? Private chats not shared.", Icons.analytics, consent.analyticsConsent, (v) => _updateConsent(consent.copyWith(analytics: v))),
        const SizedBox(height: 20),
        Text("Permissions - With Explanation", style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
        const SizedBox(height: 12),
        _permissionTile("Microphone", "For voice learning - speech to text, ask AI Tutor with voice. Request shows why needed. You can deny.", Icons.mic, () => privacy.requestPermission('microphone')),
        _permissionTile("Camera", "For capturing drawings, profile photos, competition submissions with verification. Request with explanation.", Icons.camera_alt, () => privacy.requestPermission('camera')),
        _permissionTile("Storage", "For offline lessons, queued submissions when no internet, low-bandwidth cache. Secure local storage.", Icons.storage, () => privacy.requestPermission('storage')),
        _permissionTile("Notifications", "For assignment due, competition status, exhibition selected, teacher feedback. You can disable.", Icons.notifications, () => privacy.requestPermission('notifications')),
        const SizedBox(height: 20),
        Text("Data Control - GDPR", style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: OutlinedButton.icon(onPressed: () async { await privacy.exportUserData(auth.currentFirebaseUser?.uid ?? 'user'); if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Export requested - encrypted JSON will be emailed")) ); }, icon: const Icon(Icons.download, size: 16), label: const Text("Export My Data", style: TextStyle(fontSize: 11)))),
          const SizedBox(width: 12),
          Expanded(child: OutlinedButton.icon(onPressed: () async { await privacy.deleteAllUserData(auth.currentFirebaseUser?.uid ?? 'user'); if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("AI data deleted - chats, analysis, voice history removed (Firestore/Storage/local)"), backgroundColor: AppColors.error)); }, icon: const Icon(Icons.delete_forever, size: 16), label: const Text("Delete AI Data", style: TextStyle(fontSize: 11)), style: OutlinedButton.styleFrom(foregroundColor: AppColors.error))),
        ]),
        const SizedBox(height: 12),
        SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: () async { await privacy.revokeAllConsent(auth.currentFirebaseUser?.uid ?? 'user'); if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("All consents revoked - AI features disabled until you consent again. Encryption keys reset."))); }, icon: const Icon(Icons.block), label: const Text("Revoke All Consents"), style: ElevatedButton.styleFrom(backgroundColor: AppColors.error))),
        const SizedBox(height: 20),
        Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(12)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Full Privacy Policy Summary", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.primaryWhite)),
          const SizedBox(height: 8),
          Text(privacy.getPrivacySummary(), style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey, height: 1.4)),
        ])),
        const SizedBox(height: 100),
      ]),
    );
  }

  Widget _consentTile(String title, String desc, IconData icon, bool value, Function(bool) onChanged) {
    return Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(12), border: Border.all(color: value ? AppColors.success.withOpacity(0.3) : AppColors.primaryBlackLighter)), child: Row(children: [
      Container(width: 36, height: 36, decoration: BoxDecoration(color: value ? AppColors.success.withOpacity(0.15) : AppColors.primaryBlackLighter, borderRadius: BorderRadius.circular(8)), child: Icon(icon, size: 18, color: value ? AppColors.success : AppColors.mediumGrey)),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)), Text(desc, style: GoogleFonts.poppins(fontSize: 9, color: AppColors.mediumGrey), maxLines: 3)])),
      Switch(value: value, activeColor: AppColors.success, onChanged: onChanged),
    ]));
  }

  Widget _permissionTile(String title, String desc, IconData icon, VoidCallback onRequest) {
    return Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(12)), child: Row(children: [
      Container(width: 32, height: 32, decoration: BoxDecoration(color: AppColors.primaryGold.withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: Icon(icon, size: 16, color: AppColors.primaryGold)),
      const SizedBox(width: 10),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)), Text(desc, style: GoogleFonts.poppins(fontSize: 9, color: AppColors.mediumGrey))])),
      OutlinedButton(onPressed: onRequest, child: const Text("Request", style: TextStyle(fontSize: 9))),
    ]));
  }

  Future<void> _updateConsent(PrivacyConsent newConsent) async {
    final privacy = Provider.of<PrivacyService>(context, listen: false);
    await privacy.saveConsent(newConsent);
  }
}

extension PrivacyConsentCopy on PrivacyConsent {
  PrivacyConsent copyWith({bool? aiTutor, bool? artAnalysis, bool? voice, bool? data, bool? analytics, bool? camera}) {
    return PrivacyConsent(
      userId: userId,
      aiTutorConsent: aiTutor ?? aiTutorConsent,
      aiArtAnalysisConsent: artAnalysis ?? aiArtAnalysisConsent,
      voiceRecordingConsent: voice ?? voiceRecordingConsent,
      dataCollectionConsent: data ?? dataCollectionConsent,
      analyticsConsent: analytics ?? analyticsConsent,
      cameraUsageConsent: camera ?? cameraUsageConsent,
      consentedAt: DateTime.now(),
      encryptionKeyId: encryptionKeyId,
    );
  }
}
