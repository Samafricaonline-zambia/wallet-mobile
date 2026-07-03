import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/app_icons.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/models/bill_merchant_model.dart';
import 'package:sampay_wallet/core/services/configure_dependencies.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/core/utils/dialog_utils.dart';
import 'package:sampay_wallet/core/validations/validations.dart';
import 'package:sampay_wallet/core/widgets/empty_space.dart';
import 'package:sampay_wallet/core/widgets/simple_form.dart';
import 'package:sampay_wallet/core/widgets/simple_text_field.dart';
import 'package:sampay_wallet/core/constants/bills/bills_confirmation_messages.dart';
import 'package:sampay_wallet/features/bills/models/bill_item_model.dart';
import 'package:sampay_wallet/features/bills/services/bills_service.dart';
import 'package:watch_it/watch_it.dart';

class PayWithAccountForm extends StatelessWidget with WatchItMixin {
  final BillsService billsService = getIt<BillsService>();
  final Function(BillItemModel item)? onSubmit;
  final BillMerchantType merchantType;
  final String actionLabel;

  PayWithAccountForm({
    super.key,
    this.onSubmit,
    required this.merchantType,
    this.actionLabel = "Buy Tokens",
  });

  @override
  Widget build(BuildContext context) {
    final BillItemModel currentBillingItem = watchValue(
      (ValueNotifier<BillItemModel> m) => m,
      instanceName: "currentBillingItem",
    );

    void handleClick() {
      DialogUtils()
          .openConfirmDialog(
            context,
            message: BillsConfirmationMessages.getMerchantConfirmationMessage(
              merchantType,
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
          labelText: "Account Number",
          icon: AppIcons.electricity,
          initialValue: currentBillingItem.accountNumber,
          keyboardType: .number,
          validator: (v) => AppValidations.validateZambianElectricityMeter(v),
          onChanged: (value) => billsService.updateCurrentBillingItem(
            currentBillingItem.copyWith(accountNumber: value),
          ),
        ),
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
