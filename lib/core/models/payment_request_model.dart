import 'dart:convert';

class PaymentRequestModel {
  final String request;
  final String institutionId;
  final String account;
  final double amount;
  final String reference;
  final String service;

  PaymentRequestModel({
    this.request = "",
    required this.institutionId,
    required this.account,
    required this.amount,
    this.reference = "",
    required this.service,
  });

  PaymentRequestModel copyWith({
    String? request,
    String? institutionId,
    String? account,
    double? amount,
    String? reference,
    String? service,
  }) => PaymentRequestModel(
    request: request ?? this.request,
    institutionId: institutionId ?? this.institutionId,
    account: account ?? this.account,
    amount: amount ?? this.amount,
    reference: reference ?? this.reference,
    service: service ?? this.service,
  );

  factory PaymentRequestModel.empty() => PaymentRequestModel(
    request: "",
    institutionId: "",
    account: "",
    amount: 0.0,
    reference: "",
    service: "",
  );

  factory PaymentRequestModel.fromJson(String str) =>
      PaymentRequestModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PaymentRequestModel.fromMap(Map<String, dynamic> json) =>
      PaymentRequestModel(
        request: json["request"],
        institutionId: json["institution_id"],
        account: json["account"],
        amount: json["amount"],
        reference: json["reference"],
        service: json["service"],
      );

  Map<String, dynamic> toMap() => {
    "request": request,
    "institution_id": institutionId,
    "account": account,
    "amount": amount,
    "reference": reference,
    "service": service,
  };
}
