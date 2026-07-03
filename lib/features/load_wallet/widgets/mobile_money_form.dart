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
import 'package:sampay_wallet/core/widgets/simple_image_card.dart';
import 'package:sampay_wallet/core/widgets/simple_text_field.dart';
import 'package:sampay_wallet/features/load_wallet/services/load_wallet_service.dart';
import 'package:sampay_wallet/services/app_state_service.dart';
import 'package:watch_it/watch_it.dart';

class LoadMobileMoneyForm extends StatelessWidget with WatchItMixin {
  final LoadWalletService loadWalletService = getIt<LoadWalletService>();
  final AppStateService appState = getIt<AppStateService>();
  final Function(LoadWalletWithMOMO loadWalletRequest)? onSubmit;
  final DialogOptionModel option;

  LoadMobileMoneyForm({super.key, this.onSubmit, required this.option});

  @override
  Widget build(BuildContext context) {
    final int selectedWalletTypeIndex = watchValue(
      (ValueNotifier<int> m) => m,
      instanceName: "selectedWalletTypeIndex",
    );

    final LoadWalletWithMOMO loadWalletRequestMOMO = watchValue(
      (ValueNotifier<LoadWalletWithMOMO> m) => m,
      instanceName: "loadWalletRequestMOMO",
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
            onSubmit?.call(loadWalletRequestMOMO);
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
          SimpleImageCard(image: option.image),
          EmptySpace.small(),
          SimpleAppText.title(option.title, fontWeight: FontWeight.w900),
          EmptySpace.small(),
          SimpleAppText.small(option.description, align: .center),
          EmptySpace.small(),
        ],
        children: [
          SimpleDropDown(
            labelText: "Choose wallet",
            items: AppConstants.WALLET_OPTIONS,
            initialValue: AppConstants.WALLET_OPTIONS[selectedWalletTypeIndex],
            onIndexChanged: (value) {
              loadWalletService.setSelectedWalletType(value);
            },
            validator: (v) => AppValidations.validateNotNone(v),
          ),
          EmptySpace.small(),
          SimpleTextField(
            labelText: "Mobile number",
            icon: AppIcons.phone,
            prefixText: "+260",
            isDisabled: true,
            initialValue: appState.phoneNumber,
            onChanged: (value) => loadWalletService.updateLoadWalletRequestMOMO(
              loadWalletRequestMOMO.copyWith(account: value),
            ),
            keyboardType: .number,
            validator: (v) => AppValidations.validatePhoneNumber(v),
          ),
          EmptySpace.small(),
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
