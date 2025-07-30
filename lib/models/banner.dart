import 'package:json_annotation/json_annotation.dart';

part 'banner.g.dart';

@JsonSerializable()
class Banner {
  final String id;
  final String title;
  final String? subtitle;
  final String imageUrl;
  final String? description;
  final BannerAction? action;
  final BannerStyle? style;
  final bool isActive;
  final int priority;
  final DateTime? startDate;
  final DateTime? endDate;

  Banner({
    required this.id,
    required this.title,
    this.subtitle,
    required this.imageUrl,
    this.description,
    this.action,
    this.style,
    required this.isActive,
    required this.priority,
    this.startDate,
    this.endDate,
  });

  factory Banner.fromJson(Map<String, dynamic> json) => _$BannerFromJson(json);
  Map<String, dynamic> toJson() => _$BannerToJson(this);

  // Helper methods
  bool get isCurrentlyActive {
    if (!isActive) return false;
    
    final now = DateTime.now();
    if (startDate != null && now.isBefore(startDate!)) return false;
    if (endDate != null && now.isAfter(endDate!)) return false;
    
    return true;
  }

  String get displayTitle => title;
  String get displaySubtitle => subtitle ?? '';
  String get displayDescription => description ?? '';
}

@JsonSerializable()
class BannerAction {
  final BannerActionType type;
  final String? url;
  final String? route;
  final Map<String, dynamic>? parameters;

  BannerAction({
    required this.type,
    this.url,
    this.route,
    this.parameters,
  });

  factory BannerAction.fromJson(Map<String, dynamic> json) => _$BannerActionFromJson(json);
  Map<String, dynamic> toJson() => _$BannerActionToJson(this);
}

@JsonSerializable()
class BannerStyle {
  final String? backgroundColor;
  final String? textColor;
  final String? overlayColor;
  final double? overlayOpacity;
  final BannerTextPosition? textPosition;
  final double? borderRadius;
  final bool? showShadow;

  BannerStyle({
    this.backgroundColor,
    this.textColor,
    this.overlayColor,
    this.overlayOpacity,
    this.textPosition,
    this.borderRadius,
    this.showShadow,
  });

  factory BannerStyle.fromJson(Map<String, dynamic> json) => _$BannerStyleFromJson(json);
  Map<String, dynamic> toJson() => _$BannerStyleToJson(this);
}

enum BannerActionType {
  @JsonValue('navigate')
  navigate,
  @JsonValue('external_url')
  externalUrl,
  @JsonValue('product_detail')
  productDetail,
  @JsonValue('category')
  category,
  @JsonValue('search')
  search,
  @JsonValue('none')
  none,
}

enum BannerTextPosition {
  @JsonValue('top_left')
  topLeft,
  @JsonValue('top_center')
  topCenter,
  @JsonValue('top_right')
  topRight,
  @JsonValue('center_left')
  centerLeft,
  @JsonValue('center')
  center,
  @JsonValue('center_right')
  centerRight,
  @JsonValue('bottom_left')
  bottomLeft,
  @JsonValue('bottom_center')
  bottomCenter,
  @JsonValue('bottom_right')
  bottomRight,
}

// Carousel specific banner model
@JsonSerializable()
class CarouselBanner extends Banner {
  final int displayDuration; // in seconds
  final bool autoPlay;

  CarouselBanner({
    required String id,
    required String title,
    String? subtitle,
    required String imageUrl,
    String? description,
    BannerAction? action,
    BannerStyle? style,
    required bool isActive,
    required int priority,
    DateTime? startDate,
    DateTime? endDate,
    required this.displayDuration,
    required this.autoPlay,
  }) : super(
          id: id,
          title: title,
          subtitle: subtitle,
          imageUrl: imageUrl,
          description: description,
          action: action,
          style: style,
          isActive: isActive,
          priority: priority,
          startDate: startDate,
          endDate: endDate,
        );

  factory CarouselBanner.fromJson(Map<String, dynamic> json) => _$CarouselBannerFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$CarouselBannerToJson(this);
}

// Promotional banner model
@JsonSerializable()
class PromotionalBanner extends Banner {
  final String? discountText;
  final String? offerCode;
  final DateTime? validUntil;

  PromotionalBanner({
    required String id,
    required String title,
    String? subtitle,
    required String imageUrl,
    String? description,
    BannerAction? action,
    BannerStyle? style,
    required bool isActive,
    required int priority,
    DateTime? startDate,
    DateTime? endDate,
    this.discountText,
    this.offerCode,
    this.validUntil,
  }) : super(
          id: id,
          title: title,
          subtitle: subtitle,
          imageUrl: imageUrl,
          description: description,
          action: action,
          style: style,
          isActive: isActive,
          priority: priority,
          startDate: startDate,
          endDate: endDate,
        );

  factory PromotionalBanner.fromJson(Map<String, dynamic> json) => _$PromotionalBannerFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$PromotionalBannerToJson(this);

  String get displayDiscountText => discountText ?? '';
  String get displayOfferCode => offerCode ?? '';
  bool get hasValidOffer => validUntil != null && DateTime.now().isBefore(validUntil!);
}
