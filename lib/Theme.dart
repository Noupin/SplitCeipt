import 'package:flutter/material.dart';

// The primary color is #EDEDEC
const Color _primaryColor = Color(0xFFEDEDEC);

// The primary variant color is a darker shade of the primary color
const Color _primaryVariantColor = Color(0xFFC4C4C4);

// The secondary color is #018180
const Color _secondaryColor = Color(0xFF018180);

// The secondary variant color is a darker shade of the secondary color
const Color _secondaryVariantColor = Color(0xFF005C5B);

// The background color is a very light shade of the primary color
const Color _backgroundColor = Color(0xFFFDFDFD);

// The surface color is a light shade of the primary color
const Color _surfaceColor = Color(0xFFF6F6F6);

// The error color is a predefined red color
const Color _errorColor = Color(0xFFB00020);

// The onPrimary color is a predefined black color
const Color _onPrimaryColor = Color(0xFF000000);

// The onSecondary color is a predefined white color
const Color _onSecondaryColor = Color(0xFFFFFFFF);

// The onBackground color is a predefined black color
const Color _onBackgroundColor = Color(0xFF000000);

// The onSurface color is a predefined black color
const Color _onSurfaceColor = Color(0xFF000000);

// The onError color is a predefined white color
const Color _onErrorColor = Color(0xFFFFFFFF);

// The custom flutter color scheme based on the colors you provided
final ThemeData customThemeData = ThemeData.from(
  // Use the new ThemeData.from factory, which uses colorScheme.error instead of errorColor
  // This avoids the deprecation warning in Flutter 3.3 and later versions
  // See https://api.flutter.dev/flutter/material/ThemeData/errorColor.html for more details
  colorScheme: const ColorScheme(
    primary: _primaryColor,
    secondary: _secondaryColor,
    surface: _surfaceColor,
    background: _backgroundColor,
    error: _errorColor,
    onPrimary: _onPrimaryColor,
    onSecondary: _onSecondaryColor,
    onSurface: _onSurfaceColor,
    onBackground: _onBackgroundColor,
    onError: _onErrorColor,
    brightness: Brightness.light,
  ),
  useMaterial3: true,
).copyWith(
    // You can also customize other theme properties here, such as typography, icon theme, etc.
    // See https://api.flutter.dev/flutter/material/ThemeData-class.html for more options
    );
