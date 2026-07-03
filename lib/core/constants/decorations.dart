import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/themes/color_constants.dart';

class AppDecorations {
  static BoxDecoration white({List<BoxShadow>? shadow}) => BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.circular(AppConstants.STANDARD_BORDER_RADIUS),
    boxShadow: shadow,
  );

  static BoxDecoration primary({List<BoxShadow>? shadow}) => BoxDecoration(
    color: AppColors.kPrimary,
    borderRadius: BorderRadius.circular(AppConstants.STANDARD_BORDER_RADIUS),
    boxShadow: shadow,
  );

  static BoxDecoration secondary({List<BoxShadow>? shadow}) => BoxDecoration(
    color: AppColors.kSecondary,
    borderRadius: BorderRadius.circular(AppConstants.STANDARD_BORDER_RADIUS),
    boxShadow: shadow,
  );

  static BoxDecoration tertiary({List<BoxShadow>? shadow}) => BoxDecoration(
    color: AppColors.kTertiary,
    borderRadius: BorderRadius.circular(AppConstants.STANDARD_BORDER_RADIUS),
    boxShadow: shadow,
  );

  static BoxDecoration color(Color color, {List<BoxShadow>? shadow}) =>
      BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(
          AppConstants.STANDARD_BORDER_RADIUS,
        ),
        boxShadow: shadow,
      );
}
