import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/extensions/widget_extensions.dart';
import 'package:sampay_wallet/core/themes/color_constants.dart';
import 'package:sampay_wallet/core/widgets/empty_space.dart';
import 'package:sampay_wallet/core/widgets/simple_app_text.dart';
import 'package:sampay_wallet/core/widgets/simple_ripple_wrapper.dart';

class SimpleBottomMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onClick;
  final bool isSelected;
  const SimpleBottomMenuItem({
    super.key,
    required this.icon,
    required this.label,
    this.isSelected = false,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme appTheme = AppConstants.AppTheme(context);

    if (isSelected) {
      return Expanded(
        child: FloatingActionButton(
          onPressed: () {},
          child: Row(
            children: [
              Icon(icon, color: appTheme.white),
              EmptySpace.horizontalSmall(),
              SimpleAppText.small(label, color: appTheme.tertiary),
            ],
          ),
        ),
      ).onTap(onClick);
    }

    return Expanded(child: Icon(icon, color: appTheme.tertiary)).onTap(onClick);
  }
}
