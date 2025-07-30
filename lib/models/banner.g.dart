// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Banner _$BannerFromJson(Map<String, dynamic> json) => Banner(
  id: json['id'] as String,
  title: json['title'] as String,
  subtitle: json['subtitle'] as String?,
  imageUrl: json['imageUrl'] as String,
  description: json['description'] as String?,
  action: json['action'] == null
      ? null
      : BannerAction.fromJson(json['action'] as Map<String, dynamic>),
  style: json['style'] == null
      ? null
      : BannerStyle.fromJson(json['style'] as Map<String, dynamic>),
  isActive: json['isActive'] as bool,
  priority: (json['priority'] as num).toInt(),
  startDate: json['startDate'] == null
      ? null
      : DateTime.parse(json['startDate'] as String),
  endDate: json['endDate'] == null
      ? null
      : DateTime.parse(json['endDate'] as String),
);

Map<String, dynamic> _$BannerToJson(Banner instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'subtitle': instance.subtitle,
  'imageUrl': instance.imageUrl,
  'description': instance.description,
  'action': instance.action,
  'style': instance.style,
  'isActive': instance.isActive,
  'priority': instance.priority,
  'startDate': instance.startDate?.toIso8601String(),
  'endDate': instance.endDate?.toIso8601String(),
};

BannerAction _$BannerActionFromJson(Map<String, dynamic> json) => BannerAction(
  type: $enumDecode(_$BannerActionTypeEnumMap, json['type']),
  url: json['url'] as String?,
  route: json['route'] as String?,
  parameters: json['parameters'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$BannerActionToJson(BannerAction instance) =>
    <String, dynamic>{
      'type': _$BannerActionTypeEnumMap[instance.type]!,
      'url': instance.url,
      'route': instance.route,
      'parameters': instance.parameters,
    };

const _$BannerActionTypeEnumMap = {
  BannerActionType.navigate: 'navigate',
  BannerActionType.externalUrl: 'external_url',
  BannerActionType.productDetail: 'product_detail',
  BannerActionType.category: 'category',
  BannerActionType.search: 'search',
  BannerActionType.none: 'none',
};

BannerStyle _$BannerStyleFromJson(Map<String, dynamic> json) => BannerStyle(
  backgroundColor: json['backgroundColor'] as String?,
  textColor: json['textColor'] as String?,
  overlayColor: json['overlayColor'] as String?,
  overlayOpacity: (json['overlayOpacity'] as num?)?.toDouble(),
  textPosition: $enumDecodeNullable(
    _$BannerTextPositionEnumMap,
    json['textPosition'],
  ),
  borderRadius: (json['borderRadius'] as num?)?.toDouble(),
  showShadow: json['showShadow'] as bool?,
);

Map<String, dynamic> _$BannerStyleToJson(BannerStyle instance) =>
    <String, dynamic>{
      'backgroundColor': instance.backgroundColor,
      'textColor': instance.textColor,
      'overlayColor': instance.overlayColor,
      'overlayOpacity': instance.overlayOpacity,
      'textPosition': _$BannerTextPositionEnumMap[instance.textPosition],
      'borderRadius': instance.borderRadius,
      'showShadow': instance.showShadow,
    };

const _$BannerTextPositionEnumMap = {
  BannerTextPosition.topLeft: 'top_left',
  BannerTextPosition.topCenter: 'top_center',
  BannerTextPosition.topRight: 'top_right',
  BannerTextPosition.centerLeft: 'center_left',
  BannerTextPosition.center: 'center',
  BannerTextPosition.centerRight: 'center_right',
  BannerTextPosition.bottomLeft: 'bottom_left',
  BannerTextPosition.bottomCenter: 'bottom_center',
  BannerTextPosition.bottomRight: 'bottom_right',
};

CarouselBanner _$CarouselBannerFromJson(Map<String, dynamic> json) =>
    CarouselBanner(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String?,
      imageUrl: json['imageUrl'] as String,
      description: json['description'] as String?,
      action: json['action'] == null
          ? null
          : BannerAction.fromJson(json['action'] as Map<String, dynamic>),
      style: json['style'] == null
          ? null
          : BannerStyle.fromJson(json['style'] as Map<String, dynamic>),
      isActive: json['isActive'] as bool,
      priority: (json['priority'] as num).toInt(),
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      displayDuration: (json['displayDuration'] as num).toInt(),
      autoPlay: json['autoPlay'] as bool,
    );

Map<String, dynamic> _$CarouselBannerToJson(CarouselBanner instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'imageUrl': instance.imageUrl,
      'description': instance.description,
      'action': instance.action,
      'style': instance.style,
      'isActive': instance.isActive,
      'priority': instance.priority,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'displayDuration': instance.displayDuration,
      'autoPlay': instance.autoPlay,
    };

PromotionalBanner _$PromotionalBannerFromJson(Map<String, dynamic> json) =>
    PromotionalBanner(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String?,
      imageUrl: json['imageUrl'] as String,
      description: json['description'] as String?,
      action: json['action'] == null
          ? null
          : BannerAction.fromJson(json['action'] as Map<String, dynamic>),
      style: json['style'] == null
          ? null
          : BannerStyle.fromJson(json['style'] as Map<String, dynamic>),
      isActive: json['isActive'] as bool,
      priority: (json['priority'] as num).toInt(),
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      discountText: json['discountText'] as String?,
      offerCode: json['offerCode'] as String?,
      validUntil: json['validUntil'] == null
          ? null
          : DateTime.parse(json['validUntil'] as String),
    );

Map<String, dynamic> _$PromotionalBannerToJson(PromotionalBanner instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'imageUrl': instance.imageUrl,
      'description': instance.description,
      'action': instance.action,
      'style': instance.style,
      'isActive': instance.isActive,
      'priority': instance.priority,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'discountText': instance.discountText,
      'offerCode': instance.offerCode,
      'validUntil': instance.validUntil?.toIso8601String(),
    };
