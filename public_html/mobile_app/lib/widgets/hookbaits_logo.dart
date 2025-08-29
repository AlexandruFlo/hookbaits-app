import 'package:flutter/material.dart';

class HookbaitsLogo extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? textColor;
  final bool showIcon;
  final bool showWave;
  final double fontSize;
  final FontWeight fontWeight;
  final double letterSpacing;

  const HookbaitsLogo({
    super.key,
    this.height,
    this.width,
    this.textColor = Colors.white,
    this.showIcon = true,
    this.showWave = true,
    this.fontSize = 20,
    this.fontWeight = FontWeight.bold,
    this.letterSpacing = 1.2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (showWave) ...[
            Icon(
              Icons.waves_outlined,
              color: textColor,
              size: fontSize + 4,
            ),
            const SizedBox(width: 8),
          ],
          if (showIcon) ...[
            // Logo-ul Hook cu stil personalizat
            Container(
              width: fontSize + 8,
              height: fontSize + 8,
              decoration: BoxDecoration(
                color: textColor?.withOpacity(0.1) ?? Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: textColor ?? Colors.white,
                  width: 1.5,
                ),
              ),
              child: Icon(
                Icons.phishing_outlined, // Iconița pentru cârlig de pescuit
                color: textColor,
                size: fontSize - 2,
              ),
            ),
            const SizedBox(width: 12),
          ],
          // Textul HOOKBAITS cu styling avansat
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'HOOK',
                  style: TextStyle(
                    color: textColor,
                    fontSize: fontSize,
                    fontWeight: fontWeight,
                    letterSpacing: letterSpacing,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(1, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
                TextSpan(
                  text: 'BAITS',
                  style: TextStyle(
                    color: textColor?.withOpacity(0.9) ?? Colors.white.withOpacity(0.9),
                    fontSize: fontSize,
                    fontWeight: FontWeight.w500,
                    letterSpacing: letterSpacing * 0.8,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(1, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Logo pentru splash screen
class HookbaitsLogoLarge extends StatelessWidget {
  final Color? backgroundColor;
  final Color? logoColor;

  const HookbaitsLogoLarge({
    super.key,
    this.backgroundColor = Colors.black,
    this.logoColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo mare cu efect
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: logoColor?.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: logoColor ?? Colors.white,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: logoColor?.withOpacity(0.3) ?? Colors.white.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                Icons.phishing_outlined,
                color: logoColor,
                size: 64,
              ),
            ),
            const SizedBox(height: 24),
            
            // Text cu efect
            HookbaitsLogo(
              textColor: logoColor,
              fontSize: 32,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.0,
              showIcon: false,
              showWave: false,
            ),
            
            const SizedBox(height: 12),
            
            // Subtitle
            Text(
              'PROFESSIONAL FISHING GEAR',
              style: TextStyle(
                color: logoColor?.withOpacity(0.7),
                fontSize: 12,
                fontWeight: FontWeight.w300,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Logo compact pentru navigație
class HookbaitsLogoCompact extends StatelessWidget {
  final Color? color;

  const HookbaitsLogoCompact({
    super.key,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return HookbaitsLogo(
      textColor: color ?? Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.w800,
      letterSpacing: 1.0,
      showWave: true,
      showIcon: false,
    );
  }
}
