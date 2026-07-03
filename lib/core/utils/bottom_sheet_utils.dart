import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sampay_wallet/core/layouts/default_bs.dart';

class BottomSheetUtils {
  late BuildContext _context;

  BottomSheetUtils(BuildContext context) {
    _context = context;
  }

  void open(Widget content, {VoidCallback? onClose}) {
    if (_context.mounted) {
      showModalBottomSheet(
        enableDrag: false,
        context: _context,
        builder: (context) {
          return DefaultBottomSheet(child: content);
        },
      ).then((value) {
        onClose?.call();
      });
    }
  }

  void close() {
    if (_context.mounted) {
      _context.pop();
    }
  }
}
