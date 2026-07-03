import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/widgets/simple_app_text.dart';

class SimpleButtons extends StatelessWidget {
  final String title;
  final VoidCallback? onClick;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double fontSize;
  final bool isFullWidth;
  final bool isShadowed;
  final double? width;
  final double? borderRadius;
  final bool isLoading;

  const SimpleButtons(
    this.title, {
    super.key,
    this.onClick,
    this.backgroundColor,
    this.foregroundColor,
    this.fontSize = 18,
    this.isFullWidth = false,
    this.isShadowed = false,
    this.width,
    this.borderRadius,
    this.isLoading = false,
  });

  // Small button variant
  factory SimpleButtons.small(
    String title, {
    Key? key,
    VoidCallback? onClick,
    Color? backgroundColor,
    Color? foregroundColor,
    bool isFullWidth = false,
    bool isShadowed = false,
    bool isLoading = false,
  }) {
    return SimpleButtons(
      title,
      key: key,
      onClick: onClick,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      fontSize: 14,
      isFullWidth: isFullWidth,
      borderRadius: 8,
      isShadowed: isShadowed,
      isLoading: isLoading,
    );
  }

  // Medium button variant
  factory SimpleButtons.medium(
    String title, {
    Key? key,
    VoidCallback? onClick,
    Color? backgroundColor,
    Color? foregroundColor,
    bool isFullWidth = false,
    bool isShadowed = false,
    bool isLoading = false,
  }) {
    return SimpleButtons(
      title,
      key: key,
      onClick: onClick,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      fontSize: 16,
      isFullWidth: isFullWidth,
      borderRadius: 8,
      isShadowed: isShadowed,
      isLoading: isLoading,
    );
  }

  // Large button variant
  factory SimpleButtons.large(
    String title, {
    Key? key,
    VoidCallback? onClick,
    Color? backgroundColor,
    Color? foregroundColor,
    bool isFullWidth = false,
    bool isShadowed = false,
    bool isLoading = false,
  }) {
    return SimpleButtons(
      title,
      key: key,
      onClick: onClick,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      fontSize: 18,
      isFullWidth: isFullWidth,
      borderRadius: 10,
      isShadowed: isShadowed,
      isLoading: isLoading,
    );
  }

  // Full width button variant (always takes full width)
  factory SimpleButtons.fullWidth(
    String title, {
    Key? key,
    VoidCallback? onClick,
    Color? backgroundColor,
    Color? foregroundColor,
    double fontSize = 18,
    bool isShadowed = false,
    bool isLoading = false,
  }) {
    return SimpleButtons(
      title,
      key: key,
      onClick: onClick,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      fontSize: fontSize,
      isFullWidth: true,
      borderRadius: 10,
      isShadowed: isShadowed,
      isLoading: isLoading,
    );
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context).colorScheme;

    return ElevatedButton(
      onPressed: isLoading ? null : onClick,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? appTheme.primary,
        foregroundColor: foregroundColor ?? appTheme.onPrimary,
        elevation: isShadowed ? 5 : 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 10),
        ),
        minimumSize: isFullWidth
            ? const Size(double.infinity, 0)
            : (width != null ? Size(width!, 0) : null),
      ),
      child: isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  foregroundColor ?? appTheme.onPrimary,
                ),
              ),
            )
          : SimpleAppText(title, fontSize: fontSize),
    );
  }
}
