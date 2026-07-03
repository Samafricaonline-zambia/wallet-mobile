// extensions/widget_extensions.dart
import 'package:flutter/material.dart';

extension WidgetExtension on Widget {
  Widget onTap(VoidCallback? onTap, {bool showRippleEffect = false}) {
    if (onTap == null) return this;

    if (showRippleEffect) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: this,
      );
    }

    return GestureDetector(onTap: onTap, child: this);
  }

  Widget maxWidth(double value) {
    return SizedBox(width: value, child: this);
  }

  Widget maxHeight(double value) {
    return SizedBox(height: value, child: this);
  }

  Widget maxSize(double height, double width) {
    return SizedBox(height: height, width: width, child: this);
  }
}
