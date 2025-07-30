import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../models/product.dart';
import 'api_service.dart';

/// Service class for handling cart-related API operations.
///
/// This service provides methods for:
/// - Adding items to cart
/// - Removing items from cart
/// - Updating item quantities
/// - Getting cart contents
/// - Calculating totals
///
/// All methods return Future objects and handle errors appropriately.
class CartService {
  final ApiService _apiService;

  CartService({ApiService? apiService})
    : _apiService = apiService ?? ApiService();

  /// Adds a product to the cart
  ///
  /// Parameters:
  /// - [productId]: The ID of the product to add
  /// - [variantId]: The specific variant of the product
  /// - [quantity]: Number of items to add (default: 1)
  /// - [cartId]: Optional cart ID (if null, creates new cart)
  Future<CartResponse> addToCart(
    String productId,
    String variantId, {
    int quantity = 1,
    String? cartId,
  }) async {
    try {
      if (productId.isEmpty || variantId.isEmpty) {
        throw CartServiceException('Product ID and variant ID cannot be empty');
      }

      if (quantity <= 0) {
        throw CartServiceException('Quantity must be greater than 0');
      }

      final body = {'variant_id': variantId, 'quantity': quantity};

      final endpoint = cartId != null
          ? '/store/carts/$cartId/line-items'
          : '/store/carts';

      final response = await _apiService.post(endpoint, body: body);

      return CartResponse.fromJson(response);
    } catch (e) {
      debugPrint('Error adding to cart: $e');
      throw CartServiceException('Failed to add item to cart: $e');
    }
  }

  /// Updates the quantity of an item in the cart
  ///
  /// Parameters:
  /// - [cartId]: The cart ID
  /// - [lineItemId]: The line item ID to update
  /// - [quantity]: New quantity (0 to remove item)
  Future<CartResponse> updateCartItem(
    String cartId,
    String lineItemId,
    int quantity,
  ) async {
    try {
      if (cartId.isEmpty || lineItemId.isEmpty) {
        throw CartServiceException('Cart ID and line item ID cannot be empty');
      }

      if (quantity < 0) {
        throw CartServiceException('Quantity cannot be negative');
      }

      if (quantity == 0) {
        return await removeFromCart(cartId, lineItemId);
      }

      final body = {'quantity': quantity};

      final response = await _apiService.put(
        '/store/carts/$cartId/line-items/$lineItemId',
        body: body,
      );

      return CartResponse.fromJson(response);
    } catch (e) {
      debugPrint('Error updating cart item: $e');
      throw CartServiceException('Failed to update cart item: $e');
    }
  }

  /// Removes an item from the cart
  ///
  /// Parameters:
  /// - [cartId]: The cart ID
  /// - [lineItemId]: The line item ID to remove
  Future<CartResponse> removeFromCart(String cartId, String lineItemId) async {
    try {
      if (cartId.isEmpty || lineItemId.isEmpty) {
        throw CartServiceException('Cart ID and line item ID cannot be empty');
      }

      final response = await _apiService.delete(
        '/store/carts/$cartId/line-items/$lineItemId',
      );

      return CartResponse.fromJson(response);
    } catch (e) {
      debugPrint('Error removing from cart: $e');
      throw CartServiceException('Failed to remove item from cart: $e');
    }
  }

  /// Gets the current cart contents
  ///
  /// Parameters:
  /// - [cartId]: The cart ID
  /// - [useCache]: Whether to use cached results (default: false)
  Future<CartResponse> getCart(String cartId, {bool useCache = false}) async {
    try {
      if (cartId.isEmpty) {
        throw CartServiceException('Cart ID cannot be empty');
      }

      final response = await _apiService.get(
        '/store/carts/$cartId',
        useCache: useCache,
      );

      return CartResponse.fromJson(response);
    } catch (e) {
      debugPrint('Error getting cart: $e');
      throw CartServiceException('Failed to get cart: $e');
    }
  }

