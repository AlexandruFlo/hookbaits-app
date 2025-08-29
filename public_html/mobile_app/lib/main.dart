import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config.dart';
import 'state/cart.dart';
import 'state/auth_state.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HookbaitsApp());
}

class HookbaitsApp extends StatelessWidget {
  const HookbaitsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthState()),
        ChangeNotifierProvider(create: (_) => CartState()),
      ],
      child: MaterialApp(
        title: AppConfig.appName,
        theme: ThemeData(
          primarySwatch: Colors.green,
          primaryColor: const Color(0xFF0A7F2E), // Verde Hookbaits
          scaffoldBackgroundColor: const Color(0xFFF8F9FA),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF0A7F2E),
            foregroundColor: Colors.white,
            elevation: 2,
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          navigationBarTheme: NavigationBarThemeData(
            backgroundColor: Colors.white,
            indicatorColor: const Color(0xFF0A7F2E).withOpacity(0.2),
            labelTextStyle: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return const TextStyle(color: Color(0xFF0A7F2E), fontWeight: FontWeight.bold);
              }
              return const TextStyle(color: Colors.grey);
            }),
            iconTheme: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return const IconThemeData(color: Color(0xFF0A7F2E));
              }
              return const IconThemeData(color: Colors.grey);
            }),
            elevation: 8,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0A7F2E),
              foregroundColor: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          cardTheme: CardTheme(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(8),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF0A7F2E)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF0A7F2E), width: 2),
            ),
          ),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

