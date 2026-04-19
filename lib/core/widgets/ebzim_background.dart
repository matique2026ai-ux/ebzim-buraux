import 'package:flutter/material.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';

class EbzimBackground extends StatelessWidget {
  final Widget child;

  const EbzimBackground({super.key, required this.child});

  /// ── EMERALD NOCTURNE BACKGROUND ───────────────────────────────────
  /// Visual artist's implementation of a deep gemstone atmosphere.
  /// Consists of layered atmospheric glows and a physical material texture.
  /// ───────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Stack(
      fit: StackFit.expand,
      children: [
        // ── Deep Velvet Base (Pure Obsidian) ───────────────────────────
        Container(color: isDark ? const Color(0xFF010503) : const Color(0xFFFDFBF7)),

        // ── Artistic Light Leak 1 (Top Left - Warm Emerald) ────────────
        if (isDark)
          Positioned(
            top: -400,
            left: -300,
            child: Container(
              width: 1500,
              height: 1200,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF064E3B).withOpacity(0.35), // Doubled intensity
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

        // ── Artistic Light Leak 2 (Bottom Right - Gemstone) ───────────
        if (isDark)
          Positioned(
            bottom: -300,
            right: -200,
            child: Container(
              width: 1000,
              height: 1000,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF0B6E4F).withOpacity(0.25), // Increased highlight
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

        // ── Material Texture (Physical Grain for WOW factor) ────────────
        if (isDark)
          Positioned.fill(
            child: Opacity(
              opacity: 0.04, // Doubled texture visibility
              child: Image.network(
                'https://www.transparenttextures.com/patterns/stardust.png',
                repeat: ImageRepeat.repeat,
                color: Colors.white,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
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
                  ? AppTheme.accentColor.withOpacity(0.05) // Subtle gold ambient glow
                  : theme.primaryColor.withOpacity(0.05),
                Colors.transparent,
              ],
            ),
          ),
        ),

        // ── Satin Sheen Overlay ──────────────────────────────────────────
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(-0.5, -0.5),
                radius: 1.5,
                colors: [
                  Colors.white.withOpacity(isDark ? 0.03 : 0.0), // Subtle silk sheen
                  Colors.transparent,
                ],
              ),
            ),
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
