import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/decorations.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';

class DefaultBottomSheet extends StatelessWidget {
  final double? height;
  final Widget? child;
  const DefaultBottomSheet({super.key, this.height, this.child});

  @override
  Widget build(BuildContext context) {
    Widget createChild() {
      return Container(
        padding: EdgeInsets.only(
          bottom: AppUtils().isKeyboardOpen(context)
              ? AppUtils().getKeyboardHeight(context)
              : 0,
        ),
        width: AppUtils().getScreenWidth(context),
        height: height,
        decoration: AppDecorations.white(),
        child: SingleChildScrollView(child: child),
      );
    }

    return createChild();
  }
}
