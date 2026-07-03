import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/core/widgets/simple_image_tile.dart';

class SimpleImageTileRow extends StatelessWidget {
  final List<SimpleImageTile> children;
  final int itemsInRow;
  const SimpleImageTileRow(this.children, {super.key, this.itemsInRow = 2});

  @override
  Widget build(BuildContext context) {
    final double totalWidth = AppUtils().getScreenWidth(context);

    return SizedBox(
      width: totalWidth,
      child: Wrap(
        runSpacing: 10,
        spacing: 10,
        children: children.map((child) {
          return child.copyWith(rowCount: itemsInRow);
        }).toList(),
      ),
    );
  }
}
