class FormValidators {
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName este obligatoriu';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email-ul este obligatoriu';
    }
    
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegExp.hasMatch(value.trim())) {
      return 'Introduceți un email valid';
    }
    
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Numărul de telefon este obligatoriu';
    }
    
    // Regex pentru numerele de telefon românești
    final phoneRegExp = RegExp(r'^(\+40|0040|0)[0-9]{9}$');
    
    if (!phoneRegExp.hasMatch(value.trim().replaceAll(' ', ''))) {
      return 'Introduceți un număr de telefon valid (ex: 0721234567)';
    }
    
    return null;
  }

  static String? validatePostalCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Codul poștal este obligatoriu';
    }
    
    // Regex pentru codurile poștale românești (6 cifre)
    final postalCodeRegExp = RegExp(r'^[0-9]{6}$');
    
    if (!postalCodeRegExp.hasMatch(value.trim())) {
      return 'Codul poștal trebuie să aibă 6 cifre';
    }
    
    return null;
  }

  static String? validateName(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName este obligatoriu';
    }
    
    if (value.trim().length < 2) {
      return '$fieldName trebuie să aibă cel puțin 2 caractere';
    }
    
    // Verifică că numele conține doar litere și spații
    final nameRegExp = RegExp(r'^[a-zA-ZăâîșțĂÂÎȘȚ\s]+$');
    
    if (!nameRegExp.hasMatch(value.trim())) {
      return '$fieldName poate conține doar litere';
    }
    
    return null;
  }

  static String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Adresa este obligatorie';
    }
    
    if (value.trim().length < 5) {
      return 'Adresa trebuie să aibă cel puțin 5 caractere';
    }
    
    return null;
  }

  static String? validateCity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Orașul este obligatoriu';
    }
    
    if (value.trim().length < 2) {
      return 'Numele orașului trebuie să aibă cel puțin 2 caractere';
    }
    
    // Verifică că orașul conține doar litere și spații
    final cityRegExp = RegExp(r'^[a-zA-ZăâîșțĂÂÎȘȚ\s-]+$');
    
    if (!cityRegExp.hasMatch(value.trim())) {
      return 'Numele orașului poate conține doar litere și liniuțe';
    }
    
    return null;
  }

  static String? validateCounty(String? value) {
    return validateRequired(value, 'Județul');
  }

  static String? validateTermsAccepted(bool? value) {
    if (value != true) {
      return 'Trebuie să acceptați termenii și condițiile';
    }
    return null;
  }

  static String? validatePaymentMethod(String? value) {
    if (value == null || value.isEmpty) {
      return 'Selectați o metodă de plată';
    }
    
    final validMethods = ['cod', 'bacs', 'stripe'];
    if (!validMethods.contains(value)) {
      return 'Metoda de plată selectată nu este validă';
    }
    
    return null;
  }

  static String? validateShippingMethod(String? value) {
    if (value == null || value.isEmpty) {
      return 'Selectați o metodă de livrare';
    }
    
    final validMethods = ['standard', 'express'];
    if (!validMethods.contains(value)) {
      return 'Metoda de livrare selectată nu este validă';
    }
    
    return null;
  }

  // Validare pentru cart - să nu fie gol
  static String? validateCartNotEmpty(int itemCount) {
    if (itemCount == 0) {
      return 'Coșul nu poate fi gol pentru a plasa o comandă';
    }
    return null;
  }

  // Validare pentru stoc
  static String? validateStock(int requestedQuantity, int? availableStock) {
    if (availableStock != null && requestedQuantity > availableStock) {
      return 'Cantitatea cerută ($requestedQuantity) depășește stocul disponibil ($availableStock)';
    }
    return null;
  }
}

// Extensie pentru validare rapidă
extension StringValidation on String? {
  bool get isValidEmail {
    return FormValidators.validateEmail(this) == null;
  }
  
  bool get isValidPhone {
    return FormValidators.validatePhone(this) == null;
  }
  
  bool get isValidPostalCode {
    return FormValidators.validatePostalCode(this) == null;
  }
  
  bool get isNotEmpty {
    return this != null && this!.trim().isNotEmpty;
  }
}
