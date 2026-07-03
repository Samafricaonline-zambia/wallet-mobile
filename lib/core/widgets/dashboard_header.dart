import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/app_icons.dart';
import 'package:sampay_wallet/core/constants/app_labels.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/constants/shadows.dart';
import 'package:sampay_wallet/core/extensions/num_extensions.dart';
import 'package:sampay_wallet/core/extensions/widget_extensions.dart';
import 'package:sampay_wallet/core/models/wallet_model.dart';
import 'package:sampay_wallet/core/themes/color_constants.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/core/widgets/empty_space.dart';
import 'package:sampay_wallet/core/widgets/simple_app_text.dart';
import 'package:sampay_wallet/core/widgets/simple_flex.dart';
import 'package:sampay_wallet/core/widgets/simple_icon_inset_tile.dart';
import 'package:sampay_wallet/core/widgets/simple_icon_tile.dart';
import 'package:sampay_wallet/core/widgets/simple_slider.dart';

class DashboardHeader extends StatefulWidget {
  final WalletModel localWallet;
  final WalletModel internationalWallet;
  final VoidCallback? onLoadWalletClick;
  final VoidCallback? onRefreshWalletClick;
  final VoidCallback? onSendMoneyClick;

  const DashboardHeader({
    super.key,
    required this.localWallet,
    required this.internationalWallet,
    this.onLoadWalletClick,
    this.onRefreshWalletClick,
    this.onSendMoneyClick,
  });

  @override
  State<DashboardHeader> createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends State<DashboardHeader> {
  int selectedWalletIndex = 0;

  @override
  Widget build(BuildContext context) {
    final double totalWidth = AppUtils().getScreenWidth(context);
    final ColorScheme appTheme = AppConstants.AppTheme(context);

    Widget localWallet() {
      return Column(
        children: [
          SimpleAppText(
            widget.localWallet.title,
            color: appTheme.white,
            fontWeight: FontWeight.w900,
          ),
          EmptySpace.small(),
          SimpleAppText(
            widget.localWallet.balance.smartBalance,
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: appTheme.white,
          ),
          EmptySpace.small(),
          SimpleAppText(
            widget.localWallet.currency,
            color: appTheme.white,
            fontWeight: FontWeight.w900,
          ),
        ],
      );
    }

    Widget internationalWallet() {
      final bool isDisabled = !widget.internationalWallet.isActive;
      return Column(
        children: [
          SimpleAppText(
            widget.internationalWallet.title,
            color: appTheme.white.withAlpha(isDisabled ? 100 : 255),
            fontWeight: FontWeight.w900,
          ),
          EmptySpace.small(),
          SimpleAppText(
            widget.internationalWallet.balance.smartBalance,
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: appTheme.white.withAlpha(isDisabled ? 100 : 255),
          ),
          EmptySpace.small(),
          SimpleAppText(
            widget.internationalWallet.currency,
            color: appTheme.white.withAlpha(isDisabled ? 100 : 255),
            fontWeight: FontWeight.w900,
          ),
        ],
      );
    }

    void slideWallet() {
      setState(() {
        if (selectedWalletIndex < 1) {
          selectedWalletIndex = 1;
        } else {
          selectedWalletIndex = 0;
        }
      });
    }

    return SizedBox(
      width: totalWidth,
      height: 300,
      //height: double.infinity,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: .center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.arrow_left,
                size: 38,
                color: appTheme.white,
              ).onTap(slideWallet),
              SimpleSlider(
                activeIndex: selectedWalletIndex,
                height: 130,
                //width: 170,
                children: [localWallet(), internationalWallet()],
              ),
              Icon(
                Icons.arrow_right,
                size: 38,
                color: appTheme.white,
              ).onTap(slideWallet),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: Container(
              width: totalWidth,
              height: 120,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                boxShadow: AppShadows.light,
                border: Border.all(width: 1, color: appTheme.grey),
                borderRadius: BorderRadius.circular(
                  AppConstants.STANDARD_BORDER_RADIUS,
                ),
                color: appTheme.white,
              ),
              child: SecondaryDashboardHeader(
                onLoadWalletClick: widget.onLoadWalletClick,
                onRefreshWalletClick: widget.onRefreshWalletClick,
                onSendMoneyClick: widget.onSendMoneyClick,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SecondaryDashboardHeader extends StatelessWidget {
  final VoidCallback? onLoadWalletClick;
  final VoidCallback? onRefreshWalletClick;
  final VoidCallback? onSendMoneyClick;

  const SecondaryDashboardHeader({
    super.key,
    this.onLoadWalletClick,
    this.onRefreshWalletClick,
    this.onSendMoneyClick,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SimpleIconInsetTile(
          icon: AppIcons.wallet,
          title: AppLabels.LOAD,
          onClick: onLoadWalletClick,
        ),
        SimpleIconInsetTile(
          icon: AppIcons.refresh,
          title: AppLabels.REFRESH,
          onClick: onRefreshWalletClick,
        ),
        SimpleIconInsetTile(
          icon: AppIcons.send,
          title: AppLabels.PAY,
          onClick: onSendMoneyClick,
        ),
      ],
    );
  }
}
