import 'package:json_annotation/json_annotation.dart';

part 'ui_models.g.dart';

@JsonSerializable()
class UIScreen {
  final String screenId;
  final String title;
  final UITheme? theme;
  final List<UIComponent> components;
  final Map<String, dynamic>? metadata;

  UIScreen({
    required this.screenId,
    required this.title,
    this.theme,
    required this.components,
    this.metadata,
  });

  factory UIScreen.fromJson(Map<String, dynamic> json) =>
      _$UIScreenFromJson(json);
  Map<String, dynamic> toJson() => _$UIScreenToJson(this);
}

@JsonSerializable()
class UITheme {
  final String? primaryColor;
  final String? secondaryColor;
  final String? backgroundColor;
  final String? textColor;
  final String? cardColor;
  final String? dividerColor;
  final Map<String, dynamic>? customColors;

  UITheme({
    this.primaryColor,
    this.secondaryColor,
    this.backgroundColor,
    this.textColor,
    this.cardColor,
    this.dividerColor,
    this.customColors,
  });

  factory UITheme.fromJson(Map<String, dynamic> json) =>
      _$UIThemeFromJson(json);
  Map<String, dynamic> toJson() => _$UIThemeToJson(this);
}

@JsonSerializable()
class UIComponent {
  final String type;
  final String? id;
  final Map<String, dynamic> properties;
  final List<UIComponent>? children;
  final UIAction? action;
  final UIStyle? style;

  UIComponent({
    required this.type,
    this.id,
    Map<String, dynamic>? properties,
    this.children,
    this.action,
    this.style,
  }) : properties = properties ?? {};

  factory UIComponent.fromJson(Map<String, dynamic> json) =>
      _$UIComponentFromJson(json);
  Map<String, dynamic> toJson() => _$UIComponentToJson(this);
}

@JsonSerializable()
class UIAction {
  final String type;
  final String? route;
  final Map<String, dynamic>? parameters;
  final String? url;
  final String? method;

  UIAction({
    required this.type,
    this.route,
    this.parameters,
    this.url,
    this.method,
  });

  factory UIAction.fromJson(Map<String, dynamic> json) =>
      _$UIActionFromJson(json);
  Map<String, dynamic> toJson() => _$UIActionToJson(this);
}

@JsonSerializable()
class UIStyle {
  final double? width;
  final double? height;
  final String? backgroundColor;
  final String? textColor;
  final double? fontSize;
  final String? fontWeight;
  final double? borderRadius;
  final String? borderColor;
  final double? borderWidth;
  final UIPadding? padding;
  final UIPadding? margin;
  final String? alignment;

  UIStyle({
    this.width,
    this.height,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.borderRadius,
    this.borderColor,
    this.borderWidth,
    this.padding,
    this.margin,
    this.alignment,
  });

  factory UIStyle.fromJson(Map<String, dynamic> json) =>
      _$UIStyleFromJson(json);
  Map<String, dynamic> toJson() => _$UIStyleToJson(this);
}

@JsonSerializable()
class UIPadding {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final double? all;

  UIPadding({this.top, this.bottom, this.left, this.right, this.all});

  factory UIPadding.fromJson(Map<String, dynamic> json) =>
      _$UIPaddingFromJson(json);
  Map<String, dynamic> toJson() => _$UIPaddingToJson(this);
}

// Specific component models for better type safety
@JsonSerializable()
class CarouselComponentData {
  final List<String> images;
  final bool autoPlay;
  final int autoPlayInterval;
  final bool showIndicators;
  final double height;

  CarouselComponentData({
    required this.images,
    this.autoPlay = true,
    this.autoPlayInterval = 3,
    this.showIndicators = true,
    this.height = 200.0,
  });

  factory CarouselComponentData.fromJson(Map<String, dynamic> json) =>
      _$CarouselComponentDataFromJson(json);
  Map<String, dynamic> toJson() => _$CarouselComponentDataToJson(this);
}

@JsonSerializable()
class TabBarComponentData {
  final List<TabData> tabs;
  final String? selectedTabId;
  final bool isScrollable;

  TabBarComponentData({
    required this.tabs,
    this.selectedTabId,
    this.isScrollable = false,
  });

  factory TabBarComponentData.fromJson(Map<String, dynamic> json) =>
      _$TabBarComponentDataFromJson(json);
  Map<String, dynamic> toJson() => _$TabBarComponentDataToJson(this);
}

@JsonSerializable()
class TabData {
  final String id;
  final String title;
  final String? icon;
  final List<UIComponent> content;

  TabData({
    required this.id,
    required this.title,
    this.icon,
    required this.content,
  });

  factory TabData.fromJson(Map<String, dynamic> json) =>
      _$TabDataFromJson(json);
  Map<String, dynamic> toJson() => _$TabDataToJson(this);
}

@JsonSerializable()
class ProductListComponentData {
  final String title;
  final String? apiEndpoint;
  final List<String>? productIds;
  final bool isHorizontal;
  final int? limit;
  final bool showViewAll;

  ProductListComponentData({
    required this.title,
    this.apiEndpoint,
    this.productIds,
    this.isHorizontal = true,
    this.limit,
    this.showViewAll = false,
  });

  factory ProductListComponentData.fromJson(Map<String, dynamic> json) =>
      _$ProductListComponentDataFromJson(json);
  Map<String, dynamic> toJson() => _$ProductListComponentDataToJson(this);
}

@JsonSerializable()
class BannerComponentData {
  final String imageUrl;
  final String? title;
  final String? subtitle;
  final UIAction? action;
  final double? height;
  final String? overlayColor;
  final double? overlayOpacity;

  BannerComponentData({
    required this.imageUrl,
    this.title,
    this.subtitle,
    this.action,
    this.height,
    this.overlayColor,
    this.overlayOpacity,
  });

  factory BannerComponentData.fromJson(Map<String, dynamic> json) =>
      _$BannerComponentDataFromJson(json);
  Map<String, dynamic> toJson() => _$BannerComponentDataToJson(this);
}