  /// Creates a new cart
  ///
  /// Parameters:
  /// - [region]: Optional region for the cart
  Future<CartResponse> createCart({String? region}) async {
    try {
      final body = <String, dynamic>{};

      if (region != null && region.isNotEmpty) {
        body['region_id'] = region;
      }

      final response = await _apiService.post('/store/carts', body: body);

      return CartResponse.fromJson(response);
    } catch (e) {
      debugPrint('Error creating cart: $e');
      throw CartServiceException('Failed to create cart: $e');
    }
  }

  /// Clears all items from the cart
  ///
  /// Parameters:
  /// - [cartId]: The cart ID
  Future<CartResponse> clearCart(String cartId) async {
    try {
      if (cartId.isEmpty) {
        throw CartServiceException('Cart ID cannot be empty');
      }

      // Get current cart to get all line items
      final cart = await getCart(cartId);

      // Remove each item
      for (final item in cart.cart.items) {
        await removeFromCart(cartId, item.id);
      }

      // Return updated cart
      return await getCart(cartId);
    } catch (e) {
      debugPrint('Error clearing cart: $e');
      throw CartServiceException('Failed to clear cart: $e');
    }
  }

  /// Disposes the service and cleans up resources
  void dispose() {
    _apiService.dispose();
  }
}

/// Response model for cart API calls
class CartResponse {
  final Cart cart;

  CartResponse({required this.cart});

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    return CartResponse(cart: Cart.fromJson(json['cart'] ?? json));
  }

  Map<String, dynamic> toJson() {
    return {'cart': cart.toJson()};
  }
}

/// Model representing a shopping cart
class Cart {
  final String id;
  final List<CartItem> items;
  final int subtotal;
  final int total;
  final String currencyCode;
  final DateTime createdAt;
  final DateTime updatedAt;

  Cart({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.total,
    required this.currencyCode,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List<dynamic>? ?? [];

    return Cart(
      id: json['id'] as String,
      items: itemsList.map((item) => CartItem.fromJson(item)).toList(),
      subtotal: json['subtotal'] as int? ?? 0,
      total: json['total'] as int? ?? 0,
      currencyCode: json['currency_code'] as String? ?? 'INR',
      createdAt: DateTime.parse(
        json['created_at'] as String? ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] as String? ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'total': total,
      'currency_code': currencyCode,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Gets the total number of items in the cart
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  /// Gets the formatted total price
  String get formattedTotal => _formatCurrency(total / 100);

  /// Gets the formatted subtotal price
  String get formattedSubtotal => _formatCurrency(subtotal / 100);

  /// Gets the total amount as double
  double get totalAmount => total / 100;

  /// Gets the subtotal amount as double
  double get subtotalAmount => subtotal / 100;

  /// Format currency in INR
  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }
}

/// Model representing an item in the cart
class CartItem {
  final String id;
  final String variantId;
  final String title;
  final String? description;
  final String? thumbnail;
  final int quantity;
  final int unitPrice;
  final int total;

  CartItem({
    required this.id,
    required this.variantId,
    required this.title,
    this.description,
    this.thumbnail,
    required this.quantity,
    required this.unitPrice,
    required this.total,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] as String,
      variantId: json['variant_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      thumbnail: json['thumbnail'] as String?,
      quantity: json['quantity'] as int,
      unitPrice: json['unit_price'] as int? ?? 0,
      total: json['total'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'variant_id': variantId,
      'title': title,
      'description': description,
      'thumbnail': thumbnail,
      'quantity': quantity,
      'unit_price': unitPrice,
      'total': total,
    };
  }

  /// Gets the formatted unit price
  String get formattedUnitPrice => _formatCurrency(unitPrice / 100);

  /// Gets the formatted total price
  String get formattedTotal => _formatCurrency(total / 100);

  /// Format currency in INR
  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }
}

/// Custom exception class for cart service errors
class CartServiceException implements Exception {
  final String message;

  const CartServiceException(this.message);

  @override
  String toString() => 'CartServiceException: $message';
}
