import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/app_icons.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/themes/app_theme.dart';
import 'package:sampay_wallet/core/themes/color_constants.dart';
import 'package:sampay_wallet/core/widgets/empty_space.dart';
import 'package:sampay_wallet/core/widgets/simple_app_text.dart';
import 'package:sampay_wallet/core/widgets/simple_image_card.dart';
import 'package:sampay_wallet/core/widgets/simple_ripple_wrapper.dart';

class SimpleIconTile extends StatelessWidget {
  final IconData? icon;
  final String image;
  final String title;
  final String description;
  final bool isBordered;
  final double iconSize;
  final double? width;
  final double? height;
  final double padding;
  final Function()? onClick;
  final Widget? titleWidget;
  final Widget? descriptionWidget;
  final Color? bgColor;

  const SimpleIconTile({
    super.key,
    this.icon,
    this.image = "",
    this.title = "",
    this.onClick,
    this.iconSize = 50,
    this.isBordered = false,
    this.padding = AppConstants.STANDARD_PAGE_PADDING,
    this.height,
    this.width,
    this.titleWidget,
    this.description = "",
    this.descriptionWidget,
    this.bgColor = AppColors.white,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme appTheme = AppConstants.AppTheme(context);

    Widget createTitleChild() {
      if (titleWidget != null) return titleWidget!;

      if (title.isEmpty) return const EmptySpace(height: 0);

      return SimpleAppText(
        title,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        shouldWrap: false,
      );
    }

    Widget createDescriptionChild() {
      if (descriptionWidget != null) return descriptionWidget!;

      if (description.isEmpty) return const EmptySpace(height: 0);

      return SimpleAppText.small(description, align: .center);
    }

    return SimpleRippleWrapper(
      onTap: onClick,
      backgroundColor: bgColor,
      borderRadius: AppConstants.STANDARD_BORDER_RADIUS,
      borderWidth: isBordered ? 1 : 0,
      borderColor: isBordered ? appTheme.primary : null,
      padding: EdgeInsets.all(padding),
      width: width,
      height: height,
      child: Column(
        mainAxisAlignment: .center,
        crossAxisAlignment: .center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            Icon(
              icon ?? AppIcons.home,
              size: iconSize,
              color: appTheme.primary,
            ),
          if (image.isNotEmpty)
            Image(
              image: AssetImage(image),
              width: iconSize,
              height: iconSize,
              fit: .contain,
            ),
          createTitleChild(),
          if (title.isNotEmpty ||
              description.isNotEmpty ||
              titleWidget != null ||
              descriptionWidget != null)
            EmptySpace.small(),
          createDescriptionChild(),
        ],
      ),
    );
  }
}
