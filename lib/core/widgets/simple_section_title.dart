import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/widgets/simple_app_text.dart';

class SimpleSectionTitle extends StatelessWidget {
  final String? title;
  final Color? color;
  final bool isCenterTitle;
  final FontWeight? fontWeight;

  const SimpleSectionTitle({
    super.key,
    this.title,
    this.isCenterTitle = false,
    this.color = Colors.black,
    this.fontWeight = FontWeight.w700,
  });

  @override
  Widget build(BuildContext context) {
    if (isCenterTitle) {
      return Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          children: [
            Expanded(child: Divider(thickness: 2, color: Colors.grey.shade300)),
            const SizedBox(width: 12),
            SimpleAppText(
              title ?? "",
              fontSize: 18,
              fontWeight: fontWeight,
              color: color,
            ),
            const SizedBox(width: 12),
            Expanded(child: Divider(thickness: 2, color: Colors.grey.shade300)),
          ],
        ),
      );
    }

    // Default left-aligned with line on right
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        children: [
          SimpleAppText(
            title ?? "",
            fontSize: 18,
            fontWeight: fontWeight,
            color: color,
          ),
          const SizedBox(width: 12),
          Expanded(child: Divider(thickness: 2, color: Colors.grey.shade300)),
        ],
      ),
    );
  }
}
