import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/models/chart_data_model.dart';
import 'package:sampay_wallet/core/models/wallet_transactions_model.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/core/utils/chart_utils.dart';
import 'package:sampay_wallet/core/widgets/simple_app_text.dart';
import 'package:sampay_wallet/core/widgets/simple_drop_down.dart';
import 'package:sampay_wallet/core/widgets/simple_flex.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class MonthlySpendingChart extends StatefulWidget {
  final List<TransactionsModel> transactions;
  const MonthlySpendingChart({super.key, required this.transactions});

  @override
  State<MonthlySpendingChart> createState() => _MonthlySpendingChartState();
}

class _MonthlySpendingChartState extends State<MonthlySpendingChart> {
  List<ChartDataModel> data = [];
  double totalExpenditure = 0;
  int selectedMonth = 1;

  void calculateChart() {
    setState(() {
      data = ChartUtils().getDateWiseMonthlySpending(
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
    final double totalDaysInMonth = AppUtils().getTotalDaysInMonth().toDouble();
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
          SfCartesianChart(
            legend: Legend(isVisible: false, position: LegendPosition.bottom),
            primaryXAxis: NumericAxis(
              minimum: 1,
              maximum: totalDaysInMonth,
              decimalPlaces: 0,
              desiredIntervals: data.length < 10 ? 10 : data.length + 1,
            ),
            series: <CartesianSeries>[
              // Render pie chart
              ColumnSeries<ChartDataModel, int>(
                dataSource: data,
                xValueMapper: (ChartDataModel data, _) =>
                    int.tryParse(data.label),
                yValueMapper: (ChartDataModel data, _) => data.value,
                dataLabelMapper: (data, index) => data.value.toStringAsFixed(2),
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  labelPosition: ChartDataLabelPosition.outside,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
