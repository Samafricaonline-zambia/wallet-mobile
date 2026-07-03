import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/models/bank_details_model.dart';
import 'package:sampay_wallet/core/widgets/empty_space.dart';
import 'package:sampay_wallet/core/widgets/simple_app_text.dart';
import 'package:sampay_wallet/core/widgets/simple_flex.dart';
import 'package:sampay_wallet/core/widgets/simple_form.dart';
import 'package:sampay_wallet/core/widgets/simple_image_card.dart';

class BankPop extends StatelessWidget {
  final BankDetailsModel bank;
  final Function(BankDetailsModel bank)? onSubmit;
  const BankPop({super.key, required this.bank, this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return SimpleForm(
      actionTitle: "Upload POP",
      onSubmit: () => onSubmit?.call(bank),
      children: [
        SimpleImageCard(image: bank.logo, height: 100, width: 100),
        EmptySpace.large(),
        SimpleFlex(
          leftChild: SimpleAppText("Name"),
          rightChild: SimpleAppText(bank.name, shouldWrap: false),
        ),
        EmptySpace(),
        SimpleFlex(
          leftChild: SimpleAppText("Account Number"),
          rightChild: SimpleAppText(bank.accountNumber, shouldWrap: false),
        ),
        EmptySpace(),
        SimpleFlex(
          leftChild: SimpleAppText("Sort Code"),
          rightChild: SimpleAppText(bank.sortCode, shouldWrap: false),
        ),
        EmptySpace(),
        SimpleFlex(
          leftChild: SimpleAppText("Branch Name"),
          rightChild: SimpleAppText(bank.branchName, shouldWrap: false),
        ),
        EmptySpace(),
        SimpleFlex(
          leftChild: SimpleAppText("Branch Code"),
          rightChild: SimpleAppText(bank.branchCode, shouldWrap: false),
        ),
        EmptySpace(),
        SimpleFlex(
          leftChild: SimpleAppText("SWIFT Code"),
          rightChild: SimpleAppText(bank.swiftCode, shouldWrap: false),
        ),
      ],
    );
  }
}
