import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/app_icons.dart';
import 'package:sampay_wallet/core/constants/international_payments.dart';
import 'package:sampay_wallet/core/services/configure_dependencies.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/core/validations/validations.dart';
import 'package:sampay_wallet/core/widgets/empty_space.dart';
import 'package:sampay_wallet/core/widgets/simple_form.dart';
import 'package:sampay_wallet/core/widgets/simple_section_title.dart';
import 'package:sampay_wallet/core/widgets/simple_text_field.dart';
import 'package:sampay_wallet/features/international_payments/models/payment_request_model.dart';
import 'package:sampay_wallet/features/international_payments/services/international_payments_service.dart';
import 'package:sampay_wallet/features/international_payments/widgets/reason_dropdown.dart';
import 'package:watch_it/watch_it.dart';

class BankPaymentForm extends StatelessWidget with WatchItMixin {
  final InternationalPaymentsService internationalPaymentsService =
      getIt<InternationalPaymentsService>();

  final Function(bool isSuccess)? onSubmit;
  BankPaymentForm({super.key, this.onSubmit});

  @override
  Widget build(BuildContext context) {
    final InternationalPaymentsRequestModel currentRequest = watchValue(
      (ValueNotifier<InternationalPaymentsRequestModel> m) => m,
      instanceName: "currentInternaltionalPaymentRequest",
    );

    void handleTransferPurposeChange(int index) {
      final selectedPurpose = InternationalPaymentsConstants.getPurposeByIndex(
        index,
      );

      internationalPaymentsService.updateCurrentPaymentRequest(
        currentRequest.copyWith(
          senderreportcode: selectedPurpose.code,
          senderreason: selectedPurpose.reason,
          senderreasonindex: index,
        ),
      );
    }

    void handleSubmit() async {
      // verify details
      final value = await internationalPaymentsService.verifyReceiver(
        currentRequest,
      );

      onSubmit?.call(value);
    }

    return SimpleForm(
      actionTitle: "Make Payment",
      onSubmit: handleSubmit,
      children: [
        SimpleSectionTitle(
          title: "Sender details",
          fontWeight: FontWeight.w900,
        ),
        SimpleTextField(
          labelText: "Mobile Number",
          icon: AppIcons.phone,
          prefixText: "+260",
          initialValue: currentRequest.debtoraccount,
          keyboardType: .phone,
          validator: (v) => AppValidations.validatePhoneNumber(v),
          onChanged: (value) =>
              internationalPaymentsService.updateCurrentPaymentRequest(
                currentRequest.copyWith(debtoraccount: value),
              ),
          messageText: "Mobile number associated with your wallet",
        ),
        EmptySpace.small(),
        SimpleTextField(
          labelText: "Fullname",
          icon: AppIcons.profile,
          initialValue: currentRequest.senderfullname,
          keyboardType: .name,
          validator: (v) => AppValidations.validateNotNone(v),
          onChanged: (value) =>
              internationalPaymentsService.updateCurrentPaymentRequest(
                currentRequest.copyWith(senderfullname: value),
              ),
        ),
        EmptySpace.small(),
        SimpleTextField(
          labelText: "Amount",
          icon: AppIcons.dollar,
          initialValue: currentRequest.amount.toStringAsFixed(2),
          keyboardType: .numberWithOptions(),
          validator: (v) => AppValidations.validateNotNullOrZero(
            v,
            message: "Enter appropriate amount",
          ),
          onChanged: (value) =>
              internationalPaymentsService.updateCurrentPaymentRequest(
                currentRequest.copyWith(
                  amount: AppUtils().valueOrDefault<double>(
                    double.tryParse(value),
                  ),
                ),
              ),
        ),
        EmptySpace.small(),
        TransferReasonDropDown(onChange: handleTransferPurposeChange),
        // SimpleTextField(
        //   labelText: "Purpose",
        //   icon: AppIcons.notes,
        //   initialValue: currentRequest.senderreason,
        //   keyboardType: .text,
        //   validator: (v) => AppValidations.validateNotNone(
        //     v,
        //     message: "Enter appropriate reason for transfer",
        //   ),
        //   onChanged: (value) =>
        //       internationalPaymentsService.updateCurrentPaymentRequest(
        //         currentRequest.copyWith(senderreason: value),
        //       ),
        //   messageText: "Reason for sending money",
        // ),
        EmptySpace(),
        SimpleSectionTitle(
          title: "Receiver details",
          fontWeight: FontWeight.w900,
        ),
        SimpleTextField(
          labelText: "Account Number",
          icon: AppIcons.profile,
          initialValue: currentRequest.creditaccount,
          keyboardType: .number,
          validator: (v) =>
              AppValidations.validateBankAccountDetails(accountNumber: v),
          onChanged: (value) =>
              internationalPaymentsService.updateCurrentPaymentRequest(
                currentRequest.copyWith(creditaccount: value),
              ),
          messageText: "Mobile number associated with receiver's wallet",
        ),
        EmptySpace.small(),
        SimpleTextField(
          labelText: "Fullname",
          icon: AppIcons.profile,
          initialValue: currentRequest.receiverfullname,
          keyboardType: .name,
          validator: (v) => AppValidations.validateNotNone(v),
          onChanged: (value) =>
              internationalPaymentsService.updateCurrentPaymentRequest(
                currentRequest.copyWith(receiverfullname: value),
              ),
        ),
        EmptySpace.small(),
        SimpleTextField(
          labelText: "Address",
          icon: AppIcons.map,
          initialValue: currentRequest.receiveraddress,
          keyboardType: .name,
          validator: (v) => AppValidations.validateNotNone(v),
          onChanged: (value) =>
              internationalPaymentsService.updateCurrentPaymentRequest(
                currentRequest.copyWith(receiveraddress: value),
              ),
        ),
        EmptySpace.small(),
        SimpleTextField(
          labelText: "Town",
          icon: AppIcons.map,
          initialValue: currentRequest.receivertown,
          keyboardType: .text,
          validator: (v) => AppValidations.validateNotNull(v),
          onChanged: (value) =>
              internationalPaymentsService.updateCurrentPaymentRequest(
                currentRequest.copyWith(receivertown: value),
              ),
        ),
        EmptySpace.small(),
        SimpleTextField(
          labelText: "Postcode",
          icon: AppIcons.map,
          initialValue: currentRequest.receiverpostcode,
          keyboardType: .text,
          validator: (v) => AppValidations.validateNotNullOrZero(v),
          onChanged: (value) =>
              internationalPaymentsService.updateCurrentPaymentRequest(
                currentRequest.copyWith(receiverpostcode: value),
              ),
        ),
        EmptySpace.small(),
        SimpleTextField(
          labelText: "Country",
          icon: AppIcons.flag,
          initialValue: currentRequest.receivercountry,
          isDisabled: true,
          keyboardType: .text,
        ),
      ],
    );
  }
}
