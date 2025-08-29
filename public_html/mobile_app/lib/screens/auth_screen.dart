import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/auth_state.dart';
import '../theme/app_theme.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLogin = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.oceanDepth,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 40),
                
                // 🎣 Logo premium cu efecte oceanic
                _buildPremiumLogo(),
                const SizedBox(height: 50),
                
                // 📋 Formular premium cu gradient
                _buildPremiumForm(),
                const SizedBox(height: 30),
                
                // 🔄 Toggle între login/register
                _buildToggleButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🎣 Logo premium HOOKBAITS cu efecte oceanic
  Widget _buildPremiumLogo() {
    return Container(
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
      child: Column(
        children: [
          // Logo sau icon HOOKBAITS
          Image.asset(
            'assets/logo.png',
            height: 80,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Icon(
              Icons.phishing_outlined,
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
          const SizedBox(height: 16),
          
          // Titlul elegant
          Text(
            _isLogin ? 'Bun venit înapoi!' : 'Alătură-te comunității!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.pearlWhite,
              letterSpacing: 1,
              shadows: [
                Shadow(
                  color: AppColors.deepOcean,
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          
          Text(
            _isLogin 
                ? 'Accesează produsele premium HOOKBAITS'
                : 'Creează-ți contul pentru nadă de calitate',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.silverScale,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // 📋 Formular premium cu gradient și stiluri oceanic
  Widget _buildPremiumForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.crystalClear.withOpacity(0.95),
            AppColors.pearlWhite.withOpacity(0.9),
            AppColors.silverScale.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepOcean.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: AppColors.silverScale.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Câmp nume (doar pentru înregistrare)
            if (!_isLogin) ...[
              _buildPremiumTextField(
                controller: _nameController,
                label: 'Nume complet',
                icon: Icons.person_outline,
                validator: (value) => value?.isEmpty == true ? 'Numele este obligatoriu' : null,
              ),
              const SizedBox(height: 20),
            ],
            
            // Câmp email
            _buildPremiumTextField(
              controller: _emailController,
              label: 'Adresa de email',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value?.isEmpty == true) return 'Email-ul este obligatoriu';
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
                  return 'Email invalid';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            
            // Câmp parolă
            _buildPremiumTextField(
              controller: _passwordController,
              label: 'Parola',
              icon: Icons.lock_outline,
              obscureText: true,
              validator: (value) {
                if (value?.isEmpty == true) return 'Parola este obligatorie';
                if (value!.length < 6) return 'Parola trebuie să aibă minim 6 caractere';
                return null;
              },
            ),
            const SizedBox(height: 30),
            
            // Buton premium de submit
            _buildPremiumSubmitButton(),
          ],
        ),
      ),
    );
  }

  // 🎨 Text field premium cu design oceanic
  Widget _buildPremiumTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      style: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: AppColors.textLight,
          fontSize: 14,
        ),
        prefixIcon: Icon(
          icon,
          color: AppColors.stormyWater,
          size: 22,
        ),
        filled: true,
        fillColor: AppColors.pearlWhite.withOpacity(0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppColors.silverScale.withOpacity(0.3),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppColors.stormyWater,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppColors.silverScale.withOpacity(0.3),
            width: 1,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppColors.coral,
            width: 1,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    );
  }

  // 🚀 Buton premium de submit cu gradient oceanic
  Widget _buildPremiumSubmitButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: AppColors.premiumButtonGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.stormyWater.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isLoading ? null : _handleSubmit,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            alignment: Alignment.center,
            child: _isLoading
                ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.goldenHour),
                    strokeWidth: 3,
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _isLogin ? Icons.login_outlined : Icons.person_add_outlined,
                        color: AppColors.pearlWhite,
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _isLogin ? 'AUTENTIFICARE' : 'CREEAZĂ CONT',
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
    );
  }

  // 🔄 Buton toggle elegant pentru schimbarea modului
  Widget _buildToggleButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.silverScale.withOpacity(0.1),
            AppColors.pearlWhite.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.silverScale.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            _isLogin 
                ? 'Nu ai încă un cont HOOKBAITS?' 
                : 'Ai deja un cont HOOKBAITS?',
            style: TextStyle(
              color: AppColors.silverScale,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          
          TextButton(
            onPressed: () => setState(() => _isLogin = !_isLogin),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              backgroundColor: AppColors.goldenHour.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: AppColors.goldenHour.withOpacity(0.3),
                  width: 1,
                ),
              ),
            ),
            child: Text(
              _isLogin ? 'ÎNREGISTREAZĂ-TE ACUM' : 'AUTENTIFICĂ-TE',
              style: TextStyle(
                color: AppColors.goldenHour,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    final auth = context.read<AuthState>();
    final success = _isLogin 
      ? await auth.login(_emailController.text, _passwordController.text)
      : await auth.register(_nameController.text, _emailController.text, _passwordController.text);
    
    setState(() => _isLoading = false);
    
    if (success && mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: AppColors.goldenHour),
              const SizedBox(width: 8),
              Text(_isLogin ? 'Autentificare reușită!' : 'Cont creat cu succes!'),
            ],
          ),
          backgroundColor: AppColors.seaweed,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: AppColors.goldenHour),
              const SizedBox(width: 8),
              Expanded(child: Text(_isLogin ? 'Autentificare eșuată. Verifică datele.' : 'Înregistrare eșuată. Încearcă din nou.')),
            ],
          ),
          backgroundColor: AppColors.coral,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}
