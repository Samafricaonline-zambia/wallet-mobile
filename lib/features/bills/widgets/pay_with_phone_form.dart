import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/app_icons.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/models/bill_merchant_model.dart';
import 'package:sampay_wallet/core/models/input_field_model.dart';
import 'package:sampay_wallet/core/services/configure_dependencies.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/core/utils/dialog_utils.dart';
import 'package:sampay_wallet/core/validations/validations.dart';
import 'package:sampay_wallet/core/widgets/empty_space.dart';
import 'package:sampay_wallet/core/widgets/simple_drop_down.dart';
import 'package:sampay_wallet/core/widgets/simple_form.dart';
import 'package:sampay_wallet/core/widgets/simple_text_field.dart';
import 'package:sampay_wallet/core/constants/bills/bills_confirmation_messages.dart';
import 'package:sampay_wallet/core/constants/bills/bills_data.dart';
import 'package:sampay_wallet/features/bills/models/bill_item_model.dart';
import 'package:sampay_wallet/features/bills/services/bills_service.dart';
import 'package:watch_it/watch_it.dart';

class PayWithPhoneForm extends StatelessWidget with WatchItMixin {
  final BillsService billsService = getIt<BillsService>();
  final Function(BillItemModel item)? onSubmit;
  final String actionLabel;
  final BillMerchantModel merchant;

  PayWithPhoneForm({
    super.key,
    required this.merchant,
    this.actionLabel = "Buy Airtime",
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final BillItemModel currentBillingItem = watchValue(
      (ValueNotifier<BillItemModel> m) => m,
      instanceName: "currentBillingItem",
    );

    final InputFieldModel inputFieldModel =
        merchant.inputField ??
        InputFieldModel.fromMerchantType(merchant.merchantType);

    void handleClick() {
      DialogUtils()
          .openConfirmDialog(
            context,
            message: BillsConfirmationMessages.getMerchantConfirmationMessage(
              merchant.merchantType,
              AppUtils().valueOrDefault(currentBillingItem.accountNumber),
              AppUtils()
                  .valueOrDefault<double>(currentBillingItem.value)
                  .toString(),
            ),
          )
          .then((value) {
            if (value == true) {
              onSubmit?.call(currentBillingItem);
            }
          });
    }

    return SimpleForm(
      isFullWidth: true,
      actionTitle: actionLabel,
      onSubmit: handleClick,
      children: [
        SimpleTextField(
          labelText: inputFieldModel.label,
          icon: inputFieldModel.icon,
          prefixText: inputFieldModel.prefix,
          initialValue: currentBillingItem.accountNumber,
          keyboardType: inputFieldModel.keyboardType,
          validator: (v) => AppValidations.validateBillPayment(merchant, v),
          onChanged: (value) => billsService.updateCurrentBillingItem(
            currentBillingItem.copyWith(accountNumber: value),
          ),
        ),
        if (merchant.merchantType == BillMerchantType.data) ...[
          EmptySpace(),
          SimpleDropDown(
            items: ["Daily Bundle", "Weekly Bundle", "Monthly Bundle"],
            initialValue: "Daily Bundle",
            onChanged: (value) => billsService.updateCurrentBillingItem(
              currentBillingItem.copyWith(tag: value),
            ),
          ),
        ],
        EmptySpace(),
        SimpleTextField(
          labelText: "Amount",
          icon: AppIcons.dollar,
          prefixText: "ZMW ",
          initialValue: AppUtils()
              .valueOrDefault<double>(currentBillingItem.value)
              .toString(),
          keyboardType: .numberWithOptions(decimal: true),
          messageText: "You will be charged: ZMW 0.0",
          validator: (v) => AppValidations.validateNotNullOrZero(
            v,
            message: "Enter appropriate amount",
          ),
          onChanged: (value) => billsService.updateCurrentBillingItem(
            currentBillingItem.copyWith(
              value: AppUtils().valueOrDefault<double>(double.tryParse(value)),
            ),
          ),
        ),
      ],
    );
  }
}
