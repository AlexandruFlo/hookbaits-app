import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../state/favorites_state.dart';
import '../theme/app_theme.dart';
import '../widgets/premium_product_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
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
              // 🏷️ Header premium
              _buildPremiumHeader(),
              
              // ❤️ Conținutul favoriteș
              Expanded(
                child: Consumer<FavoritesState>(
                  builder: (context, favorites, child) {
                    if (favorites.favorites.isEmpty) {
                      return _buildEmptyFavoritesState();
                    }
                    return _buildFavoritesList(favorites);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🏷️ Header premium cu design oceanic
  Widget _buildPremiumHeader() {
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
      child: Row(
        children: [
          // Icon elegant cu gradient
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: AppColors.goldenReflection,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.goldenHour.withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.favorite_rounded,
              color: AppColors.deepOcean,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          
          // Titlu
          Expanded(
            child: Consumer<FavoritesState>(
              builder: (context, favorites, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Produse favorite',
                      style: TextStyle(
                        color: AppColors.pearlWhite,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                        shadows: [
                          Shadow(
                            color: AppColors.deepOcean.withOpacity(0.5),
                            offset: const Offset(0, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    
                    Text(
                      favorites.favorites.isEmpty 
                          ? 'Niciun produs favorit'
                          : '${favorites.favorites.length} ${favorites.favorites.length == 1 ? 'produs favorit' : 'produse favorite'}',
                      style: TextStyle(
                        color: AppColors.silverScale,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          
          // Buton clear all
          Consumer<FavoritesState>(
            builder: (context, favorites, child) {
              if (favorites.favorites.isEmpty) return const SizedBox.shrink();
              
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.coral.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.coral.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _showClearAllDialog(context, favorites),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        Icons.clear_all_outlined,
                        color: AppColors.coral,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ❤️ State pentru favorite goale
  Widget _buildEmptyFavoritesState() {
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
              boxShadow: [
                BoxShadow(
                  color: AppColors.stormyWater.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              Icons.favorite_border_outlined,
              size: 80,
              color: AppColors.stormyWater,
            ),
          ),
          const SizedBox(height: 30),
          
          Text(
            'Nu ai produse favorite',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          
          Text(
            'Apasă pe ❤️ de pe produse pentru\na le adăuga la favorite',
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

  // 📋 Lista cu produse favorite - design premium
  Widget _buildFavoritesList(FavoritesState favorites) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.68,
      ),
      itemCount: favorites.favorites.length,
      itemBuilder: (context, index) {
        final product = favorites.favorites[index];
        final imageUrl = product.image?.src;
        final price = product.priceRange?.minAmount ?? '';
        
        // 🎣 Folosește cardul premium pentru consistență!
        return PremiumProductCard(
          product: product,
          imageUrl: imageUrl,
          price: price,
          isFavorite: true, // Mereu favorit în această pagină
          onFavoriteToggle: () async {
            await favorites.toggleFavorite(product);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.favorite_border, color: AppColors.goldenHour),
                      const SizedBox(width: 8),
                      Expanded(child: Text('${product.name} eliminat din favorite')),
                    ],
                  ),
                  backgroundColor: AppColors.stormyWater,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }

  // 💎 Dialog premium pentru ștergerea tuturor favoritelor
  void _showClearAllDialog(BuildContext context, FavoritesState favorites) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.crystalClear,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.coral, AppColors.sunset]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.warning_outlined,
                color: AppColors.pearlWhite,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Șterge toate favoritele',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        content: Text(
          'Ești sigur că vrei să elimini toate produsele favorite? Această acțiune nu poate fi anulată.',
          style: TextStyle(
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              backgroundColor: AppColors.silverScale.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'ANULEAZĂ',
              style: TextStyle(
                color: AppColors.stormyWater,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              favorites.clearFavorites();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.check_circle, color: AppColors.goldenHour),
                      const SizedBox(width: 8),
                      const Text('Toate favoritele au fost șterse'),
                    ],
                  ),
                  backgroundColor: AppColors.seaweed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.coral,
              foregroundColor: AppColors.pearlWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('ȘTERGE TOT'),
          ),
        ],
      ),
    );
  }
}