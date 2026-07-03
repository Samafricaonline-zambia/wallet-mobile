import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sampay_wallet/core/constants/assets.dart';
import 'package:sampay_wallet/core/constants/ecommerce_constants.dart';
import 'package:sampay_wallet/core/extensions/widget_extensions.dart';
import 'package:sampay_wallet/core/layouts/dashboard_layout.dart';
import 'package:sampay_wallet/core/routes/app_router.dart';
import 'package:sampay_wallet/core/services/configure_dependencies.dart';
import 'package:sampay_wallet/core/themes/app_theme.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/core/widgets/empty_space.dart';
import 'package:sampay_wallet/core/widgets/simple_app_text.dart';
import 'package:sampay_wallet/core/widgets/simple_flex.dart';
import 'package:sampay_wallet/core/widgets/simple_icon_tile.dart';
import 'package:sampay_wallet/core/widgets/simple_image_card.dart';
import 'package:sampay_wallet/services/wallet_service.dart';
import 'package:watch_it/watch_it.dart';

class DashboardPage extends StatelessWidget with WatchItMixin {
  final WalletService walletService = getIt<WalletService>();
  DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double totalWidth = AppUtils().getScreenWidth(context);
    final double tileWidth = totalWidth * 0.45;
    final double imageSize = 100;

    callOnceAfterThisBuild((ctx) {
      walletService.fetchWalletBalance();
    });

    return DashboardLayout(
      selectedTabBarIndex: 0,
      // child: SimpleImageTileRow([
      //   SimpleImageTile(
      //     padding: EdgeInsets.all(0),
      //     // width: imageSize,
      //     // height: imageSize,
      //     image: AppAssets.internationalTransfer,
      //     //title: "International \nTransfer",
      //   ),
      //   SimpleImageTile(
      //     padding: EdgeInsets.all(0),
      //     // width: imageSize,
      //     // height: imageSize,
      //     image: AppAssets.sampayBusiness,
      //     //title: "Sampay \nBusiness",
      //     onClick: () {
      //       context.push(
      //         AppRoutes.webview,
      //         extra: {
      //           'url': EcommerceConstants.sampayBusiness.link,
      //           //'title': EcommerceConstants.sampayBusiness.title,
      //         },
      //       );
      //     },
      //   ),
      //   SimpleImageTile(
      //     padding: EdgeInsets.all(0),
      //     // width: imageSize,
      //     // height: imageSize,
      //     image: AppAssets.payMerchant,
      //     //title: "Pay \nMerchant",
      //     onClick: () {
      //       context.push(AppRoutes.payMerchant);
      //     },
      //   ),
      //   SimpleImageTile(
      //     padding: EdgeInsets.all(0),
      //     // width: imageSize,
      //     // height: imageSize,
      //     image: AppAssets.scanQR,
      //     //title: "Scan \nQR",
      //     onClick: () {
      //       context.push(AppRoutes.qrCode);
      //     },
      //   ),
      // ]),
      child: Column(
        children: [
          SimpleFlex(
            children: [
              SimpleIconTile(
                image: AppAssets.sampayBusiness,
                iconSize: imageSize,
                width: tileWidth,
                height: tileWidth,
                padding: 0,
                titleWidget: SimpleAppText("Sampay \nBusiness", align: .center),
                bgColor: AppTheme.currentTheme.colorScheme.light,
                onClick: () {
                  context.push(
                    AppRoutes.webview,
                    extra: {
                      'url': EcommerceConstants.sampayBusiness.link,
                      'title': EcommerceConstants.sampayBusiness.title,
                    },
                  );
                },
                //borderColor: AppTheme.currentTheme.colorScheme.primary,
              ),
              SimpleIconTile(
                image: AppAssets.internationalTransfer,
                iconSize: imageSize,
                width: tileWidth,
                height: tileWidth,
                padding: 0,
                titleWidget: SimpleAppText(
                  "International \nPayments",
                  align: .center,
                ),
                bgColor: AppTheme.currentTheme.colorScheme.light,
                onClick: () {
                  context.push(AppRoutes.internationalPayments);
                },
              ),
            ],
          ),
          EmptySpace(height: 5),
          SimpleFlex(
            children: [
              SimpleIconTile(
                image: AppAssets.payMerchant,
                iconSize: imageSize,
                width: tileWidth,
                height: tileWidth,
                bgColor: AppTheme.currentTheme.colorScheme.light,
                padding: 0,
                titleWidget: SimpleAppText(
                  "Merchant \nPayments",
                  align: .center,
                ),
                onClick: () {
                  context.push(AppRoutes.payMerchant);
                },
                //borderColor: AppTheme.currentTheme.colorScheme.primary,
              ),
              SimpleIconTile(
                image: AppAssets.scanQR,
                iconSize: imageSize,
                width: tileWidth,
                height: tileWidth,
                bgColor: AppTheme.currentTheme.colorScheme.light,
                padding: 0,
                titleWidget: SimpleAppText("Scan \nQR", align: .center),
                onClick: () {
                  context.push(AppRoutes.qrCode);
                },
                //borderColor: AppTheme.currentTheme.colorScheme.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
