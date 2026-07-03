import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/layouts/options_layout.dart';
import 'package:sampay_wallet/core/models/bill_merchant_model.dart';
import 'package:sampay_wallet/core/services/configure_dependencies.dart';
import 'package:sampay_wallet/core/themes/color_constants.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/core/widgets/empty_space.dart';
import 'package:sampay_wallet/core/widgets/simple_app_text.dart';
import 'package:sampay_wallet/core/widgets/simple_image_card.dart';
import 'package:sampay_wallet/core/widgets/simple_toast.dart';
import 'package:sampay_wallet/features/bills/models/bill_item_model.dart';
import 'package:sampay_wallet/features/bills/services/bills_service.dart';
import 'package:sampay_wallet/features/bills/widgets/pay_with_phone_form.dart';
import 'package:sampay_wallet/features/bills/widgets/pay_with_account_form.dart';
import 'package:sampay_wallet/services/wallet_service.dart';
import 'package:watch_it/watch_it.dart';

class BillPaymentPage extends StatelessWidget with WatchItMixin {
  final BillsService billsService = getIt<BillsService>();
  final WalletService walletService = getIt<WalletService>();
  BillPaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = AppUtils().getScreenWidth(context);
    final BillMerchantModel? merchant = watchValue(
      (ValueNotifier<BillMerchantModel?> m) => m,
      instanceName: "selectedBillMerchant",
    );

    String getTitle() {
      switch (merchant?.merchantType) {
        case .electricity:
          return "Buy ${merchant?.name} tokens";

        case .data:
          return "Buy ${merchant?.name} data";

        case .airtime:
          return "Buy ${merchant?.name} airtime";

        default:
          return "Buy ${merchant?.name}";
      }
    }

    void goToBillsDashboard() async {
      if (context.mounted) {
        context.pop();
      }
    }

    void showPaymentStatus(
      bool isSuccess, {
      String errorMessage = "Error processing payment",
    }) {
      billsService.updateCurrentBillingItem(BillItemModel());
      AppUtils().hideKeyboard(context);
      if (isSuccess) {
        SimpleToast.showSuccessToast(
          "Payment successful",
          context,
          onCompleted: goToBillsDashboard,
        );
      } else {
        SimpleToast.showErrorToast(errorMessage, context);
      }
    }

    void handleCableTvBillPayment(BillItemModel item) async {
      walletService
          .makeVasPayment(
            service: AppUtils().valueOrDefault(merchant?.service),
            account: AppUtils().valueOrDefault(item.accountNumber),
            amount: AppUtils().valueOrDefault<double>(item.value),
            transactionType: AppUtils().valueOrDefault(
              merchant?.transactionType,
            ),
            serviceType: 'Purchase',
          )
          .then((response) {
            showPaymentStatus(
              response.isSuccess,
              errorMessage: response.displayMessage,
            );
          });
    }

    void handleAirtimeBillPayment(BillItemModel item) async {
      walletService
          .makeVasPayment(
            service: AppUtils().valueOrDefault(merchant?.service),
            account: AppUtils().formatPhoneNumber(
              AppUtils().valueOrDefault(item.accountNumber),
              prefixWith: "260",
            ),
            amount: AppUtils().valueOrDefault<double>(item.value),
            transactionType: AppUtils().valueOrDefault(
              merchant?.transactionType,
            ),
            serviceType: 'Purchase',
          )
          .then((response) {
            showPaymentStatus(
              response.isSuccess,
              errorMessage: response.displayMessage,
            );
          });
    }

    void handleElectricityBillPayment(BillItemModel item) async {
      walletService
          .makeVasPayment(
            service: AppUtils().valueOrDefault(merchant?.service),
            account: AppUtils().valueOrDefault(item.accountNumber),
            amount: AppUtils().valueOrDefault<double>(item.value),
            transactionType: AppUtils().valueOrDefault(
              merchant?.transactionType,
            ),
            serviceType: 'Purchase',
          )
          .then((response) {
            showPaymentStatus(
              response.isSuccess,
              errorMessage: response.displayMessage,
            );
          });
    }

    Widget buildChild() {
      switch (merchant?.merchantType) {
        case BillMerchantType.electricity:
          return PayWithAccountForm(
            //merchantName: merchant.name,
            merchantType: merchant!.merchantType,
            actionLabel: "Buy ${merchant.name} Tokens",
            onSubmit: (item) => handleElectricityBillPayment(
              item.copyWith(category: merchant.label),
            ),
          );

        case BillMerchantType.cableTv:
          return PayWithPhoneForm(
            merchant: merchant!,
            actionLabel: "Pay for ${merchant.name}",
            onSubmit: (item) => handleCableTvBillPayment(
              item.copyWith(category: merchant.label),
            ),
          );

        case BillMerchantType.data:
          return PayWithPhoneForm(
            merchant: merchant!,
            actionLabel: "Buy ${merchant.name} bundle",
            onSubmit: (item) {
              SimpleToast("API's does not exists", context);
            },
          );

        default:
          return PayWithPhoneForm(
            merchant: merchant!,
            actionLabel: "Buy ${merchant.name} Airtime",
            onSubmit: (item) => handleAirtimeBillPayment(
              item.copyWith(category: merchant.label),
            ),
          );
      }
    }

    return OptionsLayout(
      title: getTitle(),
      child: SizedBox(
        width: screenWidth,
        child: Column(
          crossAxisAlignment: .center,
          children: [
            SimpleImageCard(image: merchant?.icon, height: 100, width: 100),
            EmptySpace.large(),
            SimpleAppText.title(getTitle()),
            EmptySpace(),
            buildChild(),
          ],
        ),
      ),
    );
  }
}
