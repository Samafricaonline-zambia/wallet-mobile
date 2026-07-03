import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';

class EmptySpace extends StatelessWidget {
  final double? height;
  final double? width;

  const EmptySpace({super.key, this.height = 30, this.width = 30});

  factory EmptySpace.none() => EmptySpace(height: 0, width: 0);
  factory EmptySpace.small() => EmptySpace(height: 10);
  factory EmptySpace.large() => EmptySpace(height: 50);
  factory EmptySpace.half() => EmptySpace(height: double.infinity / 2);

  factory EmptySpace.horizontal() => EmptySpace(width: 30, height: 5);
  factory EmptySpace.horizontalSmall() => EmptySpace(width: 10, height: 5);
  factory EmptySpace.horizontalLarge() => EmptySpace(width: 50, height: 5);
  factory EmptySpace.horizontalHalf() =>
      EmptySpace(width: double.infinity / 2, height: 5);

  @override
  Widget build(BuildContext context) {
    final double totalWidth = AppUtils().getScreenWidth(context);
    return SizedBox(height: height, width: width ?? totalWidth);
  }
}
