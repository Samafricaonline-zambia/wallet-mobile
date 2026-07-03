import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/app_icons.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/constants/decorations.dart';
import 'package:sampay_wallet/core/models/simple_item_model.dart';
import 'package:sampay_wallet/core/themes/color_constants.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/core/widgets/empty_space.dart';
import 'package:sampay_wallet/core/widgets/simple_app_text.dart';
import 'package:sampay_wallet/core/widgets/simple_divider.dart';
import 'package:sampay_wallet/core/widgets/simple_flex.dart';
import 'package:sampay_wallet/core/widgets/simple_form.dart';
import 'package:sampay_wallet/core/widgets/simple_image_card.dart';
import 'package:sampay_wallet/features/scan-qr/models/qr_model.dart';
import 'package:watch_it/watch_it.dart';

class QRPaymentForm extends StatelessWidget with WatchItMixin {
  final VoidCallback? onSubmit;
  const QRPaymentForm({super.key, this.onSubmit});

  @override
  Widget build(BuildContext context) {
    final ColorScheme appTheme = AppConstants.AppTheme(context);
    final QRModel qrCode = watchValue(
      (ValueNotifier<QRModel> m) => m,
      instanceName: "qrCode",
    );

    return Container(
      padding: EdgeInsets.all(AppConstants.STANDARD_PAGE_PADDING),
      decoration: AppDecorations.white(),
      child: SimpleForm(
        actionTitle: "Make Payment",
        isFullWidth: true,
        onSubmit: onSubmit,
        children: [
          SimpleImageCard(icon: AppIcons.wallet, color: appTheme.primary),
          EmptySpace(),
          SimpleAppText.title("Make Payment", fontWeight: FontWeight.w900),
          EmptySpace(),
          SimpleAppText("You are about to send"),
          EmptySpace.small(),
          SimpleAppText(
            "ZMW ${AppUtils().valueOrDefault<double>(qrCode.amount).toStringAsFixed(2)}",
            fontWeight: FontWeight.w900,
            fontSize: 24,
            color: appTheme.primary,
          ),
          SimpleDivider(),
          SimpleFlex(
            children: [
              SimpleAppText("Name"),
              SimpleAppText(AppUtils().valueOrDefault(qrCode.name)),
            ],
          ),
          EmptySpace.small(),
          SimpleFlex(
            children: [
              SimpleAppText("Username"),
              SimpleAppText(
                AppUtils().formatPhoneNumber(
                  AppUtils().valueOrDefault(qrCode.phone),
                  prefixWith: "@260",
                ),
              ),
            ],
          ),
          EmptySpace.small(),
          SimpleFlex(
            children: [
              SimpleAppText("Wallet"),
              SimpleAppText(AppUtils().valueOrDefault(qrCode.wallet)),
            ],
          ),
        ],
      ),
    );
  }
}
