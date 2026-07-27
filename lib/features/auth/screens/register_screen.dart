import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../../../services/auth_service.dart';
import '../../../models/teacher_model.dart';
import '../../../services/storage_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscure = true;
  String? _error;
  bool _agreed = false;
  XFile? _profileImage;
  UserRole _selectedRole = UserRole.student;

  Future<void> _pickImage() async {
    final storage = StorageService();
    final files = await storage.pickFromGallery(allowMultiple: false);
    if (files != null && files.isNotEmpty) {
      setState(() => _profileImage = files.first);
    }
  }

  Future<void> _captureCamera() async {
    final storage = StorageService();
    final file = await storage.captureWithCamera();
    if (file != null) setState(() => _profileImage = file);
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreed) {
      setState(() => _error = "Please agree to Terms & Conditions");
      return;
    }
    setState(() => _error = null);
    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      await auth.registerWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        displayName: _nameController.text.trim(),
        role: _selectedRole,
      );
      // Upload profile photo securely after registration (Phase 2)
      final uid = auth.currentFirebaseUser?.uid;
      if (_profileImage != null && uid != null) {
        final storage = StorageService();
        final url = await storage.uploadProfilePhoto(uid, _profileImage!);
        if (url != null) await auth.updateProfile(photoUrl: url);
      }

      if (mounted) {
        if (_selectedRole == UserRole.teacher) {
          Navigator.pushReplacementNamed(context, '/teacherDashboard');
        } else {
          Navigator.pushReplacementNamed(context, '/home');
        }
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
      appBar: AppBar(backgroundColor: Colors.transparent, leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: AppColors.primaryWhite), onPressed: () => Navigator.pop(context)), elevation: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Create Account", style: GoogleFonts.playfairDisplay(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
              const SizedBox(height: 8),
              Text("Join Donlee Digital World Creative Art Academy. Profile photos stored securely. Camera upload enabled for artwork verification.", style: GoogleFonts.poppins(fontSize: 13, color: AppColors.mediumGrey)),
              const SizedBox(height: 24),
              // Phase 2 - Profile photo with camera + gallery
              Center(
                child: Column(children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Stack(children: [
                      Container(width: 90, height: 90, decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primaryBlackLighter, border: Border.all(color: AppColors.primaryGold.withOpacity(0.3), width: 2)), child: _profileImage != null ? ClipOval(child: Image.network(_profileImage!.path, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.person, size: 40, color: AppColors.mediumGrey))) : const Icon(Icons.person, size: 40, color: AppColors.mediumGrey)),
                      Positioned(bottom: 0, right: 0, child: Container(padding: const EdgeInsets.all(6), decoration: const BoxDecoration(color: AppColors.primaryGold, shape: BoxShape.circle), child: const Icon(Icons.edit, size: 14, color: AppColors.primaryBlack))),
                    ]),
                  ),
                  const SizedBox(height: 8),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    OutlinedButton.icon(onPressed: _captureCamera, icon: const Icon(Icons.camera_alt, size: 14), label: const Text("Camera", style: TextStyle(fontSize: 11)), style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6))),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(onPressed: _pickImage, icon: const Icon(Icons.photo_library, size: 14), label: const Text("Gallery", style: TextStyle(fontSize: 11)), style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6))),
                  ]),
                  Text("Profile photo - secure storage, role-based access", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.darkGrey)),
                ]),
              ),
              const SizedBox(height: 20),
              // Role selector - Phase 2
              Text("I am a:", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryWhite)),
              const SizedBox(height: 8),
              Row(children: [
                Expanded(child: ChoiceChip(label: Text("Student", style: GoogleFonts.poppins(fontSize: 12, color: _selectedRole == UserRole.student ? AppColors.primaryBlack : AppColors.primaryWhite)), selected: _selectedRole == UserRole.student, selectedColor: AppColors.primaryGold, backgroundColor: AppColors.cardBlack, onSelected: (v) => setState(() => _selectedRole = UserRole.student))),
                const SizedBox(width: 8),
                Expanded(child: ChoiceChip(label: Text("Teacher", style: GoogleFonts.poppins(fontSize: 12, color: _selectedRole == UserRole.teacher ? AppColors.primaryBlack : AppColors.primaryWhite)), selected: _selectedRole == UserRole.teacher, selectedColor: AppColors.primaryGold, backgroundColor: AppColors.cardBlack, onSelected: (v) => setState(() => _selectedRole = UserRole.teacher))),
                const SizedBox(width: 8),
                Expanded(child: ChoiceChip(label: Text("School Admin", style: GoogleFonts.poppins(fontSize: 11, color: _selectedRole == UserRole.schoolAdmin ? AppColors.primaryBlack : AppColors.primaryWhite)), selected: _selectedRole == UserRole.schoolAdmin, selectedColor: AppColors.primaryGold, backgroundColor: AppColors.cardBlack, onSelected: (v) => setState(() => _selectedRole = UserRole.schoolAdmin))),
              ]),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(controller: _nameController, style: const TextStyle(color: AppColors.primaryWhite), decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_outline, color: AppColors.primaryGold), hintText: 'Donlee Artist'), validator: (v) => v != null && v.length >= 3 ? null : 'Enter your name'),
                    const SizedBox(height: 16),
                    TextFormField(controller: _emailController, style: const TextStyle(color: AppColors.primaryWhite), decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined, color: AppColors.primaryGold)), validator: (v) => v != null && v.contains('@') ? null : 'Valid email required'),
                    const SizedBox(height: 16),
                    TextFormField(controller: _passwordController, obscureText: _obscure, style: const TextStyle(color: AppColors.primaryWhite), decoration: InputDecoration(labelText: 'Password', prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primaryGold), suffixIcon: IconButton(icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, color: AppColors.mediumGrey), onPressed: () => setState(() => _obscure = !_obscure))), validator: (v) => v != null && v.length >= 6 ? null : 'Min 6 chars'),
                    const SizedBox(height: 16),
                    TextFormField(controller: _confirmController, obscureText: _obscure, style: const TextStyle(color: AppColors.primaryWhite), decoration: const InputDecoration(labelText: 'Confirm Password', prefixIcon: Icon(Icons.lock_outline, color: AppColors.primaryGold)), validator: (v) => v == _passwordController.text ? null : 'Passwords do not match'),
                    const SizedBox(height: 16),
                    Row(children: [
                      Checkbox(value: _agreed, activeColor: AppColors.primaryGold, checkColor: AppColors.primaryBlack, onChanged: (v) => setState(() => _agreed = v ?? false)),
                      Expanded(child: Text.rich(TextSpan(children: [TextSpan(text: "I agree to the ", style: GoogleFonts.poppins(color: AppColors.mediumGrey, fontSize: 12)), TextSpan(text: "Terms & Privacy Policy", style: GoogleFonts.poppins(color: AppColors.primaryGold, fontSize: 12, fontWeight: FontWeight.bold)), TextSpan(text: " - Secure storage of photos & progress", style: GoogleFonts.poppins(color: AppColors.mediumGrey, fontSize: 10))]))),
                    ]),
                    if (_error != null) Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.error.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Text(_error!, style: const TextStyle(color: AppColors.error, fontSize: 13))),
                    const SizedBox(height: 24),
                    SizedBox(width: double.infinity, child: ElevatedButton(onPressed: auth.isLoading ? null : _register, child: auth.isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : Text("CREATE ${_selectedRole.name.toUpperCase()} ACCOUNT"))),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text("Already have an account? ", style: GoogleFonts.poppins(color: AppColors.mediumGrey)), GestureDetector(onTap: () => Navigator.pop(context), child: Text("Sign In", style: GoogleFonts.poppins(color: AppColors.primaryGold, fontWeight: FontWeight.bold)))]),
              const SizedBox(height: 12),
              Center(child: GestureDetector(onTap: () => Navigator.pushNamed(context, '/teacherAuth'), child: Text("Are you a teacher? Teacher Portal →", style: GoogleFonts.poppins(color: AppColors.primaryGold, fontSize: 12, decoration: TextDecoration.underline)))),
            ],
          ),
        ),
      ),
    );
  }
}
