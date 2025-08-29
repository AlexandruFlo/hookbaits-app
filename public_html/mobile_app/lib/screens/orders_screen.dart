import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/auth_state.dart';
import '../api/woocommerce_api.dart';
import '../theme/app_theme.dart';

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

  LinearGradient _getStatusGradient(String status) {
    switch (status) {
      case 'Livrată':
        return const LinearGradient(colors: [Color(0xFF27AE60), Color(0xFF2ECC71)]);
      case 'În curs de livrare':
        return LinearGradient(colors: [AppColors.goldenHour, AppColors.sunset]);
      case 'Procesare':
        return LinearGradient(colors: [AppColors.stormyWater, AppColors.clearWater]);
      case 'În așteptare':
        return LinearGradient(colors: [AppColors.silverScale, AppColors.crystalClear]);
      case 'Anulată':
      case 'Eșuată':
        return LinearGradient(colors: [AppColors.coral, AppColors.sunset]);
      case 'Rambursată':
        return const LinearGradient(colors: [Color(0xFF9B59B6), Color(0xFFE74C3C)]);
      default:
        return LinearGradient(colors: [AppColors.silverScale, AppColors.pearlWhite]);
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Livrată':
        return Icons.check_circle_outline;
      case 'În curs de livrare':
        return Icons.local_shipping_outlined;
      case 'Procesare':
        return Icons.sync_outlined;
      case 'În așteptare':
        return Icons.schedule_outlined;
      case 'Anulată':
        return Icons.cancel_outlined;
      case 'Eșuată':
        return Icons.error_outline;
      case 'Rambursată':
        return Icons.refresh_outlined;
      default:
        return Icons.shopping_bag_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
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
              // 🏷️ Header premium
              _buildPremiumHeader(),
              
              // 📦 Conținutul comenzilor
              Expanded(
                child: !auth.isAuthenticated
                    ? _buildUnauthenticatedState()
                    : isLoading
                        ? _buildLoadingState()
                        : orders.isEmpty
                            ? _buildEmptyOrdersState()
                            : _buildOrdersList(),
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
              Icons.shopping_bag_outlined,
              color: AppColors.deepOcean,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          
          // Titlu
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Comenzile mele',
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
                  orders.isEmpty 
                      ? 'Istoric comenzi HOOKBAITS'
                      : '${orders.length} ${orders.length == 1 ? 'comandă' : 'comenzi'}',
                  style: TextStyle(
                    color: AppColors.silverScale,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          
          // Buton refresh
          Container(
            decoration: BoxDecoration(
              color: AppColors.pearlWhite.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.silverScale.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _loadOrders,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.refresh_outlined,
                    color: AppColors.pearlWhite,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔒 State pentru utilizatori neautentificați
  Widget _buildUnauthenticatedState() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(32),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.crystalClear,
              AppColors.pearlWhite,
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.deepOcean.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: AppColors.silverScale.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.oceanicGradient,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.lock_outline,
                color: AppColors.goldenHour,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            
            Text(
              'Autentificare necesară',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            
            Text(
              'Pentru a vedea comenzile tale HOOKBAITS,\nte rugăm să te autentifici în contul tău.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textLight,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ⏳ State de loading cu design oceanic
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: AppColors.oceanicGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.stormyWater.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.goldenHour),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 24),
          
          Text(
            'Încărcare comenzi...',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textLight,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // 📦 State pentru comenzi goale
  Widget _buildEmptyOrdersState() {
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
              Icons.shopping_bag_outlined,
              size: 80,
              color: AppColors.stormyWater,
            ),
          ),
          const SizedBox(height: 30),
          
          Text(
            'Nu ai încă nicio comandă',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          
          Text(
            'Explorează gama noastră premium de nadă\nși plasează prima ta comandă HOOKBAITS',
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

  // 📋 Lista cu comenzi - design premium
  Widget _buildOrdersList() {
    return RefreshIndicator(
      onRefresh: _loadOrders,
      color: AppColors.stormyWater,
      backgroundColor: AppColors.pearlWhite,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return _buildPremiumOrderCard(order, index);
        },
      ),
    );
  }

  // 🎨 Card premium pentru comandă
  Widget _buildPremiumOrderCard(Map<String, dynamic> order, int index) {
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
            // Header cu comanda și status
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon comandă
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: AppColors.oceanicGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.receipt_outlined,
                    color: AppColors.goldenHour,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                
                // Info comandă
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Comanda ${order['id']}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      
                      Text(
                        'Data: ${order['date']}',
                        style: TextStyle(
                          color: AppColors.textLight,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Status badge premium
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: _getStatusGradient(order['status']),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.stormyWater.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getStatusIcon(order['status']),
                        color: Colors.white,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        order['status'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Separator elegant
            Container(
              height: 1,
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    AppColors.silverScale.withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            
            // Lista produse
            Text(
              'Produse comandate:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            
            ...order['items'].map<Widget>((item) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.silverScale.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.silverScale.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      gradient: AppColors.oceanicGradient,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  Expanded(
                    child: Text(
                      '${item['name']}',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: AppColors.premiumButtonGradient,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'x${item['quantity']}',
                      style: TextStyle(
                        color: AppColors.pearlWhite,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            )).toList(),
            
            const SizedBox(height: 20),
            
            // Footer cu total și acțiuni
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Total premium
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
                        'TOTAL: LEI',
                        style: TextStyle(
                          color: AppColors.goldenHour,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${order['total']}',
                        style: TextStyle(
                          color: AppColors.pearlWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Buton detalii premium
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.clearWater.withOpacity(0.8),
                        AppColors.silverScale.withOpacity(0.3),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.stormyWater.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                Icon(Icons.info_outline, color: AppColors.goldenHour),
                                const SizedBox(width: 8),
                                Text('Detalii comandă ${order['id']}'),
                              ],
                            ),
                            backgroundColor: AppColors.stormyWater,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.visibility_outlined,
                              color: AppColors.stormyWater,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'DETALII',
                              style: TextStyle(
                                color: AppColors.stormyWater,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
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
          ],
        ),
      ),
    );
  }
}
