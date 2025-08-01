import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
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
      case 'iconbutton':
        return _buildIconButton(json, context);
      case 'image':
        return _buildImage(json, context);
      case 'lottie':
        return _buildLottie(json, context);
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
      case 'customscrollview':
        return _buildCustomScrollView(json, context);
      case 'sliverappbar':
        return _buildSliverAppBar(json, context);
      case 'slivertoboxadapter':
        return _buildSliverToBoxAdapter(json, context);
      case 'flexiblespacebar':
        return _buildFlexibleSpaceBar(json, context);
      case 'margin':
        return _buildMargin(json, context);
      case 'textfield':
        return _buildTextField(json, context);
      case 'sliverlist':
        return _buildSliverList(json, context);
      case 'stack':
        return _buildStack(json, context);
      case 'positioned':
        return _buildPositioned(json, context);
      case 'appbar':
        return _buildAppBar(json, context);
      case 'pageview':
        return _buildPageView(json, context);
      default:
        // Log unknown components for debugging
        debugPrint('Unknown component type: $type');
        return Container(
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
    }
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
    final width = json['width'] as num?;
    final height = json['height'] as num?;
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

    return CustomScrollView(
      slivers: slivers
          .map((sliver) => _parseComponent(sliver, context))
          .where((widget) => widget is Widget)
          .cast<Widget>()
          .toList(),
    );
  }

  static Widget _buildSliverAppBar(Map<String, dynamic> json, BuildContext context) {
    final expandedHeight = json['expandedHeight'] as num?;
    final floating = json['floating'] as bool? ?? false;
    final pinned = json['pinned'] as bool? ?? false;
    final flexibleSpace = json['flexibleSpace'];
    final borderRadius = json['borderRadius'] as num?;

    // Fix for purple corner bleeding: set transparent background and handle radius in flexibleSpace
    return SliverAppBar(
      expandedHeight: expandedHeight?.toDouble(),
      floating: floating,
      pinned: pinned,
      backgroundColor: Colors.transparent, // Prevent purple bleeding
      elevation: 0, // Remove shadow to prevent artifacts
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
    final delegate = json['delegate'] as Map<String, dynamic>?;
    final itemCount = delegate?['itemCount'] as int? ?? 0;
    final itemBuilder = delegate?['itemBuilder'] as String?;

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          // For now, return placeholder items
          // In a real implementation, you would use the itemBuilder to create specific items
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

    return AppBar(
      title: title != null ? Text(title) : null,
      backgroundColor: _parseColor(backgroundColor),
      foregroundColor: _parseColor(foregroundColor),
      elevation: elevation?.toDouble(),
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
}
