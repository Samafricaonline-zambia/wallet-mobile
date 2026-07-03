// lib/core/widgets/remember_me.dart
import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/widgets/simple_app_text.dart';

class RememberMe extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String label;
  final Color? activeColor;
  final Color? checkColor;

  const RememberMe({
    super.key,
    required this.value,
    required this.onChanged,
    this.label = 'Remember me',
    this.activeColor,
    this.checkColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: value,
            onChanged: (value) => onChanged.call(value ?? false),
            activeColor: activeColor ?? Theme.of(context).primaryColor,
            checkColor: checkColor ?? Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => onChanged(!value),
          child: SimpleAppText(label, color: Colors.grey.shade700),
        ),
      ],
    );
  }
}
