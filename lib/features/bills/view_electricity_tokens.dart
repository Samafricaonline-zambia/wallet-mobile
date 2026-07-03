import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/layouts/options_layout.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/core/widgets/simple_list.dart';
import 'package:sampay_wallet/core/widgets/simple_list_tile.dart';
import 'package:sampay_wallet/features/bills/models/electricity_token_model.dart';
import 'package:watch_it/watch_it.dart';

class ViewElectricityTokensPage extends StatelessWidget with WatchItMixin {
  const ViewElectricityTokensPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ElectricityTokensModel electricityTokens = watchValue(
      (ValueNotifier<ElectricityTokensModel> m) => m,
      instanceName: "electricityTokens",
    );

    return OptionsLayout(
      title: "Zesco",
      pageTitle: "Zesco Tokens",
      pageDescription: "View past Zesco Tokens Purchases",
      isPadding: false,
      child: SimpleList(
        itemCount: electricityTokens.tokens.length,
        itemBuilder: (context, index) {
          return SimpleListTile(
            title: electricityTokens.tokens[index].token,
            description: AppUtils().formatTimestamp(
              electricityTokens.tokens[index].time,
            ),
            isShowTrailingIcon: false,
          );
        },
      ),
    );
  }
}
