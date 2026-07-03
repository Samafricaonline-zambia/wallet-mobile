import 'dart:convert';

class KYCAndChargesModel {
  final String institutionId;
  final String account;
  final double amount;
  final String? requestType;

  KYCAndChargesModel({
    required this.institutionId,
    required this.account,
    required this.amount,
    this.requestType,
  });

  KYCAndChargesModel copyWith({
    String? institutionId,
    String? account,
    double? amount,
    String? requestType,
  }) {
    return KYCAndChargesModel(
      institutionId: institutionId ?? this.institutionId,
      account: account ?? this.account,
      amount: amount ?? this.amount,
      requestType: requestType ?? this.requestType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'institution_id': institutionId,
      'account': account,
      'amount': amount,
      'request': requestType,
    };
  }

  factory KYCAndChargesModel.fromMap(Map<String, dynamic> map) {
    return KYCAndChargesModel(
      institutionId: map['institution_id'] ?? '',
      account: map['account'] ?? '',
      amount: map['amount']?.toDouble() ?? 0.0,
      requestType: map['request'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory KYCAndChargesModel.fromJson(String source) =>
      KYCAndChargesModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'KYCAndChargesModel(institution_id: $institutionId, account: $account, amount: $amount, request: $requestType)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is KYCAndChargesModel &&
        other.institutionId == institutionId &&
        other.account == account &&
        other.amount == amount &&
        other.requestType == requestType;
  }

  @override
  int get hashCode =>
      institutionId.hashCode ^
      account.hashCode ^
      amount.hashCode ^
      requestType.hashCode;
}
