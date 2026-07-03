import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/themes/color_constants.dart';

class SimpleCard extends StatelessWidget {
  final Widget child;
  final double padding;
  final Color? bgColor;
  const SimpleCard({
    super.key,
    required this.child,
    this.padding = AppConstants.STANDARD_PAGE_PADDING,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme appTheme = AppConstants.AppTheme(context);

    return IntrinsicHeight(
      child: Container(
        decoration: BoxDecoration(
          color: bgColor ?? appTheme.white,
          borderRadius: BorderRadius.all(
            Radius.circular(AppConstants.STANDARD_BORDER_RADIUS),
          ),
        ),
        padding: EdgeInsetsGeometry.all(padding),
        child: child,
      ),
    );
  }
}
