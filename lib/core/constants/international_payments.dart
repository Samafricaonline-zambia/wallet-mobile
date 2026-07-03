import 'package:sampay_wallet/core/constants/assets.dart';
import 'package:sampay_wallet/core/models/dialog_option_model.dart';

class InternationalPaymentsConstants {
  static String southAfrica = "ZA";
  static String zimbabwe = "ZW";
  static List<DialogOptionModel> countries = [
    DialogOptionModel(
      id: "212006",
      image: AppAssets.southAfrica,
      title: "South Africa",
      subTitle: "ZA",
      description:
          "Send money to South Africa via mobile money or bank transfer",
      badgeText: "Mobile Wallet",
    ),
    DialogOptionModel(
      id: "290001",
      image: AppAssets.zimbabwe,
      title: "Zimbabwe",
      subTitle: "ZW",
      description: "Send money to Zimbabwe via mobile money or bank transfer",
      badgeText: "Bank Account",
    ),
  ];
}
