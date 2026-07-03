import 'dart:convert';

class LoadWalletWithCard {
  final double? amount;
  final String? cardNumber;
  final String? expiry;
  final String? cvv;
  final String? reference;

  LoadWalletWithCard({
    this.amount,
    this.cardNumber,
    this.expiry,
    this.cvv,
    this.reference,
  });

  LoadWalletWithCard copyWith({
    double? amount,
    String? cardNumber,
    String? expiry,
    String? cvv,
    String? reference,
  }) {
    return LoadWalletWithCard(
      amount: amount ?? this.amount,
      cardNumber: cardNumber ?? this.cardNumber,
      expiry: expiry ?? this.expiry,
      cvv: cvv ?? this.cvv,
      reference: reference ?? this.reference,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'card_number': cardNumber,
      'expiry': expiry,
      'cvv': cvv,
      'reference': reference,
    };
  }

  factory LoadWalletWithCard.fromMap(Map<String, dynamic> map) {
    return LoadWalletWithCard(
      amount: map['amount']?.toInt() ?? 0,
      cardNumber: map['card_number'] ?? '',
      expiry: map['expiry'] ?? '',
      cvv: map['cvv'] ?? '',
      reference: map['reference'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory LoadWalletWithCard.fromJson(String source) =>
      LoadWalletWithCard.fromMap(json.decode(source));

  @override
  String toString() {
    return 'LoadWalletWithCard(amount: $amount, card_number: $cardNumber, expiry: $expiry, cvv: $cvv, reference: $reference)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LoadWalletWithCard &&
        other.amount == amount &&
        other.cardNumber == cardNumber &&
        other.expiry == expiry &&
        other.cvv == cvv &&
        other.reference == reference;
  }

  @override
  int get hashCode {
    return amount.hashCode ^
        cardNumber.hashCode ^
        expiry.hashCode ^
        cvv.hashCode ^
        reference.hashCode;
  }
}
