import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/assignment_model.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../services/teacher_service.dart';

class SubmissionsReviewScreen extends StatefulWidget {
  const SubmissionsReviewScreen({super.key});

  @override
  State<SubmissionsReviewScreen> createState() => _SubmissionsReviewScreenState();
}

class _SubmissionsReviewScreenState extends State<SubmissionsReviewScreen> {
  final TeacherService _service = TeacherService();
  int _selectedIndex = 0;

  // Mock submissions
  final List<Map<String, dynamic>> _mockSubs = [
    {
      'student': 'Amara Okafor',
      'photo': 'AO',
      'assignment': 'Loomis Head - 5 Angles',
      'submitted': '2h ago',
      'images': [
        'https://images.unsplash.com/photo-1579783902614-a3fb3927b6a5?w=800',
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800',
      ],
      'status': 'pending',
      'isCamera': true,
    },
    {
      'student': 'Tunde Adebayo',
      'photo': 'TA',
      'assignment': 'Loomis Head - 5 Angles',
      'submitted': '5h ago',
      'images': ['https://images.unsplash.com/photo-1513364776144-60967b0f800f?w=800'],
      'status': 'pending',
      'isCamera': false,
    },
    {
      'student': 'Chioma Nwosu',
      'photo': 'CN',
      'assignment': 'Value Scale & Sphere',
      'submitted': '1d ago',
      'images': ['https://images.unsplash.com/photo-1578301978693-85fa9c0320b9?w=800'],
      'status': 'reviewed',
      'score': 85,
      'isCamera': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final current = _mockSubs[_selectedIndex];

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: const CustomAppBar(title: "Review Submissions", subtitle: "Camera & gallery uploads + scoring", showBack: true),
      body: Row(children: [
        // List pane - desktop style, but responsive
        if (MediaQuery.of(context).size.width > 600)
          Container(
            width: 300,
            decoration: BoxDecoration(color: AppColors.cardBlack, border: Border(right: BorderSide(color: AppColors.primaryBlackLighter))),
            child: ListView.separated(
              itemCount: _mockSubs.length,
              separatorBuilder: (_, __) => Divider(color: AppColors.primaryBlackLighter, height: 1),
              itemBuilder: (c, i) {
                final s = _mockSubs[i];
                final isSelected = i == _selectedIndex;
                return ListTile(
                  selected: isSelected,
                  selectedTileColor: AppColors.primaryGold.withOpacity(0.1),
                  leading: Stack(children: [
                    CircleAvatar(backgroundColor: AppColors.primaryGold.withOpacity(0.2), child: Text(s['photo'], style: const TextStyle(color: AppColors.primaryGold, fontSize: 12))),
                    if (s['isCamera']) Positioned(bottom: 0, right: 0, child: Container(padding: const EdgeInsets.all(2), decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle), child: const Icon(Icons.camera_alt, size: 8, color: Colors.white))),
                  ]),
                  title: Text(s['student'], style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: isSelected ? AppColors.primaryGold : AppColors.primaryWhite)),
                  subtitle: Text("${s['assignment']}\n${s['submitted']} • ${s['isCamera'] ? 'Camera' : 'Gallery'}", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)),
                  trailing: Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: s['status'] == 'pending' ? AppColors.error.withOpacity(0.15) : AppColors.success.withOpacity(0.15), borderRadius: BorderRadius.circular(6)), child: Text(s['status'], style: GoogleFonts.poppins(fontSize: 9, color: s['status'] == 'pending' ? AppColors.error : AppColors.success))),
                  onTap: () => setState(() => _selectedIndex = i),
                );
              },
            ),
          ),
        // Detail pane
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (MediaQuery.of(context).size.width <= 600) ...[
                SizedBox(height: 60, child: ListView.separated(scrollDirection: Axis.horizontal, itemCount: _mockSubs.length, separatorBuilder: (_, __) => const SizedBox(width: 8), itemBuilder: (c, i) => ChoiceChip(label: Text(_mockSubs[i]['student'], style: GoogleFonts.poppins(fontSize: 11)), selected: i == _selectedIndex, selectedColor: AppColors.primaryGold, onSelected: (_) => setState(() => _selectedIndex = i)))),
                const SizedBox(height: 16),
              ],
              Row(children: [
                CircleAvatar(radius: 24, backgroundColor: AppColors.primaryGold.withOpacity(0.2), child: Text(current['photo'], style: const TextStyle(color: AppColors.primaryGold))),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(current['student'], style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)), Text(current['assignment'], style: GoogleFonts.poppins(fontSize: 12, color: AppColors.primaryGold)), Text("${current['submitted']} • ${current['isCamera'] ? 'Captured with camera - secure upload' : 'Uploaded from gallery'}", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey))])),
                Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: current['isCamera'] ? AppColors.success.withOpacity(0.15) : AppColors.primaryBlackLight, borderRadius: BorderRadius.circular(20), border: Border.all(color: current['isCamera'] ? AppColors.success.withOpacity(0.3) : AppColors.primaryBlackLighter)), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(current['isCamera'] ? Icons.camera_alt : Icons.photo_library, size: 12, color: current['isCamera'] ? AppColors.success : AppColors.mediumGrey), const SizedBox(width: 4), Text(current['isCamera'] ? "Camera Verified" : "Gallery", style: GoogleFonts.poppins(fontSize: 10, color: current['isCamera'] ? AppColors.success : AppColors.mediumGrey))])),
              ]),
              const SizedBox(height: 20),
              Text("Student Artwork (${(current['images'] as List).length})", style: GoogleFonts.playfairDisplay(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
              const SizedBox(height: 12),
              ... (current['images'] as List<String>).map((img) => Container(margin: const EdgeInsets.only(bottom: 16), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(16)), child: Column(children: [ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(16)), child: Image.network(img, width: double.infinity, height: 300, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(height: 200, color: AppColors.primaryBlackLighter, child: const Icon(Icons.broken_image, color: AppColors.mediumGrey)))), Padding(padding: const EdgeInsets.all(12), child: Row(children: [IconButton(icon: const Icon(Icons.zoom_in, color: AppColors.primaryGold), onPressed: () {}), IconButton(icon: const Icon(Icons.edit, color: AppColors.mediumGrey), onPressed: () {}), const Spacer(), OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.draw, size: 14), label: const Text("Annotate", style: TextStyle(fontSize: 11)))]))] ))),
              const SizedBox(height: 20),
              Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.primaryBlackLight, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.primaryGold.withOpacity(0.2))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("Teacher Review & Scoring", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
                const SizedBox(height: 16),
                Text("Feedback (visible to student)", style: GoogleFonts.poppins(fontSize: 11, color: AppColors.mediumGrey)),
                const SizedBox(height: 8),
                TextField(maxLines: 4, style: const TextStyle(color: AppColors.primaryWhite, fontSize: 13), decoration: InputDecoration(hintText: 'Great effort on proportions! For next time, focus on jaw angle. See my annotation on image 1...', hintStyle: GoogleFonts.poppins(fontSize: 11, color: AppColors.darkGrey), filled: true, fillColor: AppColors.primaryBlackLighter, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
                const SizedBox(height: 16),
                Row(children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Score /100", style: GoogleFonts.poppins(fontSize: 11, color: AppColors.mediumGrey)), const SizedBox(height: 6), TextField(keyboardType: TextInputType.number, style: const TextStyle(color: AppColors.primaryWhite), decoration: InputDecoration(hintText: '85', prefixIcon: const Icon(Icons.score, color: AppColors.primaryGold, size: 18)), controller: TextEditingController(text: current['score']?.toString() ?? ''))])),
                  const SizedBox(width: 16),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Future: AI Suggestion", style: GoogleFonts.poppins(fontSize: 11, color: AppColors.mediumGrey)), const SizedBox(height: 6), Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.primaryGold.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.primaryGold.withOpacity(0.2))), child: Row(children: [const Icon(Icons.auto_awesome, size: 14, color: AppColors.primaryGold), const SizedBox(width: 6), Expanded(child: Text("AI: Proportions suggest jaw 10% too long. Shading: Core shadow could be darker.", style: GoogleFonts.poppins(fontSize: 9, color: AppColors.goldLight, fontStyle: FontStyle.italic)))]))])),
                ]),
                const SizedBox(height: 20),
                Row(children: [Expanded(child: OutlinedButton(onPressed: () {}, child: const Text("Request Resubmit"))), const SizedBox(width: 12), Expanded(child: ElevatedButton(onPressed: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Feedback sent! Student will see score & annotation"), backgroundColor: AppColors.success)); }, child: const Text("Submit Review")))]),
              ])),
              const SizedBox(height: 100),
            ]),
          ),
        ),
      ],
    );
  }
}
