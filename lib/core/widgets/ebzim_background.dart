import 'package:flutter/material.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';

class EbzimBackground extends StatelessWidget {
  final Widget child;

  const EbzimBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Premium Mesh Gradient Background
        Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(-0.8, -0.6),
              radius: 1.2,
              colors: isDark 
                ? [const Color(0xFF005A00), AppTheme.primaryColor]
                : [const Color(0xFFF2F7F2), const Color(0xFFF9F9F7)], // Silk Ivory Gradient
            ),
          ),
        ),
        
        // Second subtle gradient for depth
        Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0.7, 0.8),
              radius: 1.0,
              colors: [
                isDark 
                  ? const Color(0xFF003300).withValues(alpha: 0.5)
                  : theme.primaryColor.withValues(alpha: 0.05),
                Colors.transparent,
              ],
            ),
          ),
        ),

        // Pattern Texture (Muted for premium feel)
        Opacity(
          opacity: 0.05,
          child: Image.network(
            'https://www.transparenttextures.com/patterns/cubes.png',
            repeat: ImageRepeat.repeat,
            errorBuilder: (_, _, _) => const SizedBox.shrink(),
          ),
        ),

        // Logo Overlay (The "Calm" part the user likes)
        Positioned.fill(
          child: Opacity(
            opacity: 0.03,
            child: Image.network(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuC1-5S7uEnoS4ojXews_C3Fp00jh6j3uNLswPUVk8LyFG8-5y4G4_40vWBabyDF8QqWpHAfg_lQWXxZcVwjtPk3nRRvn1oO88mnZLuF2C-Ebo8NJrtxTHkPHnnC_SCyS8efhl-HnWcZASfWNITpBAn3UGPCxdYequIhVYaEF2roIsgByjb3rIZYnKANGH8awKTpCqnMC4IepnSdoqE9Mt3uTeBaMl5m4qEVFQ3RGDCKNSK2difoe9hMF2gN3BAEhA3pquo9ZtMXNtDU',
              fit: BoxFit.cover,
              colorBlendMode: BlendMode.luminosity,
              errorBuilder: (_, _, _) => const SizedBox.shrink(),
            ),
          ),
        ),

        // Main Content
        child,
      ],
    );
  }
}
