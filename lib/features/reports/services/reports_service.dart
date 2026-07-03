import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/models/wallet_transactions_model.dart';

class ReportsService {
  ValueNotifier<int> selectedTabIndex = ValueNotifier(0);
  ValueNotifier<TransactionsModel?> selectedTransaction = ValueNotifier(null);

  void setSelectedTabIndex(int index) => selectedTabIndex.value = index;

  void setSelectedTransaction(TransactionsModel? value) =>
      selectedTransaction.value = value;
}
