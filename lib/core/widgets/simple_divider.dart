import 'package:flutter/material.dart';

class SimpleDivider extends StatelessWidget {
  final Color color;
  final EdgeInsetsGeometry? padding;
  const SimpleDivider({super.key, this.color = Colors.black12, this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Divider(thickness: 2, color: color),
    );
  }
}
