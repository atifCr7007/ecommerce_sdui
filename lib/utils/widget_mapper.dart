import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../models/ui_models.dart';
import '../models/product.dart';
import '../controllers/home_controller.dart';
import '../views/widgets/category_tabs_widget.dart';

class WidgetMapper {
  // Public method to build product card
  static Widget buildProductCard(Product product, BuildContext context) {
    return _buildProductCard(product, context);
  }

  static Widget buildCarousel(UIComponent component, BuildContext context) {
    final images = List<String>.from(component.properties['images'] ?? []);
    final showIndicators = component.properties['showIndicators'] ?? true;
    final height = (component.properties['height'] ?? 200.0).toDouble();

    if (images.isEmpty) {
      return Container(
        height: height,
        color: Colors.grey[300],
        child: const Center(child: Text('No images available')),
      );
    }

    return StatefulBuilder(
      builder: (context, setState) {
        int currentIndex = 0;

        return Column(
          children: [
            SizedBox(
              height: height,
              child: PageView.builder(
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: CachedNetworkImage(
                        imageUrl: images[index],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.broken_image,
                            color: Colors.grey,
                            size: 50,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (showIndicators && images.length > 1) ...[
              const SizedBox(height: 10),
              AnimatedSmoothIndicator(
                activeIndex: currentIndex,
                count: images.length,
                effect: const WormEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: Colors.blue,
                  dotColor: Colors.grey,
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  static Widget buildTabBar(UIComponent component, BuildContext context) {
    final tabs = List<Map<String, dynamic>>.from(
      component.properties['tabs'] ?? [],
    );
    final isScrollable = component.properties['isScrollable'] ?? false;

    if (tabs.isEmpty) {
      return const SizedBox.shrink();
    }

    return DefaultTabController(
      length: tabs.length,
      child: Column(
        children: [
          TabBar(
            isScrollable: isScrollable,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            tabs: tabs.map((tab) {
              return Tab(
                text: tab['title']?.toString() ?? '',
                icon: tab['icon'] != null ? Icon(Icons.category) : null,
              );
            }).toList(),
          ),
          SizedBox(
            height: 300, // Fixed height for tab content
            child: TabBarView(
              children: tabs.map((tab) {
                final content = tab['content'] as List<dynamic>? ?? [];
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: content.map((item) {
                      if (item is Map<String, dynamic>) {
                        final uiComponent = UIComponent.fromJson(item);
                        return _buildComponentFromMapper(uiComponent, context);
                      }
                      return const SizedBox.shrink();
                    }).toList(),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildCategoryTabs(UIComponent component, BuildContext context) {
    final title = component.properties['title']?.toString() ?? 'Categories';
    final tabs = component.properties['tabs'] as List<dynamic>? ?? [];
    final defaultTab = component.properties['defaultTab']?.toString() ?? '';
    final productLimit = component.properties['productLimit'] ?? 6;

    return CategoryTabsWidget(
      title: title,
      tabs: tabs.map((tab) => CategoryTab.fromJson(tab)).toList(),
      defaultTab: defaultTab,
      productLimit: productLimit,
    );
  }

  static Widget buildProductList(UIComponent component, BuildContext context) {
    final title = component.properties['title']?.toString() ?? '';
    final isHorizontal = component.properties['isHorizontal'] ?? true;
    final showViewAll = component.properties['showViewAll'] ?? false;
    final limit = component.properties['limit'] ?? 10;
    final categoryId = component.properties['categoryId']?.toString();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (showViewAll)
                  TextButton(
                    onPressed: () {
                      // Handle view all action
                    },
                    child: const Text('View All'),
                  ),
              ],
            ),
          ),
        ],
        SizedBox(
          height: isHorizontal ? 280 : null,
          child: FutureBuilder<List<Product>>(
            future: Get.find<HomeController>().fetchProducts(
              limit: limit,
              categoryId: categoryId,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final products = snapshot.data ?? [];

              if (products.isEmpty) {
                return const Center(child: Text('No products available'));
              }

              if (isHorizontal) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return _buildProductCard(products[index], context);
                  },
                );
              } else {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return _buildProductCard(products[index], context);
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }

  static Widget buildBanner(UIComponent component, BuildContext context) {
    final imageUrl = component.properties['imageUrl']?.toString() ?? '';
    final title = component.properties['title']?.toString();
    final subtitle = component.properties['subtitle']?.toString();
    final height = (component.properties['height'] ?? 150.0).toDouble();
    final overlayColor = _parseColor(component.properties['overlayColor']);
    final overlayOpacity = (component.properties['overlayOpacity'] ?? 0.3)
        .toDouble();
    final borderRadius = (component.properties['borderRadius'] ?? 12.0)
        .toDouble();
    final margin = component.properties['margin'] as Map<String, dynamic>?;

    // Parse margin
    final parsedMargin = margin != null
        ? EdgeInsets.symmetric(
            horizontal: (margin['horizontal'] ?? 16.0).toDouble(),
            vertical: (margin['vertical'] ?? 8.0).toDouble(),
          )
        : const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);

    return Container(
      height: height,
      margin: parsedMargin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[300],
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[300],
                child: const Icon(
                  Icons.broken_image,
                  color: Colors.grey,
                  size: 50,
                ),
              ),
            ),
            if (overlayColor != null)
              Container(color: overlayColor.withValues(alpha: overlayOpacity)),
            if (title != null || subtitle != null)
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null)
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  if (component.action != null) {
                    _handleAction(component.action!, context);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildProductCard(Product product, BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: InkWell(
          onTap: () {
            Get.toNamed(
              '/product-detail',
              parameters: {'productId': product.id},
            );
          },
          borderRadius: BorderRadius.circular(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12.0),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: product.displayImage,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[300],
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.image, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.displayPrice,
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 12),
                          Text(
                            product.rating.toStringAsFixed(1),
                            style: const TextStyle(fontSize: 10),
                          ),
                        ],
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

  static Widget _buildComponentFromMapper(
    UIComponent component,
    BuildContext context,
  ) {
    // This is a simplified version - in a real implementation,
    // you would import and use the JsonUIParser here
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Text('Component: ${component.type}'),
    );
  }

  static void _handleAction(UIAction action, BuildContext context) {
    switch (action.type.toLowerCase()) {
      case 'navigate':
        if (action.route != null) {
          Navigator.pushNamed(
            context,
            action.route!,
            arguments: action.parameters,
          );
        }
        break;
      case 'external_url':
        // Handle external URL opening
        break;
      default:
        debugPrint('Unknown action type: ${action.type}');
    }
  }

  /// Parse color from string (hex format)
  static Color? _parseColor(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      try {
        final buffer = StringBuffer();
        if (value.length == 6 || value.length == 7) buffer.write('ff');
        buffer.write(value.replaceFirst('#', ''));
        return Color(int.parse(buffer.toString(), radix: 16));
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}
