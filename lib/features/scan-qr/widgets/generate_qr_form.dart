import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/app_icons.dart';
import 'package:sampay_wallet/core/services/configure_dependencies.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/core/utils/dialog_utils.dart';
import 'package:sampay_wallet/core/validations/validations.dart';
import 'package:sampay_wallet/core/widgets/empty_space.dart';
import 'package:sampay_wallet/core/widgets/simple_drop_down.dart';
import 'package:sampay_wallet/core/widgets/simple_form.dart';
import 'package:sampay_wallet/core/widgets/simple_list.dart';
import 'package:sampay_wallet/core/widgets/simple_text_field.dart';
import 'package:sampay_wallet/features/scan-qr/models/qr_model.dart';
import 'package:sampay_wallet/features/scan-qr/services/qr_service.dart';
import 'package:sampay_wallet/features/scan-qr/widgets/qr_view.dart';
import 'package:sampay_wallet/services/app_state_service.dart';
import 'package:watch_it/watch_it.dart';

class GenerateQRForm extends StatelessWidget with WatchItMixin {
  final QrService qrService = getIt<QrService>();
  final AppStateService appState = getIt<AppStateService>();
  GenerateQRForm({super.key});

  @override
  Widget build(BuildContext context) {
    final int selectedQRWalletIndex = watchValue(
      (ValueNotifier<int> m) => m,
      instanceName: "selectedQRWalletIndex",
    );

    final QRModel qrCode = watchValue(
      (ValueNotifier<QRModel> m) => m,
      instanceName: "qrCode",
    );

    return SimpleForm(
      actionTitle: "Generate QR Code",
      isFullWidth: true,
      onSubmit: () {
        DialogUtils().openModalDialog(
          context,
          QRView(),
          title: "Receive Payment",
        );
      },
      children: [
        SimpleDropDown(
          initialValue: qrService.wallets[selectedQRWalletIndex],
          items: qrService.wallets,
          onIndexChanged: qrService.setSelectedWalletIndex,
        ),
        EmptySpace(),
        SimpleTextField(
          labelText: "Phone Number",
          icon: AppIcons.phone,
          prefixText: qrCode.phone!.isEmpty ? "260" : "",
          initialValue: qrCode.phone,
          keyboardType: .numberWithOptions(),
          isDisabled: qrCode.phone!.isNotEmpty,
          validator: (v) => AppValidations.validatePhoneNumber(v),
          onChanged: (value) =>
              qrService.generateQR(value: qrCode.copyWith(phone: value)),
        ),
        EmptySpace(),
        SimpleTextField(
          labelText: "Amount",
          icon: AppIcons.dollar,
          prefixText: "ZMW ",
          initialValue: AppUtils()
              .valueOrDefault<double>(qrCode.amount)
              .toString(),
          keyboardType: .numberWithOptions(decimal: true),
          validator: (v) => AppValidations.validateNotNullOrZero(
            v,
            message: "Enter appropriate amount",
          ),
          onChanged: (value) => qrService.generateQR(
            value: qrCode.copyWith(
              amount: AppUtils().valueOrDefault<double>(double.tryParse(value)),
            ),
          ),
        ),
      ],
    );
  }
}
