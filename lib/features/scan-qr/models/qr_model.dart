import 'dart:convert';

import 'package:sampay_wallet/core/utils/app_utils.dart';

class QRModel {
  final String? id;
  final String? phone;
  final String? name;
  final String? wallet;
  final double? amount;

  const QRModel({this.id, this.phone, this.name, this.wallet, this.amount});
  QRModel copyWith({
    String? id,
    String? phone,
    String? name,
    String? wallet,
    double? amount,
  }) {
    return QRModel(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      wallet: wallet ?? this.wallet,
      amount: amount ?? this.amount,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'phone': phone,
      'name': name,
      'wallet': wallet,
      'amount': amount,
    };
  }

  static QRModel fromMap(Map<String, Object?> json) {
    return QRModel(
      id: json['id'] == null ? null : json['id'] as String,
      phone: json['phone'] == null ? null : json['phone'] as String,
      name: json['name'] == null ? null : json['name'] as String,
      wallet: json['wallet'] == null ? null : json['wallet'] as String,
      amount: json['amount'] == null ? null : json['amount'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory QRModel.fromJson(String source) =>
      QRModel.fromMap(json.decode(source));

  @override
  String toString() {
    return "$id|$phone|$name|$wallet|$amount|sampay";
  }

  factory QRModel.fromString(String source) {
    final segments = source.split("|");

    return QRModel(
      id: segments[0],
      phone: segments[1],
      name: segments[2],
      wallet: segments[3],
      amount: AppUtils().valueOrDefault(double.tryParse(segments[4])),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is QRModel &&
        other.runtimeType == runtimeType &&
        other.id == id &&
        other.phone == phone &&
        other.name == name &&
        other.wallet == wallet &&
        other.amount == amount;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, id, phone, name, wallet, amount);
  }
}
