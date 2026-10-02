import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/themes/color_constants.dart';
import 'package:sampay_wallet/core/widgets/simple_pill.dart';
import 'package:sampay_wallet/core/widgets/simple_ripple_wrapper.dart';

/// A horizontally scrollable row of pills.
///
/// When [onSelect] is provided the pills become selectable: the pill at
/// [selectedIndex] is highlighted using the theme primary color, and tapping
/// a pill invokes [onSelect] with its index.
class SimplePillScroll extends StatelessWidget {
  final List<String> items;
  final int selectedIndex;
  final Function(int index)? onSelect;
  final EdgeInsetsGeometry padding;
  final double spacing;
  final double fontSize;

  const SimplePillScroll(
    this.items, {
    super.key,
    this.selectedIndex = -1,
    this.onSelect,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppConstants.STANDARD_PAGE_PADDING,
    ),
    this.spacing = 8,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme appTheme = AppConstants.AppTheme(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: padding,
      child: Row(
        children: List.generate(items.length, (index) {
          final bool isSelected = index == selectedIndex;

          final Widget pill = SimplePill(
            items[index],
            bgColor: isSelected ? appTheme.primary : appTheme.light,
            color: isSelected ? appTheme.white : appTheme.onLight,
            fontSize: fontSize,
          );

          if (onSelect == null) {
            return Padding(
              padding: EdgeInsets.only(right: spacing),
              child: pill,
            );
          }

          return Padding(
            padding: EdgeInsets.only(right: spacing),
            child: SimpleRippleWrapper(
              borderRadius: AppColors.radiusFull,
              padding: EdgeInsets.zero,
              onTap: () => onSelect!(index),
              child: pill,
            ),
          );
        }),
      ),
    );
  }
}
