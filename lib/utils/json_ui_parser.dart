import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/ui_models.dart';
import '../utils/widget_mapper.dart';
import '../widgets/orders_list_widget.dart';
import '../widgets/order_statistics_widget.dart';

class JsonUIParser {
  static Widget parseScreen(UIScreen screen, BuildContext context) {
    return Column(
      children: screen.components
          .map((component) => parseComponent(component, context))
          .toList(),
    );
  }

  static Widget parseComponent(UIComponent component, BuildContext context) {
    switch (component.type.toLowerCase()) {
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
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              colorBlendMode: BlendMode.multiply,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: const Color(0xFF2196F3),
                  child: const Center(
                    child: Icon(
                      Icons.broken_image,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                );
              },
            ),
          );
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
    return WidgetMapper.buildCategoryTabs(component, context);
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
    final children =
        component.children
            ?.map((child) => parseComponent(child, context))
            .toList() ??
        [];

    return SingleChildScrollView(child: Column(children: children));
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
        return CrossAxisAlignment.center;
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
    final status = component.properties?['status'] as String? ?? '';
    final title = component.properties?['title'] as String? ?? '';
    final description = component.properties?['description'] as String? ?? '';
    final colorHex = component.properties?['color'] as String? ?? '#2196F3';

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
}
