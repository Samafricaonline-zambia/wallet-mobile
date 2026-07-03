// lib/core/widgets/simple_avatar.dart
import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/themes/color_constants.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/core/widgets/simple_app_text.dart';

class SimpleAvatar extends StatelessWidget {
  final String? imagePath;
  final String? userName;
  final double radius;
  final double fontSize;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback? onTap;

  const SimpleAvatar({
    super.key,
    this.imagePath,
    this.userName,
    this.radius = 40,
    this.fontSize = 18,
    this.backgroundColor,
    this.textColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme appTheme = AppConstants.AppTheme(context);
    final bgColor = backgroundColor ?? appTheme.primary;

    final Widget avatar = Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: bgColor.withAlpha(100),
          width: 5, // Thickness of the outer circle
        ),
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: bgColor,
        backgroundImage: imagePath != null && imagePath!.isNotEmpty
            ? AssetImage(imagePath!)
            : null,
        child: imagePath == null || imagePath!.isEmpty
            ? SimpleAppText(
                AppUtils().getNameInitials(userName ?? ""),
                fontWeight: FontWeight.w900,
                fontSize: 24,
                color: appTheme.white,
              )
            : null,
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: avatar,
      );
    }

    return avatar;
  }
}
