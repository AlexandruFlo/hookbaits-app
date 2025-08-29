import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/auth_state.dart';
import '../theme/app_theme.dart';
import 'auth_screen.dart';
import 'orders_screen.dart';
import 'favorites_screen.dart';
import 'addresses_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthState>(
      builder: (context, auth, child) {
        if (!auth.isAuthenticated) {
          return _buildUnauthenticatedScreen(context);
        }
        return _buildAuthenticatedScreen(context, auth);
      },
    );
  }

  // 🌊 Ecran pentru utilizatori neautentificați - design oceanic
  Widget _buildUnauthenticatedScreen(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.oceanDepth,
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 🎣 Iconografia oceanică elegantă
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.pearlWhite.withOpacity(0.2),
                          AppColors.silverScale.withOpacity(0.1),
                        ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.goldenHour.withOpacity(0.3),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.person_outline,
                      size: 80,
                      color: AppColors.goldenHour,
                      shadows: [
                        Shadow(
                          color: AppColors.deepOcean,
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  // 📝 Mesaj elegant cu tipografie premium
                  Text(
                    'Bun venit la HOOKBAITS',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppColors.pearlWhite,
                      letterSpacing: 1.5,
                      shadows: [
                        Shadow(
                          color: AppColors.deepOcean,
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  Text(
                    'Pentru a comanda produsele noastre premium\ntrebuie să îți creezi un cont',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.silverScale,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 50),
                  
                  // 🚀 Buton premium cu gradient oceanic
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: AppColors.premiumButtonGradient,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.goldenHour.withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const AuthScreen(),
                          ));
                        },
                        borderRadius: BorderRadius.circular(28),
                        child: Container(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.person_add_outlined,
                                color: AppColors.pearlWhite,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'CREEAZĂ CONT / AUTENTIFICARE',
                                style: TextStyle(
                                  color: AppColors.pearlWhite,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1,
                                  shadows: [
                                    Shadow(
                                      color: AppColors.deepOcean,
                                      offset: const Offset(0, 1),
                                      blurRadius: 2,
                                    ),
                                  ],
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
            ),
          ),
        ),
      ),
    );
  }

  // 👤 Ecran pentru utilizatori autentificați - design premium
  Widget _buildAuthenticatedScreen(BuildContext context, AuthState auth) {
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🏷️ Header cu profilul utilizatorului
                _buildUserProfileCard(auth),
                const SizedBox(height: 30),
                
                // 📋 Meniul principal cu opțiuni
                _buildAccountMenu(context),
                const SizedBox(height: 30),
                
                // 🚪 Butonul de delogare
                _buildLogoutButton(context, auth),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 👤 Cardul de profil utilizator - design oceanic
  Widget _buildUserProfileCard(AuthState auth) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.oceanicGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepOcean.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar premium cu gradient
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              gradient: AppColors.goldenReflection,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.goldenHour.withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.person,
              color: AppColors.deepOcean,
              size: 36,
            ),
          ),
          const SizedBox(width: 20),
          
          // Informațiile utilizatorului
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  auth.user?.name ?? 'Utilizator HOOKBAITS',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.pearlWhite,
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
                  auth.user?.email ?? 'email@hookbaits.ro',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.silverScale,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.goldenHour.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.goldenHour.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'MEMBRU PREMIUM',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.goldenHour,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 📋 Meniul principal cu opțiuni - design premium
  Widget _buildAccountMenu(BuildContext context) {
    final menuItems = [
      _MenuItemData(
        icon: Icons.shopping_bag_outlined,
        title: 'Comenzile mele',
        subtitle: 'Istoricul comenzilor tale',
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const OrdersScreen())),
      ),
      _MenuItemData(
        icon: Icons.favorite_outline,
        title: 'Produse favorite',
        subtitle: 'Nada ta preferată',
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FavoritesScreen())),
      ),
      _MenuItemData(
        icon: Icons.location_on_outlined,
        title: 'Adrese de livrare',
        subtitle: 'Gestionează adresele',
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddressesScreen())),
      ),
      _MenuItemData(
        icon: Icons.settings_outlined,
        title: 'Setări',
        subtitle: 'Preferințe aplicație',
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsScreen())),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Opțiuni cont',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 16),
        ...menuItems.map((item) => _buildMenuItem(item)),
      ],
    );
  }

  // 🔧 Item din meniul principal
  Widget _buildMenuItem(_MenuItemData item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.crystalClear,
            AppColors.pearlWhite,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepOcean.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: AppColors.silverScale.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: item.onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: AppColors.oceanicGradient,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.stormyWater.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    item.icon,
                    color: AppColors.goldenHour,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.silverScale,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🚪 Butonul de delogare premium
  Widget _buildLogoutButton(BuildContext context, AuthState auth) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.coral,
            AppColors.sunset,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.coral.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            await auth.logout();
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.check_circle, color: AppColors.goldenHour),
                      const SizedBox(width: 8),
                      const Text('Delogare efectuată cu succes'),
                    ],
                  ),
                  backgroundColor: AppColors.seaweed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.logout_outlined,
                  color: AppColors.pearlWhite,
                  size: 22,
                ),
                const SizedBox(width: 12),
                Text(
                  'DELOGARE',
                  style: TextStyle(
                    color: AppColors.pearlWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                    shadows: [
                      Shadow(
                        color: AppColors.coral.withOpacity(0.5),
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 📋 Model pentru item-urile din meniu
class _MenuItemData {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  _MenuItemData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}
}
