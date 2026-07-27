import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../services/auth_service.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../services/storage_service.dart';

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  bool _editing = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final user = auth.currentUserModel;
    final role = auth.currentRole;

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: CustomAppBar(title: "Profile", subtitle: "${role.name.toUpperCase()} Account • Secure", showBack: true, actions: [IconButton(icon: Icon(_editing ? Icons.check : Icons.edit, color: AppColors.primaryGold), onPressed: () => setState(() => _editing = !_editing))]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          Stack(children: [
            Container(
              width: 110, height: 110,
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.primaryGold, width: 3), image: user?.photoUrl != null ? DecorationImage(image: NetworkImage(user!.photoUrl!), fit: BoxFit.cover) : null, color: AppColors.primaryBlackLight),
              child: user?.photoUrl == null ? const Icon(Icons.person, size: 50, color: AppColors.mediumGrey) : null,
            ),
            Positioned(bottom: 0, right: 0, child: GestureDetector(onTap: () async {
              final storage = StorageService();
              final files = await storage.pickFromGallery(allowMultiple: false);
              if (files != null && files.isNotEmpty && auth.currentFirebaseUser != null) {
                final url = await storage.uploadProfilePhoto(auth.currentFirebaseUser!.uid, files.first);
                if (url != null) await auth.updateProfile(photoUrl: url);
              }
            }, child: Container(padding: const EdgeInsets.all(8), decoration: const BoxDecoration(color: AppColors.primaryGold, shape: BoxShape.circle), child: const Icon(Icons.camera_alt, size: 16, color: AppColors.primaryBlack)))),
          ]),
          const SizedBox(height: 16),
          Text(user?.displayName ?? 'Artist', style: GoogleFonts.playfairDisplay(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
          const SizedBox(height: 4),
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: role == auth.currentRole ? AppColors.primaryGold.withOpacity(0.15) : AppColors.cardBlack, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.primaryGold.withOpacity(0.3))), child: Text(role.name.toUpperCase(), style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primaryGold, letterSpacing: 1))),
          const SizedBox(height: 6),
          Text(user?.email ?? '', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.mediumGrey)),
          const SizedBox(height: 24),
          Row(children: [
            Expanded(child: _statBox("${user?.totalLessonsCompleted ?? 0}", "Lessons Done", Icons.check_circle)),
            const SizedBox(width: 12),
            Expanded(child: _statBox("${user?.totalArtworksUploaded ?? 0}", "Artworks", Icons.palette)),
            const SizedBox(width: 12),
            Expanded(child: _statBox("${((user?.overallProgress ?? 0)*100).toInt()}%", "Progress", Icons.trending_up)),
          ]),
          const SizedBox(height: 24),
          _profileTile(Icons.school, "School", auth.currentSchoolId ?? "Not assigned - Join via code"),
          _profileTile(Icons.class_, "Class", auth.currentClassId ?? "Not assigned"),
          _profileTile(Icons.security, "Data Security", "Photos & progress securely stored in Firebase • Role-based access • Encrypted at rest"),
          _profileTile(Icons.camera_alt, "Camera Upload", "You have used camera capture - original work verified • Gallery also available where allowed"),
          const SizedBox(height: 24),
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(16)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Learning Journey", style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
            const SizedBox(height: 12),
            ...[
              {'module': 'Introduction to Fine Art', 'progress': 1.0},
              {'module': 'Elements of Art', 'progress': 0.8},
              {'module': 'Facial Drawing', 'progress': 0.45},
              {'module': 'Color Theory', 'progress': 0.2},
            ].map((m) => Padding(padding: const EdgeInsets.only(bottom: 12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(m['module'] as String, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.primaryWhite)), Text("${((m['progress'] as double)*100).toInt()}%", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.primaryGold))]),
              const SizedBox(height: 4),
              ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: m['progress'] as double, backgroundColor: AppColors.primaryBlackLighter, color: AppColors.primaryGold, minHeight: 4)),
            ]))),
          ])),
          const SizedBox(height: 20),
          SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: () => Navigator.pushNamed(context, '/certificates'), icon: const Icon(Icons.workspace_premium), label: const Text("View My Certificates"))),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: () { Provider.of<AuthService>(context, listen: false).logout(); Navigator.pushReplacementNamed(context, '/login'); }, icon: const Icon(Icons.logout), label: const Text("Log Out"), style: ElevatedButton.styleFrom(backgroundColor: AppColors.error))),
          const SizedBox(height: 100),
        ]),
      ),
    );
  }

  Widget _statBox(String value, String label, IconData icon) {
    return Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.primaryBlackLighter)), child: Column(children: [Icon(icon, color: AppColors.primaryGold, size: 18), const SizedBox(height: 6), Text(value, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)), Text(label, style: GoogleFonts.poppins(fontSize: 9, color: AppColors.mediumGrey), textAlign: TextAlign.center)]));
  }

  Widget _profileTile(IconData icon, String title, String subtitle) {
    return Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(12)), child: Row(children: [Container(width: 36, height: 36, decoration: BoxDecoration(color: AppColors.primaryBlackLighter, borderRadius: BorderRadius.circular(8)), child: Icon(icon, size: 18, color: AppColors.primaryGold)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryWhite)), const SizedBox(height: 2), Text(subtitle, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.mediumGrey), maxLines: 2)]))]));
  }
}
