import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sampay_wallet/core/layouts/options_layout.dart';
import 'package:sampay_wallet/core/models/bank_details_model.dart';
import 'package:sampay_wallet/core/services/configure_dependencies.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/core/utils/bottom_sheet_utils.dart';
import 'package:sampay_wallet/core/widgets/simple_toast.dart';
import 'package:sampay_wallet/features/load_wallet/models/bank_deposit_model.dart';
import 'package:sampay_wallet/features/load_wallet/services/load_wallet_service.dart';
import 'package:sampay_wallet/features/load_wallet/widgets/bank_pop.dart';
import 'package:sampay_wallet/features/load_wallet/widgets/upload_pop.dart';
import 'package:sampay_wallet/services/app_state_service.dart';
import 'package:sampay_wallet/services/wallet_service.dart';
import 'package:watch_it/watch_it.dart';

class BankDetailsAndPopPage extends StatelessWidget with WatchItMixin {
  final LoadWalletService loadWalletService = getIt<LoadWalletService>();
  final WalletService walletService = getIt<WalletService>();
  final AppStateService appState = getIt<AppStateService>();
  BankDetailsAndPopPage({super.key});

  @override
  Widget build(BuildContext context) {
    BankDetailsModel bank = loadWalletService.selectedBank.value;

    void handleUploadFormSubmit(BankDepositModel value) async {
      if (AppUtils().isContextValid(context)) {
        if (value.depositfile!.path.isEmpty) {
          SimpleToast.showErrorToast(
            "No image selected. Please select an image to upload",
            context,
          );
        } else {
          walletService.uploadBankDepositProof(value).then((value) {
            if (AppUtils().isContextValid(context)) {
              if (value.isNotEmpty) {
                SimpleToast.showErrorToast(value, context);
              } else {
                SimpleToast.showSuccessToast(
                  "Request submitted successfully",
                  context,
                  onCompleted: () {
                    context.pop();
                  },
                );
              }
            }
          });
        }
      }
    }

    void handleUploadPopClick(BankDetailsModel bank) {
      loadWalletService.updateLoadWalletWithBankDeposit(
        BankDepositModel.empty().copyWith(
          bankref: appState.phoneNumber,
          depositamount: 1.0,
          depositbank: bank.name.split(" ")[0],
          depositdate: AppUtils().formatDate(DateTime.now().toIso8601String()),
        ),
      );
      BottomSheetUtils(
        context,
      ).open(UploadPopForm(onSubmit: handleUploadFormSubmit));
    }

    return OptionsLayout(
      title: bank.name,
      pageTitle: "Bank Deposit",
      pageDescription:
          "Please note that when you use this option, it may take up to 24 Hours for funds to reflect on your wallet.",
      child: BankPop(bank: bank, onSubmit: handleUploadPopClick),
    );
  }
}
