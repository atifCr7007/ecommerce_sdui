import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/product_detail_controller.dart';
import '../models/ui_models.dart';

import '../parsers/json_parser.dart';
import '../utils/theme_manager.dart';

class ProductDetailView extends StatefulWidget {
  final String productId;

  const ProductDetailView({super.key, required this.productId});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  UIScreen? _productDetailScreen;
  Map<String, dynamic>? _productDetailScreenData;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProductDetailScreen();
  }

  Future<void> _loadProductDetailScreen() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Load the product detail screen JSON
      final String jsonString = await rootBundle.loadString(
        'assets/json_ui/product_detail.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      setState(() {
        _productDetailScreen = UIScreen.fromJson(jsonData);
        _productDetailScreenData = jsonData;
        _isLoading = false;
      });

      // Initialize the product detail controller
      if (mounted) {
        final controller = Get.find<ProductDetailController>();
        await controller.loadProduct(widget.productId);
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to load product details: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Product Details'), centerTitle: true),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Product Details'), centerTitle: true),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text(
                'Failed to Load Product',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadProductDetailScreen,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_productDetailScreen == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Product Details'), centerTitle: true),
        body: const Center(child: Text('No content available')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              final controller = Get.find<ProductDetailController>();
              controller.shareProduct();
            },
          ),
        ],
      ),
      body: Obx(() {
        final controller = Get.find<ProductDetailController>();

        if (controller.isLoading.value && controller.product.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.value != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cloud_off, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Connection Error',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    controller.error.value!,
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => controller.loadProduct(widget.productId),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return _buildProductDetailContent(controller);
      }),
    );
  }

  Widget _buildProductDetailContent(ProductDetailController controller) {
    // Create a custom parser that can handle product-specific data
    return ProductDetailJsonParser.parseScreenWithScaffold(
      _productDetailScreen!,
      context,
      controller,
      _productDetailScreenData,
    );
  }
}

// Custom parser for product detail screen that can inject product data
class ProductDetailJsonParser {
  static Widget parseScreen(
    UIScreen screen,
    BuildContext context,
    ProductDetailController controller,
  ) {
    // Handle the root component properly - it should be a scrollview
    if (screen.components.isNotEmpty) {
      return _parseComponent(screen.components.first, context, controller);
    }

    return const Center(child: Text('No content available'));
  }

  static Widget parseScreenWithScaffold(
    UIScreen screen,
    BuildContext context,
    ProductDetailController controller,
    Map<String, dynamic>? screenData,
  ) {
    Widget body = SafeArea(child: parseScreen(screen, context, controller));

    // Check if screen data has floating action button
    FloatingActionButton? fab;
    if (screenData != null && screenData.containsKey('floatingActionButton')) {
      fab = _buildFloatingActionButton(
        screenData['floatingActionButton'],
        context,
      );
    }

    return Scaffold(body: body, floatingActionButton: fab);
  }

  static Widget _parseComponent(
    UIComponent component,
    BuildContext context,
    ProductDetailController controller,
  ) {
    // Handle special product detail components by ID first
    switch (component.id) {
      case 'product_images':
        return _buildProductImages(component, context, controller);
      case 'product_title':
        return _buildProductTitle(component, context, controller);
      case 'product_price':
        return _buildProductPrice(component, context, controller);
      case 'product_rating':
        return _buildProductRating(component, context, controller);
      case 'product_description':
        return _buildProductDescription(component, context, controller);
      case 'quantity_display':
        return _buildQuantityDisplay(component, context, controller);
      case 'add_to_cart':
        return _buildAddToCartButton(component, context, controller);
      case 'related_products':
        return _buildRelatedProducts(component, context, controller);
      case 'decrease_quantity':
        return _buildQuantityButton(component, context, controller, false);
      case 'increase_quantity':
        return _buildQuantityButton(component, context, controller, true);
      case 'favorite_button':
        return _buildFavoriteButton(component, context, controller);
      default:
        // For components with children, parse them recursively
        if (component.children != null && component.children!.isNotEmpty) {
          final parsedChildren = component.children!.map((child) {
            return _parseComponent(child, context, controller);
          }).toList();

          // Use standard parser but handle children properly
          return _buildComponentWithChildren(
            component,
            parsedChildren,
            context,
          );
        }

        // Use the standard JSON UI parser for leaf components
        return JsonUIParser.parseComponent(component, context);
    }
  }

