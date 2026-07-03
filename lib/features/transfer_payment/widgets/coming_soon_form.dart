import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/constants/decorations.dart';
import 'package:sampay_wallet/core/models/dialog_option_model.dart';
import 'package:sampay_wallet/core/themes/color_constants.dart';
import 'package:sampay_wallet/core/widgets/empty_space.dart';
import 'package:sampay_wallet/core/widgets/simple_app_text.dart';
import 'package:sampay_wallet/core/widgets/simple_form.dart';
import 'package:sampay_wallet/core/widgets/simple_image_card.dart';
import 'package:sampay_wallet/core/widgets/simple_pill.dart';

class TransferComingSoonForm extends StatelessWidget {
  final Function()? onSubmit;
  final DialogOptionModel option;

  const TransferComingSoonForm({
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
        isFullWidth: true,
        onSubmit: onSubmit,
        children: [
          SimpleImageCard(image: option.image),
          EmptySpace.small(),
          SimpleAppText.title(option.title, fontWeight: FontWeight.w900),
          EmptySpace.small(),
          SimplePill(
            "Coming Soon",
            bgColor: AppColors.warning,
            color: AppColors.white,
            fontSize: 16,
          ),
          EmptySpace(),
          SimpleAppText(option.description, align: .center),
          EmptySpace(),
          SimpleAppText.small(
            "This feature is currently under development and will be available soon.",
            align: .center,
            color: AppColors.grey,
          ),
        ],
      ),
    );
  }
}
