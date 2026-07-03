import 'dart:convert';

class WalletModel {
  final double balance;
  final String title;
  final String currency;
  final bool isActive;

  WalletModel({
    this.balance = 0.0,
    this.title = "",
    this.currency = "",
    this.isActive = false,
  });

  WalletModel copyWith({
    double? balance,
    String? title,
    String? currency,
    bool? isActive,
  }) {
    return WalletModel(
      balance: balance ?? this.balance,
      title: title ?? this.title,
      currency: currency ?? this.currency,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'balance': balance,
      'title': title,
      'currency': currency,
      'account_status': isActive ? 'active' : 'inactive',
    };
  }

  factory WalletModel.fromMap(Map<String, dynamic> map) {
    return WalletModel(
      balance: map['balance']?.toDouble() ?? 0.0,
      title: map['title'] ?? '',
      currency: map['currency'] ?? '',
      isActive: (map['account_status'] ?? '') == "active",
    );
  }

  String toJson() => json.encode(toMap());

  factory WalletModel.fromJson(String source) =>
      WalletModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'WalletModel(balance: $balance, title: $title, currency: $currency, isActive: $isActive)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WalletModel &&
        other.balance == balance &&
        other.title == title &&
        other.currency == currency &&
        other.isActive == isActive;
  }

  @override
  int get hashCode =>
      balance.hashCode ^ title.hashCode ^ currency.hashCode ^ isActive.hashCode;
}
