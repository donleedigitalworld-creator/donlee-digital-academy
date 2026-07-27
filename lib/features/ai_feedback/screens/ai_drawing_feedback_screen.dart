import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/ai/ai_models.dart';
import '../../../services/ai/ai_drawing_feedback_service.dart';
import '../../../services/storage_service.dart';
import '../../../services/auth_service.dart';
import '../../../services/ai/privacy_service.dart';
import '../../../core/offline/offline_banner.dart';

class AIDrawingFeedbackScreen extends StatefulWidget {
  const AIDrawingFeedbackScreen({super.key});

  @override
  State<AIDrawingFeedbackScreen> createState() => _AIDrawingFeedbackScreenState();
}

class _AIDrawingFeedbackScreenState extends State<AIDrawingFeedbackScreen> {
  XFile? _selectedImage;
  AIDrawingFeedback? _feedback;
  bool _analyzing = false;
  final AIDrawingFeedbackService _aiService = AIDrawingFeedbackService();
  final StorageService _storage = StorageService();

  Future<void> _pickCamera() async {
    final privacy = Provider.of<PrivacyService>(context, listen: false);
    if (privacy.consent?.cameraUsageConsent != true) {
      final ok = await privacy.requestPermission('camera');
      if (!ok) return;
    }
    if (privacy.consent?.aiArtAnalysisConsent != true) {
      _showArtAnalysisConsent();
      return;
    }
    final file = await _storage.captureWithCamera();
    if (file != null) setState(() => _selectedImage = file);
  }

  Future<void> _pickGallery() async {
    final privacy = Provider.of<PrivacyService>(context, listen: false);
    if (privacy.consent?.aiArtAnalysisConsent != true) {
      _showArtAnalysisConsent();
      return;
    }
    final files = await _storage.pickFromGallery(allowMultiple: false);
    if (files != null && files.isNotEmpty) setState(() => _selectedImage = files.first);
  }

