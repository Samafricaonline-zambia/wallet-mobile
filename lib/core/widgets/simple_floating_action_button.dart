import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/constants/shadows.dart';
import 'package:sampay_wallet/core/extensions/widget_extensions.dart';
import 'package:sampay_wallet/core/themes/color_constants.dart';
import 'package:sampay_wallet/core/themes/theme_extensions.dart';

class SimpleFloatingActionButton extends StatelessWidget {
  final VoidCallback? onClick;
  final Widget? child;
  final IconData? icon;
  final double? iconSize;

  const SimpleFloatingActionButton({
    super.key,
    this.onClick,
    this.child,
    this.icon,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return WidgetExtension(
      Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          color: AppConstants.AppTheme(context).white,
          boxShadow: AppShadows.normal,
        ),
        child:
            child ??
            Icon(
              icon ?? Icons.chevron_left,
              color: AppConstants.AppTheme(context).primary,
              size: iconSize,
            ),
      ),
    ).onTap(() {
      if (onClick != null) {
        onClick!();
      } else if (context.canPop()) {
        context.pop();
      }
    });
  }
}
