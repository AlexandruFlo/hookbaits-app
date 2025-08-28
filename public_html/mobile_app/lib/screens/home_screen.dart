import 'package:flutter/material.dart';

import '../screens/product_list_screen.dart';
import '../screens/cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const ProductListScreen(),
      const CartScreen(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.storefront_outlined), label: 'Magazin'),
          NavigationDestination(icon: Icon(Icons.shopping_cart_outlined), label: 'Coș'),
        ],
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

