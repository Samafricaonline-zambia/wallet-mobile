import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/constants/shadows.dart';
import 'package:sampay_wallet/core/themes/color_constants.dart';
import 'package:sampay_wallet/core/widgets/simple_app_text.dart';

class SimpleTitleTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final AlignmentGeometry align;
  final bool isShadowed;
  final bool isBorderd;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const SimpleTitleTile(
    this.title, {
    super.key,
    this.align = Alignment.center,
    this.subTitle = "",
    this.isShadowed = false,
    this.isBorderd = true,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      alignment: subTitle.isEmpty ? align : Alignment.centerLeft,
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppConstants.AppTheme(context).white,
        borderRadius: BorderRadius.all(
          Radius.circular(AppConstants.STANDARD_BORDER_RADIUS),
        ),
        border: Border.all(
          color: AppConstants.AppTheme(context).light,
          width: isBorderd ? 3 : 0,
        ),
        boxShadow: isShadowed ? AppShadows.light : [],
      ),
      child: subTitle.isEmpty
          ? SimpleAppText.title(title, fontWeight: FontWeight.w900)
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SimpleAppText.title(title, fontWeight: FontWeight.w900),
                SimpleAppText.small(subTitle),
              ],
            ),
    );
  }
}
