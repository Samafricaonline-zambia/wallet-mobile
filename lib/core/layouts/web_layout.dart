import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sampay_wallet/core/constants/app_icons.dart';
import 'package:sampay_wallet/core/themes/color_constants.dart';
import 'package:sampay_wallet/core/widgets/simple_app_text.dart';
import 'package:sampay_wallet/core/widgets/simple_modal_progress.dart';

class WebLayout extends StatelessWidget {
  final String? title;
  final Widget child;
  final bool isLoading;
  final bool isShowNavigation;
  final VoidCallback? onBackClick;

  const WebLayout({
    super.key,
    required this.child,
    this.title,
    this.isLoading = false,
    this.isShowNavigation = false,
    this.onBackClick,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SimpleAppText(title ?? "", color: AppColors.onDark),
        elevation: 7,
        //surfaceTintColor: AppColors.kPrimary,
        backgroundColor: AppColors.kPrimary,
        shadowColor: AppColors.light,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(AppIcons.back, color: AppColors.onDark),
          onPressed: () {
            if (onBackClick != null) {
              onBackClick!();
            } else {
              context.pop();
            }
          },
        ),
      ),
      body: SimpleModalProgress(child, isLoading: isLoading),
    );
  }
}
