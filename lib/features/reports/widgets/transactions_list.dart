import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/models/wallet_transactions_model.dart';
import 'package:sampay_wallet/core/widgets/simple_divider.dart';
import 'package:sampay_wallet/features/reports/widgets/transaction_tile.dart';

class TransactionsList extends StatelessWidget {
  final WalletTransactionsModel transactions;
  const TransactionsList({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      //shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) =>
          TransactionTile(transaction: transactions.transactions![index]),
      separatorBuilder: (context, index) => SimpleDivider(),
      itemCount: transactions.totalTransactions ?? 0,
    );
  }
}
