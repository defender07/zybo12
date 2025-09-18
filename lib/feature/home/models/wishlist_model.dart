class WishlistItem {
  final int id;
  final String name;
  final String featuredImage;
  final double salePrice;
  final bool isFavorite;

  WishlistItem({
    required this.id,
    required this.name,
    required this.featuredImage,
    required this.salePrice,
    required this.isFavorite,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      id: json['id'],
      name: json['name'] ?? '',
      featuredImage: json['featured_image'] ?? '',
      salePrice: (json['sale_price'] ?? 0).toDouble(),
      isFavorite: json['is_favorite'] ?? true,
    );
  }
}
