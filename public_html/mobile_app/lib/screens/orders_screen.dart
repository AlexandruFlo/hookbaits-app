import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/auth_state.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Map<String, dynamic>> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    // Simulez încărcarea comenzilor
    await Future.delayed(const Duration(seconds: 1));
    
    // Date de test pentru comenzi
    setState(() {
      orders = [
        {
          'id': '#HB001',
          'date': '15 Decembrie 2024',
          'status': 'Livrată',
          'total': '125.50',
          'items': [
            {'name': 'Momeala Carp Expert 1kg', 'quantity': 1},
            {'name': 'Boilies Strawberry 20mm', 'quantity': 2},
          ]
        },
        {
          'id': '#HB002',
          'date': '12 Decembrie 2024',
          'status': 'În curs de livrare',
          'total': '89.00',
          'items': [
            {'name': 'Carlig Method Feeder', 'quantity': 3},
          ]
        },
        {
          'id': '#HB003',
          'date': '8 Decembrie 2024',
          'status': 'Procesare',
          'total': '256.75',
          'items': [
            {'name': 'Lanseta Carp Pro 3.6m', 'quantity': 1},
            {'name': 'Mulineta Quick Drag', 'quantity': 1},
          ]
        },
      ];
      isLoading = false;
    });
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Livrată':
        return Colors.green;
      case 'În curs de livrare':
        return Colors.orange;
      case 'Procesare':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comenzile mele'),
        backgroundColor: const Color(0xFF0A7F2E),
        foregroundColor: Colors.white,
      ),
      body: !auth.isAuthenticated
        ? const Center(
            child: Text('Trebuie să te autentifici pentru a vedea comenzile'),
          )
        : isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF0A7F2E)))
          : orders.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_bag_outlined, size: 100, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'Nu ai încă nicio comandă',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                  ],
                ),
              )
            : RefreshIndicator(
                onRefresh: _loadOrders,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Comanda ${order['id']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(order['status']),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    order['status'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Data: ${order['date']}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Produse:',
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            ...order['items'].map<Widget>((item) => Padding(
                              padding: const EdgeInsets.only(left: 16, top: 4),
                              child: Text(
                                '• ${item['name']} (x${item['quantity']})',
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            )).toList(),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total: ${order['total']} Lei',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color(0xFF0A7F2E),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Detalii comandă ${order['id']}')),
                                    );
                                  },
                                  child: const Text('Detalii'),
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
