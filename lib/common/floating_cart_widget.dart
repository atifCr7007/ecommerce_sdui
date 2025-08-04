import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';

class FloatingCartWidget extends StatelessWidget {
  const FloatingCartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    
    return Obx(() {
      final cart = cartController.cart.value;
      final currentRoute = Get.currentRoute;
      
      // Hide widget on cart and order confirmation screens
      if (currentRoute == '/cart' || 
          currentRoute == '/order-confirmation' ||
          cart == null || 
          cart.items.isEmpty) {
        return const SizedBox.shrink();
      }

      return Positioned(
        bottom: 20,
        left: 16,
        right: 16,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with shop name and item count
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.shopping_bag,
                        color: Colors.orange,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getShopName(cartController),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            '${cartController.totalQuantity} ${cartController.totalQuantity == 1 ? 'item' : 'items'} • ${cart.formattedTotal}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Cart items list
                _buildCartItemsList(cart, cartController),
                const SizedBox(height: 16),
                // Action buttons
                Row(
                  children: [
                    // View Full Menu button
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _viewFullMenu(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.orange,
                          side: const BorderSide(color: Colors.orange),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'View Full Menu',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Checkout button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _proceedToCheckout(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Checkout',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  String _getShopName(CartController cartController) {
    // Use the shop name from cart controller if available
    final shopName = cartController.currentShopName.value;
    if (shopName != null && shopName.isNotEmpty) {
      return shopName;
    }

    // Fallback to generic name
    final cart = cartController.cart.value;
    if (cart != null && cart.items.isNotEmpty) {
      return 'Current Shop';
    }
    return 'Shop';
  }

  void _viewFullMenu() {
    final cartController = Get.find<CartController>();
    final shopId = cartController.currentShopId.value;
    final shopName = cartController.currentShopName.value;

    if (shopId != null && shopName != null) {
      // Navigate to the specific shop's home page with shop context
      Get.toNamed('/home', parameters: {
        'shopId': shopId,
        'shopName': shopName,
      });
    } else {
      // Fallback to marketplace if no shop context is available
      Get.toNamed('/marketplace');
    }
  }

  void _proceedToCheckout() {
    Get.toNamed('/cart');
  }

  Widget _buildCartItemsList(dynamic cart, CartController cartController) {
    if (cart.items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      constraints: const BoxConstraints(maxHeight: 200),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: cart.items.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = cart.items[index];
          return _buildCartItem(item, cartController);
        },
      ),
    );
  }

  Widget _buildCartItem(dynamic item, CartController cartController) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // Item image
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.grey[200],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                item.thumbnail ?? 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=400&h=400&fit=crop&crop=center',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.fastfood, color: Colors.grey),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Item details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title ?? 'Unknown Item',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${item.formattedPrice} × ${item.quantity}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          // Delete button
          IconButton(
            onPressed: () => _removeItemFromCart(item, cartController),
            icon: const Icon(
              Icons.remove_circle_outline,
              color: Colors.red,
              size: 20,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),
          ),
        ],
      ),
    );
  }

  void _removeItemFromCart(dynamic item, CartController cartController) {
    cartController.removeItem(item.id);
  }


}
