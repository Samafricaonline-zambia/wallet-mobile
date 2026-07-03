import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/layouts/dashboard_layout.dart';
import 'package:sampay_wallet/core/models/chart_data_model.dart';
import 'package:sampay_wallet/core/models/wallet_transactions_model.dart';
import 'package:sampay_wallet/core/routes/app_router.dart';
import 'package:sampay_wallet/core/services/configure_dependencies.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/core/utils/chart_utils.dart';
import 'package:sampay_wallet/core/widgets/empty_space.dart';
import 'package:sampay_wallet/core/widgets/simple_app_text.dart';
import 'package:sampay_wallet/core/widgets/simple_section_title.dart';
import 'package:sampay_wallet/features/reports/services/reports_service.dart';
import 'package:sampay_wallet/features/reports/widgets/credit_vs_debit_chart.dart';
import 'package:sampay_wallet/features/reports/widgets/monthly_expense_table.dart';
import 'package:sampay_wallet/features/reports/widgets/monthly_spending_chart.dart';
import 'package:sampay_wallet/features/reports/widgets/spend_distribution_chart.dart';
import 'package:sampay_wallet/features/reports/widgets/report_tab.dart';
import 'package:sampay_wallet/features/reports/widgets/transaction_tile.dart';
import 'package:sampay_wallet/services/app_state_service.dart';
import 'package:sampay_wallet/services/wallet_service.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:watch_it/watch_it.dart';

class ReportsPage extends StatelessWidget with WatchItMixin {
  final AppStateService appState = getIt<AppStateService>();
  final WalletService walletService = getIt<WalletService>();
  final ReportsService reportsService = getIt<ReportsService>();

  ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme appTheme = AppConstants.AppTheme(context);
    final int selectedTabIndex = watchValue(
      (ValueNotifier<int> m) => m,
      instanceName: "selectedReportsTabIndex",
    );

    final WalletTransactionsModel? transactions = watchValue(
      (ValueNotifier<WalletTransactionsModel?> m) => m,
      instanceName: "walletTransactions",
    );

    void fetchTransactions(BuildContext context) async {
      await walletService.fetchWalletTransactions();
    }

    Widget createChild() {
      if (transactions == null) {
        return SimpleAppText("No transactions to display");
      }

      if (selectedTabIndex == 0) {
        return Column(
          children: transactions!.transactions!
              .map(
                (transaction) => TransactionTile(
                  transaction: transaction,
                  onClick: () {
                    print(transaction.referenceId);
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
          SimpleSectionTitle(
            title: "Spend Distribution",
            isCenterTitle: true,
            color: appTheme.primary,
            fontWeight: FontWeight.w900,
          ),
          if (transactions != null)
            SpendDistributionChart(
              transactions: transactions.transactions ?? [],
            ),

          EmptySpace(),

          SimpleSectionTitle(
            title: "Expenditure VS Income",
            isCenterTitle: true,
            color: appTheme.primary,
            fontWeight: FontWeight.w900,
          ),
          if (transactions != null)
            CreditVsDebitChart(transactions: transactions.transactions ?? []),

          EmptySpace(),

          SimpleSectionTitle(
            title: "Monthly Spending",
            isCenterTitle: true,
            color: appTheme.primary,
            fontWeight: FontWeight.w900,
          ),
          if (transactions != null)
            MonthlySpendingChart(transactions: transactions.transactions ?? []),

          EmptySpace(),

          SimpleSectionTitle(
            title: "Vendor-wise Monthly Spending",
            isCenterTitle: true,
            color: appTheme.primary,
            fontWeight: FontWeight.w900,
          ),
          if (transactions != null)
            MonthlyExpenseTable(transactions: transactions.transactions ?? []),
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
              onTabChange: (tabIndex) =>
                  reportsService.setSelectedTabIndex(tabIndex),
            ),
            EmptySpace.small(),
            Expanded(child: SingleChildScrollView(child: createChild())),
          ],
        ),
      ),
    );
  }
}
