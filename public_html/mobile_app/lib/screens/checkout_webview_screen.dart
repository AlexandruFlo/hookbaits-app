import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CheckoutWebViewScreen extends StatefulWidget {
  final String checkoutUrl;
  final VoidCallback? onOrderComplete;
  const CheckoutWebViewScreen({super.key, required this.checkoutUrl, this.onOrderComplete});

  @override
  State<CheckoutWebViewScreen> createState() => _CheckoutWebViewScreenState();
}

class _CheckoutWebViewScreenState extends State<CheckoutWebViewScreen> {
  late final WebViewController controller;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (url) {
          if (mounted) setState(() => loading = false);
          
          // Detectează dacă comanda a fost finalizată
          if (url.contains('order-received') || 
              url.contains('checkout/order-received') ||
              url.contains('thank-you') ||
              url.contains('success')) {
            Future.delayed(const Duration(seconds: 2), () {
              widget.onOrderComplete?.call();
            });
          }
        },
        onNavigationRequest: (NavigationRequest request) {
          // Permite toate navigările
          return NavigationDecision.navigate;
        },
      ))
      ..setUserAgent('HookbaitsApp/1.0')
      ..loadRequest(Uri.parse(widget.checkoutUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Finalizare')),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (loading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}

