import 'package:flutter/foundation.dart';

/// Log levels for different types of messages
enum LogLevel { debug, info, warning, error, critical }

/// Log categories for better organization
enum LogCategory {
  ui,
  navigation,
  cart,
  api,
  json,
  theme,
  controller,
  service,
  userAction,
  systemEvent,
}

/// Comprehensive debug logging utility for the SDUI ecommerce app
///
/// This utility provides structured logging with timestamps, context information,
/// and different log levels for better debugging and monitoring.
class DebugLogger {
  static const String _appTag = '[SDUI_ECOMMERCE]';

  /// Main logging method with full context
  static void log(
    String message, {
    LogLevel level = LogLevel.info,
    LogCategory category = LogCategory.systemEvent,
    String? className,
    String? methodName,
    Map<String, dynamic>? data,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!kDebugMode) return;

    final timestamp = DateTime.now().toIso8601String();
    final levelStr = level.name.toUpperCase().padRight(8);
    final categoryStr = category.name.toUpperCase().padRight(12);

    String logMessage = '$_appTag [$timestamp] [$levelStr] [$categoryStr]';

    if (className != null) {
      logMessage += ' [$className';
      if (methodName != null) {
        logMessage += '::$methodName';
      }
      logMessage += ']';
    }

    logMessage += ' $message';

    if (data != null && data.isNotEmpty) {
      logMessage += '\n  Data: ${_formatData(data)}';
    }

    if (error != null) {
      logMessage += '\n  Error: $error';
    }

    if (stackTrace != null) {
      logMessage +=
          '\n  StackTrace: ${stackTrace.toString().split('\n').take(5).join('\n')}';
    }

    debugPrint(logMessage);
  }

  /// Format data for logging
  static String _formatData(Map<String, dynamic> data) {
    try {
      return data.entries.map((e) => '${e.key}: ${e.value}').join(', ');
    } catch (e) {
      return data.toString();
    }
  }

  // Convenience methods for different log levels

  /// Debug level logging
  static void debug(
    String message, {
    LogCategory category = LogCategory.systemEvent,
    String? className,
    String? methodName,
    Map<String, dynamic>? data,
  }) {
    log(
      message,
      level: LogLevel.debug,
      category: category,
      className: className,
      methodName: methodName,
      data: data,
    );
  }

  /// Info level logging
  static void info(
    String message, {
    LogCategory category = LogCategory.systemEvent,
    String? className,
    String? methodName,
    Map<String, dynamic>? data,
  }) {
    log(
      message,
      level: LogLevel.info,
      category: category,
      className: className,
      methodName: methodName,
      data: data,
    );
  }

  /// Warning level logging
  static void warning(
    String message, {
    LogCategory category = LogCategory.systemEvent,
    String? className,
    String? methodName,
    Map<String, dynamic>? data,
    Object? error,
  }) {
    log(
      message,
      level: LogLevel.warning,
      category: category,
      className: className,
      methodName: methodName,
      data: data,
      error: error,
    );
  }

  /// Error level logging
  static void error(
    String message, {
    LogCategory category = LogCategory.systemEvent,
    String? className,
    String? methodName,
    Map<String, dynamic>? data,
    Object? error,
    StackTrace? stackTrace,
  }) {
    log(
      message,
      level: LogLevel.error,
      category: category,
      className: className,
      methodName: methodName,
      data: data,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Critical level logging
  static void critical(
    String message, {
    LogCategory category = LogCategory.systemEvent,
    String? className,
    String? methodName,
    Map<String, dynamic>? data,
    Object? error,
    StackTrace? stackTrace,
  }) {
    log(
      message,
      level: LogLevel.critical,
      category: category,
      className: className,
      methodName: methodName,
      data: data,
      error: error,
      stackTrace: stackTrace,
    );
  }

  // Specialized logging methods for common scenarios

  /// Log user actions
  static void userAction(
    String action, {
    String? screen,
    Map<String, dynamic>? context,
  }) {
    info(
      'User action: $action',
      category: LogCategory.userAction,
      data: {'screen': screen ?? 'unknown', ...?context},
    );
  }

  /// Log navigation events
  static void navigation(
    String event, {
    String? from,
    String? to,
    Map<String, dynamic>? parameters,
  }) {
    info(
      'Navigation: $event',
      category: LogCategory.navigation,
      data: {
        'from': from ?? 'unknown',
        'to': to ?? 'unknown',
        'parameters': parameters?.toString() ?? 'none',
      },
    );
  }

  /// Log cart operations
  static void cartOperation(
    String operation, {
    String? productId,
    String? variantId,
    int? quantity,
    int? totalItems,
    double? totalAmount,
  }) {
    info(
      'Cart operation: $operation',
      category: LogCategory.cart,
      data: {
        'productId': productId ?? 'unknown',
        'variantId': variantId ?? 'unknown',
        'quantity': quantity?.toString() ?? 'unknown',
        'totalItems': totalItems?.toString() ?? 'unknown',
        'totalAmount': totalAmount?.toString() ?? 'unknown',
      },
    );
  }

  /// Log JSON parsing events
  static void jsonParsing(
    String event, {
    String? componentType,
    String? screenId,
    int? componentCount,
    Object? error,
  }) {
    if (error != null) {
      DebugLogger.error(
        'JSON parsing error: $event',
        category: LogCategory.json,
        data: {
          'componentType': componentType ?? 'unknown',
          'screenId': screenId ?? 'unknown',
          'componentCount': componentCount?.toString() ?? 'unknown',
        },
        error: error,
      );
    } else {
      info(
        'JSON parsing: $event',
        category: LogCategory.json,
        data: {
          'componentType': componentType ?? 'unknown',
          'screenId': screenId ?? 'unknown',
          'componentCount': componentCount?.toString() ?? 'unknown',
        },
      );
    }
  }

  /// Log API calls
  static void apiCall(
    String endpoint, {
    String method = 'GET',
    Map<String, dynamic>? parameters,
    int? statusCode,
    Object? error,
  }) {
    if (error != null) {
      DebugLogger.error(
        'API call failed: $method $endpoint',
        category: LogCategory.api,
        data: {
          'method': method,
          'endpoint': endpoint,
          'parameters': parameters?.toString() ?? 'none',
          'statusCode': statusCode?.toString() ?? 'unknown',
        },
        error: error,
      );
    } else {
      info(
        'API call: $method $endpoint',
        category: LogCategory.api,
        data: {
          'method': method,
          'endpoint': endpoint,
          'parameters': parameters?.toString() ?? 'none',
          'statusCode': statusCode?.toString() ?? 'unknown',
        },
      );
    }
  }

  /// Log theme operations
  static void themeOperation(
    String operation, {
    String? themeId,
    Map<String, dynamic>? colors,
    Object? error,
  }) {
    if (error != null) {
      DebugLogger.error(
        'Theme operation failed: $operation',
        category: LogCategory.theme,
        data: {
          'themeId': themeId ?? 'unknown',
          'colors': colors?.toString() ?? 'none',
        },
        error: error,
      );
    } else {
      info(
        'Theme operation: $operation',
        category: LogCategory.theme,
        data: {
          'themeId': themeId ?? 'unknown',
          'colors': colors?.toString() ?? 'none',
        },
      );
    }
  }
}
