import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/marketplace_controller.dart';

/// Stac - Server-Driven UI (SDUI) framework for Flutter
/// Allows building beautiful cross-platform applications with JSON in real time
class Stac {
  /// Parse JSON into Flutter widgets using Stac format
  static Widget fromJson(Map<String, dynamic> json, BuildContext context) {
    return _parseComponent(json, context);
  }

  static Widget _parseComponent(Map<String, dynamic> json, BuildContext context) {
    final String type = json['type'] as String;

    switch (type.toLowerCase()) {
      case 'scaffold':
        return _buildScaffold(json, context);
      case 'singlechildscrollview':
        return _buildSingleChildScrollView(json, context);
      case 'padding':
        return _buildPadding(json, context);
      case 'column':
        return _buildColumn(json, context);
      case 'row':
        return _buildRow(json, context);
      case 'container':
        return _buildContainer(json, context);
      case 'text':
        return _buildText(json, context);
      case 'icon':
        return _buildIcon(json, context);
      case 'image':
        return _buildImage(json, context);
      case 'sizedbox':
        return _buildSizedBox(json, context);
      case 'spacer':
        return _buildSpacer(json, context);
      case 'expanded':
        return _buildExpanded(json, context);
      case 'center':
        return _buildCenter(json, context);
      case 'listview':
        return _buildListView(json, context);
      case 'gridview':
        return _buildGridView(json, context);
      case 'marketplace_categories':
        return _buildMarketplaceCategories(json, context);
      case 'marketplace_shops':
        return _buildMarketplaceShops(json, context);
      case 'marketplace_search':
        return _buildMarketplaceSearch(json, context);
      default:
        return Container(
          padding: const EdgeInsets.all(8),
          child: Text(
            'Unknown component: $type',
            style: const TextStyle(color: Colors.red),
          ),
        );
    }
  }

  static Widget _buildScaffold(Map<String, dynamic> json, BuildContext context) {
    final body = json['body'];
    return Scaffold(
      body: body != null ? _parseComponent(body, context) : Container(),
    );
  }

  static Widget _buildSingleChildScrollView(Map<String, dynamic> json, BuildContext context) {
    final child = json['child'];
    return SingleChildScrollView(
      child: child != null ? _parseComponent(child, context) : Container(),
    );
  }

  static Widget _buildPadding(Map<String, dynamic> json, BuildContext context) {
    final padding = json['padding'] as Map<String, dynamic>?;
    final child = json['child'];
    
    return Padding(
      padding: _parseEdgeInsets(padding),
      child: child != null ? _parseComponent(child, context) : Container(),
    );
  }

  static Widget _buildColumn(Map<String, dynamic> json, BuildContext context) {
    final children = json['children'] as List<dynamic>? ?? [];
    final crossAxisAlignment = json['crossAxisAlignment'] as String?;
    final mainAxisAlignment = json['mainAxisAlignment'] as String?;
    final spacing = json['spacing'] as num?;

    List<Widget> widgets = [];
    for (int i = 0; i < children.length; i++) {
      widgets.add(_parseComponent(children[i], context));
      if (spacing != null && i < children.length - 1) {
        widgets.add(SizedBox(height: spacing.toDouble()));
      }
    }

    return Column(
      crossAxisAlignment: _parseCrossAxisAlignment(crossAxisAlignment),
      mainAxisAlignment: _parseMainAxisAlignment(mainAxisAlignment),
      children: widgets,
    );
  }

  static Widget _buildRow(Map<String, dynamic> json, BuildContext context) {
    final children = json['children'] as List<dynamic>? ?? [];
    final crossAxisAlignment = json['crossAxisAlignment'] as String?;
    final mainAxisAlignment = json['mainAxisAlignment'] as String?;
    final spacing = json['spacing'] as num?;

    List<Widget> widgets = [];
    for (int i = 0; i < children.length; i++) {
      widgets.add(_parseComponent(children[i], context));
      if (spacing != null && i < children.length - 1) {
        widgets.add(SizedBox(width: spacing.toDouble()));
      }
    }

    return Row(
      crossAxisAlignment: _parseCrossAxisAlignment(crossAxisAlignment),
      mainAxisAlignment: _parseMainAxisAlignment(mainAxisAlignment),
      children: widgets,
    );
  }

