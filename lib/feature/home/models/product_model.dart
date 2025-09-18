class Product {
  final int id;
  final String name;
  final String featuredImage;
  final double salePrice;
  final double mrp;
  final String discount;

  Product({
    required this.id,
    required this.name,
    required this.featuredImage,
    required this.salePrice,
    required this.mrp,
    required this.discount,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      featuredImage: json['featured_image'],
      salePrice: (json['sale_price'] as num).toDouble(),
      mrp: (json['mrp'] as num).toDouble(),
      discount: json['discount'],
    );
  }
}
