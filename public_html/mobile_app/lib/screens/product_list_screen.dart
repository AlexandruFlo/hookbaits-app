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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Eroare: $e')));
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
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

