import 'package:flutter/material.dart';

class EbzimLogo extends StatelessWidget {
  final double size;
  final bool isEngraved;
  final Color? color;

  const EbzimLogo({
    super.key,
    this.size = 40,
    this.isEngraved = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (isEngraved) {
      // Create a "Stone Engraving" effect using a grayscale version with subtle lighting/shadows
      return Opacity(
        opacity: 0.7,
        child: ColorFiltered(
          colorFilter: const ColorFilter.matrix([
            0.2126, 0.7152, 0.0722, 0, 0,
            0.2126, 0.7152, 0.0722, 0, 0,
            0.2126, 0.7152, 0.0722, 0, 0,
            0,      0,      0,      1, 0,
          ]),
          child: Image.asset(
            'assets/images/logo.png',
            width: size,
            height: size,
            fit: BoxFit.contain,
          ),
        ),
      );
    }

    return Image.asset(
      'assets/images/logo.png',
      width: size,
      height: size,
      color: color,
      fit: BoxFit.contain,
    );
  }
}
