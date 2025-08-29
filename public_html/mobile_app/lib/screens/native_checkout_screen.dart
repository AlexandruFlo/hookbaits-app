import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/cart.dart';
import '../state/auth_state.dart';
import '../api/woocommerce_api.dart';
import '../state/auth_state.dart';

class NativeCheckoutScreen extends StatefulWidget {
  const NativeCheckoutScreen({super.key});

  @override
  State<NativeCheckoutScreen> createState() => _NativeCheckoutScreenState();
}

class _NativeCheckoutScreenState extends State<NativeCheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _countyController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedPaymentMethod = 'cod';
  String _selectedShippingMethod = 'standard';
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthState>();
    if (auth.isAuthenticated) {
      _emailController.text = auth.user?.email ?? '';
      final nameParts = auth.user?.name.split(' ') ?? [];
      if (nameParts.isNotEmpty) {
        _firstNameController.text = nameParts.first;
        if (nameParts.length > 1) {
          _lastNameController.text = nameParts.skip(1).join(' ');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartState>();
    final shippingCost = _selectedShippingMethod == 'express' ? 25.0 : 15.0;
    final totalWithShipping = cart.total + shippingCost;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finalizare comandă'),
        backgroundColor: const Color(0xFF0A7F2E),
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Rezumat comandă
                    _buildOrderSummary(cart, shippingCost, totalWithShipping),
                    const SizedBox(height: 24),

                    // Date de facturare
                    _buildSectionTitle('Date de facturare'),
                    _buildBillingForm(),
                    const SizedBox(height: 24),

                    // Livrare
                    _buildSectionTitle('Opțiuni de livrare'),
                    _buildShippingOptions(),
                    const SizedBox(height: 24),

                    // Plată
                    _buildSectionTitle('Metodă de plată'),
                    _buildPaymentMethods(),
                    const SizedBox(height: 24),

                    // Note suplimentare
                    _buildSectionTitle('Note suplimentare (opțional)'),
                    TextFormField(
                      controller: _notesController,
                      decoration: const InputDecoration(
                        hintText: 'Ex: Livrare la etajul 2, interfon 12',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // Buton finalizare
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isProcessing ? null : _processOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C3E50),
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isProcessing
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          SizedBox(width: 12),
                          Text('Se procesează...'),
                        ],
                      )
                    : Text(
                        'Plasează comanda (${totalWithShipping.toStringAsFixed(2)} Lei)',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(CartState cart, double shippingCost, double totalWithShipping) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Rezumat comandă',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...cart.items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${item.product.name} x${item.quantity}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  Text(
                    '${item.totalPrice.toStringAsFixed(2)} Lei',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Subtotal:'),
                Text('${cart.total.toStringAsFixed(2)} Lei'),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Livrare:'),
                Text('${shippingCost.toStringAsFixed(2)} Lei'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'TOTAL:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${totalWithShipping.toStringAsFixed(2)} Lei',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0A7F2E),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0A7F2E),
        ),
      ),
    );
  }

  Widget _buildBillingForm() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'Prenume *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty == true ? 'Prenumele este obligatoriu' : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Nume *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty == true ? 'Numele este obligatoriu' : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'Email *',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.email),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value?.isEmpty == true) return 'Email-ul este obligatoriu';
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
              return 'Email invalid';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _phoneController,
          decoration: const InputDecoration(
            labelText: 'Telefon *',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.phone),
          ),
          keyboardType: TextInputType.phone,
          validator: (value) => value?.isEmpty == true ? 'Telefonul este obligatoriu' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _addressController,
          decoration: const InputDecoration(
            labelText: 'Adresa *',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.location_on),
          ),
          validator: (value) => value?.isEmpty == true ? 'Adresa este obligatorie' : null,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: 'Oraș *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty == true ? 'Orașul este obligatoriu' : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _countyController,
                decoration: const InputDecoration(
                  labelText: 'Județ *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty == true ? 'Județul este obligatoriu' : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _postalCodeController,
          decoration: const InputDecoration(
            labelText: 'Cod poștal',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _buildShippingOptions() {
    return Column(
      children: [
        RadioListTile<String>(
          title: const Text('Livrare standard (3-5 zile)'),
          subtitle: const Text('15.00 Lei'),
          value: 'standard',
          groupValue: _selectedShippingMethod,
          activeColor: const Color(0xFF0A7F2E),
          onChanged: (value) => setState(() => _selectedShippingMethod = value!),
        ),
        RadioListTile<String>(
          title: const Text('Livrare expresă (1-2 zile)'),
          subtitle: const Text('25.00 Lei'),
          value: 'express',
          groupValue: _selectedShippingMethod,
          activeColor: const Color(0xFF0A7F2E),
          onChanged: (value) => setState(() => _selectedShippingMethod = value!),
        ),
      ],
    );
  }

  Widget _buildPaymentMethods() {
    return Column(
      children: [
        RadioListTile<String>(
          title: const Text('Plata la livrare (Ramburs)'),
          subtitle: const Text('Plătești când primești produsele'),
          value: 'cod',
          groupValue: _selectedPaymentMethod,
          activeColor: const Color(0xFF0A7F2E),
          onChanged: (value) => setState(() => _selectedPaymentMethod = value!),
          secondary: const Icon(Icons.local_shipping, color: Color(0xFF0A7F2E)),
        ),
        RadioListTile<String>(
          title: const Text('Transfer bancar'),
          subtitle: const Text('Vei primi detaliile de plată pe email'),
          value: 'bank_transfer',
          groupValue: _selectedPaymentMethod,
          activeColor: const Color(0xFF0A7F2E),
          onChanged: (value) => setState(() => _selectedPaymentMethod = value!),
          secondary: const Icon(Icons.account_balance, color: Color(0xFF0A7F2E)),
        ),
        RadioListTile<String>(
          title: const Text('Card bancar (Online)'),
          subtitle: const Text('Plată securizată cu cardul'),
          value: 'card',
          groupValue: _selectedPaymentMethod,
          activeColor: const Color(0xFF0A7F2E),
          onChanged: (value) => setState(() => _selectedPaymentMethod = value!),
          secondary: const Icon(Icons.credit_card, color: Color(0xFF0A7F2E)),
        ),
      ],
    );
  }

  Future<void> _processOrder() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Te rog completează toate câmpurile obligatorii'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final cart = context.read<CartState>();
      final auth = context.read<AuthState>();
      
      // Pregătește datele pentru comandă WooCommerce
      final lineItems = cart.items.map((item) => {
        'product_id': int.tryParse(item.product.id) ?? 0,
        'quantity': item.quantity,
      }).toList();
      
      final billing = {
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'address_1': _addressController.text,
        'city': _cityController.text,
        'state': _countyController.text,
        'postcode': _postalCodeController.text,
        'country': 'RO',
      };
      
      // Creează comanda prin WooCommerce API
      final result = await WooCommerceAPI.createOrder(
        lineItems: lineItems,
        billing: billing,
        shipping: billing, // Folosește aceeași adresă pentru livrare
        paymentMethod: _selectedPaymentMethod,
        status: _selectedPaymentMethod == 'cod' ? 'processing' : 'pending',
      );
      
      if (result != null) {
        // Comanda creată cu succes în WooCommerce
        cart.clear();
        setState(() => _isProcessing = false);
        
        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              icon: const Icon(
                Icons.check_circle,
                color: Color(0xFF2C3E50),
                size: 64,
              ),
              title: const Text('✅ Comandă plasată cu succes!'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Numărul comenzii: #${result['number']}'),
                  const SizedBox(height: 8),
                  Text('Total: ${result['total']} Lei'),
                  const SizedBox(height: 8),
                  Text('Status: ${result['status']}'),
                  const SizedBox(height: 16),
                  const Text('Comanda a fost înregistrată în sistemul WooCommerce!'),
                  const SizedBox(height: 8),
                  const Text('Veți primi un email de confirmare în curând.'),
                  if (_selectedPaymentMethod == 'bacs') ...[
                    const SizedBox(height: 16),
                    const Text('Detaliile de transfer bancar au fost trimise pe email.'),
                  ],
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Închide dialog-ul
                    Navigator.of(context).pop(); // Întoarce la coș
                  },
                  child: const Text('Înțeles'),
                ),
              ],
            ),
          );
        }
      } else {
        throw Exception('API-ul WooCommerce nu a putut crea comanda');
      }
    } catch (e) {
      setState(() => _isProcessing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Eroare la plasarea comenzii: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _countyController.dispose();
    _postalCodeController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