  static Widget _buildContainer(Map<String, dynamic> json, BuildContext context) {
    final child = json['child'];
    final width = json['width'] as num?;
    final height = json['height'] as num?;
    final padding = json['padding'] as Map<String, dynamic>?;
    final decoration = json['decoration'] as Map<String, dynamic>?;
    final clipBehavior = json['clipBehavior'] as String?;

    Widget? containerChild = child != null ? _parseComponent(child, context) : null;

    // Handle clipBehavior
    if (clipBehavior == 'hardEdge' && containerChild != null) {
      containerChild = ClipRRect(
        borderRadius: _parseBorderRadius(decoration?['borderRadius']) ?? BorderRadius.zero,
        child: containerChild,
      );
    }

    return Container(
      width: width?.toDouble(),
      height: height?.toDouble(),
      padding: _parseEdgeInsets(padding),
      decoration: _parseBoxDecoration(decoration),
      child: containerChild,
    );
  }

  static Widget _buildText(Map<String, dynamic> json, BuildContext context) {
    final data = json['data'] as String? ?? '';
    final style = json['style'] as Map<String, dynamic>?;

    return Text(
      data,
      style: _parseTextStyle(style),
    );
  }

  static Widget _buildIcon(Map<String, dynamic> json, BuildContext context) {
    final icon = json['icon'] as String?;
    final size = json['size'] as num?;
    final color = json['color'] as String?;

    return Icon(
      _parseIconData(icon),
      size: size?.toDouble(),
      color: _parseColor(color),
    );
  }

