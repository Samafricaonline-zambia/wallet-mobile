import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/themes/app_theme.dart';
import 'package:sampay_wallet/core/themes/color_constants.dart';
import 'package:sampay_wallet/core/widgets/simple_app_text.dart';

class SimpleAlert extends StatelessWidget {
  final Color? bgColor;
  final Color? color;
  final String message;
  final double? fontSize;
  final FontWeight? fontWeight;

  const SimpleAlert(
    this.message, {
    super.key,
    this.bgColor,
    this.color,
    this.fontSize,
    this.fontWeight,
  });

  factory SimpleAlert.error(
    String message, {
    double? fontSize,
    FontWeight? fontWeight,
  }) {
    return SimpleAlert(
      message,
      bgColor: AppColors.lightError,
      color: AppColors.kPrimary,
      fontSize: fontSize,
      fontWeight: fontWeight,
    );
  }

  factory SimpleAlert.warning(
    String message, {
    double? fontSize,
    FontWeight? fontWeight,
  }) {
    return SimpleAlert(
      message,
      bgColor: AppColors.lightWarning,
      color: AppColors.error,
      fontSize: fontSize,
      fontWeight: fontWeight,
    );
  }

  factory SimpleAlert.success(
    String message, {
    double? fontSize,
    FontWeight? fontWeight,
  }) {
    return SimpleAlert(
      message,
      bgColor: AppColors.lightSuccess,
      color: AppColors.success,
      fontSize: fontSize,
      fontWeight: fontWeight,
    );
  }

  factory SimpleAlert.info(
    String message, {
    double? fontSize,
    FontWeight? fontWeight,
  }) {
    return SimpleAlert(
      message,
      bgColor: AppColors.lightInfo,
      color: AppColors.info,
      fontSize: fontSize,
      fontWeight: fontWeight,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = AppTheme.currentTheme.colorScheme;

    // Determine colors based on variant
    Color backgroundColor = bgColor ?? colorScheme.surface;
    Color textColor = color ?? AppColors.white;
    IconData icon = Icons.info_outline;

    return Card(
      color: backgroundColor,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(icon, color: textColor, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: SimpleAppText(
                message,
                color: textColor,
                fontSize: fontSize,
                fontWeight: fontWeight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
