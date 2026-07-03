import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/app_icons.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/constants/decorations.dart';
import 'package:sampay_wallet/core/models/dialog_option_model.dart';
import 'package:sampay_wallet/core/models/load_wallet_models/momo.dart';
import 'package:sampay_wallet/core/services/configure_dependencies.dart';
import 'package:sampay_wallet/core/validations/validations.dart';
import 'package:sampay_wallet/core/widgets/empty_space.dart';
import 'package:sampay_wallet/core/widgets/simple_app_text.dart';
import 'package:sampay_wallet/core/widgets/simple_form.dart';
import 'package:sampay_wallet/core/widgets/simple_image_card.dart';
import 'package:sampay_wallet/core/widgets/simple_text_field.dart';
import 'package:sampay_wallet/features/load_wallet/services/load_wallet_service.dart';
import 'package:watch_it/watch_it.dart';

class LoadWalletWithCardForm extends StatelessWidget with WatchItMixin {
  final LoadWalletService loadWalletService = getIt<LoadWalletService>();
  final Function(LoadWalletWithMOMO loadWalletRequestMOMO)? onSubmit;
  final DialogOptionModel option;

  LoadWalletWithCardForm({super.key, this.onSubmit, required this.option});

  @override
  Widget build(BuildContext context) {
    final LoadWalletWithMOMO loadWalletRequestMOMO = watchValue(
      (ValueNotifier<LoadWalletWithMOMO> m) => m,
      instanceName: "loadWalletRequestMOMO",
    );

    return Container(
      decoration: AppDecorations.white(),
      padding: EdgeInsets.all(AppConstants.STANDARD_PAGE_PADDING),
      child: SimpleForm(
        actionTitle: "Proceed",
        isFullWidth: true,
        //onSubmit: () => onSubmit?.call(loadWalletRequestMOMO),
        children: [
          SimpleImageCard(image: option.image),
          EmptySpace.small(),
          SimpleAppText.title("Visa/Mastercard", fontWeight: FontWeight.w900),
          EmptySpace.small(),
          SimpleAppText(
            "Load your wallet from a VISA or Mastercard linked account",
            align: .center,
          ),
          EmptySpace(),
          SimpleTextField(
            labelText: "Amount",
            icon: AppIcons.dollar,
            prefixText: "ZMW ",
            initialValue: loadWalletRequestMOMO.amount!.toStringAsFixed(2),
            onChanged: (value) => loadWalletService.updateLoadWalletRequestMOMO(
              loadWalletRequestMOMO.copyWith(
                amount: double.tryParse(value) ?? 1,
              ),
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
