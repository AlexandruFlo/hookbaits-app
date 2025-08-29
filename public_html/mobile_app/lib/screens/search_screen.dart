import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../api/woocommerce_store_api.dart';
import '../models/product.dart';
import '../state/cart.dart';
import '../state/favorites_state.dart';
import '../theme/app_theme.dart';
import '../widgets/premium_product_card.dart';
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.pearlWhite,
              AppColors.silverScale.withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 🔍 Header premium cu search bar
              _buildPremiumSearchHeader(),
              
              // 📋 Rezultatele căutării
              Expanded(child: _buildSearchResults()),
            ],
          ),
        ),
      ),
    );
  }

  // 🔍 Header premium cu search bar oceanic
  Widget _buildPremiumSearchHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.oceanicGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.deepOcean.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Back button
              Container(
                decoration: BoxDecoration(
                  color: AppColors.pearlWhite.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        Icons.arrow_back_ios_outlined,
                        color: AppColors.pearlWhite,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              
              Expanded(
                child: Text(
                  'Căutare produse',
                  style: TextStyle(
                    color: AppColors.pearlWhite,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Search bar premium
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.crystalClear,
                  AppColors.pearlWhite,
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.deepOcean.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                hintText: 'Caută produse HOOKBAITS...',
                hintStyle: TextStyle(
                  color: AppColors.textLight,
                  fontSize: 16,
                ),
                prefixIcon: Icon(
                  Icons.search_outlined,
                  color: AppColors.stormyWater,
                  size: 22,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear_outlined,
                          color: AppColors.textLight,
                          size: 20,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          _performSearch('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                filled: true,
                fillColor: Colors.transparent,
              ),
              onChanged: (value) {
                setState(() {}); // Pentru a afișa/ascunde butonul clear
                if (value.length >= 2) {
                  _performSearch(value);
                } else {
                  _performSearch('');
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // 📋 Widget pentru rezultatele căutării
  Widget _buildSearchResults() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: AppColors.oceanicGradient,
                shape: BoxShape.circle,
              ),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.goldenHour),
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Căutam produse...',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textLight,
              ),
            ),
          ],
        ),
      );
    }

    if (!_hasSearched) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.clearWater.withOpacity(0.2),
                    AppColors.silverScale.withOpacity(0.1),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_outlined,
                size: 80,
                color: AppColors.stormyWater,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Caută produse HOOKBAITS',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Introdu cel puțin 2 caractere pentru\na începe căutarea',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textLight,
                height: 1.4,
              ),
            ),
          ],
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.clearWater.withOpacity(0.2),
                    AppColors.silverScale.withOpacity(0.1),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off_outlined,
                size: 80,
                color: AppColors.stormyWater,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Niciun rezultat',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Nu am găsit produse care să\ncorespundă căutării tale',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textLight,
                height: 1.4,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.68,
      ),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final product = _searchResults[index];
        final imageUrl = product.image?.src;
        final price = product.priceRange?.minAmount ?? '';
        
        return PremiumProductCard(
          product: product,
          imageUrl: imageUrl,
          price: price,
        );
      },
    );
  }

  Widget _originalBuild() {
    return Scaffold(
      body: Column(
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
