/// Application configuration class that manages environment-specific settings
/// and feature flags for the ecommerce SDUI app.
///
/// This configuration supports:
/// - Environment-based API endpoints
/// - Feature toggles for development/production
/// - Theme and branding settings
/// - Kong Gateway integration settings
class AppConfig {
  static const String _environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );

  /// Current environment (development, staging, production)
  static String get environment => _environment;

  /// Whether the app is running in development mode
  static bool get isDevelopment => _environment == 'development';

  /// Whether the app is running in staging mode
  static bool get isStaging => _environment == 'staging';

  /// Whether the app is running in production mode
  static bool get isProduction => _environment == 'production';

  // API Configuration
  static const String _medusaApiUrl = String.fromEnvironment(
    'MEDUSA_API_URL',
    defaultValue: 'https://medusa-public-api.herokuapp.com',
  );

  static const String _kongGatewayUrl = String.fromEnvironment(
    'KONG_GATEWAY_URL',
    defaultValue: 'http://localhost:8000',
  );

  /// Medusa Commerce API base URL
  static String get medusaApiUrl => _medusaApiUrl;

  /// Kong Gateway URL for API management
  static String get kongGatewayUrl => _kongGatewayUrl;

  /// Whether to use Kong Gateway for API calls
  static bool get useKongGateway =>
      const bool.fromEnvironment('USE_KONG_GATEWAY', defaultValue: false);

  /// Whether to use mock data instead of real API
  static bool get useMockData => const bool.fromEnvironment(
    'USE_MOCK_DATA',
    defaultValue: true, // Default to mock data for development
  );

  // App Information
  static const String appName = 'OneMart';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  // Feature Flags
  static bool get enableAnalytics =>
      const bool.fromEnvironment(
        'ENABLE_ANALYTICS',
        defaultValue: false, // Will be overridden based on environment
      ) ||
      !isDevelopment;

  static bool get enableCrashReporting =>
      const bool.fromEnvironment(
        'ENABLE_CRASH_REPORTING',
        defaultValue: false, // Will be overridden based on environment
      ) ||
      isProduction;

  static bool get enablePerformanceMonitoring =>
      const bool.fromEnvironment(
        'ENABLE_PERFORMANCE_MONITORING',
        defaultValue: false, // Will be overridden based on environment
      ) ||
      isProduction;

  static bool get enableDebugMode =>
      const bool.fromEnvironment(
        'ENABLE_DEBUG_MODE',
        defaultValue: true, // Will be overridden based on environment
      ) &&
      isDevelopment;

  // Cache Configuration
  static const Duration apiCacheExpiry = Duration(minutes: 5);
  static const Duration imageCacheExpiry = Duration(hours: 24);
  static const int maxCacheSize = 100; // MB

  // Network Configuration
  static const Duration networkTimeout = Duration(seconds: 30);
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  // UI Configuration
  static const int productsPerPage = 20;
  static const int categoriesPerPage = 50;
  static const int searchResultsPerPage = 20;

  // Theme Configuration
  static const String defaultTheme = 'purple_white';
  static const bool enableDynamicTheming = true;
  static const bool enableDarkMode = true;

  // Security Configuration
  static const bool enableSSLPinning = true;
  static const bool enableCertificateValidation = true;
  static const Duration sessionTimeout = Duration(hours: 24);

  // Logging Configuration
  static bool get enableVerboseLogging =>
      const bool.fromEnvironment(
        'ENABLE_VERBOSE_LOGGING',
        defaultValue: true,
      ) &&
      isDevelopment;

  static bool get enableNetworkLogging =>
      const bool.fromEnvironment(
        'ENABLE_NETWORK_LOGGING',
        defaultValue: true,
      ) &&
      isDevelopment;

  // Storage Configuration
  static const String localStoragePrefix = 'onemart_';
  static const String userPreferencesKey = '${localStoragePrefix}user_prefs';
  static const String cartStorageKey = '${localStoragePrefix}cart';
  static const String favoritesStorageKey = '${localStoragePrefix}favorites';

  // Kong Gateway Configuration
  static const Map<String, String> kongRoutes = {
    'products': '/api/products',
    'categories': '/api/categories',
    'cart': '/api/cart',
    'search': '/api/search',
    'auth': '/api/auth',
  };

  static const Map<String, String> kongHeaders = {
    'X-API-Version': '1.0',
    'X-Client-Type': 'mobile',
    'X-Client-Version': appVersion,
  };

  // Error Messages
  static const Map<String, String> errorMessages = {
    'network_error':
        'Network connection error. Please check your internet connection.',
    'server_error': 'Server error. Please try again later.',
    'timeout_error': 'Request timeout. Please try again.',
    'unknown_error': 'An unexpected error occurred. Please try again.',
    'validation_error': 'Invalid input. Please check your data.',
    'auth_error': 'Authentication failed. Please log in again.',
    'permission_error': 'You don\'t have permission to perform this action.',
  };

  // Success Messages
  static const Map<String, String> successMessages = {
    'item_added_to_cart': 'Item added to cart successfully!',
    'item_removed_from_cart': 'Item removed from cart.',
    'cart_updated': 'Cart updated successfully.',
    'favorite_added': 'Added to favorites!',
    'favorite_removed': 'Removed from favorites.',
    'order_placed': 'Order placed successfully!',
  };

  // Validation Rules
  static const int minSearchQueryLength = 2;
  static const int maxSearchQueryLength = 100;
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;

  // Image Configuration
  static const List<String> supportedImageFormats = [
    'jpg',
    'jpeg',
    'png',
    'webp',
  ];
  static const int maxImageSizeBytes = 5 * 1024 * 1024; // 5MB
  static const Map<String, String> imagePlaceholders = {
    'product': 'https://via.placeholder.com/300x300/E0E0E0/757575?text=Product',
    'category':
        'https://via.placeholder.com/300x200/E0E0E0/757575?text=Category',
    'banner': 'https://via.placeholder.com/800x400/E0E0E0/757575?text=Banner',
    'avatar': 'https://via.placeholder.com/100x100/E0E0E0/757575?text=User',
  };

  // Analytics Configuration
  static const String analyticsTrackingId = String.fromEnvironment(
    'ANALYTICS_TRACKING_ID',
    defaultValue: '',
  );

  static const bool enableUserTracking = bool.fromEnvironment(
    'ENABLE_USER_TRACKING',
    defaultValue: false,
  );

  // Development Tools
  static bool get showPerformanceOverlay => const bool.fromEnvironment(
    'SHOW_PERFORMANCE_OVERLAY',
    defaultValue: false,
  );

  static bool get showDebugBanner =>
      const bool.fromEnvironment('SHOW_DEBUG_BANNER', defaultValue: true) &&
      isDevelopment;

  /// Gets the appropriate API base URL based on configuration
  static String get apiBaseUrl {
    if (useMockData) {
      return 'mock://localhost'; // Special URL for mock data
    }

    if (useKongGateway) {
      return kongGatewayUrl;
    }

    return medusaApiUrl;
  }

  /// Gets environment-specific configuration as a map
  static Map<String, dynamic> toMap() {
    return {
      'environment': environment,
      'appName': appName,
      'appVersion': appVersion,
      'apiBaseUrl': apiBaseUrl,
      'useMockData': useMockData,
      'useKongGateway': useKongGateway,
      'enableAnalytics': enableAnalytics,
      'enableDebugMode': enableDebugMode,
      'isDevelopment': isDevelopment,
      'isProduction': isProduction,
    };
  }

  /// Validates the current configuration
  static bool validateConfig() {
    // Check required configuration
    if (appName.isEmpty) return false;
    if (appVersion.isEmpty) return false;
    if (!useMockData && medusaApiUrl.isEmpty) return false;

    // Validate URLs
    if (useKongGateway && !_isValidUrl(kongGatewayUrl)) return false;
    if (!useMockData && !_isValidUrl(medusaApiUrl)) return false;

    return true;
  }

  static bool _isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && uri.hasAuthority;
    } catch (e) {
      return false;
    }
  }
}
