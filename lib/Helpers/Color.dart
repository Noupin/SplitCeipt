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
