import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../controllers/marketplace_controller.dart';
import '../controllers/shop_detail_controller.dart';
import '../controllers/expandable_section_controller.dart';
import '../controllers/restaurant_listing_controller.dart';
import '../controllers/cart_controller.dart';
import '../models/restaurant.dart';

/// Stac - Server-Driven UI (SDUI) framework for Flutter
/// Allows building beautiful cross-platform applications with JSON in real time
class Stac {
  /// Parse JSON into Flutter widgets using Stac format
  static Widget fromJson(Map<String, dynamic> json, BuildContext context) {
    return _parseComponent(json, context);
  }

  static Widget _parseComponent(Map<String, dynamic> json, BuildContext context) {
    final String type = json['type'] as String;
    final Map<String, dynamic>? action = json['action'] as Map<String, dynamic>?;

    Widget widget;
    switch (type.toLowerCase()) {
      case 'scaffold':
        widget = _buildScaffold(json, context);
        break;
      case 'singlechildscrollview':
        widget = _buildSingleChildScrollView(json, context);
        break;
      case 'padding':
        widget = _buildPadding(json, context);
        break;
      case 'column':
        widget = _buildColumn(json, context);
        break;
      case 'row':
        widget = _buildRow(json, context);
        break;
      case 'container':
        widget = _buildContainer(json, context);
        break;
      case 'text':
        widget = _buildText(json, context);
        break;
      case 'icon':
        widget = _buildIcon(json, context);
        break;
      case 'iconbutton':
        widget = _buildIconButton(json, context);
        break;
      case 'image':
        widget = _buildImage(json, context);
        break;
      case 'lottie':
        widget = _buildLottie(json, context);
        break;
      case 'sizedbox':
        widget = _buildSizedBox(json, context);
        break;
      case 'spacer':
        widget = _buildSpacer(json, context);
        break;
      case 'expanded':
        widget = _buildExpanded(json, context);
        break;
      case 'center':
        widget = _buildCenter(json, context);
        break;
      case 'listview':
        widget = _buildListView(json, context);
        break;
      case 'gridview':
        widget = _buildGridView(json, context);
        break;
      case 'marketplace_categories':
        widget = _buildMarketplaceCategories(json, context);
        break;
      case 'marketplace_shops':
        widget = _buildMarketplaceShops(json, context);
        break;
      case 'marketplace_search':
        widget = _buildMarketplaceSearch(json, context);
        break;
      case 'customscrollview':
        widget = _buildCustomScrollView(json, context);
        break;
      case 'sliverappbar':
        widget = _buildSliverAppBar(json, context);
        break;
      case 'slivertoboxadapter':
        widget = _buildSliverToBoxAdapter(json, context);
        break;
      case 'dynamic_text':
        widget = _buildDynamicText(json, context);
        break;
      case 'dynamic_image':
        widget = _buildDynamicImage(json, context);
        break;
      case 'dynamic_icon':
        widget = _buildDynamicIcon(json, context);
        break;
      case 'flexiblespacebar':
        widget = _buildFlexibleSpaceBar(json, context);
        break;
      case 'expandablesection':
        widget = _buildExpandableSection(json, context);
        break;
      case 'dynamicfilterchips':
        widget = _buildDynamicFilterChips(json, context);
        break;
      case 'margin':
        widget = _buildMargin(json, context);
        break;
      case 'textfield':
        widget = _buildTextField(json, context);
        break;
      case 'sliverlist':
        widget = _buildSliverList(json, context);
        break;
      case 'stack':
        widget = _buildStack(json, context);
        break;
      case 'positioned':
        widget = _buildPositioned(json, context);
        break;
      case 'appbar':
        widget = _buildAppBar(json, context);
        break;
      case 'pageview':
        widget = _buildPageView(json, context);
        break;
      case 'divider':
        widget = _buildDivider(json, context);
        break;
      case 'dynamic_shop_list':
        widget = _buildDynamicShopList(json, context);
        break;
      case 'dynamic_restaurant_list':
        widget = _buildDynamicRestaurantList(json, context);
        break;
      case 'dynamic_product_grid':
      case 'dynamicproductgrid':
        widget = _buildDynamicProductGrid(json, context);
        break;
      default:
        // Log unknown components for debugging
        debugPrint('Unknown component type: $type');
        widget = Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.red[50],
            border: Border.all(color: Colors.red[300]!),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, color: Colors.red[700], size: 16),
              const SizedBox(height: 4),
              Text(
                'Unknown component: $type',
                style: TextStyle(color: Colors.red[700], fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
        break;
    }

    // Handle actions by wrapping widget with GestureDetector if action is present
    if (action != null) {
      return GestureDetector(
        onTap: () => _handleAction(action, context),
        child: widget,
      );
    }

    return widget;
  }

  static Widget _buildScaffold(Map<String, dynamic> json, BuildContext context) {
    final body = json['body'];
    final appBar = json['appBar'];
    return Scaffold(
      appBar: appBar != null ? _buildAppBar(appBar, context) as PreferredSizeWidget : null,
      body: body != null ? _parseComponent(body, context) : Container(),
    );
  }

  static Widget _buildSingleChildScrollView(Map<String, dynamic> json, BuildContext context) {
    final child = json['child'];
    final scrollDirection = json['scrollDirection'] as String?;
    final padding = json['padding'] as Map<String, dynamic>?;

    return SingleChildScrollView(
      scrollDirection: scrollDirection == 'horizontal' ? Axis.horizontal : Axis.vertical,
      padding: _parseEdgeInsets(padding),
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
    final mainAxisSize = json['mainAxisSize'] as String?;
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
      mainAxisSize: _parseMainAxisSize(mainAxisSize),
      children: widgets,
    );
  }

  static Widget _buildContainer(Map<String, dynamic> json, BuildContext context) {
    final child = json['child'];
    final width = _parseNumericValue(json['width']);
    final height = _parseNumericValue(json['height']);
    final padding = json['padding'] as Map<String, dynamic>?;
    final decoration = json['decoration'] as Map<String, dynamic>?;
    final clipBehavior = json['clipBehavior'] as String?;
    final Map<String, dynamic>? action = json['action'] as Map<String, dynamic>?;

    Widget? containerChild = child != null ? _parseComponent(child, context) : null;

    // Handle clipBehavior
    if (clipBehavior == 'hardEdge' && containerChild != null) {
      containerChild = ClipRRect(
        borderRadius: _parseBorderRadius(decoration?['borderRadius']) ?? BorderRadius.zero,
        child: containerChild,
      );
    }

    Widget container = Container(
      width: width?.toDouble(),
      height: height?.toDouble(),
      padding: _parseEdgeInsets(padding),
      decoration: _parseBoxDecoration(decoration),
      child: containerChild,
    );

    // Wrap with GestureDetector if action is provided
    if (action != null) {
      return GestureDetector(
        onTap: () => _handleAction(action, context),
        child: container,
      );
    }

    return container;
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

  static Widget _buildIconButton(Map<String, dynamic> json, BuildContext context) {
    final icon = json['icon'] as String?;
    final size = json['size'] as num?;
    final color = json['color'] as String?;
    final Map<String, dynamic>? action = json['action'] as Map<String, dynamic>?;

    return IconButton(
      icon: Icon(
        _parseIconData(icon),
        size: size?.toDouble(),
        color: _parseColor(color),
      ),
      onPressed: action != null ? () => _handleAction(action, context) : null,
    );
  }

  static Widget _buildImage(Map<String, dynamic> json, BuildContext context) {
    final src = json['src'] as String? ?? '';
    final width = json['width'] as num?;
    final height = json['height'] as num?;
    final fit = json['fit'] as String? ?? 'cover';
    final opacity = json['opacity'] as num? ?? 1.0;

    if (src.isEmpty) {
      return Container(
        width: width?.toDouble(),
        height: height?.toDouble(),
        color: Colors.grey[300],
        child: const Icon(Icons.image, color: Colors.grey),
      );
    }

    Widget imageWidget = Image.network(
      src,
      width: width?.toDouble(),
      height: height?.toDouble(),
      fit: _parseBoxFit(fit),
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width?.toDouble(),
          height: height?.toDouble(),
          color: Colors.grey[300],
          child: const Icon(Icons.broken_image, color: Colors.grey),
        );
      },
    );

    // Apply opacity if specified
    if (opacity < 1.0) {
      imageWidget = Opacity(
        opacity: opacity.toDouble(),
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  static BoxFit _parseBoxFit(String fit) {
    switch (fit.toLowerCase()) {
      case 'contain':
        return BoxFit.contain;
      case 'cover':
        return BoxFit.cover;
      case 'fill':
        return BoxFit.fill;
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

  static Widget _buildLottie(Map<String, dynamic> json, BuildContext context) {
    final src = json['src'] as String? ?? '';
    final width = json['width'] as num?;
    final height = json['height'] as num?;
    final fit = json['fit'] as String? ?? 'contain';
    final repeat = json['repeat'] as bool? ?? true;
    final animate = json['animate'] as bool? ?? true;

    if (src.isEmpty) {
      return Container(
        width: width?.toDouble(),
        height: height?.toDouble(),
        color: Colors.grey[300],
        child: const Icon(Icons.animation, color: Colors.grey),
      );
    }

    // Determine if src is a local asset or network URL
    final isNetworkUrl = src.startsWith('http://') || src.startsWith('https://');

    Widget lottieWidget;

    if (isNetworkUrl) {
      // Use Lottie.network for remote URLs
      lottieWidget = Lottie.network(
        src,
        fit: _parseBoxFit(fit),
        repeat: repeat,
        animate: animate,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width?.toDouble(),
            height: height?.toDouble(),
            color: Colors.grey[300],
            child: const Icon(Icons.broken_image, color: Colors.grey),
          );
        },
      );
    } else {
      // Use Lottie.asset for local assets
      lottieWidget = Lottie.asset(
        src,
        fit: _parseBoxFit(fit),
        repeat: repeat,
        animate: animate,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width?.toDouble(),
            height: height?.toDouble(),
            color: Colors.grey[300],
            child: const Icon(Icons.broken_image, color: Colors.grey),
          );
        },
      );
    }

    return SizedBox(
      width: width?.toDouble(),
      height: height?.toDouble(),
      child: lottieWidget,
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

  static Widget _buildDivider(Map<String, dynamic> json, BuildContext context) {
    final color = json['color'] as String?;
    final thickness = json['thickness'] as num?;
    final height = json['height'] as num?;

    return Divider(
      color: color != null ? _parseColor(color) : null,
      thickness: thickness?.toDouble(),
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
    final padding = json['padding'] as Map<String, dynamic>?;

    return ListView.separated(
      scrollDirection: scrollDirection == 'horizontal' ? Axis.horizontal : Axis.vertical,
      padding: _parseEdgeInsets(padding),
      itemCount: children.length,
      separatorBuilder: (context, index) => scrollDirection == 'horizontal'
          ? SizedBox(width: spacing?.toDouble() ?? 0)
          : SizedBox(height: spacing?.toDouble() ?? 0),
      itemBuilder: (context, index) => _parseComponent(children[index], context),
    );
  }

  static Widget _buildDynamicShopList(Map<String, dynamic> json, BuildContext context) {
    final scrollDirection = json['scrollDirection'] as String? ?? 'horizontal';
    final height = json['height'] as num? ?? 280;
    final padding = json['padding'] as Map<String, dynamic>?;
    final template = json['template'] as Map<String, dynamic>?;
    final dataSource = json['dataSource'] as String? ?? 'topRatedShops';

    if (template == null) {
      return Container(
        height: height.toDouble(),
        child: const Center(
          child: Text('No template provided for dynamic shop list'),
        ),
      );
    }

    // Get mock data based on dataSource
    final List<Map<String, dynamic>> shopData = _getShopData(dataSource);

    return Container(
      height: height.toDouble(),
      child: ListView.separated(
        scrollDirection: scrollDirection == 'horizontal' ? Axis.horizontal : Axis.vertical,
        padding: _parseEdgeInsets(padding),
        itemCount: shopData.length,
        separatorBuilder: (context, index) => scrollDirection == 'horizontal'
            ? const SizedBox(width: 10)
            : const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final shop = shopData[index];
          // Replace template placeholders with actual data
          final populatedTemplate = _populateTemplate(template, shop);
          return _parseComponent(populatedTemplate, context);
        },
      ),
    );
  }

  static Widget _buildDynamicRestaurantList(Map<String, dynamic> json, BuildContext context) {
    final padding = json['padding'] as Map<String, dynamic>?;
    final dataSource = json['dataSource'] as String? ?? 'restaurants';

    // Try to get GetX controller for real-time data
    try {
      final controller = Get.find<RestaurantListingController>();

      debugPrint('🎯 [GETX_INTEGRATION] Using RestaurantListingController with ${controller.filteredRestaurants.length} restaurants');

      return Padding(
        padding: _parseEdgeInsets(padding) ?? EdgeInsets.zero,
        child: Obx(() {
          final restaurants = controller.filteredRestaurants;

          if (restaurants.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text(
                  'No restaurants found',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: restaurants.length,
            itemBuilder: (context, index) {
              final restaurant = restaurants[index];
              return _buildRestaurantCardFromModel(restaurant, context);
            },
          );
        }),
      );
    } catch (e) {
      // Fallback to mock data if controller not found
      debugPrint('⚠️ [GETX_FALLBACK] RestaurantListingController not found, using mock data: $e');
      final List<Map<String, dynamic>> restaurantData = _getRestaurantData(dataSource);

      return Padding(
        padding: _parseEdgeInsets(padding) ?? EdgeInsets.zero,
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: restaurantData.length,
          itemBuilder: (context, index) {
            final restaurant = restaurantData[index];
            return _buildRestaurantCard(restaurant, context);
          },
        ),
      );
    }
  }

  static Widget _buildDynamicProductGrid(Map<String, dynamic> json, BuildContext context) {
    final crossAxisCount = json['crossAxisCount'] as int? ?? 2;
    final crossAxisSpacing = json['crossAxisSpacing'] as num? ?? 8;
    final mainAxisSpacing = json['mainAxisSpacing'] as num? ?? 8;
    final padding = json['padding'] as Map<String, dynamic>?;
    final template = json['template'] as Map<String, dynamic>?;
    final dataSource = json['dataSource'] as String? ?? 'shopProducts';

    if (template == null) {
      return Container(
        height: 200,
        child: const Center(
          child: Text('No template provided for dynamic product grid'),
        ),
      );
    }

    // Get mock product data based on dataSource
    final List<Map<String, dynamic>> productData = _getProductData(dataSource);

    return Padding(
      padding: _parseEdgeInsets(padding) ?? EdgeInsets.zero,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: crossAxisSpacing.toDouble(),
          mainAxisSpacing: mainAxisSpacing.toDouble(),
          childAspectRatio: 0.75, // Adjust based on your design
        ),
        itemCount: productData.length,
        itemBuilder: (context, index) {
          final product = productData[index];
          // Replace template placeholders with actual data
          final populatedTemplate = _populateTemplate(template, product);
          return _parseComponent(populatedTemplate, context);
        },
      ),
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

    if (padding.containsKey('horizontal') || padding.containsKey('vertical')) {
      final horizontal = (padding['horizontal'] as num?)?.toDouble() ?? 0;
      final vertical = (padding['vertical'] as num?)?.toDouble() ?? 0;
      return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
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

  static MainAxisSize _parseMainAxisSize(String? size) {
    switch (size) {
      case 'min':
        return MainAxisSize.min;
      case 'max':
        return MainAxisSize.max;
      default:
        return MainAxisSize.max;
    }
  }

  static BoxDecoration? _parseBoxDecoration(Map<String, dynamic>? decoration) {
    if (decoration == null) return null;

    return BoxDecoration(
      color: _parseColor(decoration['color']),
      gradient: _parseGradient(decoration['gradient']),
      borderRadius: _parseBorderRadius(decoration['borderRadius']),
      border: _parseBorder(decoration['border']),
      boxShadow: _parseBoxShadow(decoration['boxShadow']),
      image: _parseDecorationImage(decoration['image']),
    );
  }

  static DecorationImage? _parseDecorationImage(Map<String, dynamic>? image) {
    if (image == null) return null;

    final src = image['src'] as String?;
    if (src == null || src.isEmpty) return null;

    final fit = image['fit'] as String? ?? 'cover';
    final opacity = image['opacity'] as num? ?? 1.0;
    final alignment = image['alignment'] as String? ?? 'center';

    ImageProvider imageProvider;

    // Determine if src is a local asset or network URL
    if (src.startsWith('http://') || src.startsWith('https://')) {
      imageProvider = NetworkImage(src);
    } else {
      imageProvider = AssetImage(src);
    }

    return DecorationImage(
      image: imageProvider,
      fit: _parseBoxFit(fit),
      opacity: opacity.toDouble(),
      alignment: _parseAlignment(alignment) ?? Alignment.center,
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

  static Gradient? _parseGradient(Map<String, dynamic>? gradient) {
    if (gradient == null) return null;

    final type = gradient['type'] as String?;
    final colors = gradient['colors'] as List<dynamic>?;
    final begin = gradient['begin'] as String?;
    final end = gradient['end'] as String?;

    if (colors == null || colors.isEmpty) return null;

    final gradientColors = colors
        .map((color) => _parseColor(color))
        .where((color) => color != null)
        .cast<Color>()
        .toList();

    if (gradientColors.isEmpty) return null;

    switch (type) {
      case 'linear':
        return LinearGradient(
          colors: gradientColors,
          begin: _parseAlignment(begin) ?? Alignment.topLeft,
          end: _parseAlignment(end) ?? Alignment.bottomRight,
        );
      case 'radial':
        return RadialGradient(
          colors: gradientColors,
        );
      default:
        return LinearGradient(colors: gradientColors);
    }
  }

  static Alignment? _parseAlignment(String? alignment) {
    if (alignment == null) return null;

    switch (alignment.toLowerCase()) {
      case 'topleft':
        return Alignment.topLeft;
      case 'topcenter':
        return Alignment.topCenter;
      case 'topright':
        return Alignment.topRight;
      case 'centerleft':
        return Alignment.centerLeft;
      case 'center':
        return Alignment.center;
      case 'centerright':
        return Alignment.centerRight;
      case 'bottomleft':
        return Alignment.bottomLeft;
      case 'bottomcenter':
        return Alignment.bottomCenter;
      case 'bottomright':
        return Alignment.bottomRight;
      default:
        return Alignment.center;
    }
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
      case 'delivery_dining':
        return Icons.delivery_dining;
      case 'verified':
        return Icons.verified;
      case 'restaurant':
        return Icons.restaurant;
      case 'restaurant_menu':
        return Icons.restaurant_menu;
      case 'local_offer':
        return Icons.local_offer;
      case 'eco':
        return Icons.eco;
      case 'local_shipping':
        return Icons.local_shipping;
      case 'shopping_cart':
        return Icons.shopping_cart;
      case 'flash_on':
        return Icons.flash_on;
      case 'takeout_dining':
        return Icons.takeout_dining;
      case 'person':
        return Icons.person;
      case 'mic':
        return Icons.mic;
      case 'notifications':
        return Icons.notifications;
      case 'favorite':
        return Icons.favorite;
      case 'favorite_border':
        return Icons.favorite_border;
      case 'history':
        return Icons.history;
      case 'support_agent':
        return Icons.support_agent;
      case 'trending_up':
        return Icons.trending_up;
      case 'location_on':
        return Icons.location_on;
      default:
        return Icons.help_outline;
    }
  }

  // Marketplace-specific components
  static Widget _buildMarketplaceCategories(Map<String, dynamic> json, BuildContext context) {
    final controller = Get.find<MarketplaceController>();

    return Container(
      height: 100,
      child: Obx(() {
        // Explicitly access observable properties to register dependencies
        final categories = controller.categories;
        final selectedCategory = controller.selectedCategory.value;

        return ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          separatorBuilder: (context, index) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected = selectedCategory == category;

          return GestureDetector(
            onTap: () {
              controller.selectCategory(category);
              Get.toNamed('/category', arguments: {'category': category});
            },
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
      );
      }),
    );
  }

  static Widget _buildMarketplaceShops(Map<String, dynamic> json, BuildContext context) {
    final controller = Get.find<MarketplaceController>();
    final isFeatured = json['featured'] as bool? ?? false;

    return Obx(() {
      // Explicitly access observable properties to ensure GetX detects dependencies
      controller.shops.length; // Access shops to register dependency
      controller.selectedCategory.value; // Access selectedCategory to register dependency
      controller.searchQuery.value; // Access searchQuery to register dependency

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
        // Navigate to home view with shop context using MarketplaceController
        final controller = Get.find<MarketplaceController>();
        controller.navigateToShop(shop.id);
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

  // Sliver components for advanced scrolling layouts
  static Widget _buildCustomScrollView(Map<String, dynamic> json, BuildContext context) {
    final slivers = json['slivers'] as List<dynamic>? ?? [];

    List<Widget> sliverWidgets = slivers
        .map((sliver) => _parseComponent(sliver, context))
        .where((widget) => widget is Widget)
        .map((widget) => _ensureSliver(widget))
        .toList();

    return CustomScrollView(
      slivers: sliverWidgets,
    );
  }

  static Widget _ensureSliver(Widget widget) {
    if (widget is SliverList ||
        widget is SliverGrid ||
        widget is SliverPadding ||
        widget is SliverToBoxAdapter ||
        widget is SliverAppBar ||
        widget is SliverFillRemaining ||
        widget is SliverFixedExtentList) {
      return widget;
    } else {
      return SliverToBoxAdapter(child: widget);
    }
  }

  static Widget _buildSliverAppBar(Map<String, dynamic> json, BuildContext context) {
    final expandedHeight = json['expandedHeight'] as num?;
    final floating = json['floating'] as bool? ?? false;
    final pinned = json['pinned'] as bool? ?? false;
    final flexibleSpace = json['flexibleSpace'];
    final borderRadius = json['borderRadius'] as num?;
    final backgroundColor = json['backgroundColor'] as String?;
    final foregroundColor = json['foregroundColor'] as String?;
    final elevation = json['elevation'] as num?;
    final toolbarHeight = json['toolbarHeight'] as num?;
    final leading = json['leading'];
    final actions = json['actions'] as List<dynamic>?;

    return SliverAppBar(
      expandedHeight: expandedHeight?.toDouble(),
      floating: floating,
      pinned: pinned,
      backgroundColor: backgroundColor != null ? _parseColor(backgroundColor) : Colors.transparent,
      foregroundColor: foregroundColor != null ? _parseColor(foregroundColor) : null,
      elevation: elevation?.toDouble() ?? 0,
      toolbarHeight: toolbarHeight?.toDouble() ?? kToolbarHeight,
      leading: leading != null ? _parseComponent(leading, context) : null,
      actions: actions?.map((action) => _parseComponent(action, context)).toList(),
      flexibleSpace: flexibleSpace != null
        ? (borderRadius != null
          ? ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(borderRadius.toDouble()),
                bottomRight: Radius.circular(borderRadius.toDouble()),
              ),
              child: _parseComponent(flexibleSpace, context),
            )
          : _parseComponent(flexibleSpace, context))
        : null,
    );
  }

  static Widget _buildSliverToBoxAdapter(Map<String, dynamic> json, BuildContext context) {
    final child = json['child'];

    return SliverToBoxAdapter(
      child: child != null ? _parseComponent(child, context) : const SizedBox(),
    );
  }

  static Widget _buildFlexibleSpaceBar(Map<String, dynamic> json, BuildContext context) {
    final background = json['background'];

    return FlexibleSpaceBar(
      background: background != null ? _parseComponent(background, context) : null,
    );
  }

  static Widget _buildExpandableSection(Map<String, dynamic> json, BuildContext context) {
    final title = json['title'] as String? ?? '';
    final isExpanded = json['isExpanded'] as bool? ?? false;
    final content = json['content'];

    // Create a unique section ID based on title
    final sectionId = title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_');

    // Get or create the expandable section controller
    ExpandableSectionController controller;
    try {
      controller = Get.find<ExpandableSectionController>();
    } catch (e) {
      controller = Get.put(ExpandableSectionController());
    }

    // Initialize the section with default state
    controller.initializeSection(sectionId, isExpanded);

    return Obx(() {
      final expanded = controller.isExpanded(sectionId);

      return Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: GestureDetector(
              onTap: () {
                controller.toggleSection(sectionId);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  Icon(
                    expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: Colors.grey[600],
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: expanded ? null : 0,
            child: expanded && content != null
                ? _parseComponent(content, context)
                : const SizedBox(),
          ),
        ],
      );
    });
  }

  static Widget _buildDynamicFilterChips(Map<String, dynamic> json, BuildContext context) {
    final padding = json['padding'] as Map<String, dynamic>?;

    // Get the shop detail controller for filter state
    try {
      final controller = Get.find<ShopDetailController>();

      return Obx(() {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: _parseEdgeInsets(padding),
          child: Row(
            children: controller.availableFilters.map((filter) {
              final isSelected = controller.selectedFilters.contains(filter);

              return Container(
                margin: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => controller.toggleFilter(filter),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFE8F5E8) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF4CAF50) : const Color(0xFFE0E0E0),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (filter == 'Pure Veg' && isSelected) ...[
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: const Color(0xFF4CAF50),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: const Color(0xFF4CAF50),
                                width: 2,
                              ),
                            ),
                            child: Container(
                              margin: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4CAF50),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          filter,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? const Color(0xFF4CAF50) : const Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      });
    } catch (e) {
      // Fallback if controller not found
      return Container(
        padding: const EdgeInsets.all(16),
        child: const Text(
          'Filter controller not available',
          style: TextStyle(color: Colors.red),
        ),
      );
    }
  }

  static Widget _buildMargin(Map<String, dynamic> json, BuildContext context) {
    final margin = json['margin'] as Map<String, dynamic>?;
    final child = json['child'];

    return Container(
      margin: _parseEdgeInsets(margin),
      child: child != null ? _parseComponent(child, context) : const SizedBox(),
    );
  }

  static void _handleAction(Map<String, dynamic> action, BuildContext context) {
    final String actionType = action['type'] as String? ?? '';

    switch (actionType) {
      case 'navigate':
        final String route = action['route'] as String? ?? '';
        final Map<String, dynamic>? parameters = action['parameters'] as Map<String, dynamic>?;
        if (route.isNotEmpty) {
          if (parameters != null) {
            Get.toNamed(route, parameters: parameters.map((key, value) => MapEntry(key, value.toString())));
          } else {
            Get.toNamed(route);
          }
        }
        break;
      case 'navigate_to_category':
        final String categoryName = action['categoryName'] as String? ?? '';
        if (categoryName.isNotEmpty) {
          Get.toNamed('/category', parameters: {'categoryName': categoryName});
        }
        break;
      case 'navigate_to_offers':
        Get.toNamed('/offers');
        break;
      case 'navigate_to_shop':
        final String shopId = action['shopId'] as String? ?? '';
        if (shopId.isNotEmpty) {
          final controller = Get.find<MarketplaceController>();
          controller.navigateToShop(shopId);
        }
        break;
      case 'navigate_to_search':
        Get.toNamed('/search');
        break;
      case 'show_filter_sheet':
        try {
          final controller = Get.find<RestaurantListingController>();
          controller.showFilterBottomSheet(context);
        } catch (e) {
          debugPrint('RestaurantListingController not found for filter sheet');
        }
        break;
      case 'show_sort_sheet':
        try {
          final controller = Get.find<RestaurantListingController>();
          controller.showSortBottomSheet(context);
        } catch (e) {
          debugPrint('RestaurantListingController not found for sort sheet');
        }
        break;
      case 'toggle_filter':
        try {
          final controller = Get.find<RestaurantListingController>();
          final filterType = action['filter'] as String?;
          if (filterType != null) {
            _handleFilterToggle(controller, filterType);
          }
        } catch (e) {
          debugPrint('RestaurantListingController not found for filter toggle');
        }
        break;
      case 'toggle_favorite':
        try {
          final controller = Get.find<RestaurantListingController>();
          final restaurantId = action['restaurantId'] as String?;
          if (restaurantId != null) {
            controller.toggleFavorite(restaurantId);
          }
        } catch (e) {
          debugPrint('RestaurantListingController not found for favorite toggle');
        }
        break;
      case 'navigate_to_restaurant':
        try {
          final controller = Get.find<RestaurantListingController>();
          final restaurantId = action['restaurantId'] as String?;
          if (restaurantId != null) {
            controller.navigateToRestaurant(restaurantId);
          }
        } catch (e) {
          debugPrint('RestaurantListingController not found for restaurant navigation');
        }
        break;
      case 'navigate_back':
        Get.back();
        break;
      case 'add_to_cart':
        final String productId = action['productId'] as String? ?? '';
        final String variantId = action['variantId'] as String? ?? '';
        final int quantity = action['quantity'] as int? ?? 1;
        final String shopId = action['shopId'] as String? ?? '';
        final String shopName = action['shopName'] as String? ?? '';

        debugPrint('🛒 [ADD_TO_CART] Adding product: $productId, variant: $variantId, quantity: $quantity');
        debugPrint('🏪 [ADD_TO_CART] Shop: $shopName ($shopId)');

        if (productId.isNotEmpty) {
          try {
            // Try to use CartController directly for better integration
            final cartController = Get.find<CartController>();

            // Add to cart using CartController
            cartController.addToCart(
              productId,
              variantId,
              quantity: quantity,
              shopId: shopId,
              shopName: shopName,
            ).then((success) {
              if (success) {
                debugPrint('✅ [ADD_TO_CART] Successfully added to cart');
                debugPrint('📊 [CART_STATE] Total items: ${cartController.itemCount}');
                debugPrint('💰 [CART_STATE] Total price: ${cartController.formattedTotal}');
              } else {
                debugPrint('❌ [ADD_TO_CART] Failed to add to cart');
              }
            }).catchError((error) {
              debugPrint('❌ [ADD_TO_CART] Error: $error');
            });

          } catch (e) {
            debugPrint('❌ [ADD_TO_CART] Error adding to cart: $e');

            // Fallback to ShopDetailController
            try {
              final controller = Get.find<ShopDetailController>();
              controller.addToCart(productId);
              debugPrint('✅ [ADD_TO_CART] Fallback: Used ShopDetailController');
            } catch (e2) {
              debugPrint('❌ [ADD_TO_CART] Both controllers failed: $e2');
            }
          }
        }
        break;
      case 'show_menu':
        // Handle menu action
        debugPrint('Show menu action triggered');
        break;
      case 'showSearch':
        // Handle search action
        debugPrint('Show search action triggered');
        break;
      case 'showFilter':
        // Handle filter action
        debugPrint('Show filter action triggered');
        break;
      case 'showMenu':
        // Handle menu action
        final List<dynamic>? items = action['items'] as List<dynamic>?;
        debugPrint('Show menu action triggered with items: $items');
        break;

      case 'open_search':
        try {
          final controller = Get.find<ShopDetailController>();
          // TODO: Implement search dialog or navigation
          debugPrint('Open search action triggered');
        } catch (e) {
          debugPrint('ShopDetailController not found for search');
        }
        break;
      case 'voice_search':
        try {
          final controller = Get.find<ShopDetailController>();
          // TODO: Implement voice search functionality
          debugPrint('Voice search action triggered');
        } catch (e) {
          debugPrint('ShopDetailController not found for voice search');
        }
        break;
      case 'show_location_modal':
        // TODO: Implement location modal
        debugPrint('Show location modal action triggered');
        break;
      default:
        debugPrint('Unknown action type: $actionType');
        break;
    }
  }

  static Widget _buildTextField(Map<String, dynamic> json, BuildContext context) {
    final decoration = json['decoration'] as Map<String, dynamic>?;
    final hintText = decoration?['hintText'] as String?;
    final prefixIcon = decoration?['prefixIcon'] as String?;
    final suffixIcon = decoration?['suffixIcon'] as String?;
    final filled = decoration?['filled'] as bool? ?? false;
    final fillColor = decoration?['fillColor'] as String?;
    final borderRadius = decoration?['borderRadius'] as num?;

    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon != null ? Icon(_parseIconData(prefixIcon)) : null,
        suffixIcon: suffixIcon != null ? Icon(_parseIconData(suffixIcon)) : null,
        filled: filled,
        fillColor: _parseColor(fillColor),
        border: decoration?['border'] == 'none'
            ? InputBorder.none
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius?.toDouble() ?? 4),
              ),
        enabledBorder: decoration?['border'] == 'none'
            ? InputBorder.none
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius?.toDouble() ?? 4),
                borderSide: BorderSide.none,
              ),
        focusedBorder: decoration?['border'] == 'none'
            ? InputBorder.none
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius?.toDouble() ?? 4),
                borderSide: BorderSide.none,
              ),
      ),
    );
  }

  static Widget _buildSliverList(Map<String, dynamic> json, BuildContext context) {
    final dataSource = json['dataSource'] as String?;
    final template = json['template'] as Map<String, dynamic>?;

    if (dataSource == 'filtered_restaurants' && template != null) {
      try {
        final controller = Get.find<RestaurantListingController>();
        return Obx(() {
          final restaurants = controller.filteredRestaurants;

          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index >= restaurants.length) return null;

                final restaurant = restaurants[index];
                final populatedTemplate = _populateRestaurantTemplate(template, restaurant);

                return GestureDetector(
                  onTap: () => controller.navigateToRestaurant(restaurant.id),
                  child: _parseComponent(populatedTemplate, context),
                );
              },
              childCount: restaurants.length,
            ),
          );
        });
      } catch (e) {
        debugPrint('RestaurantListingController not found for sliverList: $e');
      }
    }

    // Fallback to original implementation
    final delegate = json['delegate'] as Map<String, dynamic>?;
    final itemCount = delegate?['itemCount'] as int? ?? 0;

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return _buildProductItem(index, context);
        },
        childCount: itemCount,
      ),
    );
  }

  static Widget _buildStack(Map<String, dynamic> json, BuildContext context) {
    final children = json['children'] as List<dynamic>? ?? [];

    return Stack(
      children: children.map((child) => _parseComponent(child, context)).toList(),
    );
  }

  static Widget _buildPositioned(Map<String, dynamic> json, BuildContext context) {
    final child = json['child'];
    final top = json['top'] as num?;
    final bottom = json['bottom'] as num?;
    final left = json['left'] as num?;
    final right = json['right'] as num?;

    return Positioned(
      top: top?.toDouble(),
      bottom: bottom?.toDouble(),
      left: left?.toDouble(),
      right: right?.toDouble(),
      child: child != null ? _parseComponent(child, context) : const SizedBox(),
    );
  }

  static Widget _buildAppBar(Map<String, dynamic> json, BuildContext context) {
    final title = json['title'] as String?;
    final backgroundColor = json['backgroundColor'] as String?;
    final foregroundColor = json['foregroundColor'] as String?;
    final elevation = json['elevation'] as num?;
    final actions = json['actions'] as List<dynamic>?;
    final leading = json['leading'] as Map<String, dynamic>?;

    debugPrint('🔧 [APPBAR_BUILD] Building AppBar with leading: $leading');

    return AppBar(
      title: title != null ? Text(title) : null,
      backgroundColor: _parseColor(backgroundColor),
      foregroundColor: _parseColor(foregroundColor),
      elevation: elevation?.toDouble(),
      leading: leading != null ? _parseComponent(leading, context) : null,
      actions: actions?.map((action) => _parseComponent(action, context)).toList(),
    );
  }

  static Widget _buildProductItem(int index, BuildContext context) {
    // Placeholder product item for shop page
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.fastfood, color: Colors.grey),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Product ${index + 1}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Description for product ${index + 1}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '₹${(index + 1) * 50}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4CAF50),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'ADD',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildPageView(Map<String, dynamic> json, BuildContext context) {
    final children = json['children'] as List<dynamic>? ?? [];
    final height = json['height'] as num? ?? 200;
    final autoPlay = json['autoPlay'] as bool? ?? true;
    final autoPlayInterval = json['autoPlayInterval'] as int? ?? 3000; // milliseconds
    final viewportFraction = json['viewportFraction'] as num? ?? 1.0;
    final enableInfiniteScroll = json['enableInfiniteScroll'] as bool? ?? true;

    final PageController pageController = PageController(
      viewportFraction: viewportFraction.toDouble(),
    );

    // Auto-play functionality
    if (autoPlay && children.isNotEmpty) {
      Timer.periodic(Duration(milliseconds: autoPlayInterval), (timer) {
        if (pageController.hasClients) {
          final currentPage = pageController.page?.round() ?? 0;
          final nextPage = enableInfiniteScroll
              ? (currentPage + 1) % children.length
              : (currentPage + 1).clamp(0, children.length - 1);

          pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
    }

    return SizedBox(
      height: height.toDouble(),
      child: PageView.builder(
        controller: pageController,
        itemCount: enableInfiniteScroll ? null : children.length,
        itemBuilder: (context, index) {
          final actualIndex = enableInfiniteScroll
              ? index % children.length
              : index;

          if (actualIndex >= children.length) return Container();

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: _parseComponent(children[actualIndex], context),
          );
        },
      ),
    );
  }

  // Helper method to get mock shop data
  static List<Map<String, dynamic>> _getShopData(String dataSource) {
    switch (dataSource) {
      case 'topRatedShops':
        return [
          {
            'name': 'Spice Garden',
            'rating': '4.5',
            'deliveryTime': '25-30 mins',
            'cuisine': 'Biryani • Kebabs • Naan',
            'image': 'https://p16-capcut-sign-sg.ibyteimg.com/tos-alisg-v-643f9f/oABEZYfLA5sIziAXvN6BBAIGiTIABEJwWICAFi~tplv-4d650qgzx3-image.image?lk3s=2d54f6b1&x-expires=1785542030&x-signature=OEXhCIkLDoxzwszr3K4XhmgQ3K8%3D',
            'shopId': 'spice-garden'
          },
          {
            'name': 'Pizza Corner',
            'rating': '4.3',
            'deliveryTime': '20-25 mins',
            'cuisine': 'Pizza • Pasta • Garlic Bread',
            'image': 'https://images.unsplash.com/photo-1513104890138-7c749659a591?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80',
            'shopId': 'pizza-corner'
          },
          {
            'name': 'Healthy Bites',
            'rating': '4.7',
            'deliveryTime': '15-20 mins',
            'cuisine': 'Salads • Smoothies • Wraps',
            'image': 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80',
            'shopId': 'healthy-bites'
          },
          {
            'name': 'Burger House',
            'rating': '4.2',
            'deliveryTime': '30-35 mins',
            'cuisine': 'Burgers • Fries • Shakes',
            'image': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80',
            'shopId': 'burger-house'
          },
          {
            'name': 'Coffee Corner',
            'rating': '4.6',
            'deliveryTime': '10-15 mins',
            'cuisine': 'Coffee • Pastries • Sandwiches',
            'image': 'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80',
            'shopId': 'coffee-corner'
          },
          {
            'name': 'Smoothie Bar',
            'rating': '4.4',
            'deliveryTime': '12-18 mins',
            'cuisine': 'Smoothies • Juices • Bowls',
            'image': 'https://images.unsplash.com/photo-1570197788417-0e82375c9371?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80',
            'shopId': 'smoothie-bar'
          }
        ];
      case 'inTheSpotlight':
        return [
          {
            'name': 'Gourmet Kitchen',
            'rating': '4.8',
            'deliveryTime': '35-40 mins',
            'cuisine': 'Fine Dining • Continental • Steaks',
            'image': 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80',
            'shopId': 'gourmet-kitchen'
          },
          {
            'name': 'Dessert Dreams',
            'rating': '4.9',
            'deliveryTime': '20-25 mins',
            'cuisine': 'Cakes • Cookies • Ice Cream',
            'image': 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80',
            'shopId': 'dessert-dreams'
          },
          {
            'name': 'Taco Fiesta',
            'rating': '4.5',
            'deliveryTime': '25-30 mins',
            'cuisine': 'Mexican • Tacos • Burritos',
            'image': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80',
            'shopId': 'taco-fiesta'
          }
        ];
      default:
        return [];
    }
  }

  // Helper method to get mock product data
  static List<Map<String, dynamic>> _getProductData(String dataSource) {
    switch (dataSource) {
      case 'shopProducts':
        // Try to get products from ShopDetailController
        try {
          final controller = Get.find<ShopDetailController>();
          return controller.filteredProducts.map((product) => {
            'productId': product.id,
            'productName': product.title,
            'productImage': product.displayImage,
            'productRating': product.rating.toString(),
            'originalPrice': '159', // Mock original price
            'discountedPrice': '99', // Mock discounted price
            'isVeg': product.tags?.contains('vegetarian') ?? false,
          }).toList();
        } catch (e) {
          // Fallback to mock data if controller not found
          return [
            {
              'productId': 'food_001',
              'productName': 'Gooey Chocolate Brownie',
              'productImage': 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=300&h=300&fit=crop',
              'productRating': '4.6',
              'originalPrice': '129',
              'discountedPrice': '99',
              'isVeg': false,
            },
            {
              'productId': 'food_002',
              'productName': 'Mummys Special [Small]',
              'productImage': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=300&h=300&fit=crop',
              'productRating': '4.6',
              'originalPrice': '159',
              'discountedPrice': '99',
              'isVeg': true,
            },
          ];
        }
      case 'beverages':
        return [
          {
            'productId': 'bev_001',
            'productName': 'Fresh Orange Juice',
            'productImage': 'https://images.unsplash.com/photo-1621506289937-a8e4df240d0b?w=300&h=300&fit=crop',
            'productRating': '4.5',
            'originalPrice': '89',
            'discountedPrice': '69',
            'isVeg': true,
          },
          {
            'productId': 'bev_002',
            'productName': 'Cold Coffee',
            'productImage': 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=300&h=300&fit=crop',
            'productRating': '4.7',
            'originalPrice': '99',
            'discountedPrice': '79',
            'isVeg': true,
          },
          {
            'productId': 'bev_003',
            'productName': 'Mango Smoothie',
            'productImage': 'https://images.unsplash.com/photo-1553530666-ba11a7da3888?w=300&h=300&fit=crop',
            'productRating': '4.8',
            'originalPrice': '119',
            'discountedPrice': '99',
            'isVeg': true,
          },
        ];
      default:
        return [];
    }
  }

  // Helper method to populate template with data
  static Map<String, dynamic> _populateTemplate(Map<String, dynamic> template, Map<String, dynamic> data) {
    final Map<String, dynamic> result = {};

    template.forEach((key, value) {
      if (value is String && value.startsWith('{{') && value.endsWith('}}')) {
        // Extract placeholder name
        final placeholder = value.substring(2, value.length - 2);
        result[key] = data[placeholder] ?? value;
      } else if (value is Map<String, dynamic>) {
        result[key] = _populateTemplate(value, data);
      } else if (value is List) {
        result[key] = value.map((item) {
          if (item is Map<String, dynamic>) {
            return _populateTemplate(item, data);
          }
          return item;
        }).toList();
      } else {
        result[key] = value;
      }
    });

    return result;
  }

  /// Helper method to parse numeric values that might be strings
  static double? _parseNumericValue(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) {
      if (value == "double.infinity") return double.infinity;
      if (value == "double.maxFinite") return double.maxFinite;
      return double.tryParse(value);
    }
    return null;
  }

  /// Handle filter toggle for restaurant listing
  static void _handleFilterToggle(RestaurantListingController controller, String filterType) {
    switch (filterType) {
      case 'pure_veg':
        controller.toggleFilter(RestaurantFilter.pureVeg);
        break;
      case 'fast_delivery':
        controller.toggleFilter(RestaurantFilter.fastDelivery);
        break;
      case 'price_range':
        controller.toggleFilter(RestaurantFilter.budgetFriendly);
        break;
      case 'top_rated':
        controller.toggleFilter(RestaurantFilter.topRated);
        break;
      case 'offers':
        controller.toggleFilter(RestaurantFilter.offers);
        break;
    }
  }

  /// Build dynamic text component for restaurant listing
  static Widget _buildDynamicText(Map<String, dynamic> json, BuildContext context) {
    final dataSource = json['dataSource'] as String?;
    final style = json['style'] as Map<String, dynamic>?;

    String text = '';
    if (dataSource != null) {
      try {
        final controller = Get.find<RestaurantListingController>();
        switch (dataSource) {
          case 'results_count':
            text = controller.resultsCountText;
            break;
          default:
            text = dataSource; // fallback to dataSource as text
        }
      } catch (e) {
        text = dataSource; // fallback if controller not found
      }
    }

    return Text(
      text,
      style: style != null ? _parseTextStyle(style) : null,
    );
  }

  /// Build dynamic image component for restaurant listing
  static Widget _buildDynamicImage(Map<String, dynamic> json, BuildContext context) {
    final dataSource = json['dataSource'] as String?;
    final fit = json['fit'] as String?;
    final placeholder = json['placeholder'] as Map<String, dynamic>?;

    // Try to get image URL from current restaurant context
    String imageUrl = '';
    if (dataSource == 'imageUrl') {
      // This will be populated by the template system
      imageUrl = 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=400&h=400&fit=crop&crop=center';
    }

    if (imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        fit: fit == 'cover' ? BoxFit.cover : BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return placeholder != null
            ? _parseComponent(placeholder, context)
            : Container(
                color: Colors.grey[300],
                child: const Icon(Icons.restaurant, color: Colors.grey),
              );
        },
      );
    }

    return placeholder != null
      ? _parseComponent(placeholder, context)
      : Container(
          width: 80,
          height: 80,
          color: Colors.grey[300],
          child: const Icon(Icons.restaurant, color: Colors.grey),
        );
  }

  /// Build dynamic icon component for restaurant listing
  static Widget _buildDynamicIcon(Map<String, dynamic> json, BuildContext context) {
    final dataSource = json['dataSource'] as String?;
    final size = (json['size'] as num?)?.toDouble();
    final color = json['color'] as String?;

    IconData iconData = Icons.help;
    if (dataSource == 'favorite_icon') {
      iconData = Icons.favorite_border; // default to unfavorited
    }

    return Icon(
      iconData,
      size: size,
      color: color != null ? _parseColor(color) : null,
    );
  }

  /// Populate restaurant template with actual restaurant data
  static Map<String, dynamic> _populateRestaurantTemplate(
    Map<String, dynamic> template,
    Restaurant restaurant,
  ) {
    // Convert template to JSON string for easy replacement
    String templateJson = json.encode(template);

    // Replace placeholders with actual restaurant data
    templateJson = templateJson.replaceAll('{{id}}', restaurant.id);
    templateJson = templateJson.replaceAll('{{name}}', restaurant.name);
    templateJson = templateJson.replaceAll('{{rating}}', '${restaurant.rating} (${restaurant.reviewCount}+)');
    templateJson = templateJson.replaceAll('{{deliveryTime}}', restaurant.deliveryTime);
    templateJson = templateJson.replaceAll('{{cuisines}}', restaurant.cuisineString);
    templateJson = templateJson.replaceAll('{{location}}', restaurant.location);
    templateJson = templateJson.replaceAll('{{distance}}', restaurant.distance);
    templateJson = templateJson.replaceAll('{{imageUrl}}', restaurant.imageUrl);
    templateJson = templateJson.replaceAll('{{favorite_icon}}', restaurant.isFavorite ? 'favorite' : 'favorite_border');

    // Convert back to Map
    return json.decode(templateJson) as Map<String, dynamic>;
  }

  // Helper method to get mock restaurant data
  static List<Map<String, dynamic>> _getRestaurantData(String dataSource) {
    return [
      {
        'id': 'mcdonalds',
        'name': 'McDonald\'s',
        'rating': '4.6 (2.2K+)',
        'deliveryTime': '10-15 mins',
        'cuisine': 'Burgers, Beverages, Cafe',
        'location': 'Vashi',
        'distance': '0.6 km',
        'imageUrl': 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=300&h=200&fit=crop',
        'isFavorite': false,
        'priceRange': '₹99',
        'offer': 'ITEMS AT ₹99'
      },
      {
        'id': 'wendys',
        'name': 'Wendy\'s Burgers',
        'rating': '4.2 (3.7K+)',
        'deliveryTime': '30-35 mins',
        'cuisine': 'Burgers, American, Fast Food',
        'location': 'Vashi',
        'distance': '2.6 km',
        'imageUrl': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=300&h=200&fit=crop',
        'isFavorite': false,
        'priceRange': '₹55',
        'offer': 'ITEMS AT ₹55'
      },
      {
        'id': 'chinatown',
        'name': 'China Town',
        'rating': '4.3 (99)',
        'deliveryTime': '25-30 mins',
        'cuisine': 'Chinese, Beverages',
        'location': 'Vashi',
        'distance': '2.4 km',
        'imageUrl': 'https://images.unsplash.com/photo-1526318896980-cf78c088247c?w=300&h=200&fit=crop',
        'isFavorite': false,
        'priceRange': '₹200',
        'offer': null
      }
    ];
  }

  // Helper method to build restaurant card from Restaurant model
  static Widget _buildRestaurantCardFromModel(Restaurant restaurant, BuildContext context) {
    return GestureDetector(
      onTap: () {
        debugPrint('🚀 [NAVIGATION] Navigating to shop detail for: ${restaurant.name}');
        _handleRestaurantNavigation(restaurant, context);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      child: Row(
        children: [
          // Restaurant Image
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              image: DecorationImage(
                image: NetworkImage(restaurant.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                // Favorite Icon
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      restaurant.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: restaurant.isFavorite ? Colors.red : Colors.grey,
                      size: 16,
                    ),
                  ),
                ),
                // Offer Badge (if available)
                if (restaurant.tags?.isNotEmpty == true)
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        restaurant.tags!.first.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Restaurant Details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and Rating
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          restaurant.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star, color: Colors.white, size: 12),
                            const SizedBox(width: 2),
                            Text(
                              restaurant.rating.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Rating and Delivery Time
                  Text(
                    '${restaurant.rating} (${restaurant.reviewCount}+) • ${restaurant.deliveryTime}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Cuisine
                  Text(
                    restaurant.cuisineString,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Location and Distance
                  Text(
                    '${restaurant.location} • ${restaurant.distance}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
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

  // Helper method to build restaurant card
  static Widget _buildRestaurantCard(Map<String, dynamic> restaurant, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Restaurant Image
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              image: DecorationImage(
                image: NetworkImage(restaurant['imageUrl'] ?? ''),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                // Favorite Icon
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      restaurant['isFavorite'] == true ? Icons.favorite : Icons.favorite_border,
                      color: restaurant['isFavorite'] == true ? Colors.red : Colors.grey,
                      size: 16,
                    ),
                  ),
                ),
                // Price/Offer Badge
                if (restaurant['offer'] != null)
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        restaurant['offer'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Restaurant Details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and Rating
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          restaurant['name'] ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star, color: Colors.white, size: 12),
                            const SizedBox(width: 2),
                            Text(
                              restaurant['rating']?.split(' ')[0] ?? '4.0',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Rating and Delivery Time
                  Text(
                    '${restaurant['rating']} • ${restaurant['deliveryTime']}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Cuisine
                  Text(
                    restaurant['cuisine'] ?? '',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Location and Distance
                  Text(
                    '${restaurant['location']} • ${restaurant['distance']}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Handle restaurant navigation to shop detail screen
  static void _handleRestaurantNavigation(Restaurant restaurant, BuildContext context) {
    try {
      debugPrint('🏪 [SHOP_NAVIGATION] Navigating to shop detail for: ${restaurant.name}');
      debugPrint('📍 [SHOP_NAVIGATION] Restaurant ID: ${restaurant.id}');

      // Navigate to shop detail view with restaurant data
      Get.toNamed('/shop-detail', arguments: {
        'shopId': restaurant.id,
        'shopName': restaurant.name,
        'shopData': {
          'id': restaurant.id,
          'name': restaurant.name,
          'rating': restaurant.rating,
          'reviewCount': restaurant.reviewCount,
          'deliveryTime': restaurant.deliveryTime,
          'cuisines': restaurant.cuisines,
          'location': restaurant.location,
          'distance': restaurant.distance,
          'imageUrl': restaurant.imageUrl,
          'isFavorite': restaurant.isFavorite,
          'tags': restaurant.tags,
        }
      });
    } catch (e) {
      debugPrint('❌ [SHOP_NAVIGATION] Error navigating to shop detail: $e');
    }
  }
}
