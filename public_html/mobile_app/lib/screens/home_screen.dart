import 'package:flutter/material.dart';

import '../screens/product_list_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/profile_screen.dart';

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
      const ProfileScreen(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Acasă'),
          NavigationDestination(icon: Icon(Icons.shopping_cart_outlined), label: 'Coș'),
          NavigationDestination(icon: Icon(Icons.person_outlined), label: 'Cont'),
        ],
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

