import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../state/auth_state.dart';
import '../models/product.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Product> favorites = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    await Future.delayed(const Duration(seconds: 1));
    
    // Produse favorite de test
    setState(() {
      favorites = [
        Product(
          id: 1,
          name: 'Momeala Carp Expert Premium 1kg',
          permalink: 'https://hookbaits.ro/produs/momeala-carp-expert-1kg',
          priceRange: ProductPriceRange(minAmount: '45.00', maxAmount: '45.00'),
          image: ProductImage(src: 'https://via.placeholder.com/300x300/0A7F2E/FFFFFF?text=Momeala+Premium'),
          descriptionHtml: 'Momeala premium pentru crap cu aromă intensă.',
        ),
        Product(
          id: 5,
          name: 'Lanseta Carp Pro Carbon 3.6m',
          permalink: 'https://hookbaits.ro/produs/lanseta-carp-pro-36m',
          priceRange: ProductPriceRange(minAmount: '180.00', maxAmount: '180.00'),
          image: ProductImage(src: 'https://via.placeholder.com/300x300/0A7F2E/FFFFFF?text=Lanseta+Pro'),
          descriptionHtml: 'Lanseta profesională din carbon pentru pescuitul crapului.',
        ),
        Product(
          id: 6,
          name: 'Mulineta Quick Drag System',
          permalink: 'https://hookbaits.ro/produs/mulineta-quick-drag',
          priceRange: ProductPriceRange(minAmount: '150.00', maxAmount: '150.00'),
          image: ProductImage(src: 'https://via.placeholder.com/300x300/0A7F2E/FFFFFF?text=Mulineta+QD'),
          descriptionHtml: 'Mulineta cu sistem quick drag pentru pescuit sportiv.',
        ),
      ];
      isLoading = false;
    });
  }

  void _removeFavorite(Product product) {
    setState(() {
      favorites.removeWhere((p) => p.id == product.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product.name} eliminat din favorite')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produse favorite'),
        backgroundColor: const Color(0xFF0A7F2E),
        foregroundColor: Colors.white,
      ),
      body: !auth.isAuthenticated
        ? const Center(
            child: Text('Trebuie să te autentifici pentru a vedea favoritele'),
          )
        : isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF0A7F2E)))
          : favorites.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_border, size: 100, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'Nu ai produse favorite încă',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Explorează magazinul și adaugă produse la favorite',
                      style: TextStyle(color: Colors.grey[500]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : RefreshIndicator(
                onRefresh: _loadFavorites,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final product = favorites[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: SizedBox(
                                width: 80,
                                height: 80,
                                child: product.image?.src != null
                                  ? CachedNetworkImage(
                                      imageUrl: product.image!.src!,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(
                                        color: Colors.grey[200],
                                        child: const Icon(Icons.inventory_2_outlined),
                                      ),
                                      errorWidget: (context, url, error) => Container(
                                        color: Colors.grey[200],
                                        child: const Icon(Icons.inventory_2_outlined),
                                      ),
                                    )
                                  : Container(
                                      color: Colors.grey[200],
                                      child: const Icon(Icons.inventory_2_outlined),
                                    ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    product.descriptionHtml ?? 'Descriere produs',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${product.priceRange?.minAmount ?? '0'} Lei',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0A7F2E),
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.favorite, color: Colors.red),
                                  onPressed: () => _removeFavorite(product),
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('${product.name} adăugat în coș')),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0A7F2E),
                                    foregroundColor: Colors.white,
                                    minimumSize: const Size(60, 32),
                                  ),
                                  child: const Text('Coș', style: TextStyle(fontSize: 12)),
                                ),
                              ],
                            ),
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