  static Widget _buildImage(Map<String, dynamic> json, BuildContext context) {
    final src = json['src'] as String? ?? '';
    
    if (src.isEmpty) {
      return Container(
        color: Colors.grey[300],
        child: const Icon(Icons.image, color: Colors.grey),
      );
    }

    return Image.network(
      src,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey[300],
          child: const Icon(Icons.broken_image, color: Colors.grey),
        );
      },
    );
  }

  static Widget _buildSizedBox(Map<String, dynamic> json, BuildContext context) {
    final width = json['width'] as num?;
    final height = json['height'] as num?;

    return SizedBox(
      width: width?.toDouble(),
      height: height?.toDouble(),
    );
  }

  static Widget _buildSpacer(Map<String, dynamic> json, BuildContext context) {
    return const Spacer();
  }

  static Widget _buildExpanded(Map<String, dynamic> json, BuildContext context) {
    final child = json['child'];
    return Expanded(
      child: child != null ? _parseComponent(child, context) : Container(),
    );
  }

  static Widget _buildCenter(Map<String, dynamic> json, BuildContext context) {
    final child = json['child'];
    return Center(
      child: child != null ? _parseComponent(child, context) : Container(),
    );
  }

  static Widget _buildListView(Map<String, dynamic> json, BuildContext context) {
    final children = json['children'] as List<dynamic>? ?? [];
    final scrollDirection = json['scrollDirection'] as String?;
    final spacing = json['spacing'] as num?;

    return ListView.separated(
      scrollDirection: scrollDirection == 'horizontal' ? Axis.horizontal : Axis.vertical,
      itemCount: children.length,
      separatorBuilder: (context, index) => scrollDirection == 'horizontal'
          ? SizedBox(width: spacing?.toDouble() ?? 0)
          : SizedBox(height: spacing?.toDouble() ?? 0),
      itemBuilder: (context, index) => _parseComponent(children[index], context),
    );
  }

  static Widget _buildGridView(Map<String, dynamic> json, BuildContext context) {
    final children = json['children'] as List<dynamic>? ?? [];
    final crossAxisCount = json['crossAxisCount'] as int? ?? 2;
    final crossAxisSpacing = json['crossAxisSpacing'] as num? ?? 0;
    final mainAxisSpacing = json['mainAxisSpacing'] as num? ?? 0;
    final childAspectRatio = json['childAspectRatio'] as num? ?? 1.0;
    final shrinkWrap = json['shrinkWrap'] as bool? ?? false;
    final physics = json['physics'] as String?;

    return GridView.builder(
      shrinkWrap: shrinkWrap,
      physics: physics == 'neverScrollable' ? const NeverScrollableScrollPhysics() : null,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: crossAxisSpacing.toDouble(),
        mainAxisSpacing: mainAxisSpacing.toDouble(),
        childAspectRatio: childAspectRatio.toDouble(),
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => _parseComponent(children[index], context),
    );
  }

  // Helper methods for parsing properties
  static EdgeInsets _parseEdgeInsets(Map<String, dynamic>? padding) {
    if (padding == null) return EdgeInsets.zero;

    if (padding.containsKey('all')) {
      return EdgeInsets.all((padding['all'] as num).toDouble());
    }

    return EdgeInsets.only(
      top: (padding['top'] as num?)?.toDouble() ?? 0,
      left: (padding['left'] as num?)?.toDouble() ?? 0,
      right: (padding['right'] as num?)?.toDouble() ?? 0,
      bottom: (padding['bottom'] as num?)?.toDouble() ?? 0,
    );
  }

  static CrossAxisAlignment _parseCrossAxisAlignment(String? alignment) {
    switch (alignment) {
      case 'start':
        return CrossAxisAlignment.start;
      case 'end':
        return CrossAxisAlignment.end;
      case 'center':
        return CrossAxisAlignment.center;
      case 'stretch':
        return CrossAxisAlignment.stretch;
      default:
        return CrossAxisAlignment.start;
    }
  }

  static MainAxisAlignment _parseMainAxisAlignment(String? alignment) {
    switch (alignment) {
      case 'start':
        return MainAxisAlignment.start;
      case 'end':
        return MainAxisAlignment.end;
      case 'center':
        return MainAxisAlignment.center;
      case 'spaceBetween':
        return MainAxisAlignment.spaceBetween;
      case 'spaceAround':
        return MainAxisAlignment.spaceAround;
      case 'spaceEvenly':
        return MainAxisAlignment.spaceEvenly;
      default:
        return MainAxisAlignment.start;
    }
  }

  static BoxDecoration? _parseBoxDecoration(Map<String, dynamic>? decoration) {
    if (decoration == null) return null;

    return BoxDecoration(
      color: _parseColor(decoration['color']),
      borderRadius: _parseBorderRadius(decoration['borderRadius']),
      border: _parseBorder(decoration['border']),
      boxShadow: _parseBoxShadow(decoration['boxShadow']),
    );
  }

  static Color? _parseColor(dynamic color) {
    if (color == null) return null;
    if (color is String) {
      if (color.startsWith('#')) {
        return Color(int.parse(color.replaceFirst('#', '0xFF')));
      }
    }
    return null;
  }

  static BorderRadius? _parseBorderRadius(dynamic borderRadius) {
    if (borderRadius == null) return null;

    if (borderRadius is num) {
      return BorderRadius.circular(borderRadius.toDouble());
    }

    if (borderRadius is Map<String, dynamic>) {
      return BorderRadius.only(
        topLeft: Radius.circular((borderRadius['topLeft'] as num?)?.toDouble() ?? 0),
        topRight: Radius.circular((borderRadius['topRight'] as num?)?.toDouble() ?? 0),
        bottomLeft: Radius.circular((borderRadius['bottomLeft'] as num?)?.toDouble() ?? 0),
        bottomRight: Radius.circular((borderRadius['bottomRight'] as num?)?.toDouble() ?? 0),
      );
    }

    return null;
  }

  static Border? _parseBorder(Map<String, dynamic>? border) {
    if (border == null) return null;

    return Border.all(
      color: _parseColor(border['color']) ?? Colors.grey,
      width: (border['width'] as num?)?.toDouble() ?? 1.0,
    );
  }

  static List<BoxShadow>? _parseBoxShadow(dynamic boxShadow) {
    if (boxShadow == null) return null;

    if (boxShadow is List) {
      return boxShadow.map((shadow) {
        final shadowMap = shadow as Map<String, dynamic>;
        final offset = shadowMap['offset'] as Map<String, dynamic>?;

        return BoxShadow(
          color: _parseColor(shadowMap['color']) ?? Colors.black26,
          blurRadius: (shadowMap['blurRadius'] as num?)?.toDouble() ?? 0,
          offset: Offset(
            (offset?['x'] as num?)?.toDouble() ?? 0,
            (offset?['y'] as num?)?.toDouble() ?? 0,
          ),
        );
      }).toList();
    }

    return null;
  }

  static TextStyle? _parseTextStyle(Map<String, dynamic>? style) {
    if (style == null) return null;

    return TextStyle(
      fontSize: (style['fontSize'] as num?)?.toDouble(),
      fontWeight: _parseFontWeight(style['fontWeight']),
      color: _parseColor(style['color']),
      height: (style['height'] as num?)?.toDouble(),
    );
  }

  static FontWeight? _parseFontWeight(dynamic fontWeight) {
    if (fontWeight == null) return null;

    if (fontWeight is String) {
      switch (fontWeight) {
        case 'bold':
          return FontWeight.bold;
        case 'w100':
          return FontWeight.w100;
        case 'w200':
          return FontWeight.w200;
        case 'w300':
          return FontWeight.w300;
        case 'w400':
          return FontWeight.w400;
        case 'w500':
          return FontWeight.w500;
        case 'w600':
          return FontWeight.w600;
        case 'w700':
          return FontWeight.w700;
        case 'w800':
          return FontWeight.w800;
        case 'w900':
          return FontWeight.w900;
        default:
          return FontWeight.normal;
      }
    }

    return null;
  }

  static IconData? _parseIconData(String? icon) {
    if (icon == null) return null;

    switch (icon) {
      case 'search':
        return Icons.search;
      case 'category':
        return Icons.category;
      case 'shopping_bag':
        return Icons.shopping_bag;
      case 'phone_android':
        return Icons.phone_android;
      case 'home':
        return Icons.home;
      case 'store':
        return Icons.store;
      case 'star':
        return Icons.star;
      default:
        return Icons.help_outline;
    }
  }

  // Marketplace-specific components
  static Widget _buildMarketplaceCategories(Map<String, dynamic> json, BuildContext context) {
    final controller = Get.find<MarketplaceController>();

    return Container(
      height: 100,
      child: Obx(() => ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: controller.categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = controller.categories[index];
          final isSelected = controller.selectedCategory.value == category;

          return GestureDetector(
            onTap: () => controller.selectCategory(category),
            child: Container(
              width: 80,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF1976D2) : const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getCategoryIcon(category),
                    size: 24,
                    color: isSelected ? Colors.white : const Color(0xFF1976D2),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : const Color(0xFF1976D2),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      )),
    );
  }

  static Widget _buildMarketplaceShops(Map<String, dynamic> json, BuildContext context) {
    final controller = Get.find<MarketplaceController>();
    final isFeatured = json['featured'] as bool? ?? false;

    return Obx(() {
      final shops = isFeatured ? controller.featuredShops : controller.filteredShops;

      if (shops.isEmpty) {
        return Container(
          height: 200,
          child: const Center(
            child: Text('No shops found'),
          ),
        );
      }

      if (isFeatured) {
        // Horizontal list for featured shops
        return Container(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: shops.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final shop = shops[index];
              return _buildShopCard(shop, context, true);
            },
          ),
        );
      } else {
        // Grid for all shops
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.8,
          ),
          itemCount: shops.length,
          itemBuilder: (context, index) {
            final shop = shops[index];
            return _buildShopCard(shop, context, false);
          },
        );
      }
    });
  }

  static Widget _buildMarketplaceSearch(Map<String, dynamic> json, BuildContext context) {
    final controller = Get.find<MarketplaceController>();

    return GestureDetector(
      onTap: () {
        // Show search dialog or navigate to search page
        _showSearchDialog(context, controller);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(
              Icons.search,
              size: 20,
              color: Color(0xFF999999),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                controller.searchQuery.value.isEmpty
                    ? 'Search shops, products, categories...'
                    : controller.searchQuery.value,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF999999),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildShopCard(dynamic shop, BuildContext context, bool isFeatured) {
    return GestureDetector(
      onTap: () {
        // Navigate to home view with shop data
        Get.toNamed('/home', parameters: {
          'shopId': shop.id,
          'shopName': shop.name,
        });
      },
      child: Container(
        width: isFeatured ? 160 : null,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Container(
                  width: double.infinity,
                  child: Image.network(
                    shop.logo,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.store, color: Colors.grey),
                      );
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shop.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 12, color: Color(0xFFFFB800)),
                        const SizedBox(width: 4),
                        Text(
                          '${shop.rating}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF666666),
                          ),
                        ),
                        const Spacer(),
                        if (shop.isVerified)
                          const Icon(Icons.verified, size: 12, color: Color(0xFF4CAF50)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'all':
        return Icons.category;
      case 'electronics':
        return Icons.phone_android;
      case 'fashion':
        return Icons.shopping_bag;
      case 'home':
        return Icons.home;
      case 'books':
        return Icons.book;
      case 'sports':
        return Icons.sports;
      default:
        return Icons.store;
    }
  }

  static void _showSearchDialog(BuildContext context, MarketplaceController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Marketplace'),
        content: TextField(
          onChanged: (value) => controller.searchShops(value),
          decoration: const InputDecoration(
            hintText: 'Enter search term...',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
