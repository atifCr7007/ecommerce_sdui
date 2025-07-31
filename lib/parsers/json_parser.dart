import 'package:flutter/material.dart';
import '../models/ui_models.dart';
import '../utils/widget_mapper.dart';
import '../utils/color_utils.dart';

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
      case 'categorytabs':
        return _buildCategoryTabs(component, context);
      case 'productlist':
        return _buildProductList(component, context);
      case 'banner':
        return _buildBanner(component, context);
      case 'button':
        return _buildButton(component, context);
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
      case 'align':
        return _buildAlign(component, context);
      case 'sizedbox':
        return _buildSizedBox(component, context);
      default:
        return Container(
          padding: const EdgeInsets.all(8.0),
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
        component.properties['mainAxisAlignment'],
      ),
      crossAxisAlignment: _getCrossAxisAlignment(
        component.properties['crossAxisAlignment'],
      ),
      mainAxisSize: _getMainAxisSize(component.properties['mainAxisSize']),
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
        component.properties['mainAxisAlignment'],
      ),
      crossAxisAlignment: _getCrossAxisAlignment(
        component.properties['crossAxisAlignment'],
      ),
      mainAxisSize: _getMainAxisSize(component.properties['mainAxisSize']),
      children: children,
    );
  }

  static Widget _buildContainer(UIComponent component, BuildContext context) {
    final child = component.children?.isNotEmpty == true
        ? parseComponent(component.children!.first, context)
        : null;

    return Container(
      width: _getDouble(component.properties['width']),
      height: _getDouble(component.properties['height']),
      padding: _getEdgeInsets(component.properties['padding']),
      margin: _getEdgeInsets(component.properties['margin']),
      decoration: _getBoxDecoration(component.properties),
      child: child,
    );
  }

  static Widget _buildText(UIComponent component, BuildContext context) {
    final text = component.properties['text']?.toString() ?? '';

    return Text(
      text,
      style: TextStyle(
        fontSize: _getDouble(component.properties['fontSize']) ?? 14.0,
        fontWeight: _getFontWeight(component.properties['fontWeight']),
        color:
            ColorUtils.parseColor(component.properties['color']) ??
            Colors.black,
      ),
      textAlign: _getTextAlign(component.properties['textAlign']),
      maxLines: _getInt(component.properties['maxLines']),
      overflow: _getTextOverflow(component.properties['overflow']),
    );
  }

  static Widget _buildImage(UIComponent component, BuildContext context) {
    final url = component.properties['url']?.toString() ?? '';
    final width = _getDouble(component.properties['width']);
    final height = _getDouble(component.properties['height']);

    if (url.isEmpty) {
      return Container(
        width: width,
        height: height,
        color: Colors.grey[300],
        child: const Icon(Icons.image, color: Colors.grey),
      );
    }

    return Image.network(
      url,
      width: width,
      height: height,
      fit: _getBoxFit(component.properties['fit']),
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width,
          height: height,
          color: Colors.grey[300],
          child: const Icon(Icons.broken_image, color: Colors.grey),
        );
      },
    );
  }

  static Widget _buildCarousel(UIComponent component, BuildContext context) {
    return WidgetMapper.buildCarousel(component, context);
  }

  static Widget _buildTabBar(UIComponent component, BuildContext context) {
    return WidgetMapper.buildTabBar(component, context);
  }

  static Widget _buildCategoryTabs(
    UIComponent component,
    BuildContext context,
  ) {
    return WidgetMapper.buildCategoryTabs(component, context);
  }

  static Widget _buildProductList(UIComponent component, BuildContext context) {
    return WidgetMapper.buildProductList(component, context);
  }

  static Widget _buildBanner(UIComponent component, BuildContext context) {
    return WidgetMapper.buildBanner(component, context);
  }

  static Widget _buildButton(UIComponent component, BuildContext context) {
    final text = component.properties['text']?.toString() ?? 'Button';
    final onPressed = component.action != null
        ? () => _handleAction(component.action!, context)
        : null;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorUtils.parseColor(
          component.properties['backgroundColor'],
        ),
        foregroundColor: ColorUtils.parseColor(
          component.properties['textColor'],
        ),
        padding: _getEdgeInsets(component.properties['padding']),
      ),
      child: Text(text),
    );
  }

  static Widget _buildSpacer(UIComponent component, BuildContext context) {
    return Spacer(flex: _getInt(component.properties['flex']) ?? 1);
  }

  static Widget _buildDivider(UIComponent component, BuildContext context) {
    return Divider(
      height: _getDouble(component.properties['height']),
      thickness: _getDouble(component.properties['thickness']),
      color: ColorUtils.parseColor(component.properties['color']),
    );
  }

  static Widget _buildScrollView(UIComponent component, BuildContext context) {
    final child = component.children?.isNotEmpty == true
        ? parseComponent(component.children!.first, context)
        : Container();

    return SingleChildScrollView(
      scrollDirection: _getAxis(component.properties['scrollDirection']),
      child: child,
    );
  }

  static Widget _buildExpanded(UIComponent component, BuildContext context) {
    final child = component.children?.isNotEmpty == true
        ? parseComponent(component.children!.first, context)
        : Container();

    return Expanded(
      flex: _getInt(component.properties['flex']) ?? 1,
      child: child,
    );
  }

  static Widget _buildFlexible(UIComponent component, BuildContext context) {
    final child = component.children?.isNotEmpty == true
        ? parseComponent(component.children!.first, context)
        : Container();

    return Flexible(
      flex: _getInt(component.properties['flex']) ?? 1,
      fit: _getFlexFit(component.properties['fit']),
      child: child,
    );
  }

  static Widget _buildPadding(UIComponent component, BuildContext context) {
    final child = component.children?.isNotEmpty == true
        ? parseComponent(component.children!.first, context)
        : Container();

    return Padding(
      padding:
          _getEdgeInsets(component.properties['padding']) ?? EdgeInsets.zero,
      child: child,
    );
  }

  static Widget _buildCenter(UIComponent component, BuildContext context) {
    final child = component.children?.isNotEmpty == true
        ? parseComponent(component.children!.first, context)
        : Container();

    return Center(child: child);
  }

  static Widget _buildAlign(UIComponent component, BuildContext context) {
    final child = component.children?.isNotEmpty == true
        ? parseComponent(component.children!.first, context)
        : Container();

    return Align(
      alignment: _getAlignment(component.properties['alignment']),
      child: child,
    );
  }

  static Widget _buildSizedBox(UIComponent component, BuildContext context) {
    final child = component.children?.isNotEmpty == true
        ? parseComponent(component.children!.first, context)
        : null;

    return SizedBox(
      width: _getDouble(component.properties['width']),
      height: _getDouble(component.properties['height']),
      child: child,
    );
  }

  // Helper methods for parsing properties
  static double? _getDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static int? _getInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
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
      case 'pop':
        Navigator.pop(context);
        break;
      case 'external_url':
        // Handle external URL opening
        break;
      case 'increase_quantity':
        // Handle quantity increase - this would be handled by the ProductDetailController
        debugPrint('Increase quantity action');
        break;
      case 'decrease_quantity':
        // Handle quantity decrease - this would be handled by the ProductDetailController
        debugPrint('Decrease quantity action');
        break;
      case 'add_to_cart':
        // Handle add to cart - this would be handled by the ProductDetailController
        debugPrint('Add to cart action');
        break;
      case 'toggle_favorite':
        // Handle toggle favorite - this would be handled by the ProductDetailController
        debugPrint('Toggle favorite action');
        break;
      default:
        debugPrint('Unknown action type: ${action.type}');
    }
  }

  // Additional helper methods for property parsing
  static MainAxisAlignment _getMainAxisAlignment(dynamic value) {
    switch (value?.toString().toLowerCase()) {
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

  static CrossAxisAlignment _getCrossAxisAlignment(dynamic value) {
    switch (value?.toString().toLowerCase()) {
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

  static MainAxisSize _getMainAxisSize(dynamic value) {
    switch (value?.toString().toLowerCase()) {
      case 'min':
        return MainAxisSize.min;
      case 'max':
        return MainAxisSize.max;
      default:
        return MainAxisSize.max;
    }
  }

  static EdgeInsets? _getEdgeInsets(dynamic value) {
    if (value == null) return null;

    if (value is Map<String, dynamic>) {
      final all = _getDouble(value['all']);
      if (all != null) return EdgeInsets.all(all);

      return EdgeInsets.only(
        top: _getDouble(value['top']) ?? 0,
        bottom: _getDouble(value['bottom']) ?? 0,
        left: _getDouble(value['left']) ?? 0,
        right: _getDouble(value['right']) ?? 0,
      );
    }

    final doubleValue = _getDouble(value);
    if (doubleValue != null) return EdgeInsets.all(doubleValue);

    return null;
  }

  static BoxDecoration? _getBoxDecoration(Map<String, dynamic> properties) {
    final backgroundColor = ColorUtils.parseColor(
      properties['backgroundColor'],
    );
    final borderRadius = _getDouble(properties['borderRadius']);
    final borderColor = ColorUtils.parseColor(properties['borderColor']);
    final borderWidth = _getDouble(properties['borderWidth']);

    if (backgroundColor == null &&
        borderRadius == null &&
        borderColor == null) {
      return null;
    }

    return BoxDecoration(
      color: backgroundColor,
      borderRadius: borderRadius != null
          ? BorderRadius.circular(borderRadius)
          : null,
      border: borderColor != null && borderWidth != null
          ? Border.all(color: borderColor, width: borderWidth)
          : null,
    );
  }

  static FontWeight? _getFontWeight(dynamic value) {
    switch (value?.toString().toLowerCase()) {
      case 'bold':
        return FontWeight.bold;
      case 'normal':
        return FontWeight.normal;
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
        return null;
    }
  }

  static TextAlign? _getTextAlign(dynamic value) {
    switch (value?.toString().toLowerCase()) {
      case 'left':
        return TextAlign.left;
      case 'right':
        return TextAlign.right;
      case 'center':
        return TextAlign.center;
      case 'justify':
        return TextAlign.justify;
      case 'start':
        return TextAlign.start;
      case 'end':
        return TextAlign.end;
      default:
        return null;
    }
  }

  static TextOverflow? _getTextOverflow(dynamic value) {
    switch (value?.toString().toLowerCase()) {
      case 'clip':
        return TextOverflow.clip;
      case 'fade':
        return TextOverflow.fade;
      case 'ellipsis':
        return TextOverflow.ellipsis;
      case 'visible':
        return TextOverflow.visible;
      default:
        return null;
    }
  }

  static BoxFit? _getBoxFit(dynamic value) {
    switch (value?.toString().toLowerCase()) {
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
        return null;
    }
  }

  static Axis _getAxis(dynamic value) {
    switch (value?.toString().toLowerCase()) {
      case 'horizontal':
        return Axis.horizontal;
      case 'vertical':
        return Axis.vertical;
      default:
        return Axis.vertical;
    }
  }

  static FlexFit _getFlexFit(dynamic value) {
    switch (value?.toString().toLowerCase()) {
      case 'tight':
        return FlexFit.tight;
      case 'loose':
        return FlexFit.loose;
      default:
        return FlexFit.loose;
    }
  }

  static Alignment _getAlignment(dynamic value) {
    switch (value?.toString().toLowerCase()) {
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
}
