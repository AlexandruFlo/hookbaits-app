import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/auth_state.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool emailNotifications = true;
  bool pushNotifications = true;
  String selectedLanguage = 'Română';
  String selectedCurrency = 'Lei (RON)';

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
              
              // ⚙️ Conținutul setărilor
              Expanded(
                child: !auth.isAuthenticated
                    ? _buildUnauthenticatedState()
                    : _buildSettingsList(auth),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.oceanDepth,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepWater.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.pearlWhite.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.settings_rounded,
              color: AppColors.pearlWhite,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Setări',
                  style: TextStyle(
                    color: AppColors.pearlWhite,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Personalizează experiența ta',
                  style: TextStyle(
                    color: AppColors.pearlWhite.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnauthenticatedState() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.pearlWhite,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.deepWater.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.coral.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.lock_outline_rounded,
                size: 48,
                color: AppColors.coral,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Autentificare necesară',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.deepWater,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Pentru a accesa setările, te rugăm să te autentifici mai întâi.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.stormyWater,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsList(AuthState auth) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
              // Setări profil
              _buildSectionHeader('Profil'),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Editează profilul'),
                subtitle: Text(auth.user?.email ?? ''),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  _showEditProfileDialog();
                },
              ),
              ListTile(
                leading: const Icon(Icons.lock),
                title: const Text('Schimbă parola'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  _showChangePasswordDialog();
                },
              ),
              
              const Divider(),
              
              // Setări notificări
              _buildSectionHeader('Notificări'),
              SwitchListTile(
                secondary: const Icon(Icons.notifications),
                title: const Text('Notificări'),
                subtitle: const Text('Activează/dezactivează toate notificările'),
                value: notificationsEnabled,
                activeColor: const Color(0xFF0A7F2E),
                onChanged: (value) {
                  setState(() {
                    notificationsEnabled = value;
                    if (!value) {
                      emailNotifications = false;
                      pushNotifications = false;
                    }
                  });
                },
              ),
              SwitchListTile(
                secondary: const Icon(Icons.email),
                title: const Text('Notificări email'),
                subtitle: const Text('Primește notificări pe email'),
                value: emailNotifications && notificationsEnabled,
                activeColor: const Color(0xFF0A7F2E),
                onChanged: notificationsEnabled ? (value) {
                  setState(() => emailNotifications = value);
                } : null,
              ),
              SwitchListTile(
                secondary: const Icon(Icons.phone_android),
                title: const Text('Notificări push'),
                subtitle: const Text('Primește notificări pe telefon'),
                value: pushNotifications && notificationsEnabled,
                activeColor: const Color(0xFF0A7F2E),
                onChanged: notificationsEnabled ? (value) {
                  setState(() => pushNotifications = value);
                } : null,
              ),
              
              const Divider(),
              
              // Setări aplicație
              _buildSectionHeader('Aplicație'),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Limba'),
                subtitle: Text(selectedLanguage),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  _showLanguageDialog();
                },
              ),
              ListTile(
                leading: const Icon(Icons.monetization_on),
                title: const Text('Moneda'),
                subtitle: Text(selectedCurrency),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  _showCurrencyDialog();
                },
              ),
              
              const Divider(),
              
              // Suport și informații
              _buildSectionHeader('Suport'),
              ListTile(
                leading: const Icon(Icons.help),
                title: const Text('Ajutor și suport'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Contactează suportul: support@hookbaits.ro')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.policy),
                title: const Text('Termeni și condiții'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Deschide termenii și condițiile')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip),
                title: const Text('Politica de confidențialitate'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Deschide politica de confidențialitate')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('Despre aplicație'),
                subtitle: const Text('Versiunea 1.0.0'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  _showAboutDialog();
                },
              ),
              
              const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      margin: const EdgeInsets.fromLTRB(8, 24, 8, 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.oceanBreeze.withOpacity(0.1),
            AppColors.seaFoam.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.oceanBreeze.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              gradient: AppColors.oceanDepth,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.deepWater,
            ),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog() {
    final auth = context.read<AuthState>();
    final nameController = TextEditingController(text: auth.user?.name ?? '');
    final emailController = TextEditingController(text: auth.user?.email ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editează profilul'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nume complet'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Anulează'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profilul a fost actualizat')),
              );
            },
            child: const Text('Salvează'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Schimbă parola'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Parola curentă'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Parola nouă'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Confirmă parola nouă'),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Anulează'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Parola a fost schimbată')),
              );
            },
            child: const Text('Schimbă'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Selectează limba'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Română', 'English', 'Français'].map((language) => 
            RadioListTile<String>(
              title: Text(language),
              value: language,
              groupValue: selectedLanguage,
              activeColor: const Color(0xFF0A7F2E),
              onChanged: (value) {
                setState(() => selectedLanguage = value!);
                Navigator.of(context).pop();
              },
            ),
          ).toList(),
        ),
      ),
    );
  }

  void _showCurrencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Selectează moneda'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Lei (RON)', 'Euro (EUR)', 'Dollar (USD)'].map((currency) => 
            RadioListTile<String>(
              title: Text(currency),
              value: currency,
              groupValue: selectedCurrency,
              activeColor: const Color(0xFF0A7F2E),
              onChanged: (value) {
                setState(() => selectedCurrency = value!);
                Navigator.of(context).pop();
              },
            ),
          ).toList(),
        ),
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Despre Hookbaits'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hookbaits - Magazin de pescuit'),
            SizedBox(height: 8),
            Text('Versiunea: 1.0.0'),
            SizedBox(height: 8),
            Text('Dezvoltat pentru pescarii pasionați'),
            SizedBox(height: 16),
            Text('© 2024 Hookbaits. Toate drepturile rezervate.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
