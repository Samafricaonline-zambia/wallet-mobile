import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sampay_wallet/core/constants/dialog_options.dart';
import 'package:sampay_wallet/core/layouts/options_layout.dart';
import 'package:sampay_wallet/core/models/load_wallet_models/momo.dart';
import 'package:sampay_wallet/core/services/configure_dependencies.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/core/widgets/simple_toast.dart';
import 'package:sampay_wallet/features/load_wallet/widgets/mobile_money_form.dart';
import 'package:sampay_wallet/services/app_state_service.dart';
import 'package:sampay_wallet/services/wallet_service.dart';
import 'package:watch_it/watch_it.dart';

class MobileMoneyPaymentPage extends StatelessWidget with WatchItMixin {
  final WalletService walletService = getIt<WalletService>();
  final AppStateService appState = getIt<AppStateService>();

  MobileMoneyPaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isLoading = watchValue(
      (ValueNotifier<bool> m) => m,
      instanceName: "isAppLoading",
    );

    void handleOnSubmit(LoadWalletWithMOMO loadWalletRequestMOMO) {
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
                loadWalletRequestMOMO.account ?? appState.phoneNumber,
                prefixWith: "0",
              ),
              wallet: AppUtils().getWallet(loadWalletRequestMOMO.wallet ?? ""),
            ),
          )
          .then((value) {
            if (!value.isSuccess && context.mounted) {
              SimpleToast.showErrorToast(value.displayMessage, context);
            } else {
              if (context.mounted && context.canPop()) {
                context.pop();
              }
            }
          });
    }

    return OptionsLayout(
      title: "Mobile Money",
      isLoading: isLoading,
      child: LoadMobileMoneyForm(
        onSubmit: handleOnSubmit,
        option: AppDialogOptions.loadMobileMoney,
      ),
    );
  }
}
