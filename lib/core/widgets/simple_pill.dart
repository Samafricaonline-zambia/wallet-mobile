import 'package:animated_pill/animated_pill.dart';
import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/themes/color_constants.dart';

class SimplePill extends StatelessWidget {
  final String text;
  final Color? bgColor;
  final Color? color;
  final double fontSize;
  final bool isAnimated;

  const SimplePill(
    this.text, {
    super.key,
    this.bgColor,
    this.color,
    this.fontSize = 12,
    this.isAnimated = true,
  });

  // Error variant
  factory SimplePill.error(
    String text, {
    double fontSize = 12,
    bool isAnimated = true,
  }) {
    return SimplePill(
      text,
      bgColor: AppColors.lightError,
      color: AppColors.error,
      fontSize: fontSize,
      isAnimated: isAnimated,
    );
  }

  // Warning variant
  factory SimplePill.warning(
    String text, {
    double fontSize = 12,
    bool isAnimated = true,
  }) {
    return SimplePill(
      text,
      bgColor: AppColors.lightWarning,
      color: AppColors.error,
      fontSize: fontSize,
      isAnimated: isAnimated,
    );
  }

  // Success variant
  factory SimplePill.success(
    String text, {
    double fontSize = 12,
    bool isAnimated = true,
  }) {
    return SimplePill(
      text,
      bgColor: AppColors.lightSuccess,
      color: AppColors.success,
      fontSize: fontSize,
      isAnimated: isAnimated,
    );
  }

  // Info variant
  factory SimplePill.info(
    String text, {
    double fontSize = 12,
    bool isAnimated = true,
  }) {
    return SimplePill(
      text,
      bgColor: AppColors.lightInfo,
      color: AppColors.info,
      fontSize: fontSize,
      isAnimated: isAnimated,
    );
  }

  // Neutral/default variant
  factory SimplePill.neutral(
    String text, {
    double fontSize = 12,
    bool isAnimated = true,
  }) {
    return SimplePill(
      text,
      bgColor: AppColors.lightGrey,
      color: AppColors.black,
      fontSize: fontSize,
      isAnimated: isAnimated,
    );
  }

  // Dark variant
  factory SimplePill.dark(
    String text, {
    double fontSize = 12,
    bool isAnimated = true,
  }) {
    return SimplePill(
      text,
      bgColor: AppColors.dark,
      color: AppColors.white,
      fontSize: fontSize,
      isAnimated: isAnimated,
    );
  }

  // Primary variant
  factory SimplePill.primary(
    String text, {
    double fontSize = 12,
    bool isAnimated = true,
  }) {
    return SimplePill(
      text,
      bgColor: AppColors.kPrimary,
      color: AppColors.white,
      fontSize: fontSize,
      isAnimated: isAnimated,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme appTheme = AppConstants.AppTheme(context);

    final backgroundColor = bgColor ?? appTheme.light;
    final textColor = color ?? appTheme.onLight;

    if (isAnimated) {
      return AnimatedPill(
        text,
        animationLoops: 1,
        fontSize: fontSize,
        backgroundColor: backgroundColor,
        textColor: textColor,
      );
    }

    // Static version without animation
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
