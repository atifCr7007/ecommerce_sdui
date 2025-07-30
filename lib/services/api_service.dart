import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Base API service class that handles HTTP client configuration,
/// error handling, and common API operations for the ecommerce app.
/// 
/// This service provides a centralized way to manage API calls with:
/// - Automatic retry logic
/// - Response caching
/// - Error handling
/// - Environment-based URL configuration
class ApiService {
  static const String _medusaBaseUrl = 'https://medusa-public-api.herokuapp.com';
  static const String _kongGatewayUrl = 'http://localhost:8000';
  static const Duration _defaultTimeout = Duration(seconds: 30);
  static const int _maxRetries = 3;

  late final http.Client _client;
  late final String _baseUrl;
  final Map<String, dynamic> _cache = {};
  final Duration _cacheExpiry = const Duration(minutes: 5);
  final Map<String, DateTime> _cacheTimestamps = {};

  ApiService({bool useKongGateway = false}) {
    _client = http.Client();
    _baseUrl = useKongGateway ? _kongGatewayUrl : _medusaBaseUrl;
  }

  /// Get the base URL being used for API calls
  String get baseUrl => _baseUrl;

  /// Performs a GET request with automatic retry and caching
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? queryParams,
    Map<String, String>? headers,
    bool useCache = true,
    Duration? timeout,
  }) async {
    final url = _buildUrl(endpoint, queryParams);
    final cacheKey = url.toString();

    // Check cache first
    if (useCache && _isCacheValid(cacheKey)) {
      debugPrint('API Cache hit: $cacheKey');
      return _cache[cacheKey] as Map<String, dynamic>;
    }

    final requestHeaders = _buildHeaders(headers);
    
    for (int attempt = 1; attempt <= _maxRetries; attempt++) {
      try {
        debugPrint('API GET: $url (attempt $attempt)');
        
        final response = await _client
            .get(url, headers: requestHeaders)
            .timeout(timeout ?? _defaultTimeout);

        final result = await _handleResponse(response);
        
        // Cache successful responses
        if (useCache) {
          _cache[cacheKey] = result;
          _cacheTimestamps[cacheKey] = DateTime.now();
        }
        
        return result;
      } catch (e) {
        debugPrint('API GET attempt $attempt failed: $e');
        
        if (attempt == _maxRetries) {
          throw ApiException('Failed to fetch data after $_maxRetries attempts: $e');
        }
        
        // Wait before retry with exponential backoff
        await Future.delayed(Duration(seconds: attempt * 2));
      }
    }
    
    throw ApiException('Unexpected error in GET request');
  }

  /// Performs a POST request
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    final url = _buildUrl(endpoint);
    final requestHeaders = _buildHeaders(headers);
    
    for (int attempt = 1; attempt <= _maxRetries; attempt++) {
      try {
        debugPrint('API POST: $url (attempt $attempt)');
        
        final response = await _client
            .post(
              url,
              headers: requestHeaders,
              body: body != null ? json.encode(body) : null,
            )
            .timeout(timeout ?? _defaultTimeout);

        return await _handleResponse(response);
      } catch (e) {
        debugPrint('API POST attempt $attempt failed: $e');
        
        if (attempt == _maxRetries) {
          throw ApiException('Failed to post data after $_maxRetries attempts: $e');
        }
        
        await Future.delayed(Duration(seconds: attempt * 2));
      }
    }
    
    throw ApiException('Unexpected error in POST request');
  }

  /// Performs a PUT request
  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    final url = _buildUrl(endpoint);
    final requestHeaders = _buildHeaders(headers);
    
    try {
      debugPrint('API PUT: $url');
      
      final response = await _client
          .put(
            url,
            headers: requestHeaders,
            body: body != null ? json.encode(body) : null,
          )
          .timeout(timeout ?? _defaultTimeout);

      return await _handleResponse(response);
    } catch (e) {
      throw ApiException('PUT request failed: $e');
    }
  }

  /// Performs a DELETE request
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    final url = _buildUrl(endpoint);
    final requestHeaders = _buildHeaders(headers);
    
    try {
      debugPrint('API DELETE: $url');
      
      final response = await _client
          .delete(url, headers: requestHeaders)
          .timeout(timeout ?? _defaultTimeout);

      return await _handleResponse(response);
    } catch (e) {
      throw ApiException('DELETE request failed: $e');
    }
  }

  /// Clears the response cache
  void clearCache() {
    _cache.clear();
    _cacheTimestamps.clear();
    debugPrint('API cache cleared');
  }

  /// Builds the complete URL with query parameters
  Uri _buildUrl(String endpoint, [Map<String, String>? queryParams]) {
    final uri = Uri.parse('$_baseUrl$endpoint');
    
    if (queryParams != null && queryParams.isNotEmpty) {
      return uri.replace(queryParameters: queryParams);
    }
    
    return uri;
  }

  /// Builds request headers with default values
  Map<String, String> _buildHeaders(Map<String, String>? customHeaders) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (customHeaders != null) {
      headers.addAll(customHeaders);
    }
    
    return headers;
  }

  /// Handles HTTP response and converts to Map
  Future<Map<String, dynamic>> _handleResponse(http.Response response) async {
    debugPrint('API Response: ${response.statusCode} ${response.reasonPhrase}');
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        final decoded = json.decode(response.body);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        } else {
          return {'data': decoded};
        }
      } catch (e) {
        throw ApiException('Failed to parse response JSON: $e');
      }
    } else {
      String errorMessage = 'HTTP ${response.statusCode}: ${response.reasonPhrase}';
      
      try {
        final errorBody = json.decode(response.body);
        if (errorBody is Map<String, dynamic> && errorBody.containsKey('message')) {
          errorMessage = errorBody['message'] as String;
        }
      } catch (e) {
        // Use default error message if parsing fails
      }
      
      throw ApiException(errorMessage, statusCode: response.statusCode);
    }
  }

  /// Checks if cached data is still valid
  bool _isCacheValid(String cacheKey) {
    if (!_cache.containsKey(cacheKey) || !_cacheTimestamps.containsKey(cacheKey)) {
      return false;
    }
    
    final timestamp = _cacheTimestamps[cacheKey]!;
    return DateTime.now().difference(timestamp) < _cacheExpiry;
  }

  /// Disposes the HTTP client
  void dispose() {
    _client.close();
    clearCache();
  }
}

/// Custom exception class for API errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  @override
  String toString() {
    if (statusCode != null) {
      return 'ApiException($statusCode): $message';
    }
    return 'ApiException: $message';
  }
}
