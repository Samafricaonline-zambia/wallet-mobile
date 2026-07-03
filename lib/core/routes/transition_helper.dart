import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TransitionHelper {
  // Change from pageBuilder to builder
  static Widget slideInFromRight(Widget page) {
    return page; // Just return the widget directly
  }

  // Or create a proper page transition
  static Page fadeIn(Widget page) {
    return CustomTransitionPage(
      key: ValueKey(page),
      child: page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}
