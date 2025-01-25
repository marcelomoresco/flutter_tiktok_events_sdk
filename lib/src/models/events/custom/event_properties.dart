// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

import 'package:tiktok_events_sdk/src/models/currency/currency_code.dart';

class EventProperties {
  final Map<String, dynamic>? customProperties;
  final String? description;
  final double? value;
  final CurrencyCode? currency;
  final int? quantity;
  final double? price;
  final String? contentType;
  final String? contentId;
  final String? brand;
  final String? contentName;

  const EventProperties({
    this.customProperties,
    this.description,
    this.value,
    this.currency,
    this.quantity,
    this.price,
    this.contentType,
    this.contentId,
    this.brand,
    this.contentName,
  });

  EventProperties copyWith({
    Map<String, dynamic>? customProperties,
    String? description,
    double? value,
    CurrencyCode? currency,
    int? quantity,
    double? price,
    String? contentType,
    String? contentId,
    String? brand,
    String? contentName,
  }) {
    return EventProperties(
      customProperties: customProperties ?? this.customProperties,
      description: description ?? this.description,
      value: value ?? this.value,
      currency: currency ?? this.currency,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      contentType: contentType ?? this.contentType,
      contentId: contentId ?? this.contentId,
      brand: brand ?? this.brand,
      contentName: contentName ?? this.contentName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (customProperties != null) ...customProperties!,
      if (description != null) 'description': description,
      if (value != null) 'value': value,
      if (currency != null) 'currency': currency?.name,
      if (quantity != null) 'quantity': quantity,
      if (price != null) 'price': price,
      if (contentType != null) 'content_type': contentType,
      if (contentId != null) 'content_id': contentId,
      if (brand != null) 'brand': brand,
      if (contentName != null) 'content_name': contentName,
    };
  }

  @override
  bool operator ==(covariant EventProperties other) {
    if (identical(this, other)) return true;

    return mapEquals(other.customProperties, customProperties) &&
        other.description == description &&
        other.value == value &&
        other.currency == currency &&
        other.quantity == quantity &&
        other.price == price &&
        other.contentType == contentType &&
        other.contentId == contentId &&
        other.brand == brand &&
        other.contentName == contentName;
  }

  @override
  int get hashCode {
    return customProperties.hashCode ^
        description.hashCode ^
        value.hashCode ^
        currency.hashCode ^
        quantity.hashCode ^
        price.hashCode ^
        contentType.hashCode ^
        contentId.hashCode ^
        brand.hashCode ^
        contentName.hashCode;
  }
}
