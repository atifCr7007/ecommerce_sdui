import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/product_detail_controller.dart';
import '../models/ui_models.dart';
import '../models/product.dart';
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
              // Handle share
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
    return ProductDetailJsonParser.parseScreen(
      _productDetailScreen!,
      context,
      controller,
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
    return Column(
      children: screen.components.map((component) {
        return _parseComponent(component, context, controller);
      }).toList(),
    );
  }

  static Widget _parseComponent(
    UIComponent component,
    BuildContext context,
    ProductDetailController controller,
  ) {
    // Handle special product detail components
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
      default:
        // Use the standard JSON parser for other components
        return JsonUIParser.parseComponent(component, context);
    }
  }

  static Widget _buildProductImages(
    UIComponent component,
    BuildContext context,
    ProductDetailController controller,
  ) {
    final product = controller.product;
    if (product == null) {
      return Container(
        height: 300,
        color: Colors.grey[300],
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    final images =
        product.value?.images?.map((img) => img.url).toList() ??
        [product.value?.thumbnail ?? ''];

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
    return SizedBox(
      height: (component.properties['height'] as num?)?.toDouble() ?? 48,
      child: ElevatedButton(
        onPressed: controller.product.value != null
            ? () => controller.addToCart()
            : null,
        child: Text(component.properties['text']?.toString() ?? 'Add to Cart'),
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
}
