import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../services/national/national_dashboard_service.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../core/offline/offline_banner.dart';

class ResourceLibraryScreen extends StatefulWidget {
  const ResourceLibraryScreen({super.key});

  @override
  State<ResourceLibraryScreen> createState() => _ResourceLibraryScreenState();
}

class _ResourceLibraryScreenState extends State<ResourceLibraryScreen> {
  final ResourceLibraryService _service = ResourceLibraryService();
  List<dynamic> _resources = [];
  bool _loading = true;
  String _filter = 'All';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final list = await _service.getResources();
    setState(() {
      _resources = list;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: const CustomAppBar(title: "Resource Library", subtitle: "Videos, templates, reference images - offline downloadable, low-bandwidth"),
      body: Column(children: [
        const OfflineBanner(),
        Container(height: 50, padding: const EdgeInsets.symmetric(vertical: 8), child: ListView.separated(padding: const EdgeInsets.symmetric(horizontal: 16), scrollDirection: Axis.horizontal, itemCount: 6, separatorBuilder: (_, __) => const SizedBox(width: 8), itemBuilder: (c, i) {
          final filters = ['All', 'Video', 'Template', 'Reference', 'Ebook', 'Offline DL'];
          return ChoiceChip(label: Text(filters[i], style: GoogleFonts.poppins(fontSize: 11)), selected: _filter == filters[i], selectedColor: AppColors.primaryGold, onSelected: (_) => setState(() => _filter = filters[i]));
        })),
        Expanded(
          child: _loading ? const Center(child: CircularProgressIndicator(color: AppColors.primaryGold)) : GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.85),
            itemCount: _resources.length,
            itemBuilder: (c, i) {
              final r = _resources[i] as ResourceModel;
              return Container(decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.primaryBlackLighter)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Stack(children: [
                  ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(14)), child: Image.network(r.thumbnailUrl ?? 'https://images.unsplash.com/photo-1513364776144-60967b0f800f?w=800', height: 100, width: double.infinity, fit: BoxFit.cover)),
                  Positioned(top: 8, right: 8, child: Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(8)), child: Text("${r.durationMinutes}m", style: GoogleFonts.poppins(fontSize: 9, color: Colors.white)))),
                  if (r.isDownloaded) Positioned(bottom: 6, left: 6, child: Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppColors.success, borderRadius: BorderRadius.circular(8)), child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.download_done, size: 10, color: Colors.white), const SizedBox(width: 2), Text("Offline", style: GoogleFonts.poppins(fontSize: 8, color: Colors.white))] ))),
                ]),
                Padding(padding: const EdgeInsets.all(10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(r.title, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryWhite), maxLines: 2),
                  const SizedBox(height: 4),
                  Row(children: [const Icon(Icons.star, size: 10, color: AppColors.primaryGold), Text(" ${r.rating} • ${r.downloadCount} downloads", style: GoogleFonts.poppins(fontSize: 9, color: AppColors.mediumGrey))]),
                  const SizedBox(height: 6),
                  Row(children: [
                    Icon(r.isFavorite ? Icons.favorite : Icons.favorite_border, size: 12, color: r.isFavorite ? AppColors.error : AppColors.mediumGrey),
                    const Spacer(),
                    Icon(Icons.download, size: 14, color: r.isDownloaded ? AppColors.success : AppColors.mediumGrey),
                    const SizedBox(width: 6),
                    const Icon(Icons.share, size: 12, color: AppColors.mediumGrey),
                  ]),
                ])),
              ]));
            },
          ),
        ),
      ]),
    );
  }
}
