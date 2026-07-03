import 'package:fl_app_toast/fl_app_toast.dart';
import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/app_icons.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/themes/color_constants.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';

class SimpleToast {
  SimpleToast(
    String message,
    BuildContext context, {
    ToastType type = ToastType.info,
    VoidCallback? onCompleted,
  }) {
    showSimpleToast(message, context, type, onCompleted: onCompleted);
  }

  Color getBackGroundColor(ToastType type, BuildContext context) {
    switch (type) {
      case ToastType.error:
        return AppConstants.AppTheme(context).error;

      case ToastType.success:
        return AppConstants.AppTheme(context).success;

      case ToastType.warning:
        return AppConstants.AppTheme(context).warning;

      default:
        return AppConstants.AppTheme(context).dark;
    }
  }

  Color getForeGroundColor(ToastType type, BuildContext context) {
    switch (type) {
      case ToastType.error:
        return AppConstants.AppTheme(context).onError;

      case ToastType.success:
        return AppConstants.AppTheme(context).onSuccess;

      case ToastType.warning:
        return AppConstants.AppTheme(context).onWarning;

      default:
        return AppConstants.AppTheme(context).onDark;
    }
  }

  Icon getIcon(ToastType type, BuildContext context) {
    switch (type) {
      case ToastType.error:
        return Icon(AppIcons.error, color: getForeGroundColor(type, context));

      case ToastType.success:
        return Icon(AppIcons.success, color: getForeGroundColor(type, context));

      case ToastType.warning:
        return Icon(AppIcons.warning, color: getForeGroundColor(type, context));

      default:
        return Icon(AppIcons.info, color: getForeGroundColor(type, context));
    }
  }

  void showSimpleToast(
    String message,
    BuildContext context,
    ToastType type, {
    VoidCallback? onCompleted,
  }) {
    if (context.mounted) {
      FlAppToast.showToast(
        message,
        type: type,
        position: ToastPosition.bottom,
        duration: Duration(seconds: 3),
        backgroundColor: getBackGroundColor(type, context),
        textColor: getForeGroundColor(type, context),
        borderRadius: 20.0,
        textSize: 12.0,
        imageSize: 20.0,
        icon: getIcon(type, context),
        iconColor: getForeGroundColor(type, context),
        context: context,
      );

      AppUtils().executeDelayed(() {
        if (onCompleted != null) {
          onCompleted();
        }
      }, duration: Duration(seconds: 3));
    }
  }

  SimpleToast.showSuccessToast(
    String message,
    BuildContext context, {
    VoidCallback? onCompleted,
  }) {
    showSimpleToast(
      message,
      context,
      ToastType.success,
      onCompleted: onCompleted,
    );
  }

  SimpleToast.showErrorToast(
    String message,
    BuildContext context, {
    VoidCallback? onCompleted,
  }) {
    showSimpleToast(
      message,
      context,
      ToastType.error,
      onCompleted: onCompleted,
    );
  }

  SimpleToast.showWarningToast(
    String message,
    BuildContext context, {
    VoidCallback? onCompleted,
  }) {
    showSimpleToast(
      message,
      context,
      ToastType.warning,
      onCompleted: onCompleted,
    );
  }
}
