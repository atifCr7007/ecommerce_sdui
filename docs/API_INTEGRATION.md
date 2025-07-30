# API Integration Guide

This document provides comprehensive information about integrating OneMart with backend APIs, specifically Medusa Commerce and Kong Gateway.

## 🏗️ Architecture Overview

```
Mobile App (Flutter)
       ↓
Kong Gateway (API Management)
       ↓
Medusa Commerce (Backend)
       ↓
PostgreSQL (Database)
```

## 🔧 Service Layer

### ApiService (Base Service)
The foundation service that handles all HTTP communications.

**Features:**
- Automatic retry logic with exponential backoff
- Response caching with configurable TTL
- Error handling and logging
- Environment-based URL configuration
- Request/response interceptors

**Configuration:**
```dart
final apiService = ApiService(
  useKongGateway: AppConfig.useKongGateway,
);
```

### ProductService
Handles all product-related API operations.

**Methods:**
- `fetchProducts()` - Get paginated product list
- `fetchProductById()` - Get single product details
- `searchProducts()` - Search products by query
- `fetchRelatedProducts()` - Get related products
- `fetchFeaturedProducts()` - Get featured products

**Example Usage:**
```dart
final productService = ProductService();
final response = await productService.fetchProducts(
  limit: 20,
  categoryId: 'electronics',
  sortBy: 'price',
  sortOrder: 'asc',
);
```

### CategoryService
Manages product categories and hierarchy.

**Methods:**
- `fetchCategories()` - Get all categories
- `fetchCategoryById()` - Get single category
- `fetchRootCategories()` - Get top-level categories
- `fetchChildCategories()` - Get subcategories
- `searchCategories()` - Search categories
- `getCategoryPath()` - Get category breadcrumb

### CartService
Handles shopping cart operations.

**Methods:**
- `createCart()` - Create new cart
- `getCart()` - Get cart contents
- `addToCart()` - Add item to cart
- `updateCartItem()` - Update item quantity
- `removeFromCart()` - Remove item from cart
- `clearCart()` - Empty cart

## 🌐 Medusa Commerce Integration

### Base URL Configuration
```dart
// Development
static const String medusaApiUrl = 'https://medusa-public-api.herokuapp.com';

// Production
static const String medusaApiUrl = 'https://your-medusa-api.com';
```

### Authentication
Medusa supports multiple authentication methods:

#### Customer Authentication
```dart
// Login
POST /store/auth
{
  "email": "customer@example.com",
  "password": "password123"
}

// Response
{
  "customer": { ... },
  "access_token": "jwt_token_here"
}
```

#### Admin Authentication
```dart
// Login
POST /admin/auth
{
  "email": "admin@example.com",
  "password": "admin_password"
}
```

### API Endpoints

#### Products
```dart
// Get products
GET /store/products?limit=20&offset=0&category_id[]=cat_123

// Get single product
GET /store/products/{product_id}

// Search products
GET /store/products?q=search_term
```

#### Categories
```dart
// Get categories
GET /store/product-categories

// Get category with descendants
GET /store/product-categories/{category_id}?include_descendants_tree=true
```

#### Cart Operations
```dart
// Create cart
POST /store/carts
{
  "region_id": "reg_123"
}

// Add item to cart
POST /store/carts/{cart_id}/line-items
{
  "variant_id": "variant_123",
  "quantity": 2
}

// Update cart item
POST /store/carts/{cart_id}/line-items/{line_item_id}
{
  "quantity": 3
}
```

### Response Formats

#### Product Response
```json
{
  "product": {
    "id": "prod_123",
    "title": "Product Name",
    "description": "Product description",
    "thumbnail": "https://example.com/image.jpg",
    "images": [
      {
        "id": "img_123",
        "url": "https://example.com/image.jpg"
      }
    ],
    "variants": [
      {
        "id": "variant_123",
        "title": "Default Variant",
        "prices": [
          {
            "id": "price_123",
            "currency_code": "USD",
            "amount": 2999
          }
        ]
      }
    ],
    "categories": [
      {
        "id": "cat_123",
        "name": "Electronics"
      }
    ]
  }
}
```

#### Category Response
```json
{
  "product_categories": [
    {
      "id": "cat_123",
      "name": "Electronics",
      "description": "Electronic devices and gadgets",
      "handle": "electronics",
      "is_active": true,
      "parent_category_id": null,
      "category_children": [
        {
          "id": "cat_456",
          "name": "Smartphones",
          "parent_category_id": "cat_123"
        }
      ]
    }
  ]
}
```

## 🚪 Kong Gateway Integration

### Configuration
Kong Gateway provides API management, security, and monitoring.