  static Widget _buildProductImages(
    UIComponent component,
    BuildContext context,
    ProductDetailController controller,
  ) {
    final product = controller.product.value;
    if (product == null) {
      return Container(
        height: 300,
        color: Colors.grey[300],
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    final images =
        product.images?.map((img) => img.url).toList() ??
        [
          product.thumbnail ??
              'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400&h=400&fit=crop',
        ];

    // Update the component properties with actual product images
    final updatedComponent = UIComponent(
      type: component.type,
      id: component.id,
      properties: {...component.properties, 'images': images},
      children: component.children,
      action: component.action,
      style: component.style,
    );

    return JsonUIParser.parseComponent(updatedComponent, context);
  }

  static Widget _buildProductTitle(
    UIComponent component,
    BuildContext context,
    ProductDetailController controller,
  ) {
    final product = controller.product;
    final title = product.value?.title ?? 'Loading...';

    return Text(
      title,
      style: TextStyle(
        fontSize: (component.properties['fontSize'] as num?)?.toDouble() ?? 24,
        fontWeight: FontWeight.bold,
        color: ThemeManager.getColor('onSurface'),
      ),
    );
  }

  static Widget _buildProductPrice(
    UIComponent component,
    BuildContext context,
    ProductDetailController controller,
  ) {
    final product = controller.product;
    final price = product.value?.displayPrice ?? '\$0.00';

    return Text(
      price,
      style: TextStyle(
        fontSize: (component.properties['fontSize'] as num?)?.toDouble() ?? 20,
        fontWeight: FontWeight.bold,
        color: ThemeManager.getColor('success'),
      ),
    );
  }

  static Widget _buildProductRating(
    UIComponent component,
    BuildContext context,
    ProductDetailController controller,
  ) {
    final product = controller.product;
    final rating = product.value?.rating.toStringAsFixed(1) ?? '0.0';

    return Text(
      rating,
      style: TextStyle(
        fontSize: (component.properties['fontSize'] as num?)?.toDouble() ?? 14,
        color: Colors.grey[600],
      ),
    );
  }

  static Widget _buildProductDescription(
    UIComponent component,
    BuildContext context,
    ProductDetailController controller,
  ) {
    final product = controller.product;
    final description =
        product.value?.description ?? 'No description available.';

    return Text(
      description,
      style: TextStyle(
        fontSize: (component.properties['fontSize'] as num?)?.toDouble() ?? 14,
        color: Colors.grey[600],
      ),
    );
  }

  static Widget _buildQuantityDisplay(
    UIComponent component,
    BuildContext context,
    ProductDetailController controller,
  ) {
    return Text(
      controller.quantity.toString(),
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  static Widget _buildAddToCartButton(
    UIComponent component,
    BuildContext context,
    ProductDetailController controller,
  ) {
    return Obx(
      () => AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: (component.properties['height'] as num?)?.toDouble() ?? 48,
        child: ElevatedButton(
          onPressed:
              controller.product.value != null &&
                  !controller.isAddingToCart.value
              ? () async {
                  // Add haptic feedback
                  HapticFeedback.lightImpact();

                  // Call add to cart with proper error handling
                  await controller.addToCart();
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: controller.isAddingToCart.value
                ? Colors.grey[400]
                : _parseColor(component.properties['backgroundColor']),
            foregroundColor: _parseColor(component.properties['textColor']),
            elevation: controller.isAddingToCart.value ? 0 : 2,
            shadowColor: controller.isAddingToCart.value
                ? Colors.transparent
                : null,
          ),
          child: controller.isAddingToCart.value
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(component.properties['text']?.toString() ?? 'Add to Cart'),
        ),
      ),
    );
  }

  static Widget _buildRelatedProducts(
    UIComponent component,
    BuildContext context,
    ProductDetailController controller,
  ) {
    // Use the standard product list component
    return JsonUIParser.parseComponent(component, context);
  }

  static Widget _buildQuantityButton(
    UIComponent component,
    BuildContext context,
    ProductDetailController controller,
    bool isIncrease,
  ) {
    return SizedBox(
      width: (component.properties['width'] as num?)?.toDouble() ?? 40,
      height: (component.properties['height'] as num?)?.toDouble() ?? 40,
      child: ElevatedButton(
        onPressed: () {
          if (isIncrease) {
            controller.increaseQuantity();
          } else {
            controller.decreaseQuantity();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _parseColor(component.properties['backgroundColor']),
          foregroundColor: _parseColor(component.properties['textColor']),
          padding: EdgeInsets.zero,
        ),
        child: Text(component.properties['text']?.toString() ?? ''),
      ),
    );
  }

  static Widget _buildFavoriteButton(
    UIComponent component,
    BuildContext context,
    ProductDetailController controller,
  ) {
    return Obx(
      () => SizedBox(
        width: (component.properties['width'] as num?)?.toDouble() ?? 48,
        height: (component.properties['height'] as num?)?.toDouble() ?? 48,
        child: OutlinedButton(
          onPressed: () => controller.toggleFavorite(),
          style: OutlinedButton.styleFrom(
            backgroundColor: _parseColor(
              component.properties['backgroundColor'],
            ),
            foregroundColor: controller.isFavorite.value
                ? Colors.red
                : _parseColor(component.properties['textColor']),
            side: BorderSide(
              color: controller.isFavorite.value
                  ? Colors.red
                  : _parseColor(component.properties['borderColor']) ??
                        Colors.grey,
              width:
                  (component.properties['borderWidth'] as num?)?.toDouble() ??
                  1,
            ),
            padding: EdgeInsets.zero,
          ),
          child: Icon(
            controller.isFavorite.value
                ? Icons.favorite
                : Icons.favorite_border,
            size: 20,
          ),
        ),
      ),
    );
  }

  static Widget _buildComponentWithChildren(
    UIComponent component,
    List<Widget> children,
    BuildContext context,
  ) {
    switch (component.type.toLowerCase()) {
      case 'scrollview':
        return SingleChildScrollView(child: Column(children: children));
      case 'column':
        return Column(children: children);
      case 'row':
        return Row(children: children);
      case 'container':
        return Container(
          height: (component.properties['height'] as num?)?.toDouble(),
          width: (component.properties['width'] as num?)?.toDouble(),
          color: _parseColor(component.properties['backgroundColor']),
          child: children.isNotEmpty ? children.first : null,
        );
      case 'padding':
        final padding =
            component.properties['padding'] as Map<String, dynamic>?;
        return Padding(
          padding: _parsePadding(padding),
          child: children.isNotEmpty ? children.first : null,
        );
      case 'expanded':
        return Expanded(
          child: children.isNotEmpty ? children.first : const SizedBox(),
        );
      default:
        return Column(children: children);
    }
  }

  static Color? _parseColor(dynamic colorValue) {
    if (colorValue == null) return null;
    if (colorValue is String) {
      if (colorValue.startsWith('#')) {
        return Color(
          int.parse(colorValue.substring(1), radix: 16) + 0xFF000000,
        );
      }
    }
    return null;
  }

  static EdgeInsets _parsePadding(Map<String, dynamic>? padding) {
    if (padding == null) return EdgeInsets.zero;

    if (padding.containsKey('all')) {
      return EdgeInsets.all((padding['all'] as num).toDouble());
    }

    return EdgeInsets.only(
      top: (padding['top'] as num?)?.toDouble() ?? 0,
      bottom: (padding['bottom'] as num?)?.toDouble() ?? 0,
      left: (padding['left'] as num?)?.toDouble() ?? 0,
      right: (padding['right'] as num?)?.toDouble() ?? 0,
    );
  }

  static FloatingActionButton _buildFloatingActionButton(
    Map<String, dynamic> fabData,
    BuildContext context,
  ) {
    final properties = fabData['properties'] as Map<String, dynamic>? ?? {};
    final iconName = properties['icon'] as String? ?? 'add';
    final backgroundColor =
        properties['backgroundColor'] as String? ?? '#2196F3';
    final foregroundColor =
        properties['foregroundColor'] as String? ?? '#FFFFFF';
    final tooltip = properties['tooltip'] as String? ?? '';
    final onPressed = properties['onPressed'] as Map<String, dynamic>?;

    // Parse colors
    final bgColor = Color(int.parse(backgroundColor.replaceFirst('#', '0xFF')));
    final fgColor = Color(int.parse(foregroundColor.replaceFirst('#', '0xFF')));

    // Parse icon
    IconData icon = Icons.add;
    switch (iconName.toLowerCase()) {
      case 'shopping_cart':
        icon = Icons.shopping_cart;
        break;
      case 'add':
        icon = Icons.add;
        break;
      case 'favorite':
        icon = Icons.favorite;
        break;
      case 'share':
        icon = Icons.share;
        break;
      default:
        icon = Icons.add;
    }

    return FloatingActionButton(
      onPressed: () => _handleFabAction(onPressed, context),
      backgroundColor: bgColor,
      foregroundColor: fgColor,
      tooltip: tooltip.isNotEmpty ? tooltip : null,
      child: Icon(icon),
    );
  }

  static void _handleFabAction(
    Map<String, dynamic>? action,
    BuildContext context,
  ) {
    if (action == null) return;

    final actionType = action['action'] as String?;
    switch (actionType?.toLowerCase()) {
      case 'navigate':
        final route = action['route'] as String?;
        if (route != null) {
          _navigateToRoute(route, context);
        }
        break;
      default:
        break;
    }
  }

  static void _navigateToRoute(String route, BuildContext context) {
    switch (route.toLowerCase()) {
      case '/cart':
        // Navigate directly to cart page
        Get.toNamed('/cart');
        break;
      default:
        Navigator.of(context).pushNamed(route);
        break;
    }
  }
}
