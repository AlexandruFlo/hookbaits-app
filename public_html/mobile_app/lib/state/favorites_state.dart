import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/product.dart';

class FavoritesState extends ChangeNotifier {
  final List<Product> _favorites = [];
  
  List<Product> get favorites => List.unmodifiable(_favorites);
  
  FavoritesState() {
    _loadFavoritesFromStorage();
  }

  // Încarcă favorite din storage local
  Future<void> _loadFavoritesFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getStringList('user_favorites') ?? [];
      
      _favorites.clear();
      for (final jsonString in favoritesJson) {
        final productData = jsonDecode(jsonString);
        // Recrează produsul din datele salvate
        final product = Product(
          id: productData['id'],
          name: productData['name'],
          permalink: productData['permalink'] ?? '',
          image: productData['image'] != null 
              ? ProductImage(
                  id: productData['image']['id'] ?? '0',
                  src: productData['image']['src'] ?? '',
                  alt: productData['image']['alt'],
                )
              : null,
          priceRange: productData['priceRange'] != null
              ? ProductPriceRange(
                  minAmount: productData['priceRange']['minAmount'] ?? '0',
                  maxAmount: productData['priceRange']['maxAmount'] ?? '0',
                )
              : null,
        );
        _favorites.add(product);
      }
      notifyListeners();
    } catch (e) {
      print('Eroare la încărcarea favorite: $e');
    }
  }

  // Salvează favorite în storage local
  Future<void> _saveFavoritesToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = _favorites.map((product) {
        return jsonEncode({
          'id': product.id,
          'name': product.name,
          'permalink': product.permalink,
          'image': product.image != null ? {
            'id': product.image!.id,
            'src': product.image!.src,
            'alt': product.image!.alt,
          } : null,
          'priceRange': product.priceRange != null ? {
            'minAmount': product.priceRange!.minAmount,
            'maxAmount': product.priceRange!.maxAmount,
          } : null,
        });
      }).toList();
      
      await prefs.setStringList('user_favorites', favoritesJson);
    } catch (e) {
      print('Eroare la salvarea favorite: $e');
    }
  }

  // Verifică dacă un produs este la favorite
  bool isFavorite(Product product) {
    return _favorites.any((fav) => fav.id == product.id);
  }

  // Adaugă/elimină produs la/din favorite
  Future<void> toggleFavorite(Product product) async {
    final index = _favorites.indexWhere((fav) => fav.id == product.id);
    
    if (index >= 0) {
      // Elimină din favorite
      _favorites.removeAt(index);
    } else {
      // Adaugă la favorite
      _favorites.add(product);
    }
    
    await _saveFavoritesToStorage();
    notifyListeners();
  }

  // Golește toate favorite
  Future<void> clearFavorites() async {
    _favorites.clear();
    await _saveFavoritesToStorage();
    notifyListeners();
  }
}
