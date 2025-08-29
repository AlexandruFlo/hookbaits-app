import 'package:flutter/material.dart';

class ErrorHandler {
  static void handleError(BuildContext context, dynamic error, {String? title}) {
    String message = 'A apărut o eroare neașteptată.';
    String displayTitle = title ?? 'Eroare';

    if (error is String) {
      message = error;
    } else if (error is Exception) {
      message = error.toString().replaceFirst('Exception: ', '');
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 8),
            Text(displayTitle),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  static void showSuccess(BuildContext context, String message, {String? title}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.green),
            const SizedBox(width: 8),
            Text(title ?? 'Succes'),
          ],
        ),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  static void showNetworkError(BuildContext context) {
    handleError(
      context,
      'Verificați conexiunea la internet și încercați din nou.',
      title: 'Eroare de conexiune',
    );
  }

  static void showValidationError(BuildContext context, String field) {
    handleError(
      context,
      'Câmpul "$field" nu este completat corect.',
      title: 'Validare',
    );
  }

  static void showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}

// Extensie pentru BuildContext
extension ErrorHandling on BuildContext {
  void showError(dynamic error, {String? title}) {
    ErrorHandler.handleError(this, error, title: title);
  }

  void showSuccess(String message, {String? title}) {
    ErrorHandler.showSuccess(this, message, title: title);
  }

  void showNetworkError() {
    ErrorHandler.showNetworkError(this);
  }

  void showValidationError(String field) {
    ErrorHandler.showValidationError(this, field);
  }

  void showSnackBar(String message, {bool isError = false}) {
    ErrorHandler.showSnackBar(this, message, isError: isError);
  }
}
