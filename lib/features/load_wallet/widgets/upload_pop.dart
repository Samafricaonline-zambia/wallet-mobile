import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/app_icons.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/constants/decorations.dart';
import 'package:sampay_wallet/core/services/configure_dependencies.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/core/validations/validations.dart';
import 'package:sampay_wallet/core/widgets/empty_space.dart';
import 'package:sampay_wallet/core/widgets/simple_app_text.dart';
import 'package:sampay_wallet/core/widgets/simple_form.dart';
import 'package:sampay_wallet/core/widgets/simple_image_selector.dart';
import 'package:sampay_wallet/core/widgets/simple_text_field.dart';
import 'package:sampay_wallet/core/widgets/simple_toast.dart';
import 'package:sampay_wallet/features/load_wallet/models/bank_deposit_model.dart';
import 'package:sampay_wallet/features/load_wallet/services/load_wallet_service.dart';
import 'package:watch_it/watch_it.dart';

class UploadPopForm extends StatelessWidget with WatchItMixin {
  final LoadWalletService loadWalletService = getIt<LoadWalletService>();
  final Function(BankDepositModel value)? onSubmit;
  UploadPopForm({super.key, this.onSubmit});

  @override
  Widget build(BuildContext context) {
    final BankDepositModel loadWalletWithBankDeposit = watchValue(
      (ValueNotifier<BankDepositModel> m) => m,
      instanceName: "loadWalletWithBankDeposit",
    );

    return Container(
      padding: EdgeInsets.all(AppConstants.STANDARD_PAGE_PADDING),
      decoration: AppDecorations.white(),
      child: SimpleForm(
        actionTitle: "Upload",
        actionSpace: EmptySpace(),
        onSubmit: () {
          if (loadWalletWithBankDeposit.depositfile == null) {
            SimpleToast.showErrorToast(
              "Please select an image to proceed",
              context,
            );
            return;
          }

          onSubmit?.call(loadWalletWithBankDeposit);
        },
        children: [
          SimpleAppText.title(
            "Upload Proof of Payment",
            fontWeight: FontWeight.w900,
          ),
          EmptySpace.small(),
          SimpleAppText.small(
            "Upload your bank deposit slip or transaction receipt",
            align: .center,
          ),
          EmptySpace.large(),
          SimpleTextField(
            labelText: "Bank Ref",
            isDisabled: true,
            icon: AppIcons.profile,
            initialValue: loadWalletWithBankDeposit.bankref,
            keyboardType: .numberWithOptions(decimal: true),
            validator: (v) => AppValidations.validateNotNullOrLessThan(
              v,
              message: "Please enter amount greater than 1",
            ),
            //onValueChanged: print,
          ),
          EmptySpace.small(),
          SimpleTextField(
            labelText: "Amount",
            icon: AppIcons.dollar,
            prefixText: "ZMW ",
            initialValue: AppUtils()
                .parseAmount(
                  loadWalletWithBankDeposit.depositamount.toStringAsFixed(2),
                  defaultValue: 1,
                )
                .toStringAsFixed(2),
            onChanged: (value) =>
                loadWalletService.updateLoadWalletWithBankDeposit(
                  loadWalletWithBankDeposit.copyWith(
                    depositamount: AppUtils().parseAmount(
                      value,
                      defaultValue: 1.0,
                    ),
                  ),
                ),
            keyboardType: .numberWithOptions(decimal: true),
            validator: (v) => AppValidations.validateNotNullOrLessThan(
              v,
              message: "Please enter amount greater than 1",
            ),
          ),
          EmptySpace.small(),
          SimpleTextField(
            labelText: "Deposit Date",
            icon: AppIcons.calendar,
            isDateField: true,
            initialValue: loadWalletWithBankDeposit.depositdate,
            onChanged: (value) =>
                loadWalletService.updateLoadWalletWithBankDeposit(
                  loadWalletWithBankDeposit.copyWith(depositdate: value),
                ),
            keyboardType: .datetime,
            validator: (v) => AppValidations.validateNotNull(
              v,
              message: "Please select appropriate date",
            ),
          ),
          EmptySpace(),
          SimpleImageSelector(
            onSelect: (value) =>
                loadWalletService.updateLoadWalletWithBankDeposit(
                  loadWalletWithBankDeposit.copyWith(depositfile: value),
                ),
          ),
        ],
      ),
    );
  }
}
