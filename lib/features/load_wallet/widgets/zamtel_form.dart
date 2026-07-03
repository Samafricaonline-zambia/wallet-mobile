import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/constants/decorations.dart';
import 'package:sampay_wallet/core/models/dialog_option_model.dart';
import 'package:sampay_wallet/core/widgets/empty_space.dart';
import 'package:sampay_wallet/core/widgets/simple_alert.dart';
import 'package:sampay_wallet/core/widgets/simple_app_text.dart';
import 'package:sampay_wallet/core/widgets/simple_form.dart';

class LoadWalletWithZamtelForm extends StatelessWidget {
  final Function()? onSubmit;
  final DialogOptionModel option;

  const LoadWalletWithZamtelForm({
    super.key,
    this.onSubmit,
    required this.option,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.white(),
      padding: EdgeInsets.all(AppConstants.STANDARD_PAGE_PADDING),
      child: SimpleForm(
        actionTitle: "Close",
        hAlign: .stretch,
        isFullWidth: true,
        onSubmit: onSubmit,
        children: [
          SimpleAppText.title(
            "Zamtel Cash Point",
            fontWeight: FontWeight.w900,
            align: .center,
          ),
          EmptySpace.small(),
          SimpleAppText(
            "Load your wallet from nearst Zamtel Agent Outlet",
            align: .center,
          ),
          EmptySpace(),
          SimpleAppText.title(
            "How to deposit at Zamtel Agent",
            fontWeight: FontWeight.w900,
            align: .start,
          ),
          SimpleAppText(
            "1. Provide the Agent with Cash to deposit.",
            align: .start,
          ),
          SimpleAppText(
            "2. Provide the Sampay Account number you wish to deposit into.",
            align: .start,
          ),
          SimpleAppText(
            "3. Confirm Sampay Account Name with the Agent.",
            align: .start,
          ),
          EmptySpace(),
          SimpleAlert.warning(
            "You will be charged 1.63% of the amount deposited",
          ),
        ],
      ),
    );
  }
}
