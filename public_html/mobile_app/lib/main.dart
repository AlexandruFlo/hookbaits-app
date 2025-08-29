import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config.dart';
import 'state/cart.dart';
import 'state/auth_state.dart';
import 'state/favorites_state.dart';
import 'state/addresses_state.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

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
        ChangeNotifierProvider(create: (_) => FavoritesState()),
        ChangeNotifierProvider(create: (_) => AddressesState()),
      ],
      child: MaterialApp(
        title: AppConfig.appName,
        theme: AppTheme.theme,
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

