import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/assets.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/extensions/widget_extensions.dart';
import 'package:sampay_wallet/core/models/wallet_transactions_model.dart';
import 'package:sampay_wallet/core/themes/color_constants.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/core/widgets/empty_space.dart';
import 'package:sampay_wallet/core/widgets/simple_app_text.dart';
import 'package:sampay_wallet/core/widgets/simple_divider.dart';
import 'package:sampay_wallet/core/widgets/simple_flex.dart';
import 'package:sampay_wallet/core/widgets/simple_image_card.dart';
import 'package:sampay_wallet/core/widgets/simple_pill.dart';
import 'package:sampay_wallet/core/widgets/simple_ripple_wrapper.dart';

class TransactionTile extends StatelessWidget {
  final TransactionsModel transaction;
  final VoidCallback? onClick;
  const TransactionTile({super.key, required this.transaction, this.onClick});

  Widget getLeadingImage(Color bgColor) {
    // if (transaction.vendor != null) {
    //   List<String> vendorSegments = (transaction.vendor ?? "").split(" ");
    //   BillMerchants merchant = AppUtils().getMerchant(vendorSegments[0]);

    //   String assetPath = AppAssets.logo;

    //   switch (merchant) {
    //     case BillMerchants.airtel:
    //       assetPath = AppAssets.airtel;
    //       break;

    //     case BillMerchants.boxOffice:
    //       assetPath = AppAssets.boxOffice;
    //       break;

    //     case BillMerchants.dstv:
    //       assetPath = AppAssets.dstv;
    //       break;

    //     case BillMerchants.gotv:
    //       assetPath = AppAssets.gotv;
    //       break;

    //     case BillMerchants.liquid:
    //       assetPath = AppAssets.liquid;
    //       break;

    //     case BillMerchants.mtn:
    //       assetPath = AppAssets.mtn;
    //       break;

    //     case BillMerchants.topStar:
    //       assetPath = AppAssets.topStar;
    //       break;

    //     case BillMerchants.zamtel:
    //       assetPath = AppAssets.zamtel;
    //       break;

    //     case BillMerchants.zesco:
    //       assetPath = AppAssets.zesco;
    //       break;

    //     default:
    //       assetPath = AppAssets.logo;
    //       break;
    //   }

    //   if (assetPath.isNotEmpty) {
    //     // return Container(
    //     //   height: 50,
    //     //   width: 50,
    //     //   padding: EdgeInsets.all(5),
    //     //   decoration: BoxDecoration(
    //     //     color: bgColor,
    //     //     borderRadius: BorderRadius.circular(15),
    //     //   ),
    //     //   child: Image(image: AssetImage(assetPath)),
    //     // );
    //     SimpleImageCard(image: assetPath);
    //   }
    // }

    return SimpleImageCard(
      image: AppUtils().getMerchantAssetImage(transaction.vendor ?? ""),
    );
  }

  Color getPillBGColor(String transactionType, ColorScheme appTheme) {
    if (transactionType.toLowerCase().startsWith("debit")) {
      return appTheme.error.withAlpha(30);
    }

    return appTheme.success.withAlpha(30);
  }

  Color getPillTextColor(String transactionType, ColorScheme appTheme) {
    if (transactionType.toLowerCase().startsWith("debit")) {
      return appTheme.error;
    }

    return appTheme.success;
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme appTheme = AppConstants.AppTheme(context);
    return Wrap(
      children: [
        SimpleRippleWrapper(
          onTap: onClick,
          padding: EdgeInsets.zero,
          child: SimpleFlex(
            leftChild: Row(
              children: [
                getLeadingImage(appTheme.light),
                EmptySpace(width: 5),
                Column(
                  mainAxisAlignment: .center,
                  crossAxisAlignment: .start,
                  children: [
                    SizedBox(
                      width: 200,
                      child: SimpleAppText.small(
                        shouldWrap: false,
                        transaction.description ?? "",
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    EmptySpace(height: 5),
                    SimpleAppText.small(
                      AppUtils().formatTimestamp(transaction.timestamp ?? ""),
                      color: appTheme.black,
                    ),
                  ],
                ),
              ],
            ),
            rightChild: Column(
              mainAxisAlignment: .center,
              crossAxisAlignment: .end,
              children: [
                SimpleAppText.small(
                  "${transaction.amount ?? ""} ${transaction.currency == 'ZMW' ? '' : transaction.currency}",
                  fontWeight: FontWeight.w900,
                  color: getPillTextColor(
                    transaction.transactionType ?? "",
                    appTheme,
                  ),
                ),
                SimplePill(
                  transaction.transactionType ?? "",
                  bgColor: getPillBGColor(
                    transaction.transactionType ?? "",
                    appTheme,
                  ),
                  color: getPillTextColor(
                    transaction.transactionType ?? "",
                    appTheme,
                  ),
                ),
              ],
            ),
          ),
        ),
        SimpleDivider(padding: EdgeInsets.only(top: 2, bottom: 2)),
      ],
    );
  }
}
