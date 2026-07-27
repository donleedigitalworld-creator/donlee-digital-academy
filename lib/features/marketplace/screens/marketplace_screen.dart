import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/marketplace/marketplace_model.dart';
import '../../../widgets/custom_app_bar.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  List<MarketplaceProduct> _products = [];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
    _products = MarketplaceProduct.mockProducts();
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: const CustomAppBar(title: "Digital Marketplace - Groundwork", subtitle: "Student artworks, teacher resources, commission work - secure transactions future-ready"),
      body: Column(children: [
        Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.orangeAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(0)), child: Row(children: [
          const Icon(Icons.info, size: 14, color: Colors.orangeAccent),
          const SizedBox(width: 8),
          Expanded(child: Text("Optional Marketplace Groundwork - Phase 6: Listings, cart, wishlist, seller profiles, secure transactions mock, future payment integration via Flutterwave/Paystack. 50% charity option for rural offline kits.", style: GoogleFonts.poppins(fontSize: 10, color: Colors.orangeAccent))),
        ])),
        Container(color: AppColors.primaryBlackLight, child: TabBar(controller: _tabCtrl, indicatorColor: AppColors.primaryGold, labelColor: AppColors.primaryGold, unselectedLabelColor: AppColors.mediumGrey, tabs: const [Tab(text: "Artworks"), Tab(text: "Resources"), Tab(text: "Commissions")])),
        Expanded(
          child: TabBarView(controller: _tabCtrl, children: [
            _buildGrid(_products.where((p) => p.type == ProductType.studentArtwork).toList()),
            _buildGrid(_products.where((p) => p.type == ProductType.teacherResource).toList()),
            Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.handyman, size: 60, color: AppColors.mediumGrey.withOpacity(0.3)),
              const SizedBox(height: 12),
              Text("Commissions - Custom Artwork Requests", style: GoogleFonts.poppins(color: AppColors.mediumGrey)),
              Text("Future: Request custom portrait, negotiation, secure escrow", style: GoogleFonts.poppins(fontSize: 11, color: AppColors.darkGrey)),
            ])),
          ]),
        ),
      ]),
    );
  }

  Widget _buildGrid(List<MarketplaceProduct> list) {
    if (list.isEmpty) {
      final all = MarketplaceProduct.mockProducts();
      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.75),
        itemCount: all.length,
        itemBuilder: (c, i) {
          final p = all[i];
          return Container(decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(14), border: Border.all(color: p.isForCharity ? AppColors.success.withOpacity(0.3) : AppColors.primaryBlackLighter)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Stack(children: [
              ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(14)), child: Image.network(p.imageUrls.first, height: 110, width: double.infinity, fit: BoxFit.cover)),
              if (p.isCompetitionWinner) Positioned(top: 6, left: 6, child: Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppColors.primaryGold, borderRadius: BorderRadius.circular(8)), child: Text("National Winner", style: GoogleFonts.poppins(fontSize: 7, fontWeight: FontWeight.bold, color: AppColors.primaryBlack)))),
              if (p.isForCharity) Positioned(top: 6, right: 6, child: Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppColors.success, borderRadius: BorderRadius.circular(8)), child: Text("${p.charityPercent.toInt()}% Charity", style: GoogleFonts.poppins(fontSize: 7, color: Colors.white)))),
            ]),
            Padding(padding: const EdgeInsets.all(10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(p.title, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primaryWhite), maxLines: 2),
              Text(p.sellerName, style: GoogleFonts.poppins(fontSize: 9, color: AppColors.primaryGold), maxLines: 1),
              const SizedBox(height: 4),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text("${p.currency} ${p.price.toInt()}", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
                Row(children: [const Icon(Icons.visibility, size: 10, color: AppColors.mediumGrey), Text(" ${p.views}", style: GoogleFonts.poppins(fontSize: 9, color: AppColors.mediumGrey)), const SizedBox(width: 6), const Icon(Icons.favorite, size: 10, color: AppColors.error), Text(" ${p.likes}", style: GoogleFonts.poppins(fontSize: 9, color: AppColors.mediumGrey))]),
              ]),
            ])),
          ]));
        },
      );
    }
    return const SizedBox();
  }
}