**Features:**
- Rate limiting
- Authentication
- Load balancing
- Request/response transformation
- Analytics and monitoring

### Route Configuration
```yaml
# kong_routes.yaml
services:
  - name: medusa-service
    url: http://medusa-backend:9000

routes:
  - name: products-list
    service: medusa-service
    paths: ["/api/products"]
    methods: ["GET"]
    
  - name: cart-operations
    service: medusa-service
    paths: ["/api/cart"]
    methods: ["GET", "POST", "PUT", "DELETE"]
```

### Plugins
```yaml
plugins:
  - name: rate-limiting
    config:
      minute: 100
      hour: 1000
      
  - name: cors
    config:
      origins: ["*"]
      methods: ["GET", "POST", "PUT", "DELETE"]
```

### Headers
Kong adds custom headers for tracking:
```dart
{
  'X-API-Version': '1.0',
  'X-Client-Type': 'mobile',
  'X-Client-Version': AppConfig.appVersion,
}
```

## 🔄 Mock Data System

### Development Mode
When `AppConfig.useMockData = true`, the app uses local mock data instead of API calls.

**Benefits:**
- Faster development
- No network dependency
- Consistent test data
- Offline development

### MockDataService
```dart
class MockDataService {
  Future<List<Product>> getProducts({
    int? limit,
    String? categoryId,
    String? searchQuery,
  }) async {
    // Return mock products
  }
  
  Future<List<ProductCategory>> getCategories() async {
    // Return mock categories
  }
}
```

### Switching Between Mock and Real Data
```dart
// In AppConfig
static bool get useMockData => const bool.fromEnvironment(
  'USE_MOCK_DATA',
  defaultValue: true, // Default to mock for development
);

// In Service
if (AppConfig.useMockData) {
  return await mockDataService.getProducts();
} else {
  return await apiService.get('/store/products');
}
```

## 🔐 Security Considerations

### API Key Management
```dart
// Store API keys securely
final secureStorage = FlutterSecureStorage();
await secureStorage.write(key: 'api_key', value: 'your_api_key');
```

### Request Signing
```dart
// Add authentication headers
final headers = {
  'Authorization': 'Bearer $accessToken',
  'X-API-Key': apiKey,
};
```

### SSL Pinning
```dart
// Enable SSL certificate pinning
static const bool enableSSLPinning = true;
```

## 📊 Error Handling

### Custom Exceptions
```dart
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  
  const ApiException(this.message, {this.statusCode});
}

class ProductServiceException implements Exception {
  final String message;
  const ProductServiceException(this.message);
}
```

### Error Response Handling
```dart
Future<T> handleApiCall<T>(Future<T> Function() apiCall) async {
  try {
    return await apiCall();
  } on SocketException {
    throw ApiException('No internet connection');
  } on TimeoutException {
    throw ApiException('Request timeout');
  } on FormatException {
    throw ApiException('Invalid response format');
  } catch (e) {
    throw ApiException('Unexpected error: $e');
  }
}
```

## 🔍 Monitoring and Analytics

### Request Logging
```dart
void logApiRequest(String method, String url, Map<String, dynamic>? body) {
  if (AppConfig.enableNetworkLogging) {
    debugPrint('API $method: $url');
    if (body != null) {
      debugPrint('Body: ${json.encode(body)}');
    }
  }
}
```

### Performance Monitoring
```dart
Future<T> measureApiCall<T>(
  String operation,
  Future<T> Function() apiCall,
) async {
  final stopwatch = Stopwatch()..start();
  
  try {
    final result = await apiCall();
    stopwatch.stop();
    
    debugPrint('$operation completed in ${stopwatch.elapsedMilliseconds}ms');
    return result;
  } catch (e) {
    stopwatch.stop();
    debugPrint('$operation failed after ${stopwatch.elapsedMilliseconds}ms: $e');
    rethrow;
  }
}
```

## 🚀 Production Deployment

### Environment Configuration
```bash
# Production environment variables
export USE_MOCK_DATA=false
export MEDUSA_API_URL=https://api.yourstore.com
export USE_KONG_GATEWAY=true
export KONG_GATEWAY_URL=https://gateway.yourstore.com
export ENABLE_SSL_PINNING=true
```

### Build Configuration
```bash
flutter build apk --release \
  --dart-define=USE_MOCK_DATA=false \
  --dart-define=MEDUSA_API_URL=https://api.yourstore.com
```

### Health Checks
```dart
Future<bool> checkApiHealth() async {
  try {
    final response = await apiService.get('/health');
    return response['status'] == 'ok';
  } catch (e) {
    return false;
  }
}
```

This integration guide provides the foundation for connecting OneMart with production APIs while maintaining flexibility for development and testing scenarios.
