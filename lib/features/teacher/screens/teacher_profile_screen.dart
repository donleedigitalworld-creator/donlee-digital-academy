import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../services/auth_service.dart';
import '../../../widgets/custom_app_bar.dart';

class TeacherProfileScreen extends StatelessWidget {
  const TeacherProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final user = auth.currentUserModel;

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: const CustomAppBar(title: "Teacher Profile", subtitle: "Verified educator • Secure", showBack: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          CircleAvatar(radius: 50, backgroundColor: AppColors.primaryGold.withOpacity(0.15), backgroundImage: user?.photoUrl != null ? NetworkImage(user!.photoUrl!) : null, child: user?.photoUrl == null ? const Icon(Icons.person, size: 40, color: AppColors.mediumGrey) : null),
          const SizedBox(height: 12),
          Text(user?.displayName ?? 'Instructor', style: GoogleFonts.playfairDisplay(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
          const SizedBox(height: 4),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.verified, size: 14, color: AppColors.success),
            const SizedBox(width: 4),
            Text("Verified Teacher • Portrait Specialist", style: GoogleFonts.poppins(fontSize: 11, color: AppColors.success)),
          ]),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(child: _stat("34", "Students", Icons.groups)),
            const SizedBox(width: 12),
            Expanded(child: _stat("12", "Classes", Icons.class_)),
            const SizedBox(width: 12),
            Expanded(child: _stat("4.9", "Rating", Icons.star)),
          ]),
          const SizedBox(height: 20),
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(16)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Bio", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
            const SizedBox(height: 8),
            Text("Professional portrait artist with 8 years teaching. Specializes in Loomis method, anatomy, and camera-based assignment review. Believes in teacher-guided learning with future AI assistance for proportions & shading.", style: GoogleFonts.poppins(fontSize: 12, color: AppColors.mediumGrey, height: 1.5)),
          ])),
          const SizedBox(height: 16),
          _tile(Icons.camera_alt, "Camera Review Enabled", "You review camera & gallery uploads, annotate, score"),
          _tile(Icons.security, "Secure Storage", "Student photos & progress encrypted, role-based access"),
          const SizedBox(height: 20),
          SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: () => Navigator.pushNamed(context, '/classManagement'), icon: const Icon(Icons.class_), label: const Text("MANAGE CLASSES"))),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: () { Provider.of<AuthService>(context, listen: false).logout(); Navigator.pushReplacementNamed(context, '/login'); }, icon: const Icon(Icons.logout), label: const Text("Log Out"))),
        ]),
      ),
    );
  }

  Widget _stat(String v, String l, IconData i) {
    return Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(12)), child: Column(children: [Icon(i, color: AppColors.primaryGold, size: 18), const SizedBox(height: 6), Text(v, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primaryWhite)), Text(l, style: GoogleFonts.poppins(fontSize: 9, color: AppColors.mediumGrey))]));
  }

  Widget _tile(IconData icon, String title, String sub) {
    return Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(12)), child: Row(children: [Container(width: 36, height: 36, decoration: BoxDecoration(color: AppColors.primaryBlackLighter, borderRadius: BorderRadius.circular(8)), child: Icon(icon, size: 18, color: AppColors.primaryGold)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryWhite)), Text(sub, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey))]))]));
  }
}
