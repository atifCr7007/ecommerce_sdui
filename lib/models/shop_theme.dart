import 'package:flutter/material.dart';

/// Shop theme configuration for custom branding
class ShopTheme {
  final String primaryColor;
  final String secondaryColor;
  final String accentColor;
  final String backgroundColor;
  final String textColor;
  final String cardColor;
  final String appBarColor;
  final String buttonColor;
  final String buttonTextColor;
  final String iconColor;
  final String deliveryTime;
  final String specialOffer;

  const ShopTheme({
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.backgroundColor,
    required this.textColor,
    required this.cardColor,
    required this.appBarColor,
    required this.buttonColor,
    required this.buttonTextColor,
    required this.iconColor,
    required this.deliveryTime,
    required this.specialOffer,
  });

  /// Convert hex color string to Color object
  Color parseColor(String hexColor) {
    return Color(int.parse(hexColor.replaceFirst('#', '0xFF')));
  }

  /// Get primary color as Color object
  Color get primaryColorValue => parseColor(primaryColor);

  /// Get secondary color as Color object
  Color get secondaryColorValue => parseColor(secondaryColor);

  /// Get accent color as Color object
  Color get accentColorValue => parseColor(accentColor);

  /// Get background color as Color object
  Color get backgroundColorValue => parseColor(backgroundColor);

  /// Get text color as Color object
  Color get textColorValue => parseColor(textColor);

  /// Get card color as Color object
  Color get cardColorValue => parseColor(cardColor);

  /// Get app bar color as Color object
  Color get appBarColorValue => parseColor(appBarColor);

  /// Get button color as Color object
  Color get buttonColorValue => parseColor(buttonColor);

  /// Get button text color as Color object
  Color get buttonTextColorValue => parseColor(buttonTextColor);

  /// Get icon color as Color object
  Color get iconColorValue => parseColor(iconColor);

  /// Create a Flutter ThemeData from this shop theme
  ThemeData toThemeData() {
    return ThemeData(
      primaryColor: primaryColorValue,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColorValue,
        secondary: secondaryColorValue,
        surface: cardColorValue,
        background: backgroundColorValue,
      ),
      scaffoldBackgroundColor: backgroundColorValue,
      appBarTheme: AppBarTheme(
        backgroundColor: appBarColorValue,
        foregroundColor: textColorValue,
        elevation: 4.0,
      ),
      cardTheme: CardThemeData(
        color: cardColorValue,
        elevation: 2.0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColorValue,
          foregroundColor: buttonTextColorValue,
          elevation: 2.0,
        ),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(
          color: textColorValue,
          fontSize: 16.0,
        ),
        bodyMedium: TextStyle(
          color: textColorValue,
          fontSize: 14.0,
        ),
        headlineLarge: TextStyle(
          color: textColorValue,
          fontSize: 32.0,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: textColorValue,
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
        ),
      ),
      iconTheme: IconThemeData(
        color: iconColorValue,
        size: 24.0,
      ),
      useMaterial3: true,
    );
  }

  /// Create a simplified shop theme with basic colors
  factory ShopTheme.simple({
    required String primaryColor,
    required String secondaryColor,
    required String backgroundColor,
    required String textColor,
    String? accentColor,
    String? deliveryTime,
    String? specialOffer,
  }) {
    final accent = accentColor ?? primaryColor;
    return ShopTheme(
      primaryColor: primaryColor,
      secondaryColor: secondaryColor,
      accentColor: accent,
      backgroundColor: backgroundColor,
      textColor: textColor,
      cardColor: '#FFFFFF',
      appBarColor: primaryColor,
      buttonColor: primaryColor,
      buttonTextColor: '#FFFFFF',
      iconColor: textColor,
      deliveryTime: deliveryTime ?? '30-45 min',
      specialOffer: specialOffer ?? 'Free delivery on orders above ₹299',
    );
  }
}
