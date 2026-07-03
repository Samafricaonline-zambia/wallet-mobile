import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/app_icons.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/constants/decorations.dart';
import 'package:sampay_wallet/core/models/dialog_option_model.dart';
import 'package:sampay_wallet/core/models/load_wallet_models/momo.dart';
import 'package:sampay_wallet/core/services/configure_dependencies.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/core/utils/dialog_utils.dart';
import 'package:sampay_wallet/core/validations/validations.dart';
import 'package:sampay_wallet/core/widgets/empty_space.dart';
import 'package:sampay_wallet/core/widgets/simple_app_text.dart';
import 'package:sampay_wallet/core/widgets/simple_drop_down.dart';
import 'package:sampay_wallet/core/widgets/simple_form.dart';
import 'package:sampay_wallet/core/widgets/simple_text_field.dart';
import 'package:sampay_wallet/features/transfer_payment/services/wallet_transfer_service.dart';
import 'package:watch_it/watch_it.dart';

class SampayTransferForm extends StatelessWidget with WatchItMixin {
  final WalletTransferService transferService = getIt<WalletTransferService>();

  final DialogOptionModel option;
  final Function(LoadWalletWithMOMO transferRequest)? onSubmit;

  SampayTransferForm({super.key, this.onSubmit, required this.option});

  @override
  Widget build(BuildContext context) {
    final LoadWalletWithMOMO transferRequest = watchValue(
      (ValueNotifier<LoadWalletWithMOMO> m) => m,
      instanceName: "transferRequest",
    );
    final int selectedWalletIndex = watchValue(
      (ValueNotifier<int> m) => m,
      instanceName: "selectedTransferWalletIndex",
    );

    final bool isAppLoading = watchValue(
      (ValueNotifier<bool> m) => m,
      instanceName: "isAppLoading",
    );

    void handleSubmit() {
      DialogUtils().openConfirmDialog<bool>(context).then((value) {
        if (context.mounted) {
          AppUtils().hideKeyboard(context);

          if (value == true) {
            onSubmit?.call(
              transferRequest.copyWith(
                wallet: AppConstants.WALLET_OPTIONS[selectedWalletIndex],
              ),
            );
          }
        }
      });
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
          SimpleAppText.title(option.title, fontWeight: FontWeight.w900),
          EmptySpace.small(),
          SimpleAppText.small(option.description, align: .center),
          EmptySpace(),
        ],
        children: [
          SimpleDropDown(
            items: AppConstants.WALLET_OPTIONS,
            labelText: "Wallet",
            icon: AppIcons.wallet,
            initialValue: AppConstants.WALLET_OPTIONS[selectedWalletIndex],
            onIndexChanged: transferService.updateSelectedWalletIndex,
          ),
          EmptySpace.small(),
          SimpleTextField(
            labelText: "Mobile number",
            icon: AppIcons.phone,
            prefixText: "+260",
            initialValue: transferRequest.account,
            onChanged: (value) => transferService.updateTransferRequest(
              transferRequest.copyWith(account: value),
            ),
            keyboardType: .number,
            validator: (v) => AppValidations.validatePhoneNumber(v),
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
