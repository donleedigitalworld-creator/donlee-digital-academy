enum ProductType { studentArtwork, teacherResource, artSupply, commission, print }
enum ProductStatus { draft, active, sold, archived }
enum OrderStatus { pending, paid, shipped, delivered, cancelled }

class MarketplaceProduct {
  final String id;
  final String sellerId;
  final String sellerName;
  final String? sellerPhotoUrl;
  final String title;
  final String description;
  final ProductType type;
  final double price;
  final String currency;
  final List<String> imageUrls;
  final ProductStatus status;
  final int views;
  final int likes;
  final bool isForCharity;
  final double charityPercent;
  final DateTime createdAt;
  final List<String> tags;
  final bool isCompetitionWinner;
  final String? competitionId;

  MarketplaceProduct({
    required this.id,
    required this.sellerId,
    required this.sellerName,
    this.sellerPhotoUrl,
    required this.title,
    required this.description,
    required this.type,
    required this.price,
    this.currency = 'NGN',
    this.imageUrls = const [],
    required this.status,
    this.views = 0,
    this.likes = 0,
    this.isForCharity = false,
    this.charityPercent = 0,
    required this.createdAt,
    this.tags = const [],
    this.isCompetitionWinner = false,
    this.competitionId,
  });

  static List<MarketplaceProduct> mockProducts() {
    return [
      MarketplaceProduct(
        id: 'prod1',
        sellerId: 'student1',
        sellerName: 'Amara Okafor - National Champion',
        title: 'Unity Mask - Mother and Child - Original (National 1st Place)',
        description: 'Award-winning artwork from National Art Championship 2025, Theme Nigeria at 65: Unity in Diversity. Exhibition at Nike Art Gallery. 50% proceeds to Donlee Foundation for rural offline kits.',
        type: ProductType.studentArtwork,
        price: 150000,
        imageUrls: ['https://images.unsplash.com/photo-1578301978693-85fa9c0320b9?w=800'],
        status: ProductStatus.active,
        views: 2345,
        likes: 189,
        isForCharity: true,
        charityPercent: 50,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        tags: ['National Winner', 'Portrait', 'Unity'],
        isCompetitionWinner: true,
        competitionId: 'comp1',
      ),
      MarketplaceProduct(
        id: 'prod2',
        sellerId: 'teacher1',
        sellerName: 'Ms. Amara Teacher - Verified Educator',
        title: 'Loomis Method Complete Worksheets Pack - 50 Pages',
        description: 'Teacher resource: printable worksheets for Loomis head angles, value scales, handouts for offline teaching in low-connectivity areas. Used by 234 teachers.',
        type: ProductType.teacherResource,
        price: 5000,
        imageUrls: ['https://images.unsplash.com/photo-1513364776144-60967b0f800f?w=800'],
        status: ProductStatus.active,
        views: 567,
        likes: 45,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        tags: ['Loomis', 'Worksheet', 'Offline Ready'],
      ),
    ];
  }
}

class CartItem {
  final String productId;
  final int quantity;

  CartItem({required this.productId, required this.quantity});
}
