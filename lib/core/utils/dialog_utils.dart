import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sampay_wallet/core/constants/app_icons.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/themes/color_constants.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/core/widgets/empty_space.dart';
import 'package:sampay_wallet/core/widgets/simple_app_text.dart';
import 'package:sampay_wallet/core/widgets/simple_buttons.dart';
import 'package:sampay_wallet/core/widgets/simple_flex.dart';

class DialogUtils {
  Future<T?> openModalDialog<T>(
    BuildContext context,
    Widget content, {
    String title = "",
    IconData? titleIcon,
    String? titleImage,
    bool isShowCloseButtonInHeader = true,
    bool isNoPadding = true,
  }) async {
    final ColorScheme appTheme = AppConstants.AppTheme(context);

    Widget getTitle() {
      if (titleIcon != null) {
        return Expanded(
          child: Row(
            children: [
              Icon(titleIcon),
              EmptySpace.horizontalSmall(),
              Expanded(child: SimpleAppText(title, shouldWrap: false)),
            ],
          ),
        );
      }

      if (titleImage != null) {
        return Expanded(
          child: Row(
            children: [
              Image(image: AssetImage(titleImage), width: 30),
              EmptySpace.horizontalSmall(),
              Expanded(child: SimpleAppText(title, shouldWrap: false)),
            ],
          ),
        );
      }

      return Expanded(child: SimpleAppText(title, shouldWrap: false));
    }

    return showDialog<T>(
      useSafeArea: true,
      context: context,
      barrierDismissible: false,
      animationStyle: AnimationStyle(
        duration: Duration(milliseconds: 300),
        reverseDuration: Duration(milliseconds: 100),
        curve: Curves.easeInOutCubic,
      ),
      builder: (BuildContext context) {
        return AlertDialog(
          constraints: BoxConstraints(
            minWidth: AppUtils().getScreenWidth(context) * 0.8,
            maxWidth: AppUtils().getScreenWidth(context) * 0.9,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppConstants.STANDARD_BORDER_RADIUS,
            ),
          ),
          titlePadding: EdgeInsets.zero,
          title: Container(
            padding: EdgeInsets.only(
              left: AppConstants.STANDARD_PAGE_PADDING,
              //right: AppConstants.STANDARD_PAGE_PADDING / 2,
              //top: AppConstants.STANDARD_PAGE_PADDING / 2,
              //bottom: AppConstants.STANDARD_PAGE_PADDING / 2,
            ),
            decoration: BoxDecoration(
              color: appTheme.lightGrey,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppConstants.STANDARD_BORDER_RADIUS),
                topRight: Radius.circular(AppConstants.STANDARD_BORDER_RADIUS),
              ),
              border: Border(
                bottom: BorderSide(
                  color: appTheme.grey, // or any color you want
                  width: 1.0, // thickness of the border
                ),
              ),
            ),
            child: SimpleFlex(
              leftChild: getTitle(),
              rightChild: isShowCloseButtonInHeader
                  ? IconButton(
                      icon: Icon(AppIcons.close),
                      onPressed: () => context.pop(),
                    )
                  : null,
            ),
          ),
          contentPadding: isNoPadding
              ? EdgeInsets.zero
              : EdgeInsets.all(AppConstants.STANDARD_PAGE_PADDING),
          backgroundColor: appTheme.white,
          content: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: content,
          ),
        );
      },
    );
  }

  Future<T?> openConfirmDialog<T>(
    BuildContext context, {
    String title = "Confirm",
    String message = "Are you sure you want to proceed?",
    String yesTitle = "Yes",
    String noTitle = "No",
    T? yesValue,
    T? noValue,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: true,
      animationStyle: AnimationStyle(
        duration: Duration(milliseconds: 300),
        reverseDuration: Duration(milliseconds: 100),
        curve: Curves.easeInOutCubic,
      ),
      builder: (BuildContext context) {
        final ColorScheme appTheme = AppConstants.AppTheme(context);

        return AlertDialog.adaptive(
          title: SimpleAppText(title),
          content: SingleChildScrollView(
            child: Column(
              children: [
                EmptySpace.small(),
                SimpleAppText(message, align: .center),
                EmptySpace(),
                SimpleFlex(
                  leftChild: SimpleButtons.small(
                    yesTitle,
                    onClick: () => Navigator.pop(context, yesValue ?? true),
                  ),
                  rightChild: SimpleButtons.small(
                    noTitle,
                    backgroundColor: appTheme.secondaryAction,
                    foregroundColor: appTheme.onSecondaryAction,
                    onClick: () => Navigator.pop(context, noValue ?? false),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
