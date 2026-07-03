import 'dart:convert';
import 'package:flutter/foundation.dart';

class WalletTransactionsModel {
  bool? status;
  String? message;
  int? totalTransactions;
  List<TransactionsModel>? transactions;

  WalletTransactionsModel({
    this.status,
    this.message,
    this.totalTransactions,
    this.transactions,
  });

  WalletTransactionsModel copyWith({
    ValueGetter<bool?>? status,
    ValueGetter<String?>? message,
    ValueGetter<int?>? totalTransactions,
    ValueGetter<List<TransactionsModel>?>? transactions,
  }) {
    return WalletTransactionsModel(
      status: status != null ? status() : this.status,
      message: message != null ? message() : this.message,
      totalTransactions: totalTransactions != null
          ? totalTransactions()
          : this.totalTransactions,
      transactions: transactions != null ? transactions() : this.transactions,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'message': message,
      'totalTransactions': totalTransactions,
      'transactions': transactions?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory WalletTransactionsModel.fromMap(Map<String, dynamic> map) {
    return WalletTransactionsModel(
      status: map['status'],
      message: map['message'],
      totalTransactions: map['totalTransactions']?.toInt(),
      transactions: map['transactions'] != null
          ? List<TransactionsModel>.from(
              map['transactions']?.map((x) => TransactionsModel.fromMap(x)),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory WalletTransactionsModel.fromJson(String source) =>
      WalletTransactionsModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'WalletTransactions(status: $status, message: $message, totalTransactions: $totalTransactions, transactions: $transactions)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WalletTransactionsModel &&
        other.status == status &&
        other.message == message &&
        other.totalTransactions == totalTransactions &&
        listEquals(other.transactions, transactions);
  }

  @override
  int get hashCode {
    return status.hashCode ^
        message.hashCode ^
        totalTransactions.hashCode ^
        transactions.hashCode;
  }
}

class TransactionsModel {
  String? date;
  String? formattedDate;
  String? sender;
  String? receiver;
  String? description;
  String? amount;
  String? currency;
  String? referenceId;
  String? narration;
  String? transactionType;
  String? vendor;
  String? timestamp;
  String? rawDetail;
  TransactionsModel({
    this.date,
    this.formattedDate,
    this.sender,
    this.receiver,
    this.description,
    this.amount,
    this.currency,
    this.referenceId,
    this.narration,
    this.transactionType,
    this.vendor,
    this.timestamp,
    this.rawDetail,
  });

  TransactionsModel copyWith({
    ValueGetter<String?>? date,
    ValueGetter<String?>? formattedDate,
    ValueGetter<String?>? sender,
    ValueGetter<String?>? receiver,
    ValueGetter<String?>? description,
    ValueGetter<String?>? amount,
    ValueGetter<String?>? currency,
    ValueGetter<String?>? referenceId,
    ValueGetter<String?>? narration,
    ValueGetter<String?>? transactionType,
    ValueGetter<String?>? vendor,
    ValueGetter<String?>? timestamp,
    ValueGetter<String?>? rawDetail,
  }) {
    return TransactionsModel(
      date: date != null ? date() : this.date,
      formattedDate: formattedDate != null
          ? formattedDate()
          : this.formattedDate,
      sender: sender != null ? sender() : this.sender,
      receiver: receiver != null ? receiver() : this.receiver,
      description: description != null ? description() : this.description,
      amount: amount != null ? amount() : this.amount,
      currency: currency != null ? currency() : this.currency,
      referenceId: referenceId != null ? referenceId() : this.referenceId,
      narration: narration != null ? narration() : this.narration,
      transactionType: transactionType != null
          ? transactionType()
          : this.transactionType,
      vendor: vendor != null ? vendor() : this.vendor,
      timestamp: timestamp != null ? timestamp() : this.timestamp,
      rawDetail: rawDetail != null ? rawDetail() : this.rawDetail,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'formattedDate': formattedDate,
      'sender': sender,
      'receiver': receiver,
      'description': description,
      'amount': amount,
      'currency': currency,
      'reference_id': referenceId,
      'narration': narration,
      'transaction_type': transactionType,
      'vendor': vendor,
      'timestamp': timestamp,
      'raw_detail': rawDetail,
    };
  }

  factory TransactionsModel.fromMap(Map<String, dynamic> map) {
    return TransactionsModel(
      date: map['date'],
      formattedDate: map['formattedDate'],
      sender: map['sender'],
      receiver: map['receiver'],
      description: map['description'],
      amount: map['amount'],
      currency: map['currency'],
      referenceId: map['reference_id'],
      narration: map['narration'],
      transactionType: map['transaction_type'],
      vendor: map['vendor'],
      timestamp: map['timestamp'],
      rawDetail: map['raw_detail'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionsModel.fromJson(String source) =>
      TransactionsModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Transactions(date: $date, formattedDate: $formattedDate, sender: $sender, receiver: $receiver, description: $description, amount: $amount, currency: $currency, reference_id: $referenceId, narration: $narration, transaction_type: $transactionType, vendor: $vendor, timestamp: $timestamp, raw_detail: $rawDetail)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TransactionsModel &&
        other.date == date &&
        other.formattedDate == formattedDate &&
        other.sender == sender &&
        other.receiver == receiver &&
        other.description == description &&
        other.amount == amount &&
        other.currency == currency &&
        other.referenceId == referenceId &&
        other.narration == narration &&
        other.transactionType == transactionType &&
        other.vendor == vendor &&
        other.timestamp == timestamp &&
        other.rawDetail == rawDetail;
  }

  @override
  int get hashCode {
    return date.hashCode ^
        formattedDate.hashCode ^
        sender.hashCode ^
        receiver.hashCode ^
        description.hashCode ^
        amount.hashCode ^
        currency.hashCode ^
        referenceId.hashCode ^
        narration.hashCode ^
        transactionType.hashCode ^
        vendor.hashCode ^
        timestamp.hashCode ^
        rawDetail.hashCode;
  }
}
