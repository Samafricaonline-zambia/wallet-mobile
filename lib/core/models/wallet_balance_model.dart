import 'dart:convert';

import 'package:flutter/widgets.dart';

class WalletBalanceModel {
  final bool? status;
  final Balances? balances;
  final String? client;
  WalletBalanceModel({this.status, this.balances, this.client});

  WalletBalanceModel copyWith({
    ValueGetter<bool?>? status,
    ValueGetter<Balances?>? balances,
    ValueGetter<String?>? client,
  }) {
    return WalletBalanceModel(
      status: status != null ? status() : this.status,
      balances: balances != null ? balances() : this.balances,
      client: client != null ? client() : this.client,
    );
  }

  Map<String, dynamic> toMap() {
    return {'status': status, 'balances': balances?.toMap(), 'client': client};
  }

  factory WalletBalanceModel.fromMap(Map<String, dynamic> map) {
    return WalletBalanceModel(
      status: map['status'],
      balances: map['balances'] != null
          ? Balances.fromMap(map['balances'])
          : null,
      client: map['client'],
    );
  }

  String toJson() => json.encode(toMap());

  factory WalletBalanceModel.fromJson(String source) =>
      WalletBalanceModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'WalletBalanceModel(status: $status, balances: $balances, client: $client)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WalletBalanceModel &&
        other.status == status &&
        other.balances == balances &&
        other.client == client;
  }

  @override
  int get hashCode => status.hashCode ^ balances.hashCode ^ client.hashCode;
}

class Balances {
  final Local? local;
  final International? international;
  Balances({this.local, this.international});

  Balances copyWith({
    ValueGetter<Local?>? local,
    ValueGetter<International?>? international,
  }) {
    return Balances(
      local: local != null ? local() : this.local,
      international: international != null
          ? international()
          : this.international,
    );
  }

  Map<String, dynamic> toMap() {
    return {'local': local?.toMap(), 'international': international?.toMap()};
  }

  factory Balances.fromMap(Map<String, dynamic> map) {
    return Balances(
      local: map['local'] != null ? Local.fromMap(map['local']) : null,
      international: map['international'] != null
          ? International.fromMap(map['international'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Balances.fromJson(String source) =>
      Balances.fromMap(json.decode(source));

  @override
  String toString() => 'Balances(local: $local, international: $international)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Balances &&
        other.local == local &&
        other.international == international;
  }

  @override
  int get hashCode => local.hashCode ^ international.hashCode;
}

class Local {
  final String? amount;
  final String? currency;
  final String? accountStatus;
  Local({this.amount, this.currency, this.accountStatus});

  Local copyWith({
    ValueGetter<String?>? amount,
    ValueGetter<String?>? currency,
    ValueGetter<String?>? accountStatus,
  }) {
    return Local(
      amount: amount != null ? amount() : this.amount,
      currency: currency != null ? currency() : this.currency,
      accountStatus: accountStatus != null
          ? accountStatus()
          : this.accountStatus,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'currency': currency,
      'account_status': accountStatus,
    };
  }

  factory Local.fromMap(Map<String, dynamic> map) {
    return Local(
      amount: map['amount'],
      currency: map['currency'],
      accountStatus: map['account_status'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Local.fromJson(String source) => Local.fromMap(json.decode(source));

  @override
  String toString() =>
      'Local(amount: $amount, currency: $currency, accountStatus: $accountStatus)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Local &&
        other.amount == amount &&
        other.currency == currency &&
        other.accountStatus == accountStatus;
  }

  @override
  int get hashCode =>
      amount.hashCode ^ currency.hashCode ^ accountStatus.hashCode;
}

class International {
  final String? amount;
  final String? accountStatus;
  final bool? tpinVerified;
  final String? email;
  final String? zraTpin;
  International({
    this.amount,
    this.accountStatus,
    this.tpinVerified,
    this.email,
    this.zraTpin,
  });

  International copyWith({
    ValueGetter<String?>? amount,
    ValueGetter<String?>? accountStatus,
    ValueGetter<bool?>? tpinVerified,
    ValueGetter<String?>? email,
    ValueGetter<String?>? zraTpin,
  }) {
    return International(
      amount: amount != null ? amount() : this.amount,
      accountStatus: accountStatus != null
          ? accountStatus()
          : this.accountStatus,
      tpinVerified: tpinVerified != null ? tpinVerified() : this.tpinVerified,
      email: email != null ? email() : this.email,
      zraTpin: zraTpin != null ? zraTpin() : this.zraTpin,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'account_status': accountStatus,
      'tpinVerified': tpinVerified,
      'email': email,
      'zraTpin': zraTpin,
    };
  }

  factory International.fromMap(Map<String, dynamic> map) {
    return International(
      amount: map['amount'],
      accountStatus: map['account_status'],
      tpinVerified: map['tpinVerified'],
      email: map['email'],
      zraTpin: map['zraTpin'],
    );
  }

  String toJson() => json.encode(toMap());

  factory International.fromJson(String source) =>
      International.fromMap(json.decode(source));

  @override
  String toString() {
    return 'International(amount: $amount, accountStatus: $accountStatus, tpinVerified: $tpinVerified, email: $email, zraTpin: $zraTpin)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is International &&
        other.amount == amount &&
        other.accountStatus == accountStatus &&
        other.tpinVerified == tpinVerified &&
        other.email == email &&
        other.zraTpin == zraTpin;
  }

  @override
  int get hashCode {
    return amount.hashCode ^
        accountStatus.hashCode ^
        tpinVerified.hashCode ^
        email.hashCode ^
        zraTpin.hashCode;
  }
}
