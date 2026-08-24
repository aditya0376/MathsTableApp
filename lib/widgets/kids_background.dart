import 'package:flutter/material.dart';

import 'cartoon_character_view.dart';

/// A full-screen background of fun cartoon characters for kids themes.
/// Scatters characters across the background at low opacity so content
/// remains readable on top.
class KidsBackground extends StatelessWidget {
  final Widget child;
  final Color? tint;

  const KidsBackground({super.key, required this.child, this.tint});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tintColor = tint ?? scheme.primary.withValues(alpha: 0.06);
    return Stack(
      children: [
        // Background layer with scattered characters (low opacity).
        const Positioned.fill(
          child: Opacity(
            opacity: 0.25,
            child: Stack(
              children: [
                Positioned(
                    left: 10, top: 40,
                    child: CartoonCharacterView(
                        type: CartoonType.robot, size: 90, primaryColor: Color(0xFF42A5F5))),
                Positioned(
                    right: 10, top: 20,
                    child: CartoonCharacterView(
                        type: CartoonType.sun, size: 100, primaryColor: Color(0xFFFFB300))),
                Positioned(
                    right: 30, top: 220,
                    child: CartoonCharacterView(
                        type: CartoonType.cat, size: 80, primaryColor: Color(0xFF8D6E63))),
                Positioned(
                    left: 20, top: 260,
                    child: CartoonCharacterView(
                        type: CartoonType.star, size: 70, primaryColor: Color(0xFFFFD54F))),
                Positioned(
                    right: 40, bottom: 60,
                    child: CartoonCharacterView(
                        type: CartoonType.rocket, size: 90, primaryColor: Color(0xFF66BB6A))),
                Positioned(
                    left: 30, bottom: 40,
                    child: CartoonCharacterView(
                        type: CartoonType.owl, size: 85, primaryColor: Color(0xFF7E57C2))),
              ],
            ),
          ),
        ),
        // Optional soft tint over the background.
        Positioned.fill(child: ColoredBox(color: tintColor)),
        // Foreground content.
        child,
      ],
    );
  }
}