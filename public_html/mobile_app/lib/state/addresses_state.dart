import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Address {
  final String id;
  final String name;
  final String street;
  final String city;
  final String county;
  final String postalCode;
  final String phone;
  final bool isDefault;

  Address({
    required this.id,
    required this.name,
    required this.street,
    required this.city,
    required this.county,
    required this.postalCode,
    required this.phone,
    this.isDefault = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'street': street,
    'city': city,
    'county': county,
    'postalCode': postalCode,
    'phone': phone,
    'isDefault': isDefault,
  };

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json['id'],
    name: json['name'],
    street: json['street'],
    city: json['city'],
    county: json['county'],
    postalCode: json['postalCode'],
    phone: json['phone'],
    isDefault: json['isDefault'] ?? false,
  );
}

class AddressesState extends ChangeNotifier {
  final List<Address> _addresses = [];
  
  List<Address> get addresses => List.unmodifiable(_addresses);
  Address? get defaultAddress => _addresses.where((addr) => addr.isDefault).isNotEmpty 
      ? _addresses.firstWhere((addr) => addr.isDefault) 
      : null;
  
  AddressesState() {
    _loadAddressesFromStorage();
  }

  // Încarcă adresele din storage local
  Future<void> _loadAddressesFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final addressesJson = prefs.getStringList('user_addresses') ?? [];
      
      _addresses.clear();
      for (final jsonString in addressesJson) {
        final addressData = jsonDecode(jsonString);
        _addresses.add(Address.fromJson(addressData));
      }
      notifyListeners();
    } catch (e) {
      print('Eroare la încărcarea adreselor: $e');
    }
  }

  // Salvează adresele în storage local
  Future<void> _saveAddressesToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final addressesJson = _addresses.map((address) => jsonEncode(address.toJson())).toList();
      await prefs.setStringList('user_addresses', addressesJson);
    } catch (e) {
      print('Eroare la salvarea adreselor: $e');
    }
  }

  // Adaugă adresă nouă
  Future<void> addAddress(Address address) async {
    // Dacă noua adresă este default, elimină default-ul de la celelalte
    if (address.isDefault) {
      for (int i = 0; i < _addresses.length; i++) {
        if (_addresses[i].isDefault) {
          _addresses[i] = Address(
            id: _addresses[i].id,
            name: _addresses[i].name,
            street: _addresses[i].street,
            city: _addresses[i].city,
            county: _addresses[i].county,
            postalCode: _addresses[i].postalCode,
            phone: _addresses[i].phone,
            isDefault: false,
          );
        }
      }
    }
    
    _addresses.add(address);
    await _saveAddressesToStorage();
    notifyListeners();
  }

  // Actualizează o adresă
  Future<void> updateAddress(Address address) async {
    final index = _addresses.indexWhere((addr) => addr.id == address.id);
    if (index >= 0) {
      // Dacă noua adresă este default, elimină default-ul de la celelalte
      if (address.isDefault) {
        for (int i = 0; i < _addresses.length; i++) {
          if (i != index && _addresses[i].isDefault) {
            _addresses[i] = Address(
              id: _addresses[i].id,
              name: _addresses[i].name,
              street: _addresses[i].street,
              city: _addresses[i].city,
              county: _addresses[i].county,
              postalCode: _addresses[i].postalCode,
              phone: _addresses[i].phone,
              isDefault: false,
            );
          }
        }
      }
      
      _addresses[index] = address;
      await _saveAddressesToStorage();
      notifyListeners();
    }
  }

  // Elimină o adresă
  Future<void> removeAddress(String addressId) async {
    _addresses.removeWhere((addr) => addr.id == addressId);
    await _saveAddressesToStorage();
    notifyListeners();
  }

  // Setează o adresă ca default
  Future<void> setDefaultAddress(String addressId) async {
    for (int i = 0; i < _addresses.length; i++) {
      final isDefault = _addresses[i].id == addressId;
      _addresses[i] = Address(
        id: _addresses[i].id,
        name: _addresses[i].name,
        street: _addresses[i].street,
        city: _addresses[i].city,
        county: _addresses[i].county,
        postalCode: _addresses[i].postalCode,
        phone: _addresses[i].phone,
        isDefault: isDefault,
      );
    }
    await _saveAddressesToStorage();
    notifyListeners();
  }

  // Golește toate adresele
  Future<void> clearAddresses() async {
    _addresses.clear();
    await _saveAddressesToStorage();
    notifyListeners();
  }
}
