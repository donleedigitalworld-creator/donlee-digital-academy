import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/assignment_model.dart';
import '../../../services/storage_service.dart';
import '../../../services/assignment_service.dart';
import 'package:provider/provider.dart';
import '../../../services/auth_service.dart';
import '../../../widgets/custom_app_bar.dart';

class SubmitAssignmentScreen extends StatefulWidget {
  final AssignmentModel assignment;
  const SubmitAssignmentScreen({super.key, required this.assignment});

  @override
  State<SubmitAssignmentScreen> createState() => _SubmitAssignmentScreenState();
}

class _SubmitAssignmentScreenState extends State<SubmitAssignmentScreen> {
  final _notesCtrl = TextEditingController();
  List<XFile> _selectedFiles = [];
  bool _uploading = false;
  final StorageService _storage = StorageService();

  Future<void> _captureCamera() async {
    final file = await _storage.captureWithCamera();
    if (file != null) setState(() => _selectedFiles.add(file));
  }

  Future<void> _pickGallery() async {
    final files = await _storage.pickFromGallery(allowMultiple: true);
    if (files != null) setState(() => _selectedFiles.addAll(files));
  }

  Future<void> _submit() async {
    if (_selectedFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please add at least one photo of your drawing"), backgroundColor: AppColors.error));
      return;
    }
    setState(() => _uploading = true);
    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      final uid = auth.currentFirebaseUser?.uid ?? 'testUid';
      final name = auth.currentUserModel?.displayName ?? 'Student';
      // Upload to Firebase Storage
      final urls = await _storage.uploadArtworkImages(uid: uid, files: _selectedFiles, assignmentId: widget.assignment.id, classId: widget.assignment.classId);

      final submission = SubmissionModel(
        id: '',
        assignmentId: widget.assignment.id,
        studentId: uid,
        studentName: name,
        studentPhotoUrl: auth.currentUserModel?.photoUrl,
        classId: widget.assignment.classId,
        artworkImageUrls: urls.isNotEmpty ? urls : _selectedFiles.map((f) => f.path).toList(), // fallback local for demo
        textResponse: _notesCtrl.text,
        submittedAt: DateTime.now(),
        isLate: widget.assignment.isOverdue,
      );

      await AssignmentService().submitAssignment(submission);
      if (mounted) {
        Navigator.pop(context);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Assignment submitted! Teacher will review & score your uploaded work."), backgroundColor: AppColors.success, duration: Duration(seconds: 3)));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: AppColors.error));
    } finally {
      setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: CustomAppBar(title: "Submit: ${widget.assignment.title}", subtitle: widget.assignment.requireCameraPhoto ? "Camera required - proves original work" : "Camera or gallery allowed", showBack: true),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: widget.assignment.requireCameraPhoto ? AppColors.success.withOpacity(0.1) : AppColors.cardBlack, borderRadius: BorderRadius.circular(12), border: Border.all(color: widget.assignment.requireCameraPhoto ? AppColors.success.withOpacity(0.3) : AppColors.primaryBlackLighter)), child: Row(children: [Icon(widget.assignment.requireCameraPhoto ? Icons.camera_alt : Icons.photo_library, color: widget.assignment.requireCameraPhoto ? AppColors.success : AppColors.primaryGold, size: 20), const SizedBox(width: 10), Expanded(child: Text(widget.assignment.requireCameraPhoto ? "This assignment REQUIRES camera capture for verification (gallery not allowed). Ensures original work." : "You can capture with camera OR upload from gallery. Profile photos stored securely.", style: GoogleFonts.poppins(fontSize: 11, color: widget.assignment.requireCameraPhoto ? AppColors.success : AppColors.mediumGrey)))])),
          const SizedBox(height: 20),
          Text("Your Artwork Photos (${_selectedFiles.length})", style: GoogleFonts.playfairDisplay(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
          const SizedBox(height: 12),
          if (_selectedFiles.isEmpty)
            Container(height: 180, decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.primaryBlackLighter, style: BorderStyle.solid)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.add_a_photo, size: 48, color: AppColors.mediumGrey.withOpacity(0.5)), const SizedBox(height: 12), Text("No photos yet", style: GoogleFonts.poppins(color: AppColors.mediumGrey)), const SizedBox(height: 4), Text("Capture drawing with camera or pick from gallery", style: GoogleFonts.poppins(fontSize: 11, color: AppColors.darkGrey))])),
          if (_selectedFiles.isNotEmpty)
            GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1), itemCount: _selectedFiles.length, itemBuilder: (c, i) {
              return Stack(children: [
                ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(_selectedFiles[i].path, width: double.infinity, height: double.infinity, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(color: AppColors.primaryBlackLighter, child: const Icon(Icons.image, color: AppColors.mediumGrey)))),
                Positioned(top: 6, right: 6, child: GestureDetector(onTap: () => setState(() => _selectedFiles.removeAt(i)), child: Container(padding: const EdgeInsets.all(6), decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle), child: const Icon(Icons.close, size: 12, color: Colors.white)))),
                Positioned(bottom: 6, left: 6, child: Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(8)), child: Text("Photo ${i+1}", style: GoogleFonts.poppins(fontSize: 9, color: AppColors.primaryWhite)))),
              ]);
            }),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: ElevatedButton.icon(onPressed: _captureCamera, icon: const Icon(Icons.camera_alt), label: const Text("CAMERA"), style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryGold))),
            const SizedBox(width: 12),
            Expanded(child: OutlinedButton.icon(onPressed: _pickGallery, icon: const Icon(Icons.photo_library), label: const Text("GALLERY"))),
          ]),
          const SizedBox(height: 20),
          Text("What did you learn?", style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
          const SizedBox(height: 8),
          TextField(controller: _notesCtrl, maxLines: 4, style: const TextStyle(color: AppColors.primaryWhite), decoration: InputDecoration(hintText: 'I struggled with jaw angle but Loomis cross helped...', hintStyle: GoogleFonts.poppins(fontSize: 11, color: AppColors.darkGrey), filled: true, fillColor: AppColors.cardBlack, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
          const SizedBox(height: 20),
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.primaryBlackLight, borderRadius: BorderRadius.circular(12)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [const Icon(Icons.lock, size: 14, color: AppColors.primaryGold), const SizedBox(width: 6), Text("Secure Storage", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryWhite))]),
            const SizedBox(height: 6),
            Text("Your photos & progress stored securely in Firebase with user-based access. Teacher can review, annotate, and score. Later AI will assist with proportion/shading suggestions (teacher guided for now).", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey, height: 1.4)),
          ])),
          const SizedBox(height: 24),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _uploading ? null : _submit, child: _uploading ? const Row(mainAxisAlignment: MainAxisAlignment.center, children: [SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryBlack)), SizedBox(width: 10), Text("Uploading...")]) : const Text("SUBMIT ARTWORK FOR REVIEW"))),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
