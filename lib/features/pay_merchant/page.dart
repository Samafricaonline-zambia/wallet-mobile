import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sampay_wallet/core/layouts/options_layout.dart';
import 'package:sampay_wallet/core/services/configure_dependencies.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/core/widgets/simple_toast.dart';
import 'package:sampay_wallet/features/bills/models/bill_item_model.dart';
import 'package:sampay_wallet/features/pay_merchant/services/pay_merchant_service.dart';
import 'package:sampay_wallet/features/pay_merchant/widgets/pay_merchant_form.dart';
import 'package:sampay_wallet/services/wallet_service.dart';

class PayMerchantPage extends StatelessWidget {
  final WalletService walletService = getIt<WalletService>();
  final PayMerchantService payMerchantService = getIt<PayMerchantService>();
  PayMerchantPage({super.key});

  @override
  Widget build(BuildContext context) {
    void goToBillsDashboard() async {
      if (context.mounted) {
        context.pop();
      }
    }

    void showPaymentStatus(
      bool isSuccess, {
      String errorMessage = "Error processing payment",
    }) {
      payMerchantService.setPayMerchantRequest(BillItemModel());
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

    void handleMerchantPayment(BillItemModel request) {
      walletService.makeMerchantPayment(request).then((value) {
        showPaymentStatus(value.isSuccess, errorMessage: value.displayMessage);
      });
    }

    return OptionsLayout(
      title: "Pay Merchant",
      pageTitle: "Pay Merchant",
      pageDescription:
          "You can pay to any merchant from here. Input the merchant code that is provided to you and make the desired payment.",
      child: PayMerchantForm(onSubmit: handleMerchantPayment),
    );
  }
}
