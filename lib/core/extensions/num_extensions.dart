// lib/core/extensions/num_extensions.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension NumberFormatting on num {
  /// Smart formatting - shows commas for smaller numbers, abbreviations for large ones
  /// Examples:
  /// 500 -> "500"
  /// 1,500 -> "1,500"
  /// 15,000 -> "15,000"
  /// 150,000 -> "150,000"
  /// 1,500,000 -> "1.5M"
  /// 15,000,000 -> "15M"
  /// 150,000,000 -> "150M"
  /// 1,500,000,000 -> "1.5Bn"
  String get smartBalance {
    final num = this.toDouble();

    // For numbers less than 1 million, show full number with commas
    if (num < 1_000_000) {
      return _formatWithCommas(num);
    }

    // For numbers 1 million and above, use abbreviations
    if (num < 1_000_000_000) {
      final millions = (num / 1_000_000).toStringAsFixed(1);
      return '${_removeDecimalZero(millions)}M';
    }

    if (num < 1_000_000_000_000) {
      final billions = (num / 1_000_000_000).toStringAsFixed(1);
      return '${_removeDecimalZero(billions)}Bn';
    }

    final trillions = (num / 1_000_000_000_000).toStringAsFixed(1);
    return '${_removeDecimalZero(trillions)}Tn';
  }

  /// Smart balance with currency symbol
  String get smartCurrency => 'ZMW $smartBalance';

  /// Force full formatting with commas (no abbreviations)
  String get fullBalance => _formatWithCommas(this.toDouble());

  /// Force full currency format
  String get fullCurrency => 'ZMW $fullBalance';

  String _formatWithCommas(double num) {
    final formatter = NumberFormat.decimalPattern();
    if (num == num.roundToDouble()) {
      return formatter.format(num.round());
    }
    return formatter.format(num);
  }

  String _removeDecimalZero(String value) {
    if (value.endsWith('.0')) {
      return value.substring(0, value.length - 2);
    }
    return value;
  }
}
