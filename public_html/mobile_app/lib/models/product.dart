class ProductPriceRange {
  final String minAmount;
  final String maxAmount;

  const ProductPriceRange({required this.minAmount, required this.maxAmount});
}

class ProductImage {
  final String? src;
  final String? alt;

  const ProductImage({this.src, this.alt});
}

class Product {
  final int id;
  final String name;
  final String permalink;
  final String? descriptionHtml;
  final ProductImage? image;
  final ProductPriceRange? priceRange;

  const Product({
    required this.id,
    required this.name,
    required this.permalink,
    this.descriptionHtml,
    this.image,
    this.priceRange,
  });

  factory Product.fromStoreApiJson(Map<String, dynamic> json) {
    // Store API shape
    final images = (json['images'] as List?) ?? [];
    final firstImage = images.isNotEmpty ? images.first as Map<String, dynamic> : null;
    final prices = json['prices'] as Map<String, dynamic>?;

    return Product(
      id: json['id'] as int,
      name: json['name'] as String? ?? 'Produs',
      permalink: json['permalink'] as String? ?? '',
      descriptionHtml: json['description'] as String?,
      image: firstImage == null
          ? null
          : ProductImage(
              src: firstImage['src'] as String?,
              alt: firstImage['alt'] as String?,
            ),
      priceRange: prices == null
          ? null
          : ProductPriceRange(
              minAmount: _formatPrice(prices['min_price']?.toString() ?? prices['price']?.toString() ?? ''),
              maxAmount: _formatPrice(prices['max_price']?.toString() ?? prices['price']?.toString() ?? ''),
            ),
    );
  }

  static String _formatPrice(String price) {
    if (price.isEmpty) return '';
    
    // Convertește din cenți în Lei (împarte la 100)
    final priceInCents = double.tryParse(price);
    if (priceInCents == null) return price;
    
    final priceInLei = priceInCents / 100;
    return priceInLei.toStringAsFixed(2);
  }
}

