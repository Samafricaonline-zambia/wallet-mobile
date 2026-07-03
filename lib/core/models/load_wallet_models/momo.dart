import 'dart:convert';

class LoadWalletWithMOMO {
  final double? amount;
  final String? account;
  final String? reference;
  final String? service;
  final String? wallet;

  LoadWalletWithMOMO({
    this.amount,
    this.account,
    this.reference,
    this.service,
    this.wallet,
  });

  LoadWalletWithMOMO copyWith({
    double? amount,
    String? account,
    String? reference,
    String? service,
    String? wallet,
  }) {
    return LoadWalletWithMOMO(
      amount: amount ?? this.amount,
      account: account ?? this.account,
      reference: reference ?? this.reference,
      service: service ?? this.service,
      wallet: wallet ?? this.wallet,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'account': account,
      'reference': reference,
      'service': service,
      'wallet': wallet,
    };
  }

  factory LoadWalletWithMOMO.fromMap(Map<String, dynamic> map) {
    return LoadWalletWithMOMO(
      amount: map['amount']?.toInt() ?? 0,
      account: map['account'] ?? '',
      reference: map['reference'] ?? '',
      service: map['service'] ?? '',
      wallet: map['wallet'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory LoadWalletWithMOMO.fromJson(String source) =>
      LoadWalletWithMOMO.fromMap(json.decode(source));

  @override
  String toString() {
    return 'LoadWalletWithMOMO(amount: $amount, account: $account, reference: $reference, service: $service, wallet: $wallet)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LoadWalletWithMOMO &&
        other.amount == amount &&
        other.account == account &&
        other.reference == reference &&
        other.service == service &&
        other.wallet == wallet;
  }

  @override
  int get hashCode {
    return amount.hashCode ^
        account.hashCode ^
        reference.hashCode ^
        service.hashCode ^
        wallet.hashCode;
  }
}
