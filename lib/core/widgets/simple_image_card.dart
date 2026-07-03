import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/app_icons.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/constants/shadows.dart';
import 'package:sampay_wallet/core/themes/color_constants.dart';
import 'package:sampay_wallet/core/widgets/empty_space.dart';

class SimpleImageCard extends StatelessWidget {
  final String? image;
  final IconData? icon;
  final Color? bgColor;
  final double height;
  final double width;
  final Color? color;
  final double? iconSize;
  final Color? borderColor;
  final bool isDisabled;
  final bool isShadowed;

  const SimpleImageCard({
    super.key,
    this.icon,
    this.image,
    this.bgColor,
    this.color,
    this.height = 50,
    this.width = 50,
    this.iconSize,
    this.borderColor,
    this.isDisabled = false,
    this.isShadowed = false,
  });

  Widget? createChild() {
    if (icon != null) {
      return Icon(icon, color: color, size: iconSize);
    }

    if (image != null) {
      if (isDisabled) {
        return FadeTransition(
          opacity: isDisabled
              ? const AlwaysStoppedAnimation(0.3)
              : const AlwaysStoppedAnimation(1.0),
          child: Image(
            image: AssetImage(image!),
            width: iconSize,
            height: iconSize,
          ),
        );
      }

      return Image(
        image: AssetImage(image!),
        width: iconSize,
        height: iconSize,
      );
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: isDisabled ? AppColors.grey : (bgColor ?? AppColors.light),
        borderRadius: BorderRadius.circular(15),
        border: borderColor != null && !isDisabled
            ? Border.all(width: 1, color: borderColor!)
            : null,
        boxShadow: isShadowed ? AppShadows.deep : null,
      ),
      child: iconSize != null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [createChild() ?? EmptySpace()],
            )
          : createChild(),
    );
  }
}
