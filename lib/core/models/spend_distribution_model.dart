import 'dart:convert';

import 'package:flutter/foundation.dart';

class SpendDistributionModel {
  bool? status;
  String? message;
  String? currency;
  String? period;
  String? from;
  String? to;
  double? totalSpent;
  List<SpendBreakdownItem>? breakdown;

  SpendDistributionModel({
    this.status,
    this.message,
    this.currency,
    this.period,
    this.from,
    this.to,
    this.totalSpent,
    this.breakdown,
  });

  SpendDistributionModel copyWith({
    ValueGetter<bool?>? status,
    ValueGetter<String?>? message,
    ValueGetter<String?>? currency,
    ValueGetter<String?>? period,
    ValueGetter<String?>? from,
    ValueGetter<String?>? to,
    ValueGetter<double?>? totalSpent,
    ValueGetter<List<SpendBreakdownItem>?>? breakdown,
  }) {
    return SpendDistributionModel(
      status: status != null ? status() : this.status,
      message: message != null ? message() : this.message,
      currency: currency != null ? currency() : this.currency,
      period: period != null ? period() : this.period,
      from: from != null ? from() : this.from,
      to: to != null ? to() : this.to,
      totalSpent: totalSpent != null ? totalSpent() : this.totalSpent,
      breakdown: breakdown != null ? breakdown() : this.breakdown,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'message': message,
      'currency': currency,
      'period': period,
      'from': from,
      'to': to,
      'total_spent': totalSpent,
      'breakdown': breakdown?.map((x) => x.toMap()).toList(),
    };
  }

  factory SpendDistributionModel.fromMap(Map<String, dynamic> map) {
    return SpendDistributionModel(
      status: map['status'],
      message: map['message'],
      currency: map['currency'],
      period: map['period'],
      from: map['from'],
      to: map['to'],
      totalSpent: map['total_spent']?.toDouble(),
      breakdown: map['breakdown'] != null
          ? List<SpendBreakdownItem>.from(
              map['breakdown']?.map((x) => SpendBreakdownItem.fromMap(x)),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SpendDistributionModel.fromJson(String source) =>
      SpendDistributionModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SpendDistributionModel(status: $status, message: $message, currency: $currency, period: $period, from: $from, to: $to, totalSpent: $totalSpent, breakdown: $breakdown)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SpendDistributionModel &&
        other.status == status &&
        other.message == message &&
        other.currency == currency &&
        other.period == period &&
        other.from == from &&
        other.to == to &&
        other.totalSpent == totalSpent &&
        listEquals(other.breakdown, breakdown);
  }

  @override
  int get hashCode {
    return status.hashCode ^
        message.hashCode ^
        currency.hashCode ^
        period.hashCode ^
        from.hashCode ^
        to.hashCode ^
        totalSpent.hashCode ^
        breakdown.hashCode;
  }
}

class SpendBreakdownItem {
  String? vendor;
  double? amount;
  double? percentage;
  int? transactionCount;

  SpendBreakdownItem({
    this.vendor,
    this.amount,
    this.percentage,
    this.transactionCount,
  });

  SpendBreakdownItem copyWith({
    ValueGetter<String?>? vendor,
    ValueGetter<double?>? amount,
    ValueGetter<double?>? percentage,
    ValueGetter<int?>? transactionCount,
  }) {
    return SpendBreakdownItem(
      vendor: vendor != null ? vendor() : this.vendor,
      amount: amount != null ? amount() : this.amount,
      percentage: percentage != null ? percentage() : this.percentage,
      transactionCount: transactionCount != null
          ? transactionCount()
          : this.transactionCount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'vendor': vendor,
      'amount': amount,
      'percentage': percentage,
      'transaction_count': transactionCount,
    };
  }

  factory SpendBreakdownItem.fromMap(Map<String, dynamic> map) {
    return SpendBreakdownItem(
      vendor: map['vendor'],
      amount: map['amount']?.toDouble(),
      percentage: map['percentage']?.toDouble(),
      transactionCount: map['transaction_count']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory SpendBreakdownItem.fromJson(String source) =>
      SpendBreakdownItem.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SpendBreakdownItem(vendor: $vendor, amount: $amount, percentage: $percentage, transactionCount: $transactionCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SpendBreakdownItem &&
        other.vendor == vendor &&
        other.amount == amount &&
        other.percentage == percentage &&
        other.transactionCount == transactionCount;
  }

  @override
  int get hashCode =>
      vendor.hashCode ^
      amount.hashCode ^
      percentage.hashCode ^
      transactionCount.hashCode;
}
