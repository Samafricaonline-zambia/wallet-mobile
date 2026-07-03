import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/app_icons.dart';
import 'package:sampay_wallet/core/services/configure_dependencies.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/core/validations/validations.dart';
import 'package:sampay_wallet/core/widgets/empty_space.dart';
import 'package:sampay_wallet/core/widgets/simple_form.dart';
import 'package:sampay_wallet/core/widgets/simple_text_field.dart';
import 'package:sampay_wallet/features/bills/models/bill_item_model.dart';
import 'package:sampay_wallet/features/pay_merchant/services/pay_merchant_service.dart';
import 'package:watch_it/watch_it.dart';

class PayMerchantForm extends StatelessWidget with WatchItMixin {
  final Function(BillItemModel item)? onSubmit;
  final PayMerchantService payMerchantService = getIt<PayMerchantService>();
  PayMerchantForm({super.key, this.onSubmit});

  @override
  Widget build(BuildContext context) {
    final BillItemModel payMerchantRequest = watchValue(
      (ValueNotifier<BillItemModel> m) => m,
      instanceName: "payMerchantRequest",
    );

    return SimpleForm(
      actionTitle: "Pay Now",
      isFullWidth: true,
      onSubmit: () => onSubmit?.call(payMerchantRequest),
      children: [
        SimpleTextField(
          labelText: "Merchant Code",
          icon: AppIcons.merchant,
          initialValue: payMerchantRequest.accountNumber,
          keyboardType: .number,
          validator: (v) => AppValidations.validateNotNull(v),
          onChanged: (value) => payMerchantService.setPayMerchantRequest(
            payMerchantRequest.copyWith(accountNumber: value),
          ),
        ),
        EmptySpace(),
        SimpleTextField(
          labelText: "Amount",
          icon: AppIcons.dollar,
          prefixText: "ZMW ",
          initialValue: AppUtils()
              .valueOrDefault<double>(payMerchantRequest.value)
              .toString(),
          keyboardType: .numberWithOptions(decimal: true),
          messageText: "You will be charged: ZMW 0.0",
          validator: (v) => AppValidations.validateNotNullOrZero(
            v,
            message: "Enter appropriate amount",
          ),
          onChanged: (value) => payMerchantService.setPayMerchantRequest(
            payMerchantRequest.copyWith(
              value: AppUtils().valueOrDefault<double>(double.tryParse(value)),
            ),
          ),
        ),
        EmptySpace(),
        SimpleTextField(
          labelText: "Narration",
          icon: AppIcons.notes,
          placeholder: "Purpose of this payment",
          keyboardType: .text,
          initialValue: payMerchantRequest.tag,
          onChanged: (value) => payMerchantService.setPayMerchantRequest(
            payMerchantRequest.copyWith(tag: value),
          ),
        ),
      ],
    );
  }
}
