import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sampay_wallet/core/constants/app_labels.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/constants/ecommerce_constants.dart';
import 'package:sampay_wallet/core/layouts/dashboard_layout.dart';
import 'package:sampay_wallet/core/routes/app_router.dart';
import 'package:sampay_wallet/core/widgets/simple_image_tile.dart';
import 'package:sampay_wallet/core/widgets/simple_image_tile_row.dart';
import 'package:sampay_wallet/core/widgets/simple_section_title.dart';

class EcommercePage extends StatelessWidget {
  const EcommercePage({super.key});

  @override
  Widget build(BuildContext context) {
    // final double totalHeight = AppUtils().getScreenHeight(context);
    // final double calculateHeight = totalHeight - ((totalHeight * 0.5) + 100);

    void handleClick(String url, String title) {
      if (url.isNotEmpty && title.isNotEmpty) {
        context.push(AppRoutes.webview, extra: {'url': url, 'title': title});
      } else {
        print("Error loading url");
      }
    }

    return DashboardLayout(
      selectedTabBarIndex: 3,
      child: Column(
        children: [
          SimpleSectionTitle(title: AppLabels.ECOMMERCE_PAGE_TITLE),
          SimpleImageTileRow(
            EcommerceConstants.ecommerceOptions
                .map(
                  (item) => SimpleImageTile(
                    image: item.image,
                    //title: item.title,
                    imageWidth: 80,
                    imageHeight: 80,
                    padding: EdgeInsets.only(top: 10),
                    onClick: () {
                      handleClick(
                        item.link ?? "https://samafricaonline.com",
                        item.title ?? "Samafricaonline",
                      );
                    },
                  ),
                )
                .toList(),
            itemsInRow: 3,
          ),
        ],
      ),
    );
  }
}
