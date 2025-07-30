import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'color_utils.dart';

class ThemeManager {
  static Map<String, dynamic>? _themeData;
  static ThemeData? _materialTheme;

  // Load theme from JSON
  static Future<void> loadTheme() async {
    try {
      final String themeJson = await rootBundle.loadString(
        'assets/theme/app_theme.json',
      );
      _themeData = json.decode(themeJson);
      _materialTheme = _createMaterialTheme();
    } catch (e) {
      debugPrint('Error loading theme: $e');
      _themeData = null;
      _materialTheme = null;
    }
  }

  // Get Material Theme
  static ThemeData get materialTheme {
    return _materialTheme ?? ThemeData.light();
  }

  // Get color from theme
  static Color getColor(String colorKey, {Color? fallback}) {
    if (_themeData == null) return fallback ?? Colors.grey;

    final colors = _themeData!['colors'] as Map<String, dynamic>?;
    if (colors == null) return fallback ?? Colors.grey;

    final colorValue = colors[colorKey];
    return ColorUtils.parseColor(colorValue) ?? fallback ?? Colors.grey;
  }

  // Get typography style
  static TextStyle getTextStyle(String styleKey, {TextStyle? fallback}) {
    if (_themeData == null) return fallback ?? const TextStyle();

    final typography = _themeData!['typography'] as Map<String, dynamic>?;
    if (typography == null) return fallback ?? const TextStyle();

    final style = typography[styleKey] as Map<String, dynamic>?;
    if (style == null) return fallback ?? const TextStyle();

    return TextStyle(
      fontSize: (style['fontSize'] as num?)?.toDouble(),
      fontWeight: _parseFontWeight(style['fontWeight']),
      color: ColorUtils.parseColor(style['color']),
      fontFamily: typography['fontFamily'] as String?,
    );
  }

  // Get spacing value
  static double getSpacing(String spacingKey, {double fallback = 16.0}) {
    if (_themeData == null) return fallback;

    final spacing = _themeData!['spacing'] as Map<String, dynamic>?;
    if (spacing == null) return fallback;

    return (spacing[spacingKey] as num?)?.toDouble() ?? fallback;
  }

  // Get border radius
  static double getBorderRadius(String radiusKey, {double fallback = 8.0}) {
    if (_themeData == null) return fallback;

    final borderRadius = _themeData!['borderRadius'] as Map<String, dynamic>?;
    if (borderRadius == null) return fallback;

    return (borderRadius[radiusKey] as num?)?.toDouble() ?? fallback;
  }

  // Get elevation
  static double getElevation(String elevationKey, {double fallback = 2.0}) {
    if (_themeData == null) return fallback;

    final elevation = _themeData!['elevation'] as Map<String, dynamic>?;
    if (elevation == null) return fallback;

    return (elevation[elevationKey] as num?)?.toDouble() ?? fallback;
  }

  // Get component style
  static Map<String, dynamic>? getComponentStyle(String componentKey) {
    if (_themeData == null) return null;

    final components = _themeData!['components'] as Map<String, dynamic>?;
    if (components == null) return null;

    return components[componentKey] as Map<String, dynamic>?;
  }

  // Create Material Theme from JSON
  static ThemeData _createMaterialTheme() {
    if (_themeData == null) return ThemeData.light();

    final colors = _themeData!['colors'] as Map<String, dynamic>? ?? {};

    final colorScheme = ColorScheme.light(
      primary: ColorUtils.parseColor(colors['primary']) ?? Colors.blue,
      primaryContainer:
          ColorUtils.parseColor(colors['primaryVariant']) ?? Colors.blue[700]!,
      secondary: ColorUtils.parseColor(colors['secondary']) ?? Colors.orange,
      secondaryContainer:
          ColorUtils.parseColor(colors['secondaryVariant']) ??
          Colors.orange[700]!,
      surface: ColorUtils.parseColor(colors['surface']) ?? Colors.white,
      error: ColorUtils.parseColor(colors['error']) ?? Colors.red,
      onPrimary: ColorUtils.parseColor(colors['onPrimary']) ?? Colors.white,
      onSecondary: ColorUtils.parseColor(colors['onSecondary']) ?? Colors.white,
      onSurface: ColorUtils.parseColor(colors['onSurface']) ?? Colors.black,
      onError: ColorUtils.parseColor(colors['onError']) ?? Colors.white,
    );

    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      fontFamily: _themeData!['typography']?['fontFamily'] as String?,

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: getColor('primary'),
        foregroundColor: getColor('onPrimary'),
        elevation: getElevation('medium'),
        centerTitle: true,
        titleTextStyle: getTextStyle(
          'headline6',
        ).copyWith(color: getColor('onPrimary')),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: getColor('surface'),
        selectedItemColor: getColor('primary'),
        unselectedItemColor: ColorUtils.parseColor('#757575'),
        elevation: getElevation('high'),
        type: BottomNavigationBarType.fixed,
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: getColor('surface'),
        elevation: getElevation('low'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(getBorderRadius('medium')),
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: getColor('primary'),
          foregroundColor: getColor('onPrimary'),
          elevation: getElevation('low'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(getBorderRadius('medium')),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: getSpacing('lg'),
            vertical: getSpacing('sm'),
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: getColor('primary'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(getBorderRadius('medium')),
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: getColor('primary'),
          side: BorderSide(color: getColor('primary')),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(getBorderRadius('medium')),
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ColorUtils.parseColor('#FAFAFA'),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(getBorderRadius('medium')),
          borderSide: BorderSide(color: ColorUtils.parseColor('#E0E0E0')!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(getBorderRadius('medium')),
          borderSide: BorderSide(color: ColorUtils.parseColor('#E0E0E0')!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(getBorderRadius('medium')),
          borderSide: BorderSide(color: getColor('primary'), width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: getSpacing('md'),
          vertical: getSpacing('sm'),
        ),
      ),

      // Tab Bar Theme
      tabBarTheme: TabBarThemeData(
        labelColor: getColor('primary'),
        unselectedLabelColor: ColorUtils.parseColor('#757575'),
        indicatorColor: getColor('primary'),
        indicatorSize: TabBarIndicatorSize.tab,
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: ColorUtils.parseColor('#E0E0E0'),
        thickness: 1,
        space: 1,
      ),
    );
  }

  // Helper method to parse font weight
  static FontWeight? _parseFontWeight(dynamic value) {
    if (value == null) return null;

    switch (value.toString().toLowerCase()) {
      case 'bold':
        return FontWeight.bold;
      case 'normal':
        return FontWeight.normal;
      case 'w100':
        return FontWeight.w100;
      case 'w200':
        return FontWeight.w200;
      case 'w300':
        return FontWeight.w300;
      case 'w400':
        return FontWeight.w400;
      case 'w500':
        return FontWeight.w500;
      case 'w600':
        return FontWeight.w600;
      case 'w700':
        return FontWeight.w700;
      case 'w800':
        return FontWeight.w800;
      case 'w900':
        return FontWeight.w900;
      default:
        return null;
    }
  }
}
