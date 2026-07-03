import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sampay_wallet/core/constants/assets.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/layouts/dashboard_layout.dart';
import 'package:sampay_wallet/core/models/bill_merchant_model.dart';
import 'package:sampay_wallet/core/routes/app_router.dart';
import 'package:sampay_wallet/core/services/configure_dependencies.dart';
import 'package:sampay_wallet/core/utils/dialog_utils.dart';
import 'package:sampay_wallet/core/widgets/empty_space.dart';
import 'package:sampay_wallet/core/widgets/simple_image_tile.dart';
import 'package:sampay_wallet/core/widgets/simple_image_tile_row.dart';
import 'package:sampay_wallet/core/widgets/simple_section_title.dart';
import 'package:sampay_wallet/core/widgets/simple_toast.dart';
import 'package:sampay_wallet/features/bills/services/bills_service.dart';
import 'package:sampay_wallet/features/bills/widgets/electricity_options.dart';

class BillsPage extends StatelessWidget {
  final BillsService billsService = getIt<BillsService>();
  BillsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
    final double iconSize = 50;

    void handleElectricityClick(String merchantName) {
      DialogUtils().openModalDialog(
        context,
        ElectricityOptions(
          onOptionClick: (index) async {
            if (context.mounted) {
              context.pop();
            }
            if (index == 1) {
              final value = await billsService.fetchZescoTokens();
              print(value.toJson());
              if (context.mounted) {
                if (value.status) {
                  context.push(AppRoutes.electricityTokens);
                } else {
                  SimpleToast.showErrorToast(
                    "Error loading tokens purchase history",
                    context,
                  );
                }
              }
            } else {
              context.push(AppRoutes.billPayment);
            }
          },
        ),
        title: merchantName,
      );
    }

    void handleBillsClick(BillMerchants merchant, String image, String title) {
      BillMerchantModel selectedMerchant = BillMerchantModel.fromBillMerchant(
        merchant,
      );
      billsService.setSelectedBillMerchant(selectedMerchant);
      if (context.mounted &&
          selectedMerchant.merchantType == BillMerchantType.electricity) {
        handleElectricityClick(selectedMerchant.name);
      } else {
        context.push(AppRoutes.billPayment);
      }
    }

    return DashboardLayout(
      selectedTabBarIndex: 1,
      child: Column(
        children: [
          SimpleSectionTitle(title: "Buy Airtime"),
          SimpleImageTileRow([
            SimpleImageTile(
              image: AppAssets.airtel,
              imageWidth: iconSize,
              imageHeight: iconSize,
              onClick: () {
                handleBillsClick(
                  BillMerchants.airtel,
                  AppAssets.airtel,
                  "Buy Airtel Airtime",
                );
              },
              //title: "International \nTransfer",
            ),
            SimpleImageTile(
              image: AppAssets.mtn,
              imageWidth: iconSize,
              imageHeight: iconSize,
              onClick: () {
                handleBillsClick(
                  BillMerchants.mtn,
                  AppAssets.mtn,
                  "Buy MTN Airtime",
                );
              },
              //title: "Sampay \nBusiness",
            ),
            SimpleImageTile(
              image: AppAssets.zamtel,
              imageWidth: iconSize,
              imageHeight: iconSize,
              onClick: () {
                handleBillsClick(
                  BillMerchants.zamtel,
                  AppAssets.zamtel,
                  "Buy Zamtel Airtime",
                );
              },
              //title: "Sampay \nBusiness",
            ),
          ], itemsInRow: 3),
          SimpleSectionTitle(title: "Pay for Cable TV"),
          SimpleImageTileRow([
            SimpleImageTile(
              image: AppAssets.dstv,
              imageWidth: iconSize,
              imageHeight: iconSize,
              onClick: () {
                handleBillsClick(
                  BillMerchants.dstv,
                  AppAssets.dstv,
                  "Make payments for cable TV",
                );
              },
              //title: "International \nTransfer",
            ),
            SimpleImageTile(
              image: AppAssets.boxOffice,
              imageWidth: iconSize,
              imageHeight: iconSize,
              onClick: () {
                handleBillsClick(
                  BillMerchants.boxOffice,
                  AppAssets.boxOffice,
                  "Make payments for cable TV",
                );
              },
              //title: "Sampay \nBusiness",
            ),
            SimpleImageTile(
              image: AppAssets.gotv,
              imageWidth: iconSize,
              imageHeight: iconSize,
              onClick: () {
                handleBillsClick(
                  BillMerchants.gotv,
                  AppAssets.gotv,
                  "Make payments for cable TV",
                );
              },
              //title: "Sampay \nBusiness",
            ),
          ], itemsInRow: 3),
          EmptySpace.small(),
          SimpleImageTileRow([
            SimpleImageTile(
              image: AppAssets.topStar,
              imageWidth: iconSize,
              imageHeight: iconSize,
              onClick: () {
                handleBillsClick(
                  BillMerchants.topStar,
                  AppAssets.topStar,
                  "Make payments for cable TV",
                );
              },
              //title: "International \nTransfer",
            ),
          ], itemsInRow: 3),
          SimpleSectionTitle(title: "Buy Electricity"),
          SimpleImageTileRow([
            SimpleImageTile(
              image: AppAssets.zesco,
              imageWidth: iconSize,
              imageHeight: iconSize,
              onClick: () {
                handleBillsClick(
                  BillMerchants.zesco,
                  AppAssets.zesco,
                  "Buy Zesco Tokens",
                );
              },
              //title: "International \nTransfer",
            ),
          ], itemsInRow: 3),
          SimpleSectionTitle(title: "Buy Data"),
          SimpleImageTileRow([
            SimpleImageTile(
              image: AppAssets.liquid,
              imageWidth: iconSize,
              imageHeight: iconSize,
              // onClick: () {
              //   handleBillsClick(
              //     BillMerchants.liquid,
              //     AppAssets.liquid,
              //     "Buy Data",
              //   );
              // },
              //title: "International \nTransfer",
            ),
          ], itemsInRow: 3),
        ],
      ),
    );
  }
}
