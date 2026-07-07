import 'dart:convert';

class InternationalPaymentsRequestModel {
  final String spid;
  final double amount;
  final String receiverfullname;
  final String receiveraddress;
  final String receiverpostcode;
  final String receivertown;
  final String receivercountry;
  final String creditaccount;
  final String senderfullname;
  final String debtoraccount;
  final String senderreportcode;
  final String senderreason;
  final String accountType;
  final int senderreasonindex; // New property

  InternationalPaymentsRequestModel({
    required this.spid,
    required this.amount,
    required this.receiverfullname,
    required this.receiveraddress,
    required this.receiverpostcode,
    required this.receivertown,
    required this.receivercountry,
    required this.creditaccount,
    required this.senderfullname,
    required this.debtoraccount,
    required this.senderreportcode,
    required this.senderreason,
    required this.accountType,
    this.senderreasonindex = 0, // Added to constructor
  });

  InternationalPaymentsRequestModel copyWith({
    String? spid,
    double? amount,
    String? receiverfullname,
    String? receiveraddress,
    String? receiverpostcode,
    String? receivertown,
    String? receivercountry,
    String? creditaccount,
    String? senderfullname,
    String? debtoraccount,
    String? senderreportcode,
    String? senderreason,
    String? accountType,
    int? senderreasonindex, // Added to copyWith
  }) {
    return InternationalPaymentsRequestModel(
      spid: spid ?? this.spid,
      amount: amount ?? this.amount,
      receiverfullname: receiverfullname ?? this.receiverfullname,
      receiveraddress: receiveraddress ?? this.receiveraddress,
      receiverpostcode: receiverpostcode ?? this.receiverpostcode,
      receivertown: receivertown ?? this.receivertown,
      receivercountry: receivercountry ?? this.receivercountry,
      creditaccount: creditaccount ?? this.creditaccount,
      senderfullname: senderfullname ?? this.senderfullname,
      debtoraccount: debtoraccount ?? this.debtoraccount,
      senderreportcode: senderreportcode ?? this.senderreportcode,
      senderreason: senderreason ?? this.senderreason,
      accountType: accountType ?? this.accountType,
      senderreasonindex: senderreasonindex ?? this.senderreasonindex,
    );
  }

  factory InternationalPaymentsRequestModel.empty() =>
      InternationalPaymentsRequestModel(
        spid: "",
        amount: 0.0,
        receiverfullname: "",
        receiveraddress: "",
        receiverpostcode: "",
        receivertown: "",
        receivercountry: "",
        creditaccount: "",
        senderfullname: "",
        debtoraccount: "",
        senderreportcode: "",
        senderreason: "",
        accountType: "",
        senderreasonindex: 0, // Default value for empty
      );

  Map<String, dynamic> toMap() {
    return {
      'spid': spid,
      'amount': amount,
      'receiverfullname': receiverfullname,
      'receiveraddress': receiveraddress,
      'receiverpostcode': receiverpostcode,
      'receivertown': receivertown,
      'receivercountry': receivercountry,
      'creditaccount': creditaccount,
      'senderfullname': senderfullname,
      'debtoraccount': debtoraccount,
      'senderreportcode': senderreportcode,
      'senderreason': senderreason,
      'accountType': accountType,
      'senderreasonindex': senderreasonindex, // Added to map
    };
  }

  factory InternationalPaymentsRequestModel.fromMap(Map<String, dynamic> map) {
    return InternationalPaymentsRequestModel(
      spid: map['spid'] ?? '',
      amount: map['amount']?.toInt() ?? 0,
      receiverfullname: map['receiverfullname'] ?? '',
      receiveraddress: map['receiveraddress'] ?? '',
      receiverpostcode: map['receiverpostcode'] ?? '',
      receivertown: map['receivertown'] ?? '',
      receivercountry: map['receivercountry'] ?? '',
      creditaccount: map['creditaccount'] ?? '',
      senderfullname: map['senderfullname'] ?? '',
      debtoraccount: map['debtoraccount'] ?? '',
      senderreportcode: map['senderreportcode'] ?? '',
      senderreason: map['senderreason'] ?? '',
      accountType: map['accountType'] ?? '',
      senderreasonindex: map['senderreasonindex'] ?? 0, // Added to fromMap
    );
  }

  String toJson() => json.encode(toMap());

  factory InternationalPaymentsRequestModel.fromJson(String source) =>
      InternationalPaymentsRequestModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'InternationalPaymentsRequestModel(spid: $spid, amount: $amount, receiverfullname: $receiverfullname, receiveraddress: $receiveraddress, receiverpostcode: $receiverpostcode, receivertown: $receivertown, receivercountry: $receivercountry, creditaccount: $creditaccount, senderfullname: $senderfullname, debtoraccount: $debtoraccount, senderreportcode: $senderreportcode, senderreason: $senderreason, accountType: $accountType, senderreasonindex: $senderreasonindex)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is InternationalPaymentsRequestModel &&
        other.spid == spid &&
        other.amount == amount &&
        other.receiverfullname == receiverfullname &&
        other.receiveraddress == receiveraddress &&
        other.receiverpostcode == receiverpostcode &&
        other.receivertown == receivertown &&
        other.receivercountry == receivercountry &&
        other.creditaccount == creditaccount &&
        other.senderfullname == senderfullname &&
        other.debtoraccount == debtoraccount &&
        other.senderreportcode == senderreportcode &&
        other.senderreason == senderreason &&
        other.accountType == accountType &&
        other.senderreasonindex == senderreasonindex; // Added to equality
  }

  @override
  int get hashCode {
    return spid.hashCode ^
        amount.hashCode ^
        receiverfullname.hashCode ^
        receiveraddress.hashCode ^
        receiverpostcode.hashCode ^
        receivertown.hashCode ^
        receivercountry.hashCode ^
        creditaccount.hashCode ^
        senderfullname.hashCode ^
        debtoraccount.hashCode ^
        senderreportcode.hashCode ^
        senderreason.hashCode ^
        accountType.hashCode ^
        senderreasonindex.hashCode; // Added to hash
  }
}
