import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/auth_state.dart';
import '../api/woocommerce_api.dart';
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
    final auth = context.read<AuthState>();
    if (auth.isAuthenticated && auth.currentUser != null) {
      try {
        final customerId = auth.currentUser!['id'];
        final userOrders = await WooCommerceAPI.getUserOrders(customerId);
        
        // Convertește comenzile WooCommerce în formatul aplicației
        final formattedOrders = userOrders.map<Map<String, dynamic>>((order) {
          final lineItems = order['line_items'] as List<dynamic>? ?? [];
          return {
            'id': '#${order['number']}',
            'date': DateTime.parse(order['date_created']).toLocal().toString().split(' ')[0],
            'status': _translateStatus(order['status']),
            'total': order['total'],
            'items': lineItems.map((item) => {
              'name': item['name'],
              'quantity': item['quantity'],
            }).toList(),
          };
        }).toList();
        
        setState(() {
          orders = formattedOrders;
          isLoading = false;
        });
      } catch (e) {
        setState(() => isLoading = false);
        print('Eroare la încărcarea comenzilor: $e');
      }
    } else {
      setState(() => isLoading = false);
    }
  }

  String _translateStatus(String status) {
    switch (status) {
      case 'completed':
        return 'Livrată';
      case 'processing':
        return 'În curs de livrare';
      case 'pending':
        return 'Procesare';
      case 'on-hold':
        return 'În așteptare';
      case 'cancelled':
        return 'Anulată';
      case 'refunded':
        return 'Rambursată';
      case 'failed':
        return 'Eșuată';
      default:
        return status;
    }
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
        backgroundColor: const Color(0xFF2C3E50),
        foregroundColor: Colors.white,
      ),
      body: !auth.isAuthenticated
        ? const Center(
            child: Text('Trebuie să te autentifici pentru a vedea comenzile'),
          )
        : isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF2C3E50)))
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
                                    color: Color(0xFF2C3E50),
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
