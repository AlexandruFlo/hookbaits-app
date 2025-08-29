import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../api/woocommerce_store_api.dart';
import '../models/product.dart';
import '../state/cart.dart';
import '../state/favorites_state.dart';
import 'product_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final WooStoreApiClient _apiClient = WooStoreApiClient();
  List<Product> _searchResults = [];
  bool _isLoading = false;
  bool _hasSearched = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _hasSearched = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _hasSearched = true;
    });

    try {
      // Căutare în API-ul real WooCommerce
      final products = await _apiClient.fetchProducts(search: query, perPage: 50);
      
      // Rezultatele sunt deja filtrate prin parametrul search
      final filteredProducts = products;

      setState(() {
        _searchResults = filteredProducts;
        _isLoading = false;
      });
    } catch (e) {
      print('Eroare căutare: $e');
      setState(() {
        _isLoading = false;
        _searchResults = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Căutare produse'),
        backgroundColor: const Color(0xFF2C3E50),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Câmp de căutare
          Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Caută produse...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF2C3E50)),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _performSearch('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF2C3E50)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF2C3E50), width: 2),
                ),
              ),
              onChanged: (value) {
                setState(() {}); // Pentru a afișa/ascunde butonul clear
                if (value.length >= 2) {
                  _performSearch(value);
                }
              },
              onSubmitted: _performSearch,
            ),
          ),
          
          // Rezultate căutare
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF2C3E50)),
                  )
                : !_hasSearched
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search, size: 100, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'Caută produsele tale favorite',
                              style: TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Introdu cel puțin 2 caractere pentru căutare',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : _searchResults.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.search_off, size: 100, color: Colors.grey),
                                const SizedBox(height: 16),
                                Text(
                                  'Nu am găsit rezultate pentru "${_searchController.text}"',
                                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Încearcă cu alte cuvinte cheie',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          )
                        : GridView.builder(
                            padding: const EdgeInsets.all(16),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: _searchResults.length,
                            itemBuilder: (context, index) {
                              final product = _searchResults[index];
                              final imageUrl = product.image?.src;
                              final price = product.priceRange?.minAmount ?? '';

                              return Card(
                                elevation: 4,
                                margin: const EdgeInsets.all(6),
                                clipBehavior: Clip.antiAlias,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                child: Stack(
                                  children: [
                                    InkWell(
                                      onTap: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => ProductScreen(productId: int.tryParse(product.id) ?? 0),
                                        ),
                                      ),
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
                                              padding: const EdgeInsets.all(8),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    product.name,
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 14,
                                                    ),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  const Spacer(),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      if (price.isNotEmpty)
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
                                                          cart.add(product);
                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                            SnackBar(
                                                              content: Text('${product.name} adăugat în coș'),
                                                              backgroundColor: const Color(0xFF2C3E50),
                                                              duration: const Duration(seconds: 2),
                                                              action: SnackBarAction(
                                                                label: 'VEZI',
                                                                textColor: Colors.white,
                                                                onPressed: () {
                                                                  Navigator.of(context).pop(); // Închide căutarea
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
                                    // Favorite
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: Consumer<FavoritesState>(
                                        builder: (context, favorites, child) {
                                          final isFavorite = favorites.isFavorite(product);
                                          return InkWell(
                                            onTap: () async {
                                              await favorites.toggleFavorite(product);
                                              if (mounted) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text(isFavorite
                                                        ? '${product.name} eliminat din favorite'
                                                        : '${product.name} adăugat la favorite'),
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
    );
  }
}
