import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/ui_models.dart';
import '../models/shop.dart';
import '../utils/widget_mapper.dart';
import '../widgets/orders_list_widget.dart';
import '../widgets/order_statistics_widget.dart';
import '../controllers/cart_controller.dart';
import '../controllers/product_detail_controller.dart';
import '../controllers/marketplace_controller.dart';

class JsonUIParser {
  static Widget parseScreen(UIScreen screen, BuildContext context) {
    return Column(
      children: screen.components
          .map((component) => parseComponent(component, context))
          .toList(),
    );
  }

  static Widget parseScreenWithScaffold(
    UIScreen screen,
    BuildContext context, {
    Map<String, dynamic>? screenData,
  }) {
    Widget body = Column(
      children: screen.components
          .map((component) => parseComponent(component, context))
          .toList(),
    );

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

  static Widget parseComponent(UIComponent component, BuildContext context) {
    final componentType = component.type.toLowerCase().trim();

    switch (componentType) {
      case 'column':
        return _buildColumn(component, context);
      case 'row':
        return _buildRow(component, context);
      case 'container':
        return _buildContainer(component, context);
      case 'text':
        return _buildText(component, context);
      case 'image':
        return _buildImage(component, context);
      case 'carousel':
        return _buildCarousel(component, context);
      case 'tabbar':
        return _buildTabBar(component, context);
      case 'productlist':
        return _buildProductList(component, context);
      case 'categorytabs':
        return _buildCategoryTabs(component, context);
      case 'banner':
        return _buildBanner(component, context);
      case 'button':
        return _buildButton(component, context);
      case 'icon':
        return _buildIcon(component, context);
      case 'variant_selector':
        return _buildVariantSelector(component, context);
      case 'orders_list':
        return _buildOrdersList(component, context);
      case 'order_statistics':
        return _buildOrderStatistics(component, context);
      case 'order_status_item':
        return _buildOrderStatusItem(component, context);
      case 'spacer':
        return _buildSpacer(component, context);
      case 'divider':
        return _buildDivider(component, context);
      case 'scrollview':
      case 'scroll_view':
        return _buildScrollView(component, context);
      case 'expanded':
        return _buildExpanded(component, context);
      case 'flexible':
        return _buildFlexible(component, context);
      case 'padding':
        return _buildPadding(component, context);
      case 'center':
        return _buildCenter(component, context);
      case 'sizedbox':
        return _buildSizedBox(component, context);
      case 'marketplace_header':
        return _buildMarketplaceHeader(component, context);
      case 'marketplace_search':
        return _buildMarketplaceSearch(component, context);
      case 'marketplace_categories':
        return _buildMarketplaceCategories(component, context);
      case 'marketplace_featured_shops':
        return _buildMarketplaceFeaturedShops(component, context);
      case 'marketplace_all_shops':
        return _buildMarketplaceAllShops(component, context);
      default:
        return Container(
          padding: const EdgeInsets.all(8),
          child: Text(
            'Unknown component: ${component.type}',
            style: const TextStyle(color: Colors.red),
          ),
        );
    }
  }

  static Widget _buildColumn(UIComponent component, BuildContext context) {
    final children =
        component.children
            ?.map((child) => parseComponent(child, context))
            .toList() ??
        [];

    return Column(
      mainAxisAlignment: _getMainAxisAlignment(
        component.properties['mainAxisAlignment'] as String?,
      ),
      crossAxisAlignment: _getCrossAxisAlignment(
        component.properties['crossAxisAlignment'] as String?,
      ),
      mainAxisSize: _getMainAxisSize(
        component.properties['mainAxisSize'] as String?,
      ),
      children: children,
    );
  }

  static Widget _buildRow(UIComponent component, BuildContext context) {
    final children =
        component.children
            ?.map((child) => parseComponent(child, context))
            .toList() ??
        [];

    return Row(
      mainAxisAlignment: _getMainAxisAlignment(
        component.properties['mainAxisAlignment'] as String?,
      ),
      crossAxisAlignment: _getCrossAxisAlignment(
        component.properties['crossAxisAlignment'] as String?,
      ),
      mainAxisSize: _getMainAxisSize(
        component.properties['mainAxisSize'] as String?,
      ),
      children: children,
    );
  }

  static Widget _buildContainer(UIComponent component, BuildContext context) {
    final properties = component.properties;
    final children =
        component.children
            ?.map((child) => parseComponent(child, context))
            .toList() ??
        [];

    Widget? child;
    if (children.length == 1) {
      child = children.first;
    } else if (children.length > 1) {
      child = Column(children: children);
    }

    return Container(
      width: _parseDouble(properties['width']),
      height: _parseDouble(properties['height']),
      padding: _parsePadding(properties['padding']),
      margin: _parsePadding(properties['margin']),
      decoration: BoxDecoration(
        color: _parseColor(properties['backgroundColor']),
        borderRadius: BorderRadius.circular(
          _parseDouble(properties['borderRadius']) ?? 0,
        ),
        border: properties['borderColor'] != null
            ? Border.all(
                color: _parseColor(properties['borderColor']) ?? Colors.grey,
                width: _parseDouble(properties['borderWidth']) ?? 1,
              )
            : null,
      ),
      child: child,
    );
  }

  static Widget _buildText(UIComponent component, BuildContext context) {
    final properties = component.properties;
    final text = properties['text'] as String? ?? '';

    return Text(
      text,
      style: TextStyle(
        fontSize: _parseDouble(properties['fontSize']) ?? 14,
        fontWeight: _parseFontWeight(properties['fontWeight']),
        color: _parseColor(properties['color']) ?? Colors.black,
      ),
      textAlign: _parseTextAlign(properties['textAlign']),
      maxLines: _parseInt(properties['maxLines']),
      overflow: properties['overflow'] == 'ellipsis'
          ? TextOverflow.ellipsis
          : null,
    );
  }

  static Widget _buildImage(UIComponent component, BuildContext context) {
    final properties = component.properties;
    final url = properties['url'] as String? ?? '';
    final width = _parseDouble(properties['width']);
    final height = _parseDouble(properties['height']);

    if (url.isEmpty) {
      return Container(
        width: width ?? 100,
        height: height ?? 100,
        color: Colors.grey[300],
        child: const Icon(Icons.image, color: Colors.grey),
      );
    }

    return Image.network(
      url,
      width: width,
      height: height,
      fit: _parseBoxFit(properties['fit']),
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width ?? 100,
          height: height ?? 100,
          color: Colors.grey[300],
          child: const Icon(Icons.broken_image, color: Colors.grey),
        );
      },
    );
  }

  static Widget _buildCarousel(UIComponent component, BuildContext context) {
    final properties = component.properties;
    final images = properties['images'] as List<dynamic>? ?? [];
    final height = _parseDouble(properties['height']) ?? 200;
    final fullWidth = properties['fullWidth'] as bool? ?? false;
    final fit = _parseBoxFit(properties['fit']) ?? BoxFit.cover;
    final showOverlay = properties['showOverlay'] as bool? ?? true;

    if (images.isEmpty) {
      return Container(
        height: height,
        color: Colors.grey[300],
        child: const Center(child: Text('No images available')),
      );
    }

    Widget carousel = SizedBox(
      height: height,
      child: PageView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) {
          final imageUrl = images[index] as String;

          Widget imageWidget = Image.network(
            imageUrl,
            fit: fit,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[300],
                child: const Center(
                  child: Icon(Icons.broken_image, color: Colors.grey, size: 48),
                ),
              );
            },
          );

          // Only add overlay for banners, not product images
          if (showOverlay && component.id != 'product_images') {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF2196F3).withValues(alpha: 0.8),
                    const Color(0xFF2196F3).withValues(alpha: 0.9),
                  ],
                ),
              ),
              child: ClipRect(
                child: ColorFiltered(
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF2196F3),
                    BlendMode.multiply,
                  ),
                  child: imageWidget,
                ),
              ),
            );
          } else {
            return ClipRect(child: imageWidget);
          }
        },
      ),
    );

    // If fullWidth is true, don't add horizontal padding
    if (fullWidth) {
      return carousel;
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: carousel,
        ),
      );
    }
  }

  static Widget _buildProductList(UIComponent component, BuildContext context) {
    return WidgetMapper.buildProductList(component, context);
  }

  static Widget _buildCategoryTabs(
    UIComponent component,
    BuildContext context,
  ) {
    try {
      return WidgetMapper.buildCategoryTabs(component, context);
    } catch (e) {
      debugPrint('[JsonUIParser] Error building CategoryTabs: $e');
      return Container(
        padding: const EdgeInsets.all(8),
        child: Text(
          'Error loading CategoryTabs: $e',
          style: const TextStyle(color: Colors.red),
        ),
      );
    }
  }

  static Widget _buildBanner(UIComponent component, BuildContext context) {
    return WidgetMapper.buildBanner(component, context);
  }

  static Widget _buildButton(UIComponent component, BuildContext context) {
    final properties = component.properties;
    final text = properties['text'] as String? ?? 'Button';
    final backgroundColor = _parseColor(properties['backgroundColor']);
    final textColor = _parseColor(properties['textColor']);

    return ElevatedButton(
      onPressed: () {
        // Handle button action
        final action = component.action;
        if (action != null) {
          _handleAction(action, context);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
      ),
      child: Text(text),
    );
  }

  static Widget _buildSpacer(UIComponent component, BuildContext context) {
    return const Spacer();
  }

  static Widget _buildDivider(UIComponent component, BuildContext context) {
    final properties = component.properties;
    return Divider(
      color: _parseColor(properties['color']),
      thickness: _parseDouble(properties['thickness']),
      height: _parseDouble(properties['height']),
    );
  }

  static Widget _buildScrollView(UIComponent component, BuildContext context) {
    final properties = component.properties;
    final children =
        component.children
            ?.map((child) => parseComponent(child, context))
            .toList() ??
        [];

    // Parse padding from properties
    EdgeInsets? padding;
    if (properties['padding'] != null) {
      final paddingMap = properties['padding'] as Map<String, dynamic>;
      if (paddingMap.containsKey('all')) {
        padding = EdgeInsets.all(_parseDouble(paddingMap['all']) ?? 0.0);
      } else if (paddingMap.containsKey('horizontal') || paddingMap.containsKey('vertical')) {
        padding = EdgeInsets.symmetric(
          horizontal: _parseDouble(paddingMap['horizontal']) ?? 0.0,
          vertical: _parseDouble(paddingMap['vertical']) ?? 0.0,
        );
      } else {
        padding = EdgeInsets.only(
          top: _parseDouble(paddingMap['top']) ?? 0.0,
          bottom: _parseDouble(paddingMap['bottom']) ?? 0.0,
          left: _parseDouble(paddingMap['left']) ?? 0.0,
          right: _parseDouble(paddingMap['right']) ?? 0.0,
        );
      }
    }

    // Parse scroll direction
    final scrollDirection = properties['scrollDirection'] == 'horizontal'
        ? Axis.horizontal
        : Axis.vertical;

    Widget scrollContent;
    if (children.length == 1) {
      // If there's only one child, use it directly
      scrollContent = children.first;
    } else {
      // If there are multiple children, wrap them in a Column or Row
      if (scrollDirection == Axis.horizontal) {
        scrollContent = Row(
          mainAxisSize: MainAxisSize.min,
          children: children,
        );
      } else {
        scrollContent = Column(
          mainAxisSize: MainAxisSize.min,
          children: children,
        );
      }
    }

    // Apply padding if specified
    if (padding != null) {
      scrollContent = Padding(
        padding: padding,
        child: scrollContent,
      );
    }

    return SingleChildScrollView(
      scrollDirection: scrollDirection,
      child: scrollContent,
    );
  }

  static Widget _buildExpanded(UIComponent component, BuildContext context) {
    final children =
        component.children
            ?.map((child) => parseComponent(child, context))
            .toList() ??
        [];

    Widget child = children.length == 1
        ? children.first
        : Column(children: children);

    return Expanded(child: child);
  }

  static Widget _buildFlexible(UIComponent component, BuildContext context) {
    final children =
        component.children
            ?.map((child) => parseComponent(child, context))
            .toList() ??
        [];

    Widget child = children.length == 1
        ? children.first
        : Column(children: children);

    return Flexible(child: child);
  }

  static Widget _buildPadding(UIComponent component, BuildContext context) {
    final properties = component.properties;
    final children =
        component.children
            ?.map((child) => parseComponent(child, context))
            .toList() ??
        [];

    Widget child = children.length == 1
        ? children.first
        : Column(children: children);

    return Padding(
      padding: _parsePadding(properties['padding']) ?? EdgeInsets.zero,
      child: child,
    );
  }

  static Widget _buildCenter(UIComponent component, BuildContext context) {
    final children =
        component.children
            ?.map((child) => parseComponent(child, context))
            .toList() ??
        [];

    Widget child = children.length == 1
        ? children.first
        : Column(children: children);

    return Center(child: child);
  }

  static Widget _buildSizedBox(UIComponent component, BuildContext context) {
    final properties = component.properties;
    return SizedBox(
      width: _parseDouble(properties['width']),
      height: _parseDouble(properties['height']),
    );
  }

  static Widget _buildIcon(UIComponent component, BuildContext context) {
    final properties = component.properties;
    final iconName = properties['icon'] as String? ?? 'help';
    final size = _parseDouble(properties['size']) ?? 24.0;
    final colorHex = properties['color'] as String? ?? '#212121';

    // Parse color
    Color iconColor;
    try {
      iconColor = Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
    } catch (e) {
      iconColor = Colors.grey;
    }

    // Map icon names to IconData
    IconData iconData = _getIconData(iconName);

    return Icon(iconData, size: size, color: iconColor);
  }

  static IconData _getIconData(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'favorite':
        return Icons.favorite;
      case 'favorite_border':
        return Icons.favorite_border;
      case 'home':
        return Icons.home;
      case 'home_outlined':
        return Icons.home_outlined;
      case 'shopping_cart':
        return Icons.shopping_cart;
      case 'shopping_cart_outlined':
        return Icons.shopping_cart_outlined;
      case 'search':
        return Icons.search;
      case 'person':
        return Icons.person;
      case 'person_outline':
        return Icons.person_outline;
      case 'star':
        return Icons.star;
      case 'star_border':
        return Icons.star_border;
      case 'add':
        return Icons.add;
      case 'remove':
        return Icons.remove;
      case 'close':
        return Icons.close;
      case 'check':
        return Icons.check;
      case 'arrow_back':
        return Icons.arrow_back;
      case 'arrow_forward':
        return Icons.arrow_forward;
      case 'menu':
        return Icons.menu;
      case 'more_vert':
        return Icons.more_vert;
      case 'share':
        return Icons.share;
      case 'bookmark':
        return Icons.bookmark;
      case 'bookmark_outline':
        return Icons.bookmark_outline;
      case 'shopping_bag':
        return Icons.shopping_bag;
      case 'shopping_bag_outlined':
        return Icons.shopping_bag_outlined;
      case 'notifications':
        return Icons.notifications;
      case 'notifications_outlined':
        return Icons.notifications_outlined;
      case 'receipt_long':
        return Icons.receipt_long;
      case 'receipt_long_outlined':
        return Icons.receipt_long_outlined;
      case 'delete':
        return Icons.delete;
      case 'delete_outline':
        return Icons.delete_outline;
      case 'edit':
        return Icons.edit;
      case 'visibility':
        return Icons.visibility;
      case 'visibility_off':
        return Icons.visibility_off;
      case 'filter_list':
        return Icons.filter_list;
      case 'sort':
        return Icons.sort;
      case 'help':
        return Icons.help;
      case 'info':
        return Icons.info;
      case 'warning':
        return Icons.warning;
      case 'error':
        return Icons.error;
      case 'check_circle':
        return Icons.check_circle;
      case 'cancel':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  static Widget _buildVariantSelector(
    UIComponent component,
    BuildContext context,
  ) {
    final properties = component.properties;
    final title = properties['title'] as String? ?? 'Select Options';
    final showColors = properties['showColors'] as bool? ?? true;
    final showSizes = properties['showSizes'] as bool? ?? true;

    return Obx(() {
      final controller = Get.find<ProductDetailController>();
      final product = controller.product.value;

      if (product == null ||
          product.variants == null ||
          product.variants!.isEmpty) {
        return const SizedBox.shrink();
      }

      // Extract unique colors and sizes from variants
      final colors = <String>{};
      final sizes = <String>{};

      for (final variant in product.variants!) {
        if (variant.color != null) colors.add(variant.color!);
        if (variant.size != null) sizes.add(variant.size!);
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF212121),
            ),
          ),
          const SizedBox(height: 12),

          // Color selection
          if (showColors && colors.isNotEmpty) ...[
            const Text(
              'Color',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF757575),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: colors.map((color) {
                final isSelected = controller.selectedColor.value == color;
                return GestureDetector(
                  onTap: () => controller.selectColor(color),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF9C27B0)
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF9C27B0)
                            : Colors.grey[300]!,
                      ),
                    ),
                    child: Text(
                      color,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],

          // Size selection
          if (showSizes && sizes.isNotEmpty) ...[
            const Text(
              'Size',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF757575),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: sizes.map((size) {
                final isSelected = controller.selectedSize.value == size;
                return GestureDetector(
                  onTap: () => controller.selectSize(size),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF9C27B0)
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF9C27B0)
                            : Colors.grey[300]!,
                      ),
                    ),
                    child: Text(
                      size,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      );
    });
  }

  static Widget _buildTabBar(UIComponent component, BuildContext context) {
    // This is a simplified implementation
    // In a real app, you'd need to handle TabController properly
    return const SizedBox(
      height: 50,
      child: Center(child: Text('TabBar component')),
    );
  }

  // Helper methods for parsing properties
  static MainAxisAlignment _getMainAxisAlignment(String? alignment) {
    switch (alignment?.toLowerCase()) {
      case 'start':
        return MainAxisAlignment.start;
      case 'end':
        return MainAxisAlignment.end;
      case 'center':
        return MainAxisAlignment.center;
      case 'spacebetween':
        return MainAxisAlignment.spaceBetween;
      case 'spacearound':
        return MainAxisAlignment.spaceAround;
      case 'spaceevenly':
        return MainAxisAlignment.spaceEvenly;
      default:
        return MainAxisAlignment.start;
    }
  }

  static CrossAxisAlignment _getCrossAxisAlignment(String? alignment) {
    switch (alignment?.toLowerCase()) {
      case 'start':
        return CrossAxisAlignment.start;
      case 'end':
        return CrossAxisAlignment.end;
      case 'center':
        return CrossAxisAlignment.center;
      case 'stretch':
        return CrossAxisAlignment.stretch;
      case 'baseline':
        return CrossAxisAlignment.baseline;
      default:
        return CrossAxisAlignment.start;
    }
  }

  static MainAxisSize _getMainAxisSize(String? size) {
    switch (size?.toLowerCase()) {
      case 'min':
        return MainAxisSize.min;
      case 'max':
        return MainAxisSize.max;
      default:
        return MainAxisSize.max;
    }
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  static Color? _parseColor(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      return _colorFromHex(value);
    }
    return null;
  }

  /// Converts hex color string to Color object
  static Color? _colorFromHex(String hexString) {
    try {
      final buffer = StringBuffer();
      if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
      buffer.write(hexString.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (e) {
      return null;
    }
  }

  /// Handles UI actions from JSON components
  static void _handleAction(UIAction action, BuildContext context) {
    switch (action.type.toLowerCase()) {
      case 'navigate':
        final route = action.parameters?['route'] as String?;
        if (route != null) {
          Get.toNamed(route, arguments: action.parameters);
        }
        break;
      case 'show_product_detail':
        final productId = action.parameters?['productId'] as String?;
        if (productId != null) {
          Get.toNamed('/product-detail', parameters: {'productId': productId});
        }
        break;
      case 'show_category':
        final categoryId = action.parameters?['categoryId'] as String?;
        if (categoryId != null) {
          Get.toNamed('/category', parameters: {'categoryId': categoryId});
        }
        break;
      case 'search':
        final query = action.parameters?['query'] as String?;
        Get.toNamed('/search', parameters: {'query': query ?? ''});
        break;
      default:
        debugPrint('Unknown action type: ${action.type}');
    }
  }

  static EdgeInsets? _parsePadding(dynamic value) {
    if (value == null) return null;
    if (value is Map<String, dynamic>) {
      final all = _parseDouble(value['all']);
      if (all != null) {
        return EdgeInsets.all(all);
      }

      final horizontal = _parseDouble(value['horizontal']);
      final vertical = _parseDouble(value['vertical']);
      if (horizontal != null || vertical != null) {
        return EdgeInsets.symmetric(
          horizontal: horizontal ?? 0,
          vertical: vertical ?? 0,
        );
      }

      return EdgeInsets.only(
        left: _parseDouble(value['left']) ?? 0,
        top: _parseDouble(value['top']) ?? 0,
        right: _parseDouble(value['right']) ?? 0,
        bottom: _parseDouble(value['bottom']) ?? 0,
      );
    }
    return null;
  }

  static FontWeight? _parseFontWeight(dynamic value) {
    if (value == null) return null;
    switch (value.toString().toLowerCase()) {
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

  static TextAlign? _parseTextAlign(dynamic value) {
    if (value == null) return null;
    switch (value.toString().toLowerCase()) {
      case 'left':
        return TextAlign.left;
      case 'right':
        return TextAlign.right;
      case 'center':
        return TextAlign.center;
      case 'justify':
        return TextAlign.justify;
      default:
        return TextAlign.left;
    }
  }

  static BoxFit? _parseBoxFit(dynamic value) {
    if (value == null) return null;
    switch (value.toString().toLowerCase()) {
      case 'fill':
        return BoxFit.fill;
      case 'contain':
        return BoxFit.contain;
      case 'cover':
        return BoxFit.cover;
      case 'fitwidth':
        return BoxFit.fitWidth;
      case 'fitheight':
        return BoxFit.fitHeight;
      case 'none':
        return BoxFit.none;
      case 'scaledown':
        return BoxFit.scaleDown;
      default:
        return BoxFit.cover;
    }
  }

  /// Build orders list component
  static Widget _buildOrdersList(UIComponent component, BuildContext context) {
    return OrdersListWidget(component: component);
  }

  /// Build order statistics component
  static Widget _buildOrderStatistics(
    UIComponent component,
    BuildContext context,
  ) {
    return OrderStatisticsWidget(component: component);
  }

  /// Build order status item component
  static Widget _buildOrderStatusItem(
    UIComponent component,
    BuildContext context,
  ) {
    final title = component.properties['title'] as String? ?? '';
    final description = component.properties['description'] as String? ?? '';
    final colorHex = component.properties['color'] as String? ?? '#9C27B0';

    final color = Color(int.parse(colorHex.replaceFirst('#', '0xFF')));

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static FloatingActionButton _buildFloatingActionButton(
    Map<String, dynamic> fabData,
    BuildContext context,
  ) {
    final properties = fabData['properties'] as Map<String, dynamic>? ?? {};
    final iconName = properties['icon'] as String? ?? 'add';
    final backgroundColor =
        properties['backgroundColor'] as String? ?? '#9C27B0';
    final foregroundColor =
        properties['foregroundColor'] as String? ?? '#FFFFFF';
    final tooltip = properties['tooltip'] as String? ?? '';
    final onPressed = properties['onPressed'] as Map<String, dynamic>?;
    final showBadge = properties['showBadge'] as bool? ?? false;

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

    Widget fabChild = Icon(icon);

    // Add cart badge if showBadge is true and icon is shopping_cart
    if (showBadge && iconName.toLowerCase() == 'shopping_cart') {
      fabChild = Obx(() {
        try {
          // Check if CartController is registered before accessing it
          if (!Get.isRegistered<CartController>()) {
            debugPrint(
              'CartController not registered yet, showing icon without badge',
            );
            return Icon(icon);
          }

          final cartController = Get.find<CartController>();
          final itemCount = cartController.totalQuantity;

          return Stack(
            children: [
              Icon(icon),
              if (itemCount > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      itemCount > 99 ? '99+' : itemCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          );
        } catch (e) {
          debugPrint('Error getting cart count for FAB badge: $e');
          return Icon(icon); // Fallback to icon without badge
        }
      });
    }

    return FloatingActionButton(
      onPressed: () => _handleFabAction(onPressed, context),
      backgroundColor: bgColor,
      foregroundColor: fgColor,
      tooltip: tooltip.isNotEmpty ? tooltip : null,
      child: fabChild,
    );
  }

  static void _handleFabAction(
    Map<String, dynamic>? action,
    BuildContext context,
  ) {
    if (action == null) {
      debugPrint('FAB action is null');
      return;
    }

    try {
      final actionType = action['action'] as String?;
      debugPrint('FAB action type: $actionType');

      switch (actionType?.toLowerCase()) {
        case 'navigate':
          final route = action['route'] as String?;
          debugPrint('FAB navigate to route: $route');
          if (route != null) {
            _navigateToRoute(route, context);
          } else {
            debugPrint('FAB route is null');
          }
          break;
        case 'callback':
          // Handle callback actions if needed
          debugPrint('FAB callback action');
          break;
        default:
          debugPrint('Unknown FAB action type: $actionType');
          break;
      }
    } catch (e) {
      debugPrint('Error handling FAB action: $e');
    }
  }

  static void _navigateToRoute(String route, BuildContext context) {
    try {
      debugPrint('Navigating to route: $route');

      switch (route.toLowerCase()) {
        case '/cart':
          // Navigate directly to cart page
          debugPrint('Navigating to cart page');
          Get.toNamed('/cart');
          break;
        case '/home':
          debugPrint('Navigating to home');
          Navigator.of(context).pop();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _switchToTab(context, 0);
          });
          break;
        case '/orders':
          debugPrint('Navigating to orders');
          Navigator.of(context).pop();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _switchToTab(context, 2);
          });
          break;
        case '/bookmarks':
          debugPrint('Navigating to bookmarks');
          Navigator.of(context).pop();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _switchToTab(context, 3);
          });
          break;
        default:
          // Handle other routes or use Navigator
          debugPrint('Using Navigator.pushNamed for route: $route');
          Navigator.of(context).pushNamed(route);
          break;
      }
    } catch (e) {
      debugPrint('Error navigating to route $route: $e');
    }
  }

  static void _switchToTab(BuildContext context, int tabIndex) {
    // This is a simple approach - we'll use a global key or event system
    // For now, let's use GetX to publish an event
    try {
      Get.find<CartController>().update(); // Trigger update to refresh UI
    } catch (e) {
      debugPrint('Error switching tab: $e');
    }
  }

  // Marketplace-specific component builders
  static Widget _buildMarketplaceHeader(UIComponent component, BuildContext context) {
    final properties = component.properties;
    final title = properties['title'] as String? ?? 'Marketplace';
    final subtitle = properties['subtitle'] as String? ?? '';
    final backgroundColor = properties['backgroundColor'] as String? ?? '#F8F9FA';
    final borderRadius = (properties['borderRadius'] as num?)?.toDouble() ?? 12.0;
    final padding = properties['padding'] as Map<String, dynamic>? ?? {};

    return Container(
      padding: _parsePadding(padding),
      decoration: BoxDecoration(
        color: _parseColor(backgroundColor),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ],
      ),
    );
  }

  static Widget _buildMarketplaceSearch(UIComponent component, BuildContext context) {
    final properties = component.properties;
    final placeholder = properties['placeholder'] as String? ?? 'Search...';
    final backgroundColor = properties['backgroundColor'] as String? ?? '#FFFFFF';
    final borderRadius = (properties['borderRadius'] as num?)?.toDouble() ?? 25.0;
    final elevation = (properties['elevation'] as num?)?.toDouble() ?? 2.0;
    final padding = properties['padding'] as Map<String, dynamic>? ?? {};

    return Container(
      padding: _parsePadding(padding),
      decoration: BoxDecoration(
        color: _parseColor(backgroundColor),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: elevation,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) {
          try {
            final controller = Get.find<MarketplaceController>();
            controller.searchShops(value);
          } catch (e) {
            debugPrint('Error searching shops: $e');
          }
        },
        decoration: InputDecoration(
          hintText: placeholder,
          prefixIcon: const Icon(Icons.search),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  static Widget _buildMarketplaceCategories(UIComponent component, BuildContext context) {
    final properties = component.properties;
    final title = properties['title'] as String? ?? 'Categories';
    final showAll = properties['showAll'] as bool? ?? true;
    final scrollDirection = properties['scrollDirection'] as String? ?? 'horizontal';
    final itemSpacing = (properties['itemSpacing'] as num?)?.toDouble() ?? 12.0;
    final padding = properties['padding'] as Map<String, dynamic>? ?? {};

    return GetBuilder<MarketplaceController>(
      builder: (controller) {
        final categories = ShopCategory.values;

        return Padding(
          padding: _parsePadding(padding) ?? EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: scrollDirection == 'horizontal' ? Axis.horizontal : Axis.vertical,
                  itemCount: categories.length + (showAll ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (showAll && index == 0) {
                      return _buildCategoryChip(
                        'All Categories',
                        '🏪',
                        controller.selectedCategory.value == null,
                        () => controller.filterByCategory(null),
                        itemSpacing,
                      );
                    }

                    final categoryIndex = showAll ? index - 1 : index;
                    final category = categories[categoryIndex];
                    return _buildCategoryChip(
                      category.displayName,
                      category.icon,
                      controller.selectedCategory.value == category,
                      () => controller.filterByCategory(category),
                      itemSpacing,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget _buildCategoryChip(
    String label,
    String icon,
    bool isSelected,
    VoidCallback onTap,
    double spacing,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: spacing),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              icon,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildMarketplaceFeaturedShops(UIComponent component, BuildContext context) {
    final properties = component.properties;
    final title = properties['title'] as String? ?? 'Featured Shops';
    final subtitle = properties['subtitle'] as String? ?? '';
    final limit = (properties['limit'] as num?)?.toInt() ?? 5;
    final scrollDirection = properties['scrollDirection'] as String? ?? 'horizontal';
    final itemSpacing = (properties['itemSpacing'] as num?)?.toDouble() ?? 16.0;
    final showRating = properties['showRating'] as bool? ?? true;
    final showVerified = properties['showVerified'] as bool? ?? true;

    return GetBuilder<MarketplaceController>(
      builder: (controller) {
        final featuredShops = controller.getFeaturedShops().take(limit).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    if (subtitle.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ],
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Navigate to all featured shops
                  },
                  child: const Text('See All'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: scrollDirection == 'horizontal' ? Axis.horizontal : Axis.vertical,
                itemCount: featuredShops.length,
                itemBuilder: (context, index) {
                  final shop = featuredShops[index];
                  return _buildShopCard(
                    shop,
                    controller,
                    isFeatured: true,
                    spacing: itemSpacing,
                    showRating: showRating,
                    showVerified: showVerified,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  static Widget _buildMarketplaceAllShops(UIComponent component, BuildContext context) {
    final properties = component.properties;
    final title = properties['title'] as String? ?? 'All Shops';
    final subtitle = properties['subtitle'] as String? ?? '';
    final layout = properties['layout'] as String? ?? 'grid';
    final columns = (properties['columns'] as num?)?.toInt() ?? 2;
    final itemSpacing = (properties['itemSpacing'] as num?)?.toDouble() ?? 16.0;
    final showRating = properties['showRating'] as bool? ?? true;
    final showVerified = properties['showVerified'] as bool? ?? true;
    final showCategory = properties['showCategory'] as bool? ?? true;

    return GetBuilder<MarketplaceController>(
      builder: (controller) {
        final filteredShops = controller.filteredShops;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$title (${filteredShops.length})',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            if (layout == 'grid')
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: itemSpacing,
                  mainAxisSpacing: itemSpacing,
                  childAspectRatio: 0.8,
                ),
                itemCount: filteredShops.length,
                itemBuilder: (context, index) {
                  final shop = filteredShops[index];
                  return _buildShopCard(
                    shop,
                    controller,
                    isFeatured: false,
                    spacing: 0,
                    showRating: showRating,
                    showVerified: showVerified,
                    showCategory: showCategory,
                  );
                },
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredShops.length,
                itemBuilder: (context, index) {
                  final shop = filteredShops[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: itemSpacing),
                    child: _buildShopCard(
                      shop,
                      controller,
                      isFeatured: false,
                      spacing: 0,
                      showRating: showRating,
                      showVerified: showVerified,
                      showCategory: showCategory,
                    ),
                  );
                },
              ),
          ],
        );
      },
    );
  }

  static Widget _buildShopCard(
    Shop shop,
    MarketplaceController controller, {
    bool isFeatured = false,
    double spacing = 16.0,
    bool showRating = true,
    bool showVerified = true,
    bool showCategory = false,
  }) {
    return GestureDetector(
      onTap: () => controller.navigateToShop(shop.id),
      child: Container(
        margin: EdgeInsets.only(right: isFeatured ? spacing : 0),
        width: isFeatured ? 160 : null,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shop logo/image
            Container(
              height: isFeatured ? 80 : 120,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Stack(
                children: [
                  Center(
                    child: shop.logo.isNotEmpty
                        ? Image.network(
                            shop.logo,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.store, size: 40, color: Colors.grey),
                          )
                        : const Icon(Icons.store, size: 40, color: Colors.grey),
                  ),
                  if (showVerified && shop.isVerified)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.verified,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Shop name
                    Text(
                      shop.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Category
                    if (showCategory)
                      Text(
                        controller.getCategoryDisplayName(shop.category),
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    if (showCategory) const SizedBox(height: 8),

                    // Rating
                    if (showRating)
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            shop.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${shop.reviewCount})',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),

                    if (!isFeatured && !showCategory) ...[
                      const SizedBox(height: 8),
                      // Description
                      Text(
                        shop.description,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
