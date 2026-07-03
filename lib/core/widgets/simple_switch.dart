import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/extensions/widget_extensions.dart';
import 'package:sampay_wallet/core/themes/color_constants.dart';
import 'package:sampay_wallet/core/widgets/simple_app_text.dart';
import 'package:sampay_wallet/core/widgets/simple_flex.dart';

class SimpleSwitch<T> extends StatefulWidget {
  final T yesValue;
  final T noValue;
  final String title;
  final Function(T value)? onChange;
  const SimpleSwitch({
    super.key,
    required this.yesValue,
    required this.noValue,
    this.onChange,
    this.title = "",
  });

  @override
  State<SimpleSwitch<T>> createState() => _SimpleSwitchState<T>();
}

class _SimpleSwitchState<T> extends State<SimpleSwitch<T>> {
  bool switchValue = false;

  void setSwitchValue(bool value) {
    setState(() {
      switchValue = value;
      widget.onChange?.call(value ? widget.yesValue : widget.noValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme appTheme = AppConstants.AppTheme(context);

    return SimpleFlex(
      leftChild: SimpleAppText(
        widget.title,
        fontWeight: switchValue == widget.yesValue ? FontWeight.w900 : null,
      ).onTap(() => setSwitchValue(!switchValue)),
      rightChild: Switch(
        value: switchValue,
        onChanged: setSwitchValue,
        activeThumbColor: appTheme.success,
        activeTrackColor: appTheme.lightSuccess,
      ),
    );
  }
}
