import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/constants/decorations.dart';
import 'package:sampay_wallet/core/extensions/widget_extensions.dart';
import 'package:sampay_wallet/core/themes/color_constants.dart';
import 'package:sampay_wallet/core/widgets/empty_space.dart';
import 'package:sampay_wallet/core/widgets/simple_app_text.dart';

class SimpleIconInsetTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onClick;
  final double iconSize;
  final double padding;

  const SimpleIconInsetTile({
    super.key,
    required this.icon,
    this.title = "",
    this.onClick,
    this.iconSize = 50,
    this.padding = AppConstants.STANDARD_PAGE_PADDING,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        width: 90,
        child: Column(
          mainAxisAlignment: .center,
          crossAxisAlignment: .center,
          children: [
            Container(
              width: iconSize,
              height: iconSize,
              decoration: AppDecorations.primary(),
              child: Icon(icon, color: AppColors.white),
            ),
            EmptySpace(height: 5),
            SimpleAppText(title),
          ],
        ),
      ),
    ).onTap(onClick);
  }
}
