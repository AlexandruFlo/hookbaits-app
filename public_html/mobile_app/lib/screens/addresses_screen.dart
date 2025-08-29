import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/auth_state.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  List<Map<String, dynamic>> addresses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      addresses = [
        {
          'id': 1,
          'type': 'Acasă',
          'name': 'Ion Popescu',
          'street': 'Str. Pescărușului nr. 15',
          'city': 'București',
          'county': 'Ilfov',
          'postalCode': '012345',
          'phone': '+40 721 234 567',
          'isDefault': true,
        },
        {
          'id': 2,
          'type': 'Serviciu',
          'name': 'Ion Popescu',
          'street': 'Bd. Unirii nr. 45, Et. 3',
          'city': 'București',
          'county': 'București',
          'postalCode': '030833',
          'phone': '+40 721 234 567',
          'isDefault': false,
        },
      ];
      isLoading = false;
    });
  }

  void _showAddAddressDialog() {
    final nameController = TextEditingController();
    final streetController = TextEditingController();
    final cityController = TextEditingController();
    final countyController = TextEditingController();
    final postalCodeController = TextEditingController();
    final phoneController = TextEditingController();
    String selectedType = 'Acasă';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adaugă adresă nouă'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedType,
                decoration: const InputDecoration(labelText: 'Tip adresă'),
                items: ['Acasă', 'Serviciu', 'Altă adresă']
                    .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                    .toList(),
                onChanged: (value) => selectedType = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nume complet'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: streetController,
                decoration: const InputDecoration(labelText: 'Strada și numărul'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: cityController,
                decoration: const InputDecoration(labelText: 'Orașul'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: countyController,
                decoration: const InputDecoration(labelText: 'Județul'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: postalCodeController,
                decoration: const InputDecoration(labelText: 'Cod poștal'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Telefon'),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Anulează'),
          ),
          ElevatedButton(
            onPressed: () {
              // Adaugă adresa nouă
              setState(() {
                addresses.add({
                  'id': addresses.length + 1,
                  'type': selectedType,
                  'name': nameController.text,
                  'street': streetController.text,
                  'city': cityController.text,
                  'county': countyController.text,
                  'postalCode': postalCodeController.text,
                  'phone': phoneController.text,
                  'isDefault': addresses.isEmpty,
                });
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Adresă adăugată cu succes')),
              );
            },
            child: const Text('Salvează'),
          ),
        ],
      ),
    );
  }

  void _setDefaultAddress(int addressId) {
    setState(() {
      for (var address in addresses) {
        address['isDefault'] = address['id'] == addressId;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Adresa implicită a fost actualizată')),
    );
  }

  void _deleteAddress(int addressId) {
    setState(() {
      addresses.removeWhere((address) => address['id'] == addressId);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Adresa a fost ștearsă')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adrese de livrare'),
        backgroundColor: const Color(0xFF0A7F2E),
        foregroundColor: Colors.white,
      ),
      body: !auth.isAuthenticated
        ? const Center(
            child: Text('Trebuie să te autentifici pentru a gestiona adresele'),
          )
        : isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF0A7F2E)))
          : Column(
              children: [
                Expanded(
                  child: addresses.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.location_off, size: 100, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              'Nu ai adrese salvate',
                              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Adaugă o adresă pentru livrări rapide',
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: addresses.length,
                        itemBuilder: (context, index) {
                          final address = addresses[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF0A7F2E),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          address['type'],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      if (address['isDefault']) ...[
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.orange,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: const Text(
                                            'IMPLICIT',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                      const Spacer(),
                                      PopupMenuButton(
                                        itemBuilder: (context) => [
                                          PopupMenuItem(
                                            value: 'default',
                                            child: const Text('Setează ca implicit'),
                                            onTap: () => _setDefaultAddress(address['id']),
                                          ),
                                          PopupMenuItem(
                                            value: 'delete',
                                            child: const Text('Șterge', style: TextStyle(color: Colors.red)),
                                            onTap: () => _deleteAddress(address['id']),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    address['name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(address['street']),
                                  Text('${address['city']}, ${address['county']}'),
                                  Text('Cod poștal: ${address['postalCode']}'),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Tel: ${address['phone']}',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _showAddAddressDialog,
                      icon: const Icon(Icons.add),
                      label: const Text('Adaugă adresă nouă'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0A7F2E),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
