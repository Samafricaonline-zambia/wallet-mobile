import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/extensions/widget_extensions.dart';
import 'package:sampay_wallet/core/widgets/simple_app_text.dart';

class SimpleResendCounter extends StatefulWidget {
  final int seconds;
  final String resendLabel;
  final VoidCallback? onResendClick;

  const SimpleResendCounter({
    super.key,
    this.seconds = 30,
    this.resendLabel = "Resend",
    this.onResendClick,
  });

  @override
  State<SimpleResendCounter> createState() => _SimpleResendCounterState();
}

class _SimpleResendCounterState extends State<SimpleResendCounter> {
  late int remainingTime = 30;

  void updateRemainingTime() {
    if (remainingTime > 0) {
      setState(() {
        remainingTime--;
      });
      Future.delayed(Duration(seconds: 1), () => updateRemainingTime());
    }
  }

  @override
  void initState() {
    super.initState();

    remainingTime = widget.seconds;
    updateRemainingTime();
  }

  @override
  void dispose() {
    remainingTime = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context).colorScheme;

    return remainingTime > 0
        ? SimpleAppText.small("Resend in ${remainingTime.toString()} seconds")
        : SimpleAppText.small(
            widget.resendLabel,
            color: appTheme.primary,
          ).onTap(() {
            setState(() {
              remainingTime = widget.seconds;
            });
            updateRemainingTime();

            if (widget.onResendClick != null) widget.onResendClick!();
          });
  }
}
