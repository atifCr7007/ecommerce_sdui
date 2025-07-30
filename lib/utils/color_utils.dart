import 'package:flutter/material.dart';

class ColorUtils {
  static Color? parseColor(dynamic colorValue) {
    if (colorValue == null) return null;
    
    String colorString = colorValue.toString();
    
    // Remove any whitespace
    colorString = colorString.trim();
    
    // Handle hex colors
    if (colorString.startsWith('#')) {
      return _parseHexColor(colorString);
    }
    
    // Handle rgba/rgb colors
    if (colorString.startsWith('rgb')) {
      return _parseRgbColor(colorString);
    }
    
    // Handle named colors
    return _parseNamedColor(colorString);
  }

  static Color? _parseHexColor(String hexColor) {
    try {
      String hex = hexColor.replaceFirst('#', '');
      
      // Handle 3-digit hex colors (e.g., #RGB -> #RRGGBB)
      if (hex.length == 3) {
        hex = hex.split('').map((char) => char + char).join();
      }
      
      // Handle 6-digit hex colors (add alpha if missing)
      if (hex.length == 6) {
        hex = 'FF' + hex;
      }
      
      // Parse 8-digit hex colors (AARRGGBB)
      if (hex.length == 8) {
        return Color(int.parse(hex, radix: 16));
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  static Color? _parseRgbColor(String rgbColor) {
    try {
      // Extract numbers from rgb(r, g, b) or rgba(r, g, b, a)
      final RegExp rgbRegex = RegExp(r'rgba?\(([^)]+)\)');
      final match = rgbRegex.firstMatch(rgbColor);
      
      if (match == null) return null;
      
      final values = match.group(1)!.split(',').map((s) => s.trim()).toList();
      
      if (values.length < 3) return null;
      
      final r = int.tryParse(values[0]);
      final g = int.tryParse(values[1]);
      final b = int.tryParse(values[2]);
      
      if (r == null || g == null || b == null) return null;
      
      double a = 1.0;
      if (values.length > 3) {
        a = double.tryParse(values[3]) ?? 1.0;
      }
      
      return Color.fromRGBO(r, g, b, a);
    } catch (e) {
      return null;
    }
  }

  static Color? _parseNamedColor(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.yellow;
      case 'orange':
        return Colors.orange;
      case 'purple':
        return Colors.purple;
      case 'pink':
        return Colors.pink;
      case 'cyan':
        return Colors.cyan;
      case 'teal':
        return Colors.teal;
      case 'indigo':
        return Colors.indigo;
      case 'lime':
        return Colors.lime;
      case 'amber':
        return Colors.amber;
      case 'brown':
        return Colors.brown;
      case 'grey':
      case 'gray':
        return Colors.grey;
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      case 'transparent':
        return Colors.transparent;
      
      // Material Design colors
      case 'primary':
        return Colors.blue;
      case 'secondary':
        return Colors.teal;
      case 'accent':
        return Colors.amber;
      case 'error':
        return Colors.red;
      case 'warning':
        return Colors.orange;
      case 'info':
        return Colors.blue;
      case 'success':
        return Colors.green;
      
      // Shades
      case 'red50':
        return Colors.red[50];
      case 'red100':
        return Colors.red[100];
      case 'red200':
        return Colors.red[200];
      case 'red300':
        return Colors.red[300];
      case 'red400':
        return Colors.red[400];
      case 'red500':
        return Colors.red[500];
      case 'red600':
        return Colors.red[600];
      case 'red700':
        return Colors.red[700];
      case 'red800':
        return Colors.red[800];
      case 'red900':
        return Colors.red[900];
      
      case 'blue50':
        return Colors.blue[50];
      case 'blue100':
        return Colors.blue[100];
      case 'blue200':
        return Colors.blue[200];
      case 'blue300':
        return Colors.blue[300];
      case 'blue400':
        return Colors.blue[400];
      case 'blue500':
        return Colors.blue[500];
      case 'blue600':
        return Colors.blue[600];
      case 'blue700':
        return Colors.blue[700];
      case 'blue800':
        return Colors.blue[800];
      case 'blue900':
        return Colors.blue[900];
      
      case 'green50':
        return Colors.green[50];
      case 'green100':
        return Colors.green[100];
      case 'green200':
        return Colors.green[200];
      case 'green300':
        return Colors.green[300];
      case 'green400':
        return Colors.green[400];
      case 'green500':
        return Colors.green[500];
      case 'green600':
        return Colors.green[600];
      case 'green700':
        return Colors.green[700];
      case 'green800':
        return Colors.green[800];
      case 'green900':
        return Colors.green[900];
      
      case 'grey50':
      case 'gray50':
        return Colors.grey[50];
      case 'grey100':
      case 'gray100':
        return Colors.grey[100];
      case 'grey200':
      case 'gray200':
        return Colors.grey[200];
      case 'grey300':
      case 'gray300':
        return Colors.grey[300];
      case 'grey400':
      case 'gray400':
        return Colors.grey[400];
      case 'grey500':
      case 'gray500':
        return Colors.grey[500];
      case 'grey600':
      case 'gray600':
        return Colors.grey[600];
      case 'grey700':
      case 'gray700':
        return Colors.grey[700];
      case 'grey800':
      case 'gray800':
        return Colors.grey[800];
      case 'grey900':
      case 'gray900':
        return Colors.grey[900];
      
      default:
        return null;
    }
  }

  // Helper method to convert Color to hex string
  static String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';
  }

  // Helper method to get contrasting text color
  static Color getContrastingTextColor(Color backgroundColor) {
    // Calculate luminance
    final luminance = backgroundColor.computeLuminance();
    
    // Return black for light backgrounds, white for dark backgrounds
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  // Helper method to lighten a color
  static Color lighten(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    
    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);
    
    return hsl.withLightness(lightness).toColor();
  }

  // Helper method to darken a color
  static Color darken(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    
    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);
    
    return hsl.withLightness(lightness).toColor();
  }
}
