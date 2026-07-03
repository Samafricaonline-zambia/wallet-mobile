import 'package:flutter/widgets.dart';
import 'package:sampay_wallet/core/models/chart_data_model.dart';
import 'package:sampay_wallet/core/models/wallet_transactions_model.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/core/utils/chart_utils.dart';
import 'package:sampay_wallet/core/widgets/empty_space.dart';
import 'package:sampay_wallet/core/widgets/simple_app_text.dart';
import 'package:sampay_wallet/core/widgets/simple_divider.dart';
import 'package:sampay_wallet/core/widgets/simple_drop_down.dart';
import 'package:sampay_wallet/core/widgets/simple_flex.dart';

class MonthlyExpenseTable extends StatefulWidget {
  final List<TransactionsModel> transactions;
  const MonthlyExpenseTable({super.key, required this.transactions});

  @override
  State<MonthlyExpenseTable> createState() => _MonthlyExpenseTableState();
}

class _MonthlyExpenseTableState extends State<MonthlyExpenseTable> {
  List<ChartDataModel> data = [];
  double totalExpenditure = 0;
  int selectedMonth = 1;

  void calculateChart() {
    setState(() {
      data = ChartUtils().getVendorWiseMonthlySpending(
        widget.transactions,
        month: AppUtils().getMonthStartDate(month: selectedMonth),
      );
    });
  }

  @override
  void initState() {
    selectedMonth = AppUtils().getCurrentMonth();
    calculateChart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final int currentMonth = AppUtils().getCurrentMonth();
    final double screenWidth = AppUtils().getScreenWidth(context);

    return SizedBox(
      width: screenWidth,
      child: Column(
        children: [
          SimpleFlex(
            leftChild: SimpleAppText("Selected month"),
            rightChild: SizedBox(
              width: 120,
              child: SimpleDropDown(
                items: List.generate(currentMonth, (index) => "${index + 1}"),
                initialValue: selectedMonth.toString(),
                onChanged: (selectedItem) {
                  setState(() {
                    selectedMonth =
                        int.tryParse(selectedItem ?? "") ?? currentMonth;
                    calculateChart();
                  });
                },
              ),
            ),
          ),
          EmptySpace(),
          SimpleDivider(),
          if (data.isNotEmpty)
            ...List.generate(data.length, (index) {
              return SimpleFlex(
                leftChild: SimpleAppText(data[index].label),
                rightChild: SimpleAppText(data[index].value.toStringAsFixed(2)),
                isWithDivider: true,
              );
            }),

          if (data.isEmpty) SimpleAppText("No records to display"),
        ],
      ),
    );
  }
}
