import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/models/chart_data_model.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/core/widgets/simple_app_text.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ExpenseChart extends StatelessWidget {
  /// List of single-entry maps: `{'label': value}` where the key is the
  /// segment label and the value is the amount.
  final List<Map<String, double>> data;

  const ExpenseChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final List<ChartDataModel> chartData = data.map((item) {
      final entry = item.entries.first;
      return ChartDataModel(label: entry.key, value: entry.value);
    }).toList();

    final double totalExpenditure = chartData.fold(
      0.0,
      (sum, item) => sum + item.value,
    );

    return SfCircularChart(
      annotations: <CircularChartAnnotation>[
        CircularChartAnnotation(
          widget: SizedBox(
            width: 150,
            child: Column(
              mainAxisAlignment: .center,
              crossAxisAlignment: .center,
              children: [
                SimpleAppText.small(
                  "Total spent",
                  shouldWrap: true,
                  align: .center,
                ),
                SimpleAppText(
                  AppUtils().formatCurrency(
                    totalExpenditure.toStringAsFixed(2),
                  ),
                  fontWeight: FontWeight.w900,
                ),
              ],
            ),
          ),
        ),
      ],
      legend: Legend(isVisible: true, position: LegendPosition.bottom),
      series: <CircularSeries>[
        // Render pie chart
        DoughnutSeries<ChartDataModel, String>(
          dataSource: chartData,
          xValueMapper: (ChartDataModel data, _) => data.label,
          yValueMapper: (ChartDataModel data, _) => data.value,
          dataLabelMapper: (data, index) => data.label,
          innerRadius: "80%",
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            labelPosition: ChartDataLabelPosition.outside,
          ),
        ),
      ],
    );
  }
}
