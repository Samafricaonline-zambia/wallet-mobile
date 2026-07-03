import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/constants/dialog_options.dart';
import 'package:sampay_wallet/core/themes/color_constants.dart';
import 'package:sampay_wallet/core/widgets/empty_space.dart';
import 'package:sampay_wallet/core/widgets/simple_option_tile.dart';

class WalletTransferOptions extends StatelessWidget {
  final Function(int optionIndex)? onClick;
  const WalletTransferOptions({super.key, this.onClick});

  @override
  Widget build(BuildContext context) {
    final ColorScheme appTheme = AppConstants.AppTheme(context);

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return SimpleOptionTile(
          image: AppDialogOptions.walletTransferOptions[index].image,
          title: AppDialogOptions.walletTransferOptions[index].title,
          description:
              AppDialogOptions.walletTransferOptions[index].description,
          badgeText: AppDialogOptions.walletTransferOptions[index].badgeText,
          backgroundColor: index % 2 == 0 ? appTheme.light : null,
          onClick: () {
            if (onClick != null) {
              onClick!(index);
            }
          },
        );
      },
      separatorBuilder: (context, index) => EmptySpace.small(),
      itemCount: AppDialogOptions.walletTransferOptions.length,
    );
  }
}
