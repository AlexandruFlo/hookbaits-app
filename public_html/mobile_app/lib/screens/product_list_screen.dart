import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../api/woocommerce_store_api.dart';
import '../models/product.dart';
import 'product_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final WooStoreApiClient api = WooStoreApiClient();
  final ScrollController scrollController = ScrollController();
  final List<Product> products = [];
  int page = 1;
  bool isLoading = false;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    _load();
    scrollController.addListener(() {
      if (scrollController.position.pixels > scrollController.position.maxScrollExtent - 400 && !isLoading && hasMore) {
        _load();
      }
    });
  }

  Future<void> _load() async {
    setState(() => isLoading = true);
    try {
      final newItems = await api.fetchProducts(page: page, perPage: 20);
      setState(() {
        products.addAll(newItems);
        page += 1;
        if (newItems.isEmpty) hasMore = false;
      });
    } catch (e) {
      // Dacă API-ul nu funcționează, încarcă produse de test
      _loadTestProducts();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Conexiune eșuată, se încarcă produse de test'))
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _loadTestProducts() {
    if (products.isEmpty) {
      final testProducts = [
        Product(
          id: 1,
          name: 'Momeala Carp Expert 1kg',
          permalink: 'https://hookbaits.ro/produs/momeala-carp-expert-1kg',
          priceRange: ProductPriceRange(minAmount: '45', maxAmount: '45'),
          image: ProductImage(src: 'https://via.placeholder.com/300x300/0A7F2E/FFFFFF?text=Momeala+1'),
        ),
        Product(
          id: 2,
          name: 'Boilies Strawberry 20mm',
          permalink: 'https://hookbaits.ro/produs/boilies-strawberry-20mm',
          priceRange: ProductPriceRange(minAmount: '32', maxAmount: '32'),
          image: ProductImage(src: 'https://via.placeholder.com/300x300/0A7F2E/FFFFFF?text=Boilies'),
        ),
        Product(
          id: 3,
          name: 'Carlig Method Feeder',
          permalink: 'https://hookbaits.ro/produs/carlig-method-feeder',
          priceRange: ProductPriceRange(minAmount: '18', maxAmount: '18'),
          image: ProductImage(src: 'https://via.placeholder.com/300x300/0A7F2E/FFFFFF?text=Carlig'),
        ),
        Product(
          id: 4,
          name: 'Fir Monofilament 0.25mm',
          permalink: 'https://hookbaits.ro/produs/fir-monofilament-025mm',
          priceRange: ProductPriceRange(minAmount: '25', maxAmount: '25'),
          image: ProductImage(src: 'https://via.placeholder.com/300x300/0A7F2E/FFFFFF?text=Fir'),
        ),
        Product(
          id: 5,
          name: 'Lanseta Carp Pro 3.6m',
          permalink: 'https://hookbaits.ro/produs/lanseta-carp-pro-36m',
          priceRange: ProductPriceRange(minAmount: '180', maxAmount: '180'),
          image: ProductImage(src: 'https://via.placeholder.com/300x300/0A7F2E/FFFFFF?text=Lanseta'),
        ),
        Product(
          id: 6,
          name: 'Mulineta Quick Drag',
          permalink: 'https://hookbaits.ro/produs/mulineta-quick-drag',
          priceRange: ProductPriceRange(minAmount: '150', maxAmount: '150'),
          image: ProductImage(src: 'https://via.placeholder.com/300x300/0A7F2E/FFFFFF?text=Mulineta'),
        ),
      ];
      
      setState(() {
        products.addAll(testProducts);
        hasMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hookbaits')),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            products.clear();
            page = 1;
            hasMore = true;
          });
          await _load();
        },
        child: GridView.builder(
          controller: scrollController,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.68,
          ),
          itemCount: products.length + (isLoading ? 2 : 0),
          itemBuilder: (context, index) {
            if (index >= products.length) {
              return const Center(child: CircularProgressIndicator());
            }
            final p = products[index];
            final imageUrl = p.image?.src;
            final price = p.priceRange?.minAmount ?? '';
            return Card(
              margin: const EdgeInsets.all(8),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProductScreen(productId: p.id))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: imageUrl == null
                          ? const ColoredBox(color: Color(0x11000000))
                          : CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(p.name, maxLines: 2, overflow: TextOverflow.ellipsis),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(price.isNotEmpty ? 'Lei $price' : '' , style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

