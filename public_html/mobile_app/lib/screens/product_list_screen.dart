import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/woocommerce_store_api.dart';
import '../state/favorites_state.dart';
import '../models/product.dart';
import '../state/cart.dart';
import 'product_screen.dart';
import 'search_screen.dart';
import '../widgets/hookbaits_logo.dart';
import '../widgets/premium_product_card.dart';
import '../theme/app_theme.dart';

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
      // API-ul nu funcționează - afișează eroare reală
      print('❌ Eroare încărcare produse: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Eroare la încărcarea produselor. Verificați conexiunea la internet și configurația API.'),
            backgroundColor: Colors.red[600],
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'REÎNCERCARE',
              textColor: Colors.white,
              onPressed: () {
                setState(() {
                  page = 1;
                  products.clear();
                  hasMore = true;
                });
                _load();
              },
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          // Banner Hook_alb-400x122.png înlocuiește complet textul HOOKBAITS
          height: 40,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/logo.png', // Hook_alb-400x122.png
              height: 40,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.black,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.phishing_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'HOOKBAITS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
          ),
        ],
      ),
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
            
            // 🎣 CARDUL PREMIUM ANIMAT cu efecte oceanice!
            return PremiumProductCard(
              product: p,
              imageUrl: imageUrl,
              price: price,
            );
          },
        ),
      ),
    );
  }
}

