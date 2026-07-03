import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/app_icons.dart';
import 'package:sampay_wallet/core/constants/assets.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/constants/decorations.dart';
import 'package:sampay_wallet/core/constants/transfers/transfer_confirmation_messages.dart';
import 'package:sampay_wallet/core/models/dialog_option_model.dart';
import 'package:sampay_wallet/core/models/kyc_and_charges_model.dart';
import 'package:sampay_wallet/core/models/load_wallet_models/momo.dart';
import 'package:sampay_wallet/core/services/configure_dependencies.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/core/utils/dialog_utils.dart';
import 'package:sampay_wallet/core/validations/validations.dart';
import 'package:sampay_wallet/core/widgets/empty_space.dart';
import 'package:sampay_wallet/core/widgets/simple_app_text.dart';
import 'package:sampay_wallet/core/widgets/simple_drop_down.dart';
import 'package:sampay_wallet/core/widgets/simple_form.dart';
import 'package:sampay_wallet/core/widgets/simple_image_card.dart';
import 'package:sampay_wallet/core/widgets/simple_text_field.dart';
import 'package:sampay_wallet/core/widgets/simple_toast.dart';
import 'package:sampay_wallet/features/transfer_payment/services/wallet_transfer_service.dart';
import 'package:sampay_wallet/services/wallet_service.dart';
import 'package:watch_it/watch_it.dart';

class BankTransferForm extends StatelessWidget with WatchItMixin {
  final WalletService walletService = getIt<WalletService>();
  final WalletTransferService transferService = getIt<WalletTransferService>();

  final DialogOptionModel option;
  final Function(LoadWalletWithMOMO transferRequest)? onSubmit;

  BankTransferForm({super.key, this.onSubmit, required this.option});

  @override
  Widget build(BuildContext context) {
    final LoadWalletWithMOMO transferRequest = watchValue(
      (ValueNotifier<LoadWalletWithMOMO> m) => m,
      instanceName: "transferRequest",
    );

    final bool isAppLoading = watchValue(
      (ValueNotifier<bool> m) => m,
      instanceName: "isAppLoading",
    );

    void handleSubmit() async {
      walletService
          .fetchKYCAndCharges(
            KYCAndChargesModel(
              institutionId: option.badgeText,
              account: AppUtils().formatPhoneNumber(
                AppUtils().valueOrDefault(transferRequest.account),
                prefixWith: "260",
              ),
              amount: AppUtils().valueOrDefault<double>(transferRequest.amount),
            ),
          )
          .then((value) {
            if (value.status) {
              if (context.mounted) {
                DialogUtils()
                    .openConfirmDialog<bool>(
                      context,
                      message:
                          TransferConfirmationMessages.getTransferConfirmationMessage(
                            transferType: TransferType.bank,
                            accountHolderName: AppUtils().valueOrDefault(
                              value.accountName,
                            ),
                            value: AppUtils()
                                .valueOrDefault<double>(value.feePreview)
                                .toStringAsFixed(2),
                          ),
                    )
                    .then((value) {
                      if (context.mounted) {
                        AppUtils().hideKeyboard(context);

                        if (value == true) {
                          onSubmit?.call(
                            transferRequest.copyWith(
                              account: AppUtils().formatPhoneNumber(
                                AppUtils().valueOrDefault(
                                  transferRequest.account,
                                ),
                                prefixWith: "260",
                              ),
                            ),
                          );
                        }
                      }
                    });
              }
            } else {
              if (context.mounted) {
                SimpleToast.showErrorToast(value.message, context);
              }
            }
          });
    }

    IconData buildAccountIcon() {
      switch (transferService.selectedInstitutionType.value) {
        case InstitutionType.bank:
          return AppIcons.merchant;

        default:
          return AppIcons.phone;
      }
    }

    String? buildAccountValidation(String? value) {
      switch (transferService.selectedInstitutionType.value) {
        case InstitutionType.bank:
          return AppValidations.validateZambianBankAccount(
            value,
            bankName: option.title,
          );

        default:
          return AppValidations.validatePhoneNumber(value);
      }
    }

    return Container(
      decoration: AppDecorations.white(),
      padding: EdgeInsets.all(AppConstants.STANDARD_PAGE_PADDING),
      child: SimpleForm(
        actionTitle: "Make Payment",
        isFullWidth: true,
        onSubmit: handleSubmit,
        isLoading: isAppLoading,
        stickyChildren: [
          SimpleImageCard(
            image: AppUtils().defaultIfEmpty(option.image, AppAssets.logo),
          ),
          EmptySpace.small(),
          SimpleAppText.title(option.title, fontWeight: FontWeight.w900),
          EmptySpace.small(),
          SimpleAppText.small(option.description, align: .center),
          EmptySpace(),
        ],
        children: [
          SimpleTextField(
            labelText: "Account number",
            icon: buildAccountIcon(),
            initialValue: transferRequest.account,
            onChanged: (value) => transferService.updateTransferRequest(
              transferRequest.copyWith(account: value),
            ),
            keyboardType: .number,
            validator: (v) => buildAccountValidation(v),
          ),
          EmptySpace.small(),
          SimpleTextField(
            labelText: "Amount",
            icon: AppIcons.dollar,
            prefixText: "ZMW ",
            initialValue: transferRequest.amount!.toStringAsFixed(2),
            onChanged: (value) => transferService.updateTransferRequest(
              transferRequest.copyWith(amount: double.tryParse(value) ?? 1),
            ),
            keyboardType: .numberWithOptions(decimal: true),
            validator: (v) => AppValidations.validateNotNullOrLessThan(
              v,
              message: "Please enter amount greater than 1",
            ),
            onValueChanged: print,
          ),
        ],
      ),
    );
  }
}
