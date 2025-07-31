import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/product.dart';
import '../../controllers/home_controller.dart';

class CategoryTab {
  final String id;
  final String name;
  final String categoryId;

  CategoryTab({required this.id, required this.name, required this.categoryId});

  factory CategoryTab.fromJson(Map<String, dynamic> json) {
    return CategoryTab(
      id: json['id'] as String,
      name: json['name'] as String,
      categoryId: json['categoryId'] as String,
    );
  }
}

class CategoryTabsWidget extends StatefulWidget {
  final String title;
  final List<CategoryTab> tabs;
  final String defaultTab;
  final int productLimit;

  const CategoryTabsWidget({
    super.key,
    required this.title,
    required this.tabs,
    required this.defaultTab,
    required this.productLimit,
  });

  @override
  State<CategoryTabsWidget> createState() => _CategoryTabsWidgetState();
}

class _CategoryTabsWidgetState extends State<CategoryTabsWidget> {
  late String selectedTabId;
  late Future<List<Product>> productsFuture;

  @override
  void initState() {
    super.initState();
    debugPrint(
      '[CategoryTabsWidget] Initializing with ${widget.tabs.length} tabs',
    );
    selectedTabId = widget.defaultTab.isNotEmpty
        ? widget.defaultTab
        : widget.tabs.first.id;
    _loadProducts();
  }

  void _loadProducts() {
    final selectedTab = widget.tabs.firstWhere(
      (tab) => tab.id == selectedTabId,
      orElse: () => widget.tabs.first,
    );

    productsFuture = Get.find<HomeController>().fetchProducts(
      limit: widget.productLimit,
      categoryId: selectedTab.categoryId,
    );
  }

  void _onTabSelected(String tabId) {
    if (selectedTabId != tabId) {
      setState(() {
        selectedTabId = tabId;
        _loadProducts();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            widget.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF212121),
            ),
          ),
        ),

        // Category Tabs
        Container(
          height: 50,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: widget.tabs.length,
            itemBuilder: (context, index) {
              final tab = widget.tabs[index];
              final isSelected = tab.id == selectedTabId;

              return Container(
                margin: const EdgeInsets.only(right: 12.0),
                child: GestureDetector(
                  onTap: () => _onTabSelected(tab.id),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 12.0,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF9C27B0)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF9C27B0)
                            : Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      tab.name,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[700],
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Products List
        SizedBox(
          height: 280,
          child: FutureBuilder<List<Product>>(
            future: productsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF2196F3)),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Error loading products',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                );
              }

              final products = snapshot.data ?? [];

              if (products.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No products available',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return _buildProductCard(products[index], context);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(Product product, BuildContext context) {
    final price = product.variants?.first.prices?.first.amount ?? 0;
    final formattedPrice = '\$${(price / 100).toStringAsFixed(2)}';

    // Determine if this product should show Hot Deals tag
    final showHotDeals = _shouldShowHotDeals(product);

    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12.0),
      child: GestureDetector(
        onTap: () {
          Get.toNamed('/product-detail', parameters: {'productId': product.id});
        },
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image with Hot Deals Badge
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Image.network(
                      product.thumbnail ?? '',
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 120,
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                            size: 40,
                          ),
                        );
                      },
                    ),
                  ),
                  // Hot Deals Badge
                  if (showHotDeals)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF5722),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Hot Deal',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              // Product Details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Title
                      Text(
                        product.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF212121),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      // Product Description
                      Expanded(
                        child: Text(
                          product.description ?? 'No description available',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // Price
                      Text(
                        formattedPrice,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2196F3),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _shouldShowHotDeals(Product product) {
    // Logic to determine if product should show Hot Deals tag
    // For demo purposes, show on every 3rd product or products with specific criteria
    final productIndex = product.id.hashCode % 10;
    return productIndex % 3 == 0; // Show on every 3rd product
  }
}
