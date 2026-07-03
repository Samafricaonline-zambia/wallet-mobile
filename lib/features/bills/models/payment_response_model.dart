import 'dart:convert';

class PaymentResponseModel {
  final String service;
  final int amount;
  final String account;
  final String reference;
  final String externalReference;
  final String token;
  PaymentResponseModel({
    required this.service,
    required this.amount,
    required this.account,
    required this.reference,
    required this.externalReference,
    required this.token,
  });

  PaymentResponseModel copyWith({
    String? service,
    int? amount,
    String? account,
    String? reference,
    String? externalReference,
    String? token,
  }) {
    return PaymentResponseModel(
      service: service ?? this.service,
      amount: amount ?? this.amount,
      account: account ?? this.account,
      reference: reference ?? this.reference,
      externalReference: externalReference ?? this.externalReference,
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'service': service,
      'amount': amount,
      'account': account,
      'reference': reference,
      'external_reference': externalReference,
      'token': token,
    };
  }

  factory PaymentResponseModel.fromMap(Map<String, dynamic> map) {
    return PaymentResponseModel(
      service: map['service'] ?? '',
      amount: map['amount']?.toInt() ?? 0,
      account: map['account'] ?? '',
      reference: map['reference'] ?? '',
      externalReference: map['external_reference'] ?? '',
      token: map['token'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentResponseModel.fromJson(String source) =>
      PaymentResponseModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Data(service: $service, amount: $amount, account: $account, reference: $reference, external_reference: $externalReference, token: $token)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PaymentResponseModel &&
        other.service == service &&
        other.amount == amount &&
        other.account == account &&
        other.reference == reference &&
        other.externalReference == externalReference &&
        other.token == token;
  }

  @override
  int get hashCode {
    return service.hashCode ^
        amount.hashCode ^
        account.hashCode ^
        reference.hashCode ^
        externalReference.hashCode ^
        token.hashCode;
  }
}
