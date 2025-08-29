import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config.dart';
import '../state/cart.dart';
import '../state/auth_state.dart';
import '../theme/app_theme.dart';
import 'native_checkout_screen.dart';
import 'auth_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartState>();
    final auth = context.watch<AuthState>();
    
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
              // 🏷️ Header premium cu total
              _buildPremiumHeader(cart),
              
              // 📦 Conținutul coșului
              Expanded(
                child: cart.items.isEmpty
                    ? _buildEmptyCart()
                    : _buildCartItems(cart),
              ),
              
              // 🚀 Bottom bar cu checkout
              if (cart.items.isNotEmpty) _buildCheckoutBar(context, cart, auth),
            ],
          ),
        ),
      ),
    );
  }

  // 🏷️ Header premium cu total și iconografie
  Widget _buildPremiumHeader(CartState cart) {
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
              Icons.shopping_cart_rounded,
              color: AppColors.deepOcean,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          
          // Info coș
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Coșul tău HOOKBAITS',
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
                  cart.items.isEmpty
                      ? 'Gol - adaugă produse premium'
                      : '${cart.items.length} ${cart.items.length == 1 ? 'produs' : 'produse'} • ${cart.total.toStringAsFixed(2)} Lei',
                  style: TextStyle(
                    color: AppColors.silverScale,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          
          // Total badge premium
          if (cart.items.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: AppColors.premiumButtonGradient,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.goldenHour.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'LEI',
                    style: TextStyle(
                      color: AppColors.goldenHour,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    cart.total.toStringAsFixed(2),
                    style: TextStyle(
                      color: AppColors.pearlWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      shadows: [
                        Shadow(
                          color: AppColors.deepOcean,
                          offset: const Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // 📦 Coș gol cu design oceanic
  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon oceanic elegant
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
              Icons.shopping_cart_outlined,
              size: 80,
              color: AppColors.stormyWater,
            ),
          ),
          const SizedBox(height: 30),
          
          Text(
            'Coșul este gol',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          
          Text(
            'Explorează gama noastră premium de nadă\nși adaugă produsele tale favorite',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textLight,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 30),
          
          // Buton pentru a reveni la produse
          Container(
            decoration: BoxDecoration(
              gradient: AppColors.premiumButtonGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.stormyWater.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => DefaultTabController.of(context)?.animateTo(0),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.phishing_outlined,
                        color: AppColors.pearlWhite,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'EXPLOREAZĂ PRODUSELE',
                        style: TextStyle(
                          color: AppColors.pearlWhite,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 📦 Lista cu produsele din coș - design premium
  Widget _buildCartItems(CartState cart) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: cart.items.length,
      itemBuilder: (context, index) {
        final item = cart.items[index];
        return _buildPremiumCartItem(cart, item, index);
      },
    );
  }

  // 🎨 Item premium din coș cu design oceanic
  Widget _buildPremiumCartItem(CartState cart, CartItem item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.crystalClear,
            AppColors.pearlWhite,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepOcean.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: AppColors.silverScale.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header cu numele și prețul
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon produs
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: AppColors.oceanicGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.phishing_outlined,
                    color: AppColors.goldenHour,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                
                // Info produs
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.product.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      Row(
                        children: [
                          Text(
                            'LEI ${item.product.priceRange?.minAmount ?? '0'}',
                            style: TextStyle(
                              color: AppColors.textLight,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            ' / bucată',
                            style: TextStyle(
                              color: AppColors.textLight,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Buton delete elegant
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.coral.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.coral.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => cart.remove(item.product),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          Icons.delete_outline,
                          color: AppColors.coral,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Controale cantitate și total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Controale cantitate premium
                _buildQuantityControls(cart, item),
                
                // Total produs
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: AppColors.premiumButtonGradient,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'LEI',
                        style: TextStyle(
                          color: AppColors.goldenHour,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.totalPrice.toStringAsFixed(2),
                        style: TextStyle(
                          color: AppColors.pearlWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 🔢 Controale cantitate premium
  Widget _buildQuantityControls(CartState cart, CartItem item) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.silverScale.withOpacity(0.1),
            AppColors.pearlWhite.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.stormyWater.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Buton minus
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => cart.decrement(item.product),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: Container(
                padding: const EdgeInsets.all(12),
                child: Icon(
                  Icons.remove,
                  color: AppColors.stormyWater,
                  size: 20,
                ),
              ),
            ),
          ),
          
          // Cantitatea
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              gradient: AppColors.oceanicGradient,
            ),
            child: Text(
              '${item.quantity}',
              style: TextStyle(
                color: AppColors.pearlWhite,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          
          // Buton plus
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => cart.increment(item.product),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              child: Container(
                padding: const EdgeInsets.all(12),
                child: Icon(
                  Icons.add,
                  color: AppColors.stormyWater,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🚀 Bottom bar premium cu buton checkout
  Widget _buildCheckoutBar(BuildContext context, CartState cart, AuthState auth) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.pearlWhite.withOpacity(0.9),
            AppColors.crystalClear,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepOcean.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Buton premium de checkout
          Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              gradient: AppColors.premiumButtonGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.stormyWater.withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _handleCheckout(context, cart, auth),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.payment_outlined,
                        color: AppColors.pearlWhite,
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'FINALIZEAZĂ COMANDA',
                        style: TextStyle(
                          color: AppColors.pearlWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.goldenHour.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'LEI ${cart.total.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: AppColors.goldenHour,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🚀 Handle checkout cu dialog premium
  void _handleCheckout(BuildContext context, CartState cart, AuthState auth) {
    if (!auth.isAuthenticated) {
      _showPremiumAuthDialog(context);
      return;
    }
    
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => const NativeCheckoutScreen(),
    ));
  }

  // 💎 Dialog premium pentru autentificare
  void _showPremiumAuthDialog(BuildContext context) {
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
                gradient: AppColors.oceanicGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.person_outline,
                color: AppColors.goldenHour,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Comandă ca oaspete',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        content: Text(
          'Poți plasa comanda completând datele în următorul pas, sau te poți autentifica pentru o experiență mai rapidă.',
          style: TextStyle(
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const AuthScreen(),
              ));
            },
            style: TextButton.styleFrom(
              backgroundColor: AppColors.goldenHour.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'AUTENTIFICARE',
              style: TextStyle(
                color: AppColors.goldenHour,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const NativeCheckoutScreen(),
              ));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.stormyWater,
              foregroundColor: AppColors.pearlWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('CONTINUĂ CA OASPETE'),
          ),
        ],
      ),
    );
  }
}

