import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
import '../../../services/auth_service.dart';
import '../../../models/artwork_model.dart';
import 'package:image_picker/image_picker.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<ArtworkModel> _mockPortfolio = [
    ArtworkModel(id: '1', userId: 'mock', userName: 'You', title: 'First Loomis Head', description: 'Practiced Loomis method - front view. Struggled with jaw line but getting better.', imageUrl: 'https://images.unsplash.com/photo-1579783902614-a3fb3927b6a5?w=800', tags: ['Loomis', 'Face', 'Practice'], createdAt: DateTime.now().subtract(const Duration(days: 1))),
    ArtworkModel(id: '2', userId: 'mock', userName: 'You', title: 'Value Sphere', description: '5 values exercise - learned core shadow', imageUrl: 'https://images.unsplash.com/photo-1513364776144-60967b0f800f?w=800', tags: ['Value', 'Shading'], createdAt: DateTime.now().subtract(const Duration(days: 2))),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUpload() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (file == null) return;
    if (!mounted) return;
    // Show upload dialog
    showDialog(context: context, builder: (c) => _uploadDialog(file.path));
  }

  Widget _uploadDialog(String path) {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    return AlertDialog(
      backgroundColor: AppColors.cardBlack,
      title: Text("Upload Artwork", style: GoogleFonts.poppins(color: AppColors.primaryWhite, fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(height: 120, decoration: BoxDecoration(color: AppColors.primaryBlackLighter, borderRadius: BorderRadius.circular(12), image: DecorationImage(image: AssetImage(path), fit: BoxFit.cover, onError: (e, s) {})), child: const Center(child: Icon(Icons.image, color: AppColors.mediumGrey))),
        const SizedBox(height: 12),
        TextField(controller: titleCtrl, style: const TextStyle(color: AppColors.primaryWhite), decoration: const InputDecoration(labelText: 'Title', hintText: 'e.g. My Gesture Study')),
        const SizedBox(height: 12),
        TextField(controller: descCtrl, maxLines: 3, style: const TextStyle(color: AppColors.primaryWhite), decoration: const InputDecoration(labelText: 'Description / What you learned')),
      ])),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        ElevatedButton(onPressed: () {
          final newArt = ArtworkModel(id: DateTime.now().millisecondsSinceEpoch.toString(), userId: Provider.of<AuthService>(context, listen: false).currentFirebaseUser?.uid ?? 'mock', userName: Provider.of<AuthService>(context, listen: false).currentUserModel?.displayName ?? 'You', title: titleCtrl.text.isEmpty ? "Untitled" : titleCtrl.text, description: descCtrl.text, imageUrl: 'https://images.unsplash.com/photo-1541961017774-22349e4a1262?w=800', tags: ['Practice'], createdAt: DateTime.now());
          setState(() => _mockPortfolio.insert(0, newArt));
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Artwork added to portfolio!"), backgroundColor: AppColors.success));
        }, child: const Text("Upload")),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: const CustomAppBar(title: "My Portfolio", subtitle: "Track your creative growth"),
      floatingActionButton: FloatingActionButton.extended(onPressed: _pickAndUpload, backgroundColor: AppColors.primaryGold, foregroundColor: AppColors.primaryBlack, icon: const Icon(Icons.add_a_photo), label: const Text("Upload Work")),
      body: Column(children: [
        Container(color: AppColors.primaryBlackLight, child: TabBar(controller: _tabController, indicatorColor: AppColors.primaryGold, labelColor: AppColors.primaryGold, unselectedLabelColor: AppColors.mediumGrey, tabs: const [Tab(text: "My Works"), Tab(text: "Stats")])),
        Expanded(child: TabBarView(controller: _tabController, children: [
          _mockPortfolio.isEmpty ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.photo_library_outlined, size: 64, color: AppColors.mediumGrey.withOpacity(0.5)), const SizedBox(height: 16), Text("No artworks yet", style: GoogleFonts.poppins(color: AppColors.mediumGrey)), const SizedBox(height: 8), Text("Your practice will appear here", style: GoogleFonts.poppins(fontSize: 12, color: AppColors.darkGrey))])) : GridView.builder(padding: const EdgeInsets.all(16), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.85), itemCount: _mockPortfolio.length, itemBuilder: (c, i) {
            final art = _mockPortfolio[i];
            return Container(decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(16)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(child: ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(16)), child: Image.network(art.imageUrl, width: double.infinity, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(color: AppColors.primaryBlackLighter, child: const Icon(Icons.broken_image, color: AppColors.mediumGrey))))),
              Padding(padding: const EdgeInsets.all(10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(art.title, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryWhite), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text("${art.createdAt.day}/${art.createdAt.month}", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)),
                const SizedBox(height: 4),
                Wrap(spacing: 4, children: art.tags.take(2).map((t) => Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppColors.primaryGold.withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: Text(t, style: GoogleFonts.poppins(fontSize: 8, color: AppColors.primaryGold)))).toList()),
              ])),
            ]));
          }),
          ListView(padding: const EdgeInsets.all(20), children: [
            Row(children: [
              Expanded(child: _statCard("Total Artworks", "${_mockPortfolio.length}", Icons.palette)),
              const SizedBox(width: 12),
              Expanded(child: _statCard("This Month", "5", Icons.calendar_today)),
            ]),
            const SizedBox(height: 16),
            Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(16)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Growth Insight", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
              const SizedBox(height: 8),
              Text("You've uploaded ${_mockPortfolio.length} works. Artists who review old vs new work weekly improve 3x faster. Compare your first and latest piece today.", style: GoogleFonts.poppins(fontSize: 12, color: AppColors.mediumGrey, height: 1.5)),
            ])),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(border: Border.all(color: AppColors.primaryGold.withOpacity(0.3)), borderRadius: BorderRadius.circular(16), gradient: LinearGradient(colors: [AppColors.primaryGold.withOpacity(0.1), Colors.transparent])),
              child: Row(children: [
                const Icon(Icons.tips_and_updates, color: AppColors.primaryGold),
                const SizedBox(width: 12),
                Expanded(child: Text("Tip: Add description of what you learned, not just title. This builds reflective practice.", style: GoogleFonts.poppins(fontSize: 11, color: AppColors.goldLight))),
              ]),
            ),
          ]),
        ])),
      ]),
    );
  }

  Widget _statCard(String label, String value, IconData icon) {
    return Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(16)), child: Column(children: [Icon(icon, color: AppColors.primaryGold), const SizedBox(height: 8), Text(value, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)), Text(label, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey))]));
  }
}
