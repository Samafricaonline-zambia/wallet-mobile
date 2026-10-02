import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/layouts/dashboard_layout.dart';
import 'package:sampay_wallet/core/models/spend_distribution_model.dart';
import 'package:sampay_wallet/core/models/wallet_transactions_model.dart';
import 'package:sampay_wallet/core/routes/app_router.dart';
import 'package:sampay_wallet/core/services/configure_dependencies.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/core/utils/date_utils.dart';
import 'package:sampay_wallet/core/widgets/empty_space.dart';
import 'package:sampay_wallet/core/widgets/simple_app_text.dart';
import 'package:sampay_wallet/core/widgets/simple_drop_down.dart';
import 'package:sampay_wallet/core/widgets/simple_section_title.dart';
import 'package:sampay_wallet/features/reports/services/reports_service.dart';
import 'package:sampay_wallet/features/reports/widgets/expense_chart.dart';
import 'package:sampay_wallet/features/reports/widgets/report_tab.dart';
import 'package:sampay_wallet/features/reports/widgets/transaction_tile.dart';
import 'package:sampay_wallet/services/app_state_service.dart';
import 'package:sampay_wallet/services/wallet_service.dart';
import 'package:watch_it/watch_it.dart';

class ReportsPage extends StatelessWidget with WatchItMixin {
  final AppStateService appState = getIt<AppStateService>();
  final WalletService walletService = getIt<WalletService>();
  final ReportsService reportsService = getIt<ReportsService>();
  final List<String> filters = [
    "Current week",
    "Last week",
    "Current month",
    "Last month",
    "Current quarter",
    "Last quarter",
    "This year",
    "Last year",
  ];

  ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme appTheme = AppConstants.AppTheme(context);
    final int selectedTabIndex = watchValue(
      (ValueNotifier<int> m) => m,
      instanceName: "selectedReportsTabIndex",
    );
    final int selectedFilterIndex = watchValue(
      (ValueNotifier<int> m) => m,
      instanceName: "selectedFilterIndex",
    );
    final SimpleDateRange selectedDateRange = watchValue(
      (ValueNotifier<SimpleDateRange> m) => m,
      instanceName: "selectedDateRange",
    );

    final WalletTransactionsModel? transactions = watchValue(
      (ValueNotifier<WalletTransactionsModel?> m) => m,
      instanceName: "walletTransactions",
    );

    final SpendDistributionModel? spendDistributionTransactions = watchValue(
      (ValueNotifier<SpendDistributionModel?> m) => m,
      instanceName: "spendDistributionTransactions",
    );

    // Compute the filtered list reactively from the watched date range so the
    // widget rebuilds whenever the range (or transactions) change.
    // final List<TransactionsModel> filteredTransactions = AppUtils()
    //     .filterTransactions(
    //       transactions?.transactions,
    //       selectedDateRange.fromDate,
    //       selectedDateRange.toDate,
    //     );

    Future<void> handleTimeframeChange({
      int index = 0,
      bool isInitial = false,
    }) async {
      final String selectedFilterText = filters[index];
      // if ((selectedFilterIndex != index) || (isInitial)) {
      //   print("***");
      reportsService.setSelectedFilterIndex(index);

      final userSelectedDateRange = reportsService.setSelectedDateRange(
        selectedFilterText,
      );
      await walletService.fetchSpendDistribution(
        userSelectedDateRange.period,
        userSelectedDateRange.fromDate,
        userSelectedDateRange.toDate,
      );
      //   print("---");
      // }
    }

    void fetchTransactions(BuildContext context) async {
      await walletService.fetchWalletTransactions();
      await handleTimeframeChange(index: selectedFilterIndex, isInitial: true);
    }

    Widget createChild() {
      if (transactions == null && selectedTabIndex == 0) {
        return SimpleAppText("No transactions to display");
      }

      if (selectedTabIndex == 0 && transactions != null) {
        if (transactions.transactions!.isEmpty) {
          fetchTransactions(context);
        }

        return Column(
          children: transactions.transactions!
              .map(
                (transaction) => TransactionTile(
                  transaction: transaction,
                  onClick: () {
                    reportsService.setSelectedTransaction(transaction);
                    context.push(AppRoutes.transaction);
                  },
                ),
              )
              .toList(),
        );
      }

      return Column(
        children: [
          EmptySpace.small(),
          SimpleSectionTitle(
            title: "Spend Distribution",
            isCenterTitle: true,
            color: appTheme.primary,
            fontWeight: FontWeight.w900,
          ),
          EmptySpace.small(),
          SimpleDropDown(
            items: filters,
            labelText: "Date filter",
            initialValue: filters[selectedFilterIndex],
            onIndexChanged: (index) => handleTimeframeChange(index: index),
          ),
          if (spendDistributionTransactions != null)
            ExpenseChart(
              data: spendDistributionTransactions.breakdown!
                  .map(
                    (item) => {
                      AppUtils().valueOrDefault(item.vendor): AppUtils()
                          .valueOrDefault<double>(item.amount),
                    },
                  )
                  .toList(),
            ),

          EmptySpace(),
        ],
      );
    }

    callOnceAfterThisBuild(fetchTransactions);

    return DashboardLayout(
      isNoScroll: true,
      selectedTabBarIndex: 2,

      child: Padding(
        padding: const EdgeInsets.only(
          bottom: AppConstants.STANDARD_PAGE_PADDING,
          left: AppConstants.STANDARD_PAGE_PADDING,
          right: AppConstants.STANDARD_PAGE_PADDING,
          top: 80,
        ),
        child: Column(
          children: [
            ReportsTab(
              selectedTabIndex: selectedTabIndex,
              onTabChange: reportsService.setSelectedTabIndex,
            ),

            EmptySpace.small(),
            Expanded(child: SingleChildScrollView(child: createChild())),
          ],
        ),
      ),
    );
  }
}
