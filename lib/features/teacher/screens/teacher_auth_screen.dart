import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/teacher_model.dart';
import '../../../services/auth_service.dart';
import '../../../services/storage_service.dart';

class TeacherAuthScreen extends StatefulWidget {
  const TeacherAuthScreen({super.key});

  @override
  State<TeacherAuthScreen> createState() => _TeacherAuthScreenState();
}

class _TeacherAuthScreenState extends State<TeacherAuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();
  final _specialCtrl = TextEditingController();
  XFile? _profileImage;
  String? _photoUrl;
  String? _error;
  bool _isLogin = false;
  bool _obscure = true;

  Future<void> _pickImage() async {
    final storage = StorageService();
    final files = await storage.pickFromGallery(allowMultiple: false);
    if (files != null && files.isNotEmpty) {
      setState(() => _profileImage = files.first);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _error = null);
    final auth = Provider.of<AuthService>(context, listen: false);
    final storage = StorageService();
    try {
      if (_isLogin) {
        await auth.loginWithEmail(email: _emailCtrl.text.trim(), password: _passCtrl.text);
        if (mounted) Navigator.pushReplacementNamed(context, '/teacherDashboard');
      } else {
        // If image selected, upload first with temp uid? For MVP, upload after creation
        // Create user, then upload photo
        await auth.registerWithEmail(email: _emailCtrl.text.trim(), password: _passCtrl.text, displayName: _nameCtrl.text.trim(), role: UserRole.teacher);
        final uid = auth.currentFirebaseUser?.uid;
        if (_profileImage != null && uid != null) {
          final url = await storage.uploadProfilePhoto(uid, _profileImage!);
          if (url != null) {
            await auth.updateProfile(photoUrl: url);
            _photoUrl = url;
          }
        }
        // Update teacher additional info
        // For brevity, teacher bio/specialization stored via Firestore directly in next screen or via extended update
        if (mounted) Navigator.pushReplacementNamed(context, '/teacherDashboard');
      }
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(backgroundColor: Colors.transparent, leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: AppColors.primaryWhite), onPressed: () => Navigator.pop(context)), elevation: 0, title: Text(_isLogin ? "Teacher Login" : "Teacher Registration", style: GoogleFonts.playfairDisplay(color: AppColors.primaryWhite, fontWeight: FontWeight.bold))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (!_isLogin) ...[
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Stack(children: [
                    CircleAvatar(radius: 50, backgroundColor: AppColors.primaryBlackLighter, backgroundImage: _profileImage != null ? null : null, child: _profileImage == null ? const Icon(Icons.person, size: 40, color: AppColors.mediumGrey) : null),
                    Positioned(bottom: 0, right: 0, child: Container(padding: const EdgeInsets.all(8), decoration: const BoxDecoration(color: AppColors.primaryGold, shape: BoxShape.circle), child: const Icon(Icons.camera_alt, size: 16, color: AppColors.primaryBlack))),
                  ]),
                ),
              ),
              const SizedBox(height: 8),
              Center(child: Text("Tap to add profile photo - secure storage", style: GoogleFonts.poppins(fontSize: 11, color: AppColors.mediumGrey))),
              const SizedBox(height: 24),
            ],
            TextFormField(controller: _emailCtrl, style: const TextStyle(color: AppColors.primaryWhite), decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined, color: AppColors.primaryGold)), validator: (v) => v != null && v.contains('@') ? null : 'Valid email required'),
            const SizedBox(height: 12),
            if (!_isLogin) TextFormField(controller: _nameCtrl, style: const TextStyle(color: AppColors.primaryWhite), decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.badge_outlined, color: AppColors.primaryGold)), validator: (v) => v != null && v.length >= 3 ? null : 'Name required'),
            if (!_isLogin) const SizedBox(height: 12),
            TextFormField(controller: _passCtrl, obscureText: _obscure, style: const TextStyle(color: AppColors.primaryWhite), decoration: InputDecoration(labelText: 'Password', prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primaryGold), suffixIcon: IconButton(icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, color: AppColors.mediumGrey), onPressed: () => setState(() => _obscure = !_obscure))), validator: (v) => v != null && v.length >= 6 ? null : 'Min 6 chars'),
            if (!_isLogin) ...[
              const SizedBox(height: 12),
              TextFormField(controller: _specialCtrl, style: const TextStyle(color: AppColors.primaryWhite), decoration: const InputDecoration(labelText: 'Specialization (e.g. Portrait, Anatomy)', prefixIcon: Icon(Icons.palette_outlined, color: AppColors.primaryGold))),
              const SizedBox(height: 12),
              TextFormField(controller: _bioCtrl, maxLines: 3, style: const TextStyle(color: AppColors.primaryWhite), decoration: const InputDecoration(labelText: 'Bio - Tell students about you', alignLabelWithHint: true)),
            ],
            const SizedBox(height: 16),
            if (_error != null) Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.error.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Text(_error!, style: const TextStyle(color: AppColors.error))),
            const SizedBox(height: 20),
            SizedBox(width: double.infinity, child: ElevatedButton(onPressed: auth.isLoading ? null : _submit, child: auth.isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : Text(_isLogin ? "LOGIN AS TEACHER" : "REGISTER AS TEACHER"))),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text(_isLogin ? "Need teacher account? " : "Already a teacher? ", style: GoogleFonts.poppins(color: AppColors.mediumGrey)), GestureDetector(onTap: () => setState(() => _isLogin = !_isLogin), child: Text(_isLogin ? "Register" : "Login", style: GoogleFonts.poppins(color: AppColors.primaryGold, fontWeight: FontWeight.bold)))]),
            const SizedBox(height: 24),
            Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.primaryBlackLight, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.primaryGold.withOpacity(0.15))), child: Row(children: [const Icon(Icons.verified_user, color: AppColors.primaryGold, size: 20), const SizedBox(width: 10), Expanded(child: Text("Teacher profiles are verified by admin. Secure storage of photos & progress data. Camera review & scoring enabled.", style: GoogleFonts.poppins(fontSize: 11, color: AppColors.mediumGrey)))])),
          ]),
        ),
      ),
    );
  }
}
