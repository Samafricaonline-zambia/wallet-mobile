import 'package:flutter/material.dart';

class SimpleList extends StatelessWidget {
  final int itemCount;
  final Widget? Function(BuildContext context, int index) itemBuilder;
  final Widget? separator;
  const SimpleList({
    super.key,
    required this.itemBuilder,
    this.separator,
    this.itemCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    if (separator != null) {
      return ListView.separated(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: itemBuilder,
        separatorBuilder: (context, index) => separator!,
        itemCount: itemCount,
      );
    }

    return ListView.builder(
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: itemBuilder,
      itemCount: itemCount,
    );
  }
}
