import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sampay_wallet/core/constants/app_icons.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/layouts/options_layout.dart';
import 'package:sampay_wallet/core/routes/app_router.dart';
import 'package:sampay_wallet/core/services/configure_dependencies.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/core/utils/dialog_utils.dart';
import 'package:sampay_wallet/core/widgets/empty_space.dart';
import 'package:sampay_wallet/core/widgets/simple_app_text.dart';
import 'package:sampay_wallet/core/widgets/simple_icon_tile.dart';
import 'package:sampay_wallet/core/widgets/simple_section_title.dart';
import 'package:sampay_wallet/features/scan-qr/models/qr_model.dart';
import 'package:sampay_wallet/features/scan-qr/services/qr_service.dart';

class QRPage extends StatelessWidget {
  final QrService qrService = getIt<QrService>();
  QRPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme appTheme = AppConstants.AppTheme(context);
    final double screenWidth = AppUtils().getScreenWidth(context);

    return OptionsLayout(
      title: "QR Code",
      pageTitle: "QR Code",
      pageDescription:
          "Create a QR Code for easily recieving payment from other Sampay user. Scan Sampay QR to transfer payment to someone.",
      child: Column(
        children: [
          SimpleSectionTitle(title: "Recieve Payment"),
          SimpleIconTile(
            icon: AppIcons.generateQR,
            titleWidget: SimpleAppText.title(
              "Create QR Code",
              fontWeight: FontWeight.w700,
              color: appTheme.primary,
            ),
            iconSize: 80,
            isBordered: true,
            width: screenWidth * 0.6,
            description: "Generate a QR code to recieve payments",
            onClick: () {
              qrService.resetQRCode();
              context.push(AppRoutes.generateQR);
            },
          ),
          EmptySpace(),
          SimpleSectionTitle(title: "Transfer Payment"),
          SimpleIconTile(
            icon: AppIcons.scanQR,
            titleWidget: SimpleAppText.title(
              "Scan QR Code",
              fontWeight: FontWeight.w700,
              color: appTheme.primary,
            ),
            iconSize: 80,
            isBordered: true,
            width: screenWidth * 0.6,
            description: "Scan a QR code to transfer payments",
            onClick: () {
              context.push(AppRoutes.scanQR);
            },
          ),
        ],
      ),
    );
  }
}
