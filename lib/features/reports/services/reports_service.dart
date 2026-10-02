import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/models/wallet_transactions_model.dart';
import 'package:sampay_wallet/core/utils/date_utils.dart';

class ReportsService extends ChangeNotifier {
  ValueNotifier<int> selectedTabIndex = ValueNotifier(0);
  ValueNotifier<int> selectedFilterIndex = ValueNotifier(0);
  ValueNotifier<SimpleDateRange> selectedDateRange = ValueNotifier(
    SimpleDateRange.empty(),
  );
  ValueNotifier<TransactionsModel?> selectedTransaction = ValueNotifier(null);

  void setSelectedTabIndex(int index) {
    selectedTabIndex.value = index;
    notifyListeners();
  }

  void setSelectedFilterIndex(int index) {
    selectedFilterIndex.value = index;
    notifyListeners();
  }

  SimpleDateRange setSelectedDateRange(String filter) {
    final newDateRange = DateTimeUtils().rangeForFilter(filter);

    selectedDateRange.value = selectedDateRange.value.copyWith(
      period: newDateRange.period,
      fromDate: newDateRange.fromDate,
      toDate: newDateRange.toDate,
    );
    notifyListeners();

    return newDateRange;
  }

  void setSelectedTransaction(TransactionsModel? value) {
    selectedTransaction.value = value;
    notifyListeners();
  }
}
