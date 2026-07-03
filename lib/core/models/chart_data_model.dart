import 'dart:convert';

import 'package:flutter/widgets.dart';

class ChartDataModel {
  final String label;
  final double value;
  final int? index;

  ChartDataModel({required this.label, required this.value, this.index});

  ChartDataModel copyWith({String? label, double? value, int? index}) {
    return ChartDataModel(
      label: label ?? this.label,
      value: value ?? this.value,
      index: index ?? this.index,
    );
  }

  Map<String, dynamic> toMap() {
    return {'label': label, 'value': value, 'index': index};
  }

  factory ChartDataModel.fromMap(Map<String, dynamic> map) {
    return ChartDataModel(
      label: map['label'] ?? '',
      value: map['value']?.toDouble() ?? 0.0,
      index: map['index']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChartDataModel.fromJson(String source) =>
      ChartDataModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'ChartDataModel(label: $label, value: $value, index: $index)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChartDataModel &&
        other.label == label &&
        other.value == value &&
        other.index == index;
  }

  @override
  int get hashCode => label.hashCode ^ value.hashCode ^ index.hashCode;
}
