import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/models/chart_data_model.dart';
import 'package:sampay_wallet/core/models/wallet_transactions_model.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/core/utils/chart_utils.dart';
import 'package:sampay_wallet/core/widgets/simple_app_text.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CreditVsDebitChart extends StatefulWidget {
  final List<TransactionsModel> transactions;
  const CreditVsDebitChart({super.key, required this.transactions});

  @override
  State<CreditVsDebitChart> createState() => _CreditVsDebitChartState();
}

class _CreditVsDebitChartState extends State<CreditVsDebitChart> {
  List<ChartDataModel> data = [];
  double totalExpenditure = 0;

  @override
  void initState() {
    data = ChartUtils().getCreditVsDebit(widget.transactions);
    totalExpenditure = ChartUtils().getTotalExpenditure(widget.transactions);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          dataSource: data,
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
