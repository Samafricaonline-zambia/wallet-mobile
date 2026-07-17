import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/constants/transfers/transfer_confirmation_messages.dart';
import 'package:sampay_wallet/core/layouts/options_layout.dart';
import 'package:sampay_wallet/core/services/configure_dependencies.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/core/utils/dialog_utils.dart';
import 'package:sampay_wallet/core/widgets/simple_toast.dart';
import 'package:sampay_wallet/features/international_payments/models/payment_request_model.dart';
import 'package:sampay_wallet/features/international_payments/services/international_payments_service.dart';
import 'package:sampay_wallet/features/international_payments/widgets/mobile_wallet_form.dart';
import 'package:watch_it/watch_it.dart';

class InternationalMobileWalletPaymentsPage extends StatelessWidget
    with WatchItMixin {
  final InternationalPaymentsService paymentsService =
      getIt<InternationalPaymentsService>();
  InternationalMobileWalletPaymentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final InternationalPaymentsRequestModel currentRequest = watchValue(
      (ValueNotifier<InternationalPaymentsRequestModel> m) => m,
      instanceName: "currentInternaltionalPaymentRequest",
    );

    void handleOnSubmit(bool isSuccess) async {
      if (isSuccess) {
        final isConfirmed = await DialogUtils().openConfirmDialog(
          context,
          message: TransferConfirmationMessages.getTransferConfirmationMessage(
            transferType: TransferType.internationalBank,
            accountHolderName: currentRequest.receiverfullname,
            value: currentRequest.amount.toStringAsFixed(2),
          ),
        );

        if (isConfirmed) {
          final String isPaymentSuccessful = await paymentsService.sendPayment(
            currentRequest,
          );

          if (AppUtils().isContextValid(context)) {
            if (isPaymentSuccessful.isEmpty) {
              SimpleToast.showSuccessToast(
                "Payment request submitted",
                context,
                onCompleted: () {
                  context.pop();
                },
              );
            } else {
              SimpleToast.showSuccessToast(isPaymentSuccessful, context);
            }
          }
        }
      } else {
        SimpleToast.showErrorToast("Receiver cannot be verified", context);
      }
    }

    return OptionsLayout(
      title: "Mobile Wallet Payment",
      child: MobileWalletForm(onSubmit: handleOnSubmit),
    );
  }
}
