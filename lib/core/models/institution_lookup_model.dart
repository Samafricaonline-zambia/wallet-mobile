import 'dart:convert';

class AccountLookupModel {
  final bool status;
  final String accountName;
  final bool accountValid;
  final String rrn;
  final String institutionName;
  final String institutionType;
  final double feePreview;
  final String message;

  AccountLookupModel({
    required this.status,
    required this.accountName,
    required this.accountValid,
    required this.rrn,
    required this.institutionName,
    required this.institutionType,
    required this.feePreview,
    required this.message,
  });

  AccountLookupModel copyWith({
    bool? status,
    String? accountName,
    bool? accountValid,
    String? rrn,
    String? institutionName,
    String? institutionType,
    double? feePreview,
    String? message,
  }) => AccountLookupModel(
    status: status ?? this.status,
    accountName: accountName ?? this.accountName,
    accountValid: accountValid ?? this.accountValid,
    rrn: rrn ?? this.rrn,
    institutionName: institutionName ?? this.institutionName,
    institutionType: institutionType ?? this.institutionType,
    feePreview: feePreview ?? this.feePreview,
    message: message ?? this.message,
  );

  factory AccountLookupModel.empty() => AccountLookupModel(
    status: false,
    accountName: "",
    accountValid: false,
    rrn: "",
    institutionName: "",
    institutionType: "",
    feePreview: 0.0,
    message: "",
  );

  factory AccountLookupModel.fromJson(String str) =>
      AccountLookupModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AccountLookupModel.fromMap(Map<String, dynamic> json) =>
      AccountLookupModel(
        status: json["status"],
        accountName: json["account_name"],
        accountValid: json["account_valid"],
        rrn: json["rrn"],
        institutionName: json["institution_name"],
        institutionType: json["institution_type"],
        feePreview: json["fee_preview"] ?? 0.0,
        message: json["message"],
      );

  Map<String, dynamic> toMap() => {
    "status": status,
    "account_name": accountName,
    "account_valid": accountValid,
    "rrn": rrn,
    "institution_name": institutionName,
    "institution_type": institutionType,
    "fee_preview": feePreview,
    "message": message,
  };
}
