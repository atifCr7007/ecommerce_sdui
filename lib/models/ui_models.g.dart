// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ui_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UIScreen _$UIScreenFromJson(Map<String, dynamic> json) => UIScreen(
  screenId: json['screenId'] as String,
  title: json['title'] as String,
  theme: json['theme'] == null
      ? null
      : UITheme.fromJson(json['theme'] as Map<String, dynamic>),
  components: (json['components'] as List<dynamic>)
      .map((e) => UIComponent.fromJson(e as Map<String, dynamic>))
      .toList(),
  metadata: json['metadata'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$UIScreenToJson(UIScreen instance) => <String, dynamic>{
  'screenId': instance.screenId,
  'title': instance.title,
  'theme': instance.theme,
  'components': instance.components,
  'metadata': instance.metadata,
};

UITheme _$UIThemeFromJson(Map<String, dynamic> json) => UITheme(
  primaryColor: json['primaryColor'] as String?,
  secondaryColor: json['secondaryColor'] as String?,
  backgroundColor: json['backgroundColor'] as String?,
  textColor: json['textColor'] as String?,
  cardColor: json['cardColor'] as String?,
  dividerColor: json['dividerColor'] as String?,
  customColors: json['customColors'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$UIThemeToJson(UITheme instance) => <String, dynamic>{
  'primaryColor': instance.primaryColor,
  'secondaryColor': instance.secondaryColor,
  'backgroundColor': instance.backgroundColor,
  'textColor': instance.textColor,
  'cardColor': instance.cardColor,
  'dividerColor': instance.dividerColor,
  'customColors': instance.customColors,
};

UIComponent _$UIComponentFromJson(Map<String, dynamic> json) => UIComponent(
  type: json['type'] as String,
  id: json['id'] as String?,
  properties: json['properties'] as Map<String, dynamic>?,
  children: (json['children'] as List<dynamic>?)
      ?.map((e) => UIComponent.fromJson(e as Map<String, dynamic>))
      .toList(),
  action: json['action'] == null
      ? null
      : UIAction.fromJson(json['action'] as Map<String, dynamic>),
  style: json['style'] == null
      ? null
      : UIStyle.fromJson(json['style'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UIComponentToJson(UIComponent instance) =>
    <String, dynamic>{
      'type': instance.type,
      'id': instance.id,
      'properties': instance.properties,
      'children': instance.children,
      'action': instance.action,
      'style': instance.style,
    };

UIAction _$UIActionFromJson(Map<String, dynamic> json) => UIAction(
  type: json['type'] as String,
  route: json['route'] as String?,
  parameters: json['parameters'] as Map<String, dynamic>?,
  url: json['url'] as String?,
  method: json['method'] as String?,
);

Map<String, dynamic> _$UIActionToJson(UIAction instance) => <String, dynamic>{
  'type': instance.type,
  'route': instance.route,
  'parameters': instance.parameters,
  'url': instance.url,
  'method': instance.method,
};

UIStyle _$UIStyleFromJson(Map<String, dynamic> json) => UIStyle(
  width: (json['width'] as num?)?.toDouble(),
  height: (json['height'] as num?)?.toDouble(),
  backgroundColor: json['backgroundColor'] as String?,
  textColor: json['textColor'] as String?,
  fontSize: (json['fontSize'] as num?)?.toDouble(),
  fontWeight: json['fontWeight'] as String?,
  borderRadius: (json['borderRadius'] as num?)?.toDouble(),
  borderColor: json['borderColor'] as String?,
  borderWidth: (json['borderWidth'] as num?)?.toDouble(),
  padding: json['padding'] == null
      ? null
      : UIPadding.fromJson(json['padding'] as Map<String, dynamic>),
  margin: json['margin'] == null
      ? null
      : UIPadding.fromJson(json['margin'] as Map<String, dynamic>),
  alignment: json['alignment'] as String?,
);

Map<String, dynamic> _$UIStyleToJson(UIStyle instance) => <String, dynamic>{
  'width': instance.width,
  'height': instance.height,
  'backgroundColor': instance.backgroundColor,
  'textColor': instance.textColor,
  'fontSize': instance.fontSize,
  'fontWeight': instance.fontWeight,
  'borderRadius': instance.borderRadius,
  'borderColor': instance.borderColor,
  'borderWidth': instance.borderWidth,
  'padding': instance.padding,
  'margin': instance.margin,
  'alignment': instance.alignment,
};

UIPadding _$UIPaddingFromJson(Map<String, dynamic> json) => UIPadding(
  top: (json['top'] as num?)?.toDouble(),
  bottom: (json['bottom'] as num?)?.toDouble(),
  left: (json['left'] as num?)?.toDouble(),
  right: (json['right'] as num?)?.toDouble(),
  all: (json['all'] as num?)?.toDouble(),
);

Map<String, dynamic> _$UIPaddingToJson(UIPadding instance) => <String, dynamic>{
  'top': instance.top,
  'bottom': instance.bottom,
  'left': instance.left,
  'right': instance.right,
  'all': instance.all,
};

CarouselComponentData _$CarouselComponentDataFromJson(
  Map<String, dynamic> json,
) => CarouselComponentData(
  images: (json['images'] as List<dynamic>).map((e) => e as String).toList(),
  autoPlay: json['autoPlay'] as bool? ?? true,
  autoPlayInterval: (json['autoPlayInterval'] as num?)?.toInt() ?? 3,
  showIndicators: json['showIndicators'] as bool? ?? true,
  height: (json['height'] as num?)?.toDouble() ?? 200.0,
);

Map<String, dynamic> _$CarouselComponentDataToJson(
  CarouselComponentData instance,
) => <String, dynamic>{
  'images': instance.images,
  'autoPlay': instance.autoPlay,
  'autoPlayInterval': instance.autoPlayInterval,
  'showIndicators': instance.showIndicators,
  'height': instance.height,
};

TabBarComponentData _$TabBarComponentDataFromJson(Map<String, dynamic> json) =>
    TabBarComponentData(
      tabs: (json['tabs'] as List<dynamic>)
          .map((e) => TabData.fromJson(e as Map<String, dynamic>))
          .toList(),
      selectedTabId: json['selectedTabId'] as String?,
      isScrollable: json['isScrollable'] as bool? ?? false,
    );

Map<String, dynamic> _$TabBarComponentDataToJson(
  TabBarComponentData instance,
) => <String, dynamic>{
  'tabs': instance.tabs,
  'selectedTabId': instance.selectedTabId,
  'isScrollable': instance.isScrollable,
};

TabData _$TabDataFromJson(Map<String, dynamic> json) => TabData(
  id: json['id'] as String,
  title: json['title'] as String,
  icon: json['icon'] as String?,
  content: (json['content'] as List<dynamic>)
      .map((e) => UIComponent.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$TabDataToJson(TabData instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'icon': instance.icon,
  'content': instance.content,
};

ProductListComponentData _$ProductListComponentDataFromJson(
  Map<String, dynamic> json,
) => ProductListComponentData(
  title: json['title'] as String,
  apiEndpoint: json['apiEndpoint'] as String?,
  productIds: (json['productIds'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  isHorizontal: json['isHorizontal'] as bool? ?? true,
  limit: (json['limit'] as num?)?.toInt(),
  showViewAll: json['showViewAll'] as bool? ?? false,
);

Map<String, dynamic> _$ProductListComponentDataToJson(
  ProductListComponentData instance,
) => <String, dynamic>{
  'title': instance.title,
  'apiEndpoint': instance.apiEndpoint,
  'productIds': instance.productIds,
  'isHorizontal': instance.isHorizontal,
  'limit': instance.limit,
  'showViewAll': instance.showViewAll,
};

BannerComponentData _$BannerComponentDataFromJson(Map<String, dynamic> json) =>
    BannerComponentData(
      imageUrl: json['imageUrl'] as String,
      title: json['title'] as String?,
      subtitle: json['subtitle'] as String?,
      action: json['action'] == null
          ? null
          : UIAction.fromJson(json['action'] as Map<String, dynamic>),
      height: (json['height'] as num?)?.toDouble(),
      overlayColor: json['overlayColor'] as String?,
      overlayOpacity: (json['overlayOpacity'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$BannerComponentDataToJson(
  BannerComponentData instance,
) => <String, dynamic>{
  'imageUrl': instance.imageUrl,
  'title': instance.title,
  'subtitle': instance.subtitle,
  'action': instance.action,
  'height': instance.height,
  'overlayColor': instance.overlayColor,
  'overlayOpacity': instance.overlayOpacity,
};
