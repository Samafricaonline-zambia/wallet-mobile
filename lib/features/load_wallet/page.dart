import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sampay_wallet/core/constants/dialog_options.dart';
import 'package:sampay_wallet/core/layouts/options_layout.dart';
import 'package:sampay_wallet/core/models/load_wallet_models/momo.dart';
import 'package:sampay_wallet/core/routes/app_router.dart';
import 'package:sampay_wallet/core/services/configure_dependencies.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/core/utils/bottom_sheet_utils.dart';
import 'package:sampay_wallet/core/widgets/simple_toast.dart';
import 'package:sampay_wallet/features/load_wallet/widgets/card_form.dart';
import 'package:sampay_wallet/features/load_wallet/widgets/load_wallet_options.dart';
import 'package:sampay_wallet/features/load_wallet/widgets/mobile_money_form.dart';
import 'package:sampay_wallet/features/load_wallet/widgets/zamtel_form.dart';
import 'package:sampay_wallet/services/wallet_service.dart';

class LoadWalletPage extends StatelessWidget {
  final WalletService walletService = getIt<WalletService>();
  LoadWalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    final BottomSheetUtils bottoSheet = BottomSheetUtils(context);

    void closeBottomSheet() {
      if (context.mounted && context.canPop()) {
        context.pop();
      }
    }

    void handleMOMOOnSubmit(LoadWalletWithMOMO loadWalletRequestMOMO) {
      if (context.mounted) {
        SimpleToast(
          "Please check your mobile for approving this transaction",
          context,
        );
      }
      walletService
          .fundWalletMOMO(
            loadWalletRequestMOMO.copyWith(
              account: AppUtils().formatPhoneNumber(
                loadWalletRequestMOMO.account ?? "",
                prefixWith: "0",
              ),
              wallet: AppUtils().getWallet(loadWalletRequestMOMO.wallet ?? ""),
            ),
          )
          .then((value) {
            if (!value.isSuccess && context.mounted) {
              SimpleToast.showErrorToast(value.displayMessage, context);
            } else {
              if (context.mounted) {
                SimpleToast.showSuccessToast(
                  "Payment successful",
                  context,
                  onCompleted: closeBottomSheet,
                );
              }
            }
          });
    }

    void handleCardPayment(LoadWalletWithMOMO loadWalletRequestMOMO) async {
      final cardPaymentUrl = await walletService.getCardPaymentUrl(
        AppUtils().valueOrDefault<double>(loadWalletRequestMOMO.amount),
      );

      if (cardPaymentUrl.isNotEmpty && AppUtils().isContextValid(context)) {
        context.pop();
        debugPrint(cardPaymentUrl);
        context.push(
          AppRoutes.cardPaymentView,
          extra: {'url': cardPaymentUrl, 'title': "VISA/MASTER Card Payment"},
        );
      } else {
        if (AppUtils().isContextValid(context)) {
          SimpleToast.showErrorToast(
            "Unable to process card payment at this time. Please try again",
            context,
          );
        }
      }
    }

    void handleOptionClick(int optionIndex) {
      switch (optionIndex) {
        case 0:
          bottoSheet.open(
            LoadMobileMoneyForm(
              onSubmit: handleMOMOOnSubmit,
              option: AppDialogOptions.loadWalletOptions[optionIndex],
            ),
          );
          break;

        case 1:
          bottoSheet.open(
            LoadWalletWithCardForm(
              onSubmit: handleCardPayment,
              option: AppDialogOptions.loadWalletOptions[optionIndex],
            ),
          );
          break;

        case 2:
          bottoSheet.open(
            LoadWalletWithZamtelForm(
              onSubmit: closeBottomSheet,
              option: AppDialogOptions.loadWalletOptions[optionIndex],
            ),
          );
          break;

        case 3:
          context.push(AppRoutes.listBanks);
          break;

        default:
      }
    }

    return OptionsLayout(
      title: "Load Wallet",
      child: LoadWalletOptions(onClick: handleOptionClick),
    );
  }
}
