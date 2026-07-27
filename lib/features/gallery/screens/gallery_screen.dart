import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../models/artwork_model.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  String _filter = "All";
  final List<String> _filters = ["All", "Portrait", "Figure", "Still Life", "Landscape", "Practice"];

  final List<ArtworkModel> _galleryArtworks = [
    ArtworkModel(id: 'g1', userId: 'u1', userName: 'Amara Okafor', title: 'Market Day - Charcoal', description: 'Inspired by Elements of Art module, focused on texture and value', imageUrl: 'https://images.unsplash.com/photo-1578301978693-85fa9c0320b9?w=800', tags: ['Charcoal', 'Still Life', 'Value'], likes: 42, createdAt: DateTime.now().subtract(const Duration(hours: 5)), isInGallery: true),
    ArtworkModel(id: 'g2', userId: 'u2', userName: 'Tunde Adebayo', title: 'Loomis Heads - 3 Angles', description: 'Practiced 10 heads today! Loomis method changed everything', imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800', tags: ['Portrait', 'Loomis', 'Face'], likes: 67, createdAt: DateTime.now().subtract(const Duration(hours: 12)), isInGallery: true),
    ArtworkModel(id: 'g3', userId: 'u3', userName: 'Chioma Nwosu', title: 'Color Harmony Study', description: 'Complementary colors - orange/blue. From Color Theory lesson 1', imageUrl: 'https://images.unsplash.com/photo-1513364776144-60967b0f800f?w=800', tags: ['Color Theory', 'Landscape', 'Practice'], likes: 89, createdAt: DateTime.now().subtract(const Duration(days: 1)), isInGallery: true),
    ArtworkModel(id: 'g4', userId: 'u4', userName: 'David Lee', title: 'Hands - 1 Hour Study', description: 'Hands module is hard but worth it. Structure first, details later', imageUrl: 'https://images.unsplash.com/photo-1579783902614-a3fb3927b6a5?w=800', tags: ['Hands', 'Figure', 'Anatomy'], likes: 54, createdAt: DateTime.now().subtract(const Duration(days: 1)), isInGallery: true),
    ArtworkModel(id: 'g5', userId: 'u5', userName: 'Zainab Musa', title: 'Lagos Skyline - Perspective', description: '2-point perspective of Balogun market. vanishing points outside page!', imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=800', tags: ['Perspective', 'Landscape', 'Urban'], likes: 121, createdAt: DateTime.now().subtract(const Duration(days: 2)), isInGallery: true),
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _filter == "All" ? _galleryArtworks : _galleryArtworks.where((a) => a.tags.any((t) => t.toLowerCase().contains(_filter.toLowerCase())) || a.title.toLowerCase().contains(_filter.toLowerCase())).toList();

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: const CustomAppBar(title: "Student Gallery", subtitle: "Inspiration from Donlee community"),
      body: Column(
        children: [
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.separated(padding: const EdgeInsets.symmetric(horizontal: 16), scrollDirection: Axis.horizontal, itemCount: _filters.length, separatorBuilder: (_, __) => const SizedBox(width: 8), itemBuilder: (c, i) {
              final f = _filters[i];
              final selected = f == _filter;
              return ChoiceChip(label: Text(f, style: GoogleFonts.poppins(fontSize: 12, fontWeight: selected ? FontWeight.bold : FontWeight.normal, color: selected ? AppColors.primaryBlack : AppColors.primaryWhite)), selected: selected, selectedColor: AppColors.primaryGold, backgroundColor: AppColors.primaryBlackLight, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: selected ? AppColors.primaryGold : AppColors.primaryBlackLighter)), onSelected: (v) => setState(() => _filter = f));
            }),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.75),
              itemCount: filtered.length,
              itemBuilder: (c, i) {
                final art = filtered[i];
                return GestureDetector(
                  onTap: () => _showArtworkDetail(art),
                  child: Container(
                    decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8)]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(16)), child: Image.network(art.imageUrl, width: double.infinity, height: double.infinity, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(color: AppColors.primaryBlackLighter, child: const Icon(Icons.image, color: AppColors.mediumGrey)))),
                              Positioned(top: 8, right: 8, child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(12)), child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.favorite, size: 10, color: AppColors.error), const SizedBox(width: 4), Text("${art.likes}", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.primaryWhite))]))),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(art.title, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryWhite), maxLines: 1, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 2),
                            Row(children: [Container(width: 16, height: 16, decoration: BoxDecoration(color: AppColors.primaryGold.withOpacity(0.2), shape: BoxShape.circle), child: Center(child: Text(art.userName[0], style: GoogleFonts.poppins(fontSize: 8, color: AppColors.primaryGold)))), const SizedBox(width: 4), Expanded(child: Text(art.userName, style: GoogleFonts.poppins(fontSize: 9, color: AppColors.mediumGrey), maxLines: 1, overflow: TextOverflow.ellipsis))]),
                          ]),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showArtworkDetail(ArtworkModel art) {
    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: AppColors.cardBlack, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))), builder: (c) => DraggableScrollableSheet(initialChildSize: 0.85, expand: false, builder: (context, scrollController) => SingleChildScrollView(controller: scrollController, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Stack(children: [
        ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(20)), child: Image.network(art.imageUrl, width: double.infinity, height: 350, fit: BoxFit.cover)),
        Positioned(top: 16, right: 16, child: IconButton(icon: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), shape: BoxShape.circle), child: const Icon(Icons.close, size: 16, color: AppColors.primaryWhite)), onPressed: () => Navigator.pop(context))),
      ]),
      Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(art.title, style: GoogleFonts.playfairDisplay(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
          const SizedBox(height: 8),
          Row(children: [CircleAvatar(radius: 14, backgroundColor: AppColors.primaryGold.withOpacity(0.2), child: Text(art.userName[0], style: GoogleFonts.poppins(fontSize: 12, color: AppColors.primaryGold))), const SizedBox(width: 8), Text(art.userName, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primaryWhite)), const Spacer(), IconButton(icon: const Icon(Icons.favorite_border, color: AppColors.mediumGrey), onPressed: () {}), Text("${art.likes}", style: GoogleFonts.poppins(color: AppColors.mediumGrey))]),
          const SizedBox(height: 16),
          Text(art.description, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.mediumGrey, height: 1.5)),
          const SizedBox(height: 16),
          Wrap(spacing: 8, children: art.tags.map((t) => Chip(label: Text(t, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.primaryGold)), backgroundColor: AppColors.primaryGold.withOpacity(0.15), side: BorderSide.none)).toList()),
          const SizedBox(height: 24),
          SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.comment_outlined, size: 16), label: const Text("Encourage Artist"))),
        ]),
      ),
    ]))));
  }
}
