import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/widgets/simple_app_text.dart';
import 'package:sampay_wallet/core/widgets/simple_divider.dart';

class SimpleFlex extends StatelessWidget {
  final Widget? leftChild;
  final Widget? rightChild;
  final MainAxisAlignment? alignment;
  final bool? isWithDivider;
  final List<Widget>? children;

  const SimpleFlex({
    super.key,
    this.leftChild,
    this.rightChild,
    this.alignment,
    this.children,
    this.isWithDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget createChild() {
      return Row(
        mainAxisAlignment: alignment ?? MainAxisAlignment.spaceBetween,
        children:
            children ??
            [leftChild ?? SimpleAppText(""), rightChild ?? SimpleAppText("")],
      );
    }

    if (isWithDivider == true) {
      return Column(children: children ?? [createChild(), SimpleDivider()]);
    }

    return createChild();
  }
}
