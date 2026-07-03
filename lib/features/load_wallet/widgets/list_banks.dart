import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/assets.dart';
import 'package:sampay_wallet/core/constants/banks.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/layouts/options_layout.dart';
import 'package:sampay_wallet/core/models/bank_details_model.dart';
import 'package:sampay_wallet/core/models/institutions.dart';
import 'package:sampay_wallet/core/models/simple_item_model.dart';
import 'package:sampay_wallet/core/services/configure_dependencies.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/core/widgets/empty_space.dart';
import 'package:sampay_wallet/core/widgets/simple_tile.dart';
import 'package:sampay_wallet/services/app_state_service.dart';
import 'package:watch_it/watch_it.dart';

class ListBanks extends StatelessWidget with WatchItMixin {
  final AppStateService appState = getIt<AppStateService>();
  final Function(BankDetailsModel value)? onClick;
  ListBanks({super.key, this.onClick});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        ...List.generate(Banks.DATA.length, (index) {
          return Column(
            children: [
              SimpleTile(
                item: SimpleItemModel(
                  title: Banks.DATA[index].name,
                  description: Banks.DATA[index].description,
                  image: AppUtils().defaultIfEmpty(
                    Banks.DATA[index].logo,
                    AppAssets.logo,
                  ),
                ),
                onClick: () {
                  onClick?.call(Banks.DATA[index]);
                },
              ),
            ],
          );
        }),
      ],
    );
  }
}
