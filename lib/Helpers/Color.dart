import 'dart:math';
import 'package:flutter/material.dart';

// A function to generate a random color
Color randomColor() {
  // Create a random number generator
  Random random = Random();

  // Generate random values for red, green and blue channels
  int r = random.nextInt(256);
  int g = random.nextInt(256);
  int b = random.nextInt(256);

  // Return a color with the generated values
  return Color.fromARGB(255, r, g, b);
}

Color desaturate(Color color, double amount, double opacity) {
  // Convert the color to HSL color space
  HSLColor hsl = HSLColor.fromColor(color);
  // Reduce the saturation by the given amount, ensuring it doesn't drop below 0
  double newSaturation = (hsl.saturation - amount).clamp(0.0, 1.0);
  // Return the new color with the modified saturation
  return hsl.withSaturation(newSaturation).toColor().withOpacity(opacity);
}
