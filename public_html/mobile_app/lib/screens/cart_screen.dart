import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config.dart';
import '../state/cart.dart';
import '../state/auth_state.dart';
import 'native_checkout_screen.dart';
import 'auth_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartState>();
    final auth = context.watch<AuthState>();
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.shopping_cart, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              'Coș (${cart.items.length} ${cart.items.length == 1 ? 'produs' : 'produse'})',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: cart.items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 100,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Coșul este gol',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Adaugă produse pentru a începe cumpărăturile',
                    style: TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Header cu totalul
                Container(
                  padding: const EdgeInsets.all(16),
                  color: const Color(0xFFF8F9FA),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${cart.total.toStringAsFixed(2)} Lei',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0A7F2E),
                        ),
                      ),
                    ],
                  ),
                ),
                // Lista de produse
                Expanded(
                  child: ListView.separated(
              itemCount: cart.items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.product.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Preț unitar: ${item.product.priceRange?.minAmount ?? '0'} Lei',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    'Total: ${item.totalPrice.toStringAsFixed(2)} Lei',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0A7F2E),
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(color: const Color(0xFF0A7F2E)),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            InkWell(
                                              onTap: () => cart.decrement(item.product),
                                              child: const Padding(
                                                padding: EdgeInsets.all(8),
                                                child: Icon(Icons.remove, size: 20, color: Color(0xFF0A7F2E)),
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                              decoration: const BoxDecoration(
                                                color: Color(0xFF0A7F2E),
                                              ),
                                              child: Text(
                                                '${item.quantity}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () => cart.increment(item.product),
                                              child: const Padding(
                                                padding: EdgeInsets.all(8),
                                                child: Icon(Icons.add, size: 20, color: Color(0xFF0A7F2E)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                                    onPressed: () => cart.remove(item.product),
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
              ],
            ),
      bottomNavigationBar: cart.items.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (!auth.isAuthenticated) {
                      // Poți comanda și fără cont, doar completezi datele
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Comandă fără cont'),
                          content: const Text('Poți plasa comanda completând datele în următorul pas, sau te poți autentifica pentru o experiență mai rapidă.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => const AuthScreen(),
                                ));
                              },
                              child: const Text('Autentificare'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => const NativeCheckoutScreen(),
                                ));
                              },
                              child: const Text('Continuă'),
                            ),
                          ],
                        ),
                      );
                      return;
                    }
                    
                    // Navighează direct la checkout-ul nativ
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const NativeCheckoutScreen(),
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A7F2E),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text('Finalizează (${cart.total.toStringAsFixed(2)} Lei)', 
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
    );
  }
}

