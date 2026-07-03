import 'package:sampay_wallet/core/constants/app_icons.dart';
import 'package:sampay_wallet/core/constants/assets.dart';
import 'package:sampay_wallet/core/models/simple_item_model.dart';

class ElectricityOptionsData {
  static List<SimpleItemModel> items = [
    SimpleItemModel(
      title: "Buy Electricity",
      description: "Purchase electricity tokens for your meter",
      icon: AppIcons.flashLight,
    ),
    SimpleItemModel(
      title: "View Tokens",
      description: "View your recent token purchases",
      icon: AppIcons.electricity,
    ),
  ];
}
