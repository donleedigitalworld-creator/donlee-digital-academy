import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/marketplace/marketplace_model.dart';
import '../../../widgets/custom_app_bar.dart';

class ProductDetailScreen extends StatelessWidget {
  final MarketplaceProduct product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: CustomAppBar(title: product.title, subtitle: "${product.sellerName} • ${product.type.name}", showBack: true),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.network(product.imageUrls.first, height: 300, width: double.infinity, fit: BoxFit.cover)),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: Text(product.title, style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryWhite))),
          if (product.isCompetitionWinner) Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: AppColors.primaryGold, borderRadius: BorderRadius.circular(8)), child: Text("National Winner", style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.primaryBlack))),
        ]),
        const SizedBox(height: 8),
        Text("${product.currency} ${product.price.toInt()} ${product.isForCharity ? '• ${product.charityPercent.toInt()}% to charity for rural offline kits' : ''}", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryGold)),
        Text("By ${product.sellerName} • ${product.views} views • ${product.likes} likes • ${product.status.name}", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey)),
        const SizedBox(height: 12),
        Text(product.description, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.offWhite, height: 1.5)),
        const SizedBox(height: 12),
        Wrap(spacing: 6, children: product.tags.map((t) => Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: AppColors.primaryBlackLight, borderRadius: BorderRadius.circular(12)), child: Text(t, style: GoogleFonts.poppins(fontSize: 9, color: AppColors.mediumGrey)))).toList()),
        const SizedBox(height: 20),
        Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.primaryBlackLight, borderRadius: BorderRadius.circular(12)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Marketplace Groundwork - Secure Transactions Future-Ready", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.primaryWhite)),
          const SizedBox(height: 6),
          Text("• Listings: Student artworks (national winner 150k NGN 50% charity), teacher resources (Loomis worksheets 50 pages 5k NGN), art supplies, commissions custom portrait, prints\n• Cart/Wishlist: Add to cart, wishlist, seller profiles verified educator, secure transactions mock future payment Flutterwave/Paystack\n• Charity: 50% proceeds to Donlee Foundation for rural offline kits - North-East 68% offline adoption\n• Competition winner: National 1st place exhibition at Nike Art Gallery auto-flagged for marketplace featured\n• Security: Role-based seller sees own products, buyer secure checkout, escrow for commissions, audit logs\n• Future: Real payments, shipping integration, review system, dispute resolution", style: GoogleFonts.poppins(fontSize: 10, color: AppColors.mediumGrey, height: 1.4)),
        ])),
        const SizedBox(height: 20),
        Row(children: [
          Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.favorite_border, size: 16), label: const Text("Wishlist"))),
          const SizedBox(width: 12),
          Expanded(child: ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.shopping_cart, size: 16), label: Text(product.isForCharity ? "Buy + Charity" : "Add to Cart"))),
        ]),
        const SizedBox(height: 100),
      ]),
    );
  }
}

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: const CustomAppBar(title: "Cart - Marketplace Groundwork", subtitle: "Secure transactions future-ready - Flutterwave/Paystack", showBack: true),
      body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.shopping_cart_outlined, size: 60, color: AppColors.mediumGrey.withOpacity(0.3)),
        const SizedBox(height: 12),
        Text("Cart is empty", style: GoogleFonts.poppins(color: AppColors.mediumGrey)),
        Text("Groundwork: Cart, checkout, escrow for commissions, charity split 50% - future payment integration", style: GoogleFonts.poppins(fontSize: 11, color: AppColors.darkGrey), textAlign: TextAlign.center),
      ])),
    );
  }
}