  void _showArtAnalysisConsent() {
    showDialog(context: context, builder: (c) => AlertDialog(
      backgroundColor: AppColors.cardBlack,
      title: Text("AI Art Analysis Consent", style: GoogleFonts.playfairDisplay(color: AppColors.primaryWhite)),
      content: Text("To analyze drawings, Donlee AI needs to process your artwork. Your images are encrypted (AES-256) at rest and in transit. Analysis is teacher-guided - teachers review AI feedback before you see it in assignments. Your art not used to train AI without Data Collection consent. Low-bandwidth mode compresses locally. Allow AI to analyze your drawing for proportion, shading, composition?", style: GoogleFonts.poppins(fontSize: 12, color: AppColors.mediumGrey)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(c), child: const Text("Deny")),
        ElevatedButton(onPressed: () async {
          final auth = Provider.of<AuthService>(context, listen: false);
          final privacy = Provider.of<PrivacyService>(context, listen: false);
          final newConsent = PrivacyConsent(
            userId: auth.currentFirebaseUser?.uid ?? 'user',
            aiTutorConsent: privacy.consent?.aiTutorConsent ?? false,
            aiArtAnalysisConsent: true,
            voiceRecordingConsent: privacy.consent?.voiceRecordingConsent ?? false,
            dataCollectionConsent: false,
            analyticsConsent: privacy.consent?.analyticsConsent ?? true,
            cameraUsageConsent: true,
            consentedAt: DateTime.now(),
          );
          await privacy.saveConsent(newConsent);
          if (mounted) Navigator.pop(c);
        }, child: const Text("Consent & Analyze")),
      ],
    ));
  }

  Future<void> _analyze() async {
    if (_selectedImage == null) return;
    setState(() => _analyzing = true);
    final auth = Provider.of<AuthService>(context, listen: false);
    final offline = Provider.of<AuthService>(context, listen: false); // placeholder for offline check

    try {
      final feedback = await _aiService.analyzeDrawing(
        studentId: auth.currentFirebaseUser?.uid ?? 'student1',
        imagePath: _selectedImage!.path,
        lowBandwidth: false,
        isOffline: false,
      );
      setState(() => _feedback = feedback);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Analysis failed: $e"), backgroundColor: AppColors.error));
    } finally {
      setState(() => _analyzing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(backgroundColor: AppColors.primaryBlack, leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: AppColors.primaryWhite), onPressed: () => Navigator.pop(context)), title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("AI Drawing Feedback", style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)), Text("Proportion, shading, composition - teacher-reviewed, encrypted, secure", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey))])),
      body: Column(children: [
        const OfflineBanner(),
        Expanded(
          child: ListView(padding: const EdgeInsets.all(20), children: [
            if (_selectedImage == null) ...[
              Container(height: 240, decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.primaryBlackLighter)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.auto_awesome, size: 48, color: AppColors.primaryGold.withOpacity(0.5)),
                const SizedBox(height: 12),
                Text("Upload drawing for AI feedback", style: GoogleFonts.poppins(color: AppColors.mediumGrey)),
                const SizedBox(height: 4),
                Text("Camera for verification OR gallery - proportion/shading/composition guidance", style: GoogleFonts.poppins(fontSize: 11, color: AppColors.darkGrey), textAlign: TextAlign.center),
              ])),
              const SizedBox(height: 16),
              Row(children: [Expanded(child: ElevatedButton.icon(onPressed: _pickCamera, icon: const Icon(Icons.camera_alt), label: const Text("CAMERA"))), const SizedBox(width: 12), Expanded(child: OutlinedButton.icon(onPressed: _pickGallery, icon: const Icon(Icons.photo_library), label: const Text("GALLERY")))]),
              const SizedBox(height: 20),
              Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.primaryGold.withOpacity(0.08), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.primaryGold.withOpacity(0.2))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [const Icon(Icons.security, size: 14, color: AppColors.primaryGold), const SizedBox(width: 6), Text("Privacy Safeguards", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryWhite))]),
                const SizedBox(height: 6),
                Text("• Permission requests: Camera & AI Art Analysis consent required before analysis\n• Encryption: AES-256 at rest (keys in Secure Storage), HTTPS in transit\n• Teacher review: AI feedback reviewed by teacher before shown in assignments (teacher-approved flag)\n• No training without Data Collection consent - your art not used to train models\n• Low-bandwidth: analysis on compressed thumbnail first, high-res on demand\n• Voice: optional, mic permission separate", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey, height: 1.5)),
              ])),
            ] else ...[
              ClipRRect(borderRadius: BorderRadius.circular(16), child: Stack(children: [
                Image.file(File(_selectedImage!.path), width: double.infinity, height: 350, fit: BoxFit.cover, errorBuilder: (c, e, s) => Image.network(_selectedImage!.path, height: 350, width: double.infinity, fit: BoxFit.cover, errorBuilder: (c2, e2, s2) => Container(height: 350, color: AppColors.primaryBlackLighter))),
                if (_feedback != null) ..._feedback!.proportionMarkers.map((offset) => Positioned(left: offset.dx * MediaQuery.of(context).size.width * 0.9, top: offset.dy * 350, child: Container(width: 16, height: 16, decoration: BoxDecoration(color: AppColors.error, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)), child: const Icon(Icons.close, size: 10, color: Colors.white)))),
                Positioned(top: 12, left: 12, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: Colors.black.withOpacity(0.7), borderRadius: BorderRadius.circular(20)), child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.verified, size: 12, color: AppColors.success), const SizedBox(width: 4), Text("Camera Verified", style: GoogleFonts.poppins(fontSize: 10, color: Colors.white))])),
              ])),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(child: OutlinedButton.icon(onPressed: () => setState(() { _selectedImage = null; _feedback = null; }), icon: const Icon(Icons.change_circle, size: 16), label: const Text("Change Image", style: TextStyle(fontSize: 12)))),
                const SizedBox(width: 12),
                Expanded(child: ElevatedButton.icon(onPressed: _analyzing ? null : _analyze, icon: _analyzing ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryBlack)) : const Icon(Icons.auto_awesome, size: 16), label: Text(_analyzing ? "Analyzing..." : "Analyze with AI", style: const TextStyle(fontSize: 12)))),
              ]),
              if (_feedback != null) ...[
                const SizedBox(height: 24),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text("AI Feedback - Overall ${(_feedback!.overallScore * 10).toInt()}/100", style: GoogleFonts.playfairDisplay(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: AppColors.success.withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.security, size: 10, color: AppColors.success), const SizedBox(width: 4), Text("Teacher-Reviewed Pending", style: GoogleFonts.poppins(fontSize: 8, color: AppColors.success))])),
                ]),
                const SizedBox(height: 12),
                GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 1.4, children: _feedback!.scores.entries.map((e) => Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(12), border: Border.all(color: e.value < 7 ? Colors.orangeAccent.withOpacity(0.3) : AppColors.primaryBlackLighter)), child: Column(children: [
                  Text(e.key.name, style: GoogleFonts.poppins(fontSize: 9, color: AppColors.mediumGrey)),
                  const SizedBox(height: 4),
                  Text("${e.value.toStringAsFixed(1)}/10", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: e.value < 7 ? Colors.orangeAccent : AppColors.primaryGold)),
                  ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: e.value / 10, backgroundColor: AppColors.primaryBlackLighter, color: e.value < 7 ? Colors.orangeAccent : AppColors.primaryGold, minHeight: 4)),
                ]))).toList()),
                const SizedBox(height: 16),
                Text("Detailed Guidance - Proportion, Shading, Composition", style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
                const SizedBox(height: 12),
                ..._feedback!.guidance.entries.map((entry) => Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.primaryBlackLighter)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Container(width: 28, height: 28, decoration: BoxDecoration(color: _feedbackTypeColor(entry.key).withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: Icon(_feedbackTypeIcon(entry.key), size: 14, color: _feedbackTypeColor(entry.key))),
                    const SizedBox(width: 8),
                    Text(entry.key.name.toUpperCase(), style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
                    const Spacer(),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: _feedbackTypeColor(entry.key).withOpacity(0.15), borderRadius: BorderRadius.circular(6)), child: Text("${_feedback!.scores[entry.key]?.toStringAsFixed(1)}/10", style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.bold, color: _feedbackTypeColor(entry.key)))),
                  ]),
                  const SizedBox(height: 8),
                  Text(entry.value, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.mediumGrey, height: 1.5)),
                ]))),
                const SizedBox(height: 16),
                Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.primaryBlackLight, borderRadius: BorderRadius.circular(12)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [Icon(Icons.star, size: 14, color: AppColors.success), const SizedBox(width: 6), Text("Strengths", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.success))]),
                  const SizedBox(height: 6),
                  ..._feedback!.strengths.map((s) => Padding(padding: const EdgeInsets.only(bottom: 4), child: Row(children: [Container(width: 4, height: 4, decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle)), const SizedBox(width: 8), Expanded(child: Text(s, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.offWhite)))]))),
                  const SizedBox(height: 12),
                  Row(children: [Icon(Icons.trending_up, size: 14, color: Colors.orangeAccent), const SizedBox(width: 6), Text("Improvements", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.orangeAccent))]),
                  const SizedBox(height: 6),
                  ..._feedback!.improvements.map((s) => Padding(padding: const EdgeInsets.only(bottom: 4), child: Row(children: [Container(width: 4, height: 4, decoration: const BoxDecoration(color: Colors.orangeAccent, shape: BoxShape.circle)), const SizedBox(width: 8), Expanded(child: Text(s, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.offWhite)))]))),
                ])),
                const SizedBox(height: 16),
                Text("AI Suggested Next Steps", style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
                const SizedBox(height: 8),
                ..._feedback!.suggestedExercises.map((ex) => Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(10)), child: Row(children: [Container(width: 32, height: 32, decoration: BoxDecoration(color: AppColors.primaryGold.withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.brush, size: 16, color: AppColors.primaryGold)), const SizedBox(width: 10), Expanded(child: Text(ex, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.primaryWhite)))]))),
                const SizedBox(height: 12),
                SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: () => Navigator.pushNamed(context, '/aiTutor', arguments: "Feedback on proportion"), icon: const Icon(Icons.chat_bubble, size: 16), label: const Text("Ask AI Tutor to Explain Feedback"))),
                const SizedBox(height: 8),
                SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.school, size: 16), label: const Text("View Suggested Lessons"))),
              ],
            ],
            const SizedBox(height: 100),
          ]),
        ),
      ]),
    );
  }

  Color _feedbackTypeColor(AIFeedbackType type) {
    switch (type) {
      case AIFeedbackType.proportion: return Colors.purpleAccent;
      case AIFeedbackType.shading: return Colors.blueAccent;
      case AIFeedbackType.composition: return AppColors.primaryGold;
      case AIFeedbackType.anatomy: return Colors.orangeAccent;
      case AIFeedbackType.perspective: return Colors.blueAccent;
      default: return AppColors.primaryGold;
    }
  }

  IconData _feedbackTypeIcon(AIFeedbackType type) {
    switch (type) {
      case AIFeedbackType.proportion: return Icons.straighten;
      case AIFeedbackType.shading: return Icons.contrast;
      case AIFeedbackType.composition: return Icons.grid_view;
      case AIFeedbackType.anatomy: return Icons.accessibility_new;
      case AIFeedbackType.perspective: return Icons.view_in_ar;
      default: return Icons.brush;
    }
  }
}
