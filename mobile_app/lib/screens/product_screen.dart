import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/woocommerce_store_api.dart';
import '../models/product.dart';
import '../state/cart.dart';

class ProductScreen extends StatefulWidget {
  final int productId;
  const ProductScreen({super.key, required this.productId});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final WooStoreApiClient api = WooStoreApiClient();
  Product? product;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final p = await api.fetchProduct(widget.productId);
      setState(() {
        product = p;
        loading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => loading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Eroare: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = product;
    return Scaffold(
      appBar: AppBar(title: Text(p?.name ?? 'Produs')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : p == null
              ? const Center(child: Text('Nu s-a găsit produsul'))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (p.image?.src != null)
                        AspectRatio(
                          aspectRatio: 1,
                          child: CachedNetworkImage(imageUrl: p.image!.src!, fit: BoxFit.cover),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.name, style: Theme.of(context).textTheme.headlineSmall),
                            const SizedBox(height: 8),
                            if (p.priceRange != null)
                              Text('Lei ${p.priceRange!.minAmount}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            const SizedBox(height: 12),
                            if (p.descriptionHtml != null && p.descriptionHtml!.isNotEmpty)
                              Text(p.descriptionHtml!.replaceAll(RegExp(r'<[^>]*>'), '')),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
      bottomNavigationBar: p == null
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.read<CartState>().add(p);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Adăugat în coș')));
                  },
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('Adaugă în coș'),
                ),
              ),
            ),
    );
  }
}

