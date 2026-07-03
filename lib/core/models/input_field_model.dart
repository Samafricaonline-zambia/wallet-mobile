import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sampay_wallet/core/constants/app_icons.dart';
import 'package:sampay_wallet/core/constants/constants.dart';

class InputFieldModel {
  final String label;
  final String prefix;
  final TextInputType? keyboardType;
  final IconData? icon;

  InputFieldModel({
    required this.label,
    required this.prefix,
    this.keyboardType,
    this.icon,
  });

  factory InputFieldModel.empty() =>
      InputFieldModel(label: "", prefix: "", keyboardType: .none);

  factory InputFieldModel.airtime() => InputFieldModel(
    label: "Phone Number",
    prefix: "+260",
    keyboardType: TextInputType.number,
    icon: AppIcons.phone,
  );

  factory InputFieldModel.data() => InputFieldModel(
    label: "Phone Number",
    prefix: "+260",
    keyboardType: TextInputType.number,
    icon: AppIcons.phone,
  );

  factory InputFieldModel.electricity() => InputFieldModel(
    label: "Phone Number",
    prefix: "+260",
    keyboardType: TextInputType.number,
    icon: AppIcons.phone,
  );

  factory InputFieldModel.cableTv() => InputFieldModel(
    label: "Account Number",
    prefix: "",
    keyboardType: TextInputType.number,
    icon: AppIcons.meter,
  );

  factory InputFieldModel.fromMerchantType(BillMerchantType merchantType) {
    switch (merchantType) {
      case BillMerchantType.airtime:
        return InputFieldModel.airtime();

      case BillMerchantType.data:
        return InputFieldModel.data();

      case BillMerchantType.electricity:
        return InputFieldModel.electricity();

      case BillMerchantType.cableTv:
        return InputFieldModel.cableTv();

      default:
        return InputFieldModel.empty();
    }
  }

  InputFieldModel copyWith({
    String? label,
    String? prefix,
    TextInputType? keyboardType,
    IconData? icon,
  }) {
    return InputFieldModel(
      label: label ?? this.label,
      prefix: prefix ?? this.prefix,
      keyboardType: keyboardType ?? this.keyboardType,
      icon: icon ?? this.icon,
    );
  }

  Map<String, dynamic> toMap() {
    return {'label': label, 'prefix': prefix, 'keyboardType': keyboardType};
  }

  factory InputFieldModel.fromMap(Map<String, dynamic> map) {
    return InputFieldModel(
      label: map['label'] ?? '',
      prefix: map['prefix'] ?? '',
      keyboardType: map['keyboardType'] ?? TextInputType.none,
    );
  }

  String toJson() => json.encode(toMap());

  factory InputFieldModel.fromJson(String source) =>
      InputFieldModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'InputFieldModel(label: $label, prefix: $prefix, keyboardType: $keyboardType)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is InputFieldModel &&
        other.label == label &&
        other.prefix == prefix &&
        other.keyboardType == keyboardType;
  }

  @override
  int get hashCode => label.hashCode ^ prefix.hashCode ^ keyboardType.hashCode;
}
