import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/constants/shadows.dart';
import 'package:sampay_wallet/core/themes/color_constants.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/core/widgets/empty_space.dart';
import 'package:sampay_wallet/core/widgets/simple_app_text.dart';
import 'package:sampay_wallet/core/widgets/simple_ripple_wrapper.dart';

class SimpleImageTile extends StatelessWidget {
  final IconData? icon;
  final String? image;
  final String? title;
  final double? width;
  final double? height;
  final double? imageWidth;
  final double? imageHeight;
  final Function()? onClick;
  final int rowCount;
  final bool isSelected;
  final bool isHorizontalLayout;
  final EdgeInsets? padding;

  const SimpleImageTile({
    super.key,
    this.icon,
    this.image,
    this.title,
    this.onClick,
    this.height,
    this.width,
    this.imageHeight,
    this.imageWidth,
    this.rowCount = 2,
    this.isSelected = false,
    this.isHorizontalLayout = false,
    this.padding,
  });

  SimpleImageTile copyWith({
    String? image,
    IconData? icon,
    String? title,
    double? width,
    double? height,
    double? imageWidth,
    double? imageHeight,
    Function()? onClick,
    int? rowCount,
    bool? isSelected,
    bool? isHorizontalLayout,
    EdgeInsets? padding,
  }) {
    return SimpleImageTile(
      image: image ?? this.image,
      icon: icon ?? this.icon,
      title: title ?? this.title,
      width: width ?? this.width,
      height: height ?? this.height,
      imageWidth: imageWidth ?? this.imageWidth,
      imageHeight: imageHeight ?? this.imageHeight,
      onClick: onClick ?? this.onClick,
      rowCount: rowCount ?? this.rowCount,
      isSelected: isSelected ?? this.isSelected,
      isHorizontalLayout: isHorizontalLayout ?? this.isHorizontalLayout,
      padding: padding ?? this.padding,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme appTheme = AppConstants.AppTheme(context);
    final double totalWidth =
        AppUtils().getScreenWidth(context) -
        (AppConstants.STANDARD_PAGE_PADDING * (rowCount + 1));

    Widget createChild() {
      if (isHorizontalLayout) {
        return Row(
          mainAxisAlignment: .center,
          crossAxisAlignment: .center,
          children: [
            if (icon != null) Icon(icon, color: appTheme.onLight),
            if (image != null)
              Image(
                image: AssetImage(image ?? ""),
                width: imageWidth ?? 100,
                height: imageHeight ?? 100,
                fit: BoxFit.contain,
              ),
            const EmptySpace(width: 10),
            if (title != null)
              SimpleAppText(
                title ?? "",
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                align: TextAlign.center,
                color: appTheme.onLight,
              ),
          ],
        );
      }

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) Icon(icon, color: appTheme.onLight),
          if (image != null)
            Image(
              image: AssetImage(image ?? ""),
              width: imageWidth ?? 100,
              height: imageHeight ?? 100,
              fit: BoxFit.contain,
            ),
          const EmptySpace(height: 10),
          if (title != null)
            SimpleAppText(
              title ?? "",
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
              align: TextAlign.center,
              color: appTheme.onLight,
              shouldWrap: false,
            ),
        ],
      );
    }

    Color getBGColor() {
      if (isSelected) return appTheme.grey.withAlpha(30);

      if (onClick == null) return appTheme.grey;

      return appTheme.light;
    }

    return SimpleRippleWrapper(
      onTap: onClick,
      height: height,
      width: width ?? (totalWidth / rowCount),
      borderWidth: 1,
      borderColor: isSelected ? appTheme.primary : appTheme.light,
      // backgroundColor: isSelected
      //     ? appTheme.grey.withAlpha(30)
      //     : appTheme.white,
      backgroundColor: getBGColor(),
      borderRadius: AppConstants.STANDARD_BORDER_RADIUS,
      padding: padding ?? EdgeInsets.all(AppConstants.STANDARD_PAGE_PADDING),
      child: createChild(),
    );
  }
}
