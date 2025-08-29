class ProductPriceRange {
  final String minAmount;
  final String maxAmount;

  const ProductPriceRange({required this.minAmount, required this.maxAmount});
}

class ProductImage {
  final String id;
  final String src;
  final String? alt;

  const ProductImage({required this.id, required this.src, this.alt});
}

class Product {
  final String id; // Schimbat din int în String pentru compatibilitate
  final String name;
  final String permalink;
  final String? descriptionHtml;
  final ProductImage? image;
  final ProductPriceRange? priceRange;
  final String? slug;

  const Product({
    required this.id,
    required this.name,
    required this.permalink,
    this.descriptionHtml,
    this.image,
    this.priceRange,
    this.slug,
  });

  factory Product.fromStoreApiJson(Map<String, dynamic> json) {
    // Store API shape
    final images = (json['images'] as List?) ?? [];
    final firstImage = images.isNotEmpty ? images.first as Map<String, dynamic> : null;
    final prices = json['prices'] as Map<String, dynamic>?;

    return Product(
      id: json['id'].toString(),
      name: json['name'] as String? ?? 'Produs',
      permalink: json['permalink'] as String? ?? '',
      descriptionHtml: json['description'] as String?,
      image: firstImage == null
          ? null
          : ProductImage(
              id: firstImage['id']?.toString() ?? '0',
              src: firstImage['src'] as String? ?? '',
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

  // Constructor pentru WooCommerce REST API JSON
  factory Product.fromWooCommerceJson(Map<String, dynamic> json) {
    final images = json['images'] as List<dynamic>? ?? [];
    final ProductImage? image = images.isNotEmpty 
        ? ProductImage(
            id: images[0]['id']?.toString() ?? '0',
            src: images[0]['src'] ?? '',
            alt: images[0]['alt'],
          )
        : null;

    final String price = json['price']?.toString() ?? '0';
    final String regularPrice = json['regular_price']?.toString() ?? price;
    final String salePrice = json['sale_price']?.toString() ?? '';
    
    // Pentru WooCommerce API, prețurile sunt deja în format final (nu în cenți)
    return Product(
      id: json['id']?.toString() ?? '0',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      permalink: json['permalink'] ?? '',
      descriptionHtml: json['description'],
      image: image,
      priceRange: ProductPriceRange(
        minAmount: price,
        maxAmount: salePrice.isNotEmpty ? salePrice : price,
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

