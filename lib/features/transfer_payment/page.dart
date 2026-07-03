import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sampay_wallet/core/constants/dialog_options.dart';
import 'package:sampay_wallet/core/layouts/options_layout.dart';
import 'package:sampay_wallet/core/models/dialog_option_model.dart';
import 'package:sampay_wallet/core/models/institutions.dart';
import 'package:sampay_wallet/core/models/load_wallet_models/momo.dart';
import 'package:sampay_wallet/core/routes/app_router.dart';
import 'package:sampay_wallet/core/services/configure_dependencies.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/core/utils/bottom_sheet_utils.dart';
import 'package:sampay_wallet/core/widgets/simple_toast.dart';
import 'package:sampay_wallet/features/load_wallet/widgets/zamtel_form.dart';
import 'package:sampay_wallet/features/transfer_payment/services/wallet_transfer_service.dart';
import 'package:sampay_wallet/features/transfer_payment/widgets/coming_soon_form.dart';
import 'package:sampay_wallet/features/transfer_payment/widgets/mobile_transfer_form.dart';
import 'package:sampay_wallet/features/transfer_payment/widgets/sampay_transfer_form.dart';
import 'package:sampay_wallet/features/transfer_payment/widgets/wallet_transfer_options.dart';
import 'package:sampay_wallet/services/wallet_service.dart';
import 'package:watch_it/watch_it.dart';

class TransferPaymentPage extends StatelessWidget with WatchItMixin {
  final WalletService walletService = getIt<WalletService>();
  final WalletTransferService transferService = getIt<WalletTransferService>();
  TransferPaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final BottomSheetUtils bottoSheet = BottomSheetUtils(context);

    final List<InstitutionModel> allInstitutions = watchValue(
      (ValueNotifier<List<InstitutionModel>> m) => m,
      instanceName: "allInstitutions",
    );

    void closeBottomSheet() {
      if (context.mounted && context.canPop()) {
        context.pop();
      }
    }

    void handleTransferMOMO(LoadWalletWithMOMO transferRequest) {
      if (context.mounted) {
        SimpleToast(
          "Please check your mobile for approving this transaction",
          context,
        );
      }
      walletService
          .transferMOMO(
            transferRequest.copyWith(
              account: AppUtils().formatPhoneNumber(
                transferRequest.account ?? "",
                prefixWith: "0",
              ),
            ),
          )
          .then((value) {
            if (!value.isSuccess && context.mounted) {
              SimpleToast.showErrorToast(value.displayMessage, context);
            } else {
              if (context.mounted) {
                SimpleToast.showSuccessToast(
                  "Transfer successful",
                  context,
                  onCompleted: closeBottomSheet,
                );
              }
            }
          });
    }

    void handleTransferSampay(LoadWalletWithMOMO transferRequest) {
      if (context.mounted) {
        SimpleToast(
          "Please check your mobile for approving this transaction",
          context,
        );
      }
      walletService
          .transferSampay(
            transferRequest.copyWith(
              account: AppUtils().formatPhoneNumber(
                transferRequest.account ?? "",
                prefixWith: "0",
              ),
            ),
          )
          .then((value) {
            if (!value.isSuccess && context.mounted) {
              SimpleToast.showErrorToast(value.displayMessage, context);
            } else {
              if (context.mounted) {
                SimpleToast.showSuccessToast(
                  "Transfer successful",
                  context,
                  onCompleted: closeBottomSheet,
                );
              }
            }
          });
    }

    void handleOptionClick(int optionIndex) {
      switch (optionIndex) {
        case 0:
          // final DialogOptionModel mobileOption = AppDialogOptions
          //     .walletTransferOptions[optionIndex]
          //     .copyWith(badgeText: foundInstitution.nfsId);
          // bottoSheet.open(
          //   MobileTransferForm(
          //     option: AppDialogOptions.walletTransferOptions[optionIndex],
          //     onSubmit: handleTransferMOMO,
          //   ),
          // );
          transferService.updateSelectedInstitutionType(.mno);
          context.push(AppRoutes.listInstitutions);
          break;

        case 1:
          bottoSheet.open(
            SampayTransferForm(
              onSubmit: handleTransferSampay,
              option: AppDialogOptions.walletTransferOptions[optionIndex],
            ),
          );
          break;

        case 2:
        case 4:
          bottoSheet.open(
            TransferComingSoonForm(
              onSubmit: closeBottomSheet,
              option: AppDialogOptions.walletTransferOptions[optionIndex],
            ),
          );
          break;

        case 3:
          transferService.updateSelectedInstitutionType(.bank);
          context.push(AppRoutes.listInstitutions);
          break;

        default:
      }
    }

    return OptionsLayout(
      title: "Local Transfers",
      child: WalletTransferOptions(onClick: handleOptionClick),
    );
  }
}
