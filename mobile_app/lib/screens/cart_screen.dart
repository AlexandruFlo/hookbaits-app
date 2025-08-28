import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config.dart';
import '../state/cart.dart';
import 'checkout_webview_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Coș')),
      body: cart.items.isEmpty
          ? const Center(child: Text('Coșul este gol'))
          : ListView.separated(
              itemCount: cart.items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = cart.items[index];
                return ListTile(
                  title: Text(item.product.name),
                  subtitle: Text('x${item.quantity} • Lei ${item.totalPrice.toStringAsFixed(2)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: () => cart.decrement(item.product)),
                      IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => cart.increment(item.product)),
                      IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => cart.remove(item.product)),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: cart.items.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: ElevatedButton(
                  onPressed: () {
                    final checkoutUrl = '${AppConfig.baseUrl}/checkout/?utm_source=app';
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => CheckoutWebViewScreen(checkoutUrl: checkoutUrl)));
                  },
                  child: Text('Finalizează (Lei ${cart.total.toStringAsFixed(2)})'),
                ),
              ),
            ),
    );
  }
}

