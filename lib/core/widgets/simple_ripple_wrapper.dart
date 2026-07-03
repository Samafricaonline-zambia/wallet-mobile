// lib/core/widgets/ripple_wrapper.dart
import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/themes/color_constants.dart';

class SimpleRippleWrapper extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? splashColor;
  final Color? highlightColor;
  final Color? borderColor;
  final double? borderRadius;
  final double? borderWidth;
  final EdgeInsets? padding;
  final double? width;
  final double? height;
  final List<BoxShadow>? shadow;

  const SimpleRippleWrapper({
    super.key,
    required this.child,
    this.onTap,
    this.backgroundColor,
    this.splashColor,
    this.borderColor,
    this.highlightColor,
    this.borderRadius,
    this.padding,
    this.borderWidth,
    this.height,
    this.width,
    this.shadow,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme appTheme = AppConstants.AppTheme(context);

    return Material(
      child: InkWell(
        onTap: () {
          if (onTap != null) {
            onTap!();
          }
        },
        splashColor: splashColor,
        highlightColor: highlightColor,
        borderRadius: BorderRadius.circular(
          AppConstants.STANDARD_BORDER_RADIUS,
        ), // Match container's border radius
        child: Ink(
          width: width,
          height: height,
          decoration: BoxDecoration(
            boxShadow: shadow,
            color: backgroundColor ?? appTheme.white,
            border: borderWidth != null
                ? Border.all(
                    width: borderWidth!,
                    color: borderColor ?? appTheme.light,
                  )
                : null,
            borderRadius: BorderRadius.circular(
              AppConstants.STANDARD_BORDER_RADIUS,
            ),
          ),
          padding:
              padding ?? EdgeInsets.all(AppConstants.STANDARD_PAGE_PADDING),
          child: child,
        ),
      ),
    );
  }
}
