import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/app_icons.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/widgets/simple_image_tile.dart';
import 'package:sampay_wallet/core/widgets/simple_image_tile_row.dart';

class ReportsTab extends StatelessWidget {
  final int selectedTabIndex;
  final Function(int tabIndex)? onTabChange;

  const ReportsTab({super.key, this.selectedTabIndex = 0, this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return SimpleImageTileRow(
      List.generate(AppConstants.REPORT_TABS.length, (index) {
        return SimpleImageTile(
          title: AppConstants.REPORT_TABS[index].title,
          icon: AppConstants.REPORT_TABS[index].icon,
          isSelected: index == selectedTabIndex,
          isHorizontalLayout: true,
          padding: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
          onClick: () {
            if (onTabChange != null) {
              onTabChange!(index);
            }
          },
        );
      }),
      itemsInRow: 2,
    );
  }
}
