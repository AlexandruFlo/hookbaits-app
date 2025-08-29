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
        title: const HookbaitsLogoCompact(),
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
        child: Column(
          children: [
            // Banner cu logo-ul Hook_alb-400x122.png
            Container(
              width: double.infinity,
              height: 120,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/logo.png', // Hook_alb-400x122.png
                  height: 80,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.black,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.phishing_outlined, color: Colors.white, size: 40),
                        SizedBox(height: 8),
                        Text(
                          'HOOKBAITS',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                        Text(
                          'PROFESSIONAL FISHING GEAR',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Lista de produse
            Expanded(
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
              elevation: 4,
              margin: const EdgeInsets.all(6),
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Stack(
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProductScreen(productId: int.tryParse(p.id) ?? 0))),
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFF8F9FA), Color(0xFFE9ECEF)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: imageUrl == null
                            ? const Icon(Icons.inventory_2_outlined, size: 60, color: Color(0xFF2C3E50))
                            : CachedNetworkImage(
                                imageUrl: imageUrl, 
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(color: Color(0xFF2C3E50)),
                                ),
                                errorWidget: (context, url, error) => const Icon(
                                  Icons.inventory_2_outlined, 
                                  size: 60, 
                                  color: Color(0xFF2C3E50),
                                ),
                              ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              p.name, 
                              maxLines: 2, 
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            if (price.isNotEmpty) Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2C3E50),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    '$price Lei',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    final cart = context.read<CartState>();
                                    cart.add(p);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('${p.name} adăugat în coș'),
                                        backgroundColor: const Color(0xFF2C3E50),
                                        duration: const Duration(seconds: 2),
                                        action: SnackBarAction(
                                          label: 'VEZI',
                                          textColor: Colors.white,
                                          onPressed: () {
                                            // Navighează la coș (tab index 1)
                                            DefaultTabController.of(context)?.animateTo(1);
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: const Color(0xFF2C3E50)),
                                    ),
                                    child: const Icon(
                                      Icons.add_shopping_cart,
                                      color: Color(0xFF2C3E50),
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                  ),
                  // Inimioara pentru favorite
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Consumer<FavoritesState>(
                      builder: (context, favorites, child) {
                        final isFavorite = favorites.isFavorite(p);
                        return InkWell(
                          onTap: () async {
                            await favorites.toggleFavorite(p);
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(isFavorite 
                                      ? '${p.name} eliminat din favorite' 
                                      : '${p.name} adăugat la favorite'),
                                  backgroundColor: isFavorite ? Colors.grey[600] : Colors.red[600],
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: Colors.red,
                              size: 18,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

