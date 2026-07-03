import 'dart:convert';

class BillItemModel {
  final String? accountNumber;
  final String? tag;
  final String? category;
  final double? value;

  BillItemModel({this.accountNumber, this.tag, this.category, this.value});

  BillItemModel copyWith({
    String? accountNumber,
    String? tag,
    String? category,
    double? value,
  }) {
    return BillItemModel(
      accountNumber: accountNumber ?? this.accountNumber,
      tag: tag ?? this.tag,
      category: category ?? this.category,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'accountNumber': accountNumber,
      'tag': tag,
      'category': category,
      'value': value,
    };
  }

  factory BillItemModel.fromMap(Map<String, dynamic> map) {
    return BillItemModel(
      accountNumber: map['accountNumber'],
      tag: map['tag'],
      category: map['category'],
      value: map['value']?.toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory BillItemModel.fromJson(String source) =>
      BillItemModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'BillItemModel(accountNumber: $accountNumber, tag: $tag, category: $category, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BillItemModel &&
        other.accountNumber == accountNumber &&
        other.tag == tag &&
        other.category == category &&
        other.value == value;
  }

  @override
  int get hashCode {
    return accountNumber.hashCode ^
        tag.hashCode ^
        category.hashCode ^
        value.hashCode;
  }
}
