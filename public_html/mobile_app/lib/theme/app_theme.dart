import 'package:flutter/material.dart';

class AppColors {
  // 🎣 PALETA PREMIUM HOOKBAITS - Inspirată din natura pescuitului
  
  // Culori principale - Nuanțe de apă profundă
  static const Color deepOcean = Color(0xFF0B1426);      // Albastru oceanic profund
  static const Color midnight = Color(0xFF1A2332);       // Albastru miezul nopții  
  static const Color stormyWater = Color(0xFF2C3E50);    // Albastru furtună
  static const Color clearWater = Color(0xFF3B5470);     // Albastru apă limpede
  static const Color shallowWater = Color(0xFF5A7394);   // Albastru apă puțin adâncă
  
  // Accente premium - Reflexii și lumină
  static const Color goldenHour = Color(0xFFD4AF37);     // Auriu ora de aur
  static const Color silverScale = Color(0xFFB8C5D1);    // Argintiu solzi
  static const Color pearlWhite = Color(0xFFF8FAFC);     // Alb perlă
  static const Color crystalClear = Color(0xFFFFFFFF);   // Cristal clar
  
  // Culori naturale - Elemente de natură
  static const Color seaweed = Color(0xFF2D5016);        // Verde alge marine
  static const Color sunset = Color(0xFFFF8C42);         // Portocaliu apus
  static const Color sunrise = Color(0xFFFFB627);        // Galben răsărit
  static const Color coral = Color(0xFFE74C3C);          // Roșu coral
  
  // Gradienți premium
  static const LinearGradient oceanDepth = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [deepOcean, midnight, stormyWater],
    stops: [0.0, 0.5, 1.0],
  );
  
  static const LinearGradient waterSurface = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [clearWater, shallowWater, silverScale],
    stops: [0.0, 0.6, 1.0],
  );
  
  static const LinearGradient goldenReflection = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [goldenHour, sunrise],
  );
  
  static const LinearGradient premiumSurface = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [pearlWhite, silverScale],
  );
  
  // Gradienți pentru cardurile premium
  static const LinearGradient oceanicGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [deepOcean, stormyWater, clearWater],
    stops: [0.0, 0.6, 1.0],
  );
  
  static const LinearGradient premiumButtonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [stormyWater, deepOcean],
  );
  
  static const LinearGradient coralGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [coral, sunset],
  );
  
  // Aliasuri pentru compatibilitate
  static const Color primary = deepOcean;
  static const Color primaryLight = stormyWater;
  static const Color primaryDark = midnight;
  static const Color secondary = goldenHour;
  static const Color accent = silverScale;
  static const Color success = seaweed;
  static const Color warning = sunrise;
  static const Color error = coral;
  static const Color background = pearlWhite;
  static const Color surface = crystalClear;
  static const Color surfaceVariant = silverScale;
  static const Color textPrimary = deepOcean;
  static const Color textSecondary = stormyWater;
  static const Color textLight = shallowWater;
  static const Color border = silverScale;
  static const Color divider = Color(0xFFE2E8F0);
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      
      // Paleta de culori
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        background: AppColors.background,
        error: AppColors.error,
        brightness: Brightness.light,
      ),
      
      // 🌊 AppBar Theme Premium cu gradient oceanic
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.deepOcean,
        foregroundColor: AppColors.pearlWhite,
        elevation: 12,
        shadowColor: AppColors.deepOcean.withOpacity(0.3),
        centerTitle: true,
        toolbarHeight: 72, // Înălțime mărită pentru eleganță
        titleTextStyle: const TextStyle(
          color: AppColors.pearlWhite,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
          shadows: [
            Shadow(
              color: AppColors.midnight,
              offset: Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        iconTheme: const IconThemeData(
          color: AppColors.pearlWhite,
          size: 26,
          shadows: [
            Shadow(
              color: AppColors.midnight,
              offset: Offset(0, 1),
              blurRadius: 2,
            ),
          ],
        ),
        actionsIconTheme: const IconThemeData(
          color: AppColors.pearlWhite,
          size: 26,
        ),
      ),
      
      // Navigation Bar Theme
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        elevation: 8,
        shadowColor: AppColors.primary.withOpacity(0.2),
        indicatorColor: AppColors.primary.withOpacity(0.15),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            );
          }
          return const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primary, size: 24);
          }
          return const IconThemeData(color: AppColors.textSecondary, size: 24);
        }),
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 3,
          shadowColor: AppColors.primary.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      
      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      
      // Card Theme
      cardTheme: CardTheme(
        color: AppColors.surface,
        elevation: 2,
        shadowColor: AppColors.primary.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(8),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        hintStyle: const TextStyle(color: AppColors.textLight),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      
      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.surface;
        }),
        checkColor: WidgetStateProperty.all(Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      
      // Radio Theme
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.textSecondary;
        }),
      ),
      
      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.textSecondary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary.withOpacity(0.3);
          }
          return AppColors.textLight.withOpacity(0.3);
        }),
      ),
      
      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.surfaceVariant,
        circularTrackColor: AppColors.surfaceVariant,
      ),
      
      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),
      
      // Scaffold Background
      scaffoldBackgroundColor: AppColors.background,
      
      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        headlineLarge: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
        headlineMedium: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
        headlineSmall: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
        titleSmall: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(color: AppColors.textPrimary),
        bodyMedium: TextStyle(color: AppColors.textPrimary),
        bodySmall: TextStyle(color: AppColors.textSecondary),
        labelLarge: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
        labelMedium: TextStyle(color: AppColors.textSecondary),
        labelSmall: TextStyle(color: AppColors.textSecondary),
      ),
      
      // Icon Theme
      iconTheme: const IconThemeData(
        color: AppColors.textPrimary,
        size: 24,
      ),
      
      // Primary Icon Theme
      primaryIconTheme: const IconThemeData(
        color: Colors.white,
        size: 24,
      ),
    );
  }
}
