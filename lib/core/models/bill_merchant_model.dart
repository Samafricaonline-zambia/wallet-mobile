import 'dart:convert';

import 'package:flutter/widgets.dart';

import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/models/input_field_model.dart';
import 'package:sampay_wallet/core/validations/validations.dart';

class BillMerchantModel {
  final String name;
  final String? label;
  final String? service;
  final String? transactionType;
  final BillMerchantType merchantType;
  final String icon;
  final InputFieldModel? inputField;

  BillMerchantModel({
    required this.name,
    this.label,
    required this.merchantType,
    required this.icon,
    this.inputField,
    this.service,
    this.transactionType,
  });

  factory BillMerchantModel.empty() => BillMerchantModel(
    name: "",
    label: "",
    merchantType: BillMerchantType.none,
    icon: "",
    inputField: InputFieldModel.empty(),
    service: "",
    transactionType: "",
  );

  factory BillMerchantModel.fromBillMerchant(BillMerchants merchant) =>
      AppConstants.BILL_MERCHANTS.firstWhere(
        (billMerchant) =>
            billMerchant.name.toLowerCase() == merchant.name.toLowerCase(),
        orElse: () => BillMerchantModel.empty(),
      );

  BillMerchantModel copyWith({
    String? name,
    String? label,
    BillMerchantType? merchantType,
    String? icon,
    InputFieldModel? inputField,
    Function(String? value, {String? message})? validator,
    String? service,
    String? transactionType,
  }) {
    return BillMerchantModel(
      name: name ?? this.name,
      label: label ?? this.label,
      merchantType: merchantType ?? this.merchantType,
      icon: icon ?? this.icon,
      inputField: inputField ?? this.inputField,
      service: service ?? this.service,
      transactionType: transactionType ?? this.transactionType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'label': label,
      'service': service,
      'transactionType': transactionType,
      'merchantType': merchantType,
      'icon': icon,
      'inputField': inputField?.toMap(),
    };
  }

  factory BillMerchantModel.fromMap(Map<String, dynamic> map) {
    return BillMerchantModel(
      name: map['name'] ?? '',
      label: map['label'],
      service: map['service'],
      transactionType: map['transactionType'],
      merchantType: BillMerchantType.fromString(map['merchantType']),
      icon: map['icon'] ?? '',
      inputField: map['inputField'] != null
          ? InputFieldModel.fromMap(map['inputField'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BillMerchantModel.fromJson(String source) =>
      BillMerchantModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'BillMerchantModel(name: $name, label: $label, merchantType: $merchantType, icon: $icon, inputField: $inputField, service: $service, transactionType: $transactionType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BillMerchantModel &&
        other.name == name &&
        other.label == label &&
        other.service == service &&
        other.transactionType == transactionType &&
        other.merchantType == merchantType &&
        other.icon == icon &&
        other.inputField == inputField;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        label.hashCode ^
        service.hashCode ^
        transactionType.hashCode ^
        merchantType.hashCode ^
        icon.hashCode ^
        inputField.hashCode;
  }
}
