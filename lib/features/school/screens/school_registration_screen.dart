import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/school_model.dart';
import '../../../services/school_service.dart';
import 'package:provider/provider.dart';
import '../../../services/auth_service.dart';

class SchoolRegistrationScreen extends StatefulWidget {
  const SchoolRegistrationScreen({super.key});

  @override
  State<SchoolRegistrationScreen> createState() => _SchoolRegistrationScreenState();
}

class _SchoolRegistrationScreenState extends State<SchoolRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addrCtrl = TextEditingController();
  final _cityCtrl = TextEditingController(text: 'Lagos');
  final _descCtrl = TextEditingController();
  bool _loading = false;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      final ownerId = auth.currentFirebaseUser?.uid ?? 'admin1';
      final school = SchoolModel(id: '', name: _nameCtrl.text, email: _emailCtrl.text, phone: _phoneCtrl.text, address: _addrCtrl.text, city: _cityCtrl.text, ownerId: ownerId, createdAt: DateTime.now(), description: _descCtrl.text);
      await SchoolService().registerSchool(school);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("School registered! You can now create classes."), backgroundColor: AppColors.success));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: AppColors.error));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(backgroundColor: AppColors.primaryBlack, leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: AppColors.primaryWhite), onPressed: () => Navigator.pop(context)), title: Text("Register School / Academy", style: GoogleFonts.playfairDisplay(color: AppColors.primaryWhite, fontWeight: FontWeight.bold))),
      body: Form(
        key: _formKey,
        child: ListView(padding: const EdgeInsets.all(20), children: [
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.primaryGold.withOpacity(0.2))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [Container(width: 48, height: 48, decoration: BoxDecoration(gradient: AppColors.goldGradient, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.school, color: AppColors.primaryBlack)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Donlee Network School Registration", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primaryWhite)), Text("Join Donlee Digital World network. Manage teachers, classes, students, progress tracking in one portal.", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey))]))]),
          ])),
          const SizedBox(height: 20),
          TextFormField(controller: _nameCtrl, style: const TextStyle(color: AppColors.primaryWhite), decoration: const InputDecoration(labelText: 'School / Studio Name *', prefixIcon: Icon(Icons.business, color: AppColors.primaryGold)), validator: (v) => v != null && v.length >= 3 ? null : 'Required'),
          const SizedBox(height: 12),
          TextFormField(controller: _emailCtrl, style: const TextStyle(color: AppColors.primaryWhite), decoration: const InputDecoration(labelText: 'Official Email *', prefixIcon: Icon(Icons.email, color: AppColors.primaryGold)), validator: (v) => v != null && v.contains('@') ? null : 'Valid email'),
          const SizedBox(height: 12),
          TextFormField(controller: _phoneCtrl, style: const TextStyle(color: AppColors.primaryWhite), decoration: const InputDecoration(labelText: 'Phone', prefixIcon: Icon(Icons.phone, color: AppColors.primaryGold))),
          const SizedBox(height: 12),
          TextFormField(controller: _addrCtrl, style: const TextStyle(color: AppColors.primaryWhite), decoration: const InputDecoration(labelText: 'Address', prefixIcon: Icon(Icons.location_on, color: AppColors.primaryGold))),
          const SizedBox(height: 12),
          TextFormField(controller: _cityCtrl, style: const TextStyle(color: AppColors.primaryWhite), decoration: const InputDecoration(labelText: 'City', prefixIcon: Icon(Icons.location_city, color: AppColors.primaryGold))),
          const SizedBox(height: 12),
          TextFormField(controller: _descCtrl, maxLines: 3, style: const TextStyle(color: AppColors.primaryWhite), decoration: const InputDecoration(labelText: 'About School', alignLabelWithHint: true)),
          const SizedBox(height: 24),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _loading ? null : _register, child: _loading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text("REGISTER SCHOOL"))),
          const SizedBox(height: 16),
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.primaryBlackLight, borderRadius: BorderRadius.circular(12)), child: Row(children: [const Icon(Icons.security, color: AppColors.primaryGold, size: 16), const SizedBox(width: 8), Expanded(child: Text("Secure storage: All school data, student progress, photos stored securely in Firebase with role-based access. Teachers only see their classes.", style: GoogleFonts.poppins(fontSize: 11, color: AppColors.mediumGrey)))])),
        ]),
      ),
    );
  }
}
