import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/layouts/default.dart';
import 'package:sampay_wallet/core/models/authentication_model.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/core/widgets/simple_toast.dart';
import 'package:sampay_wallet/services/authentication_service.dart';
import 'package:sampay_wallet/core/services/configure_dependencies.dart';
import 'package:sampay_wallet/core/widgets/simple_app_text.dart';
import 'package:sampay_wallet/core/widgets/empty_space.dart';
import 'package:sampay_wallet/features/forgot_password/widgets/forgot_password_form.dart';
import 'package:watch_it/watch_it.dart';

class ForgotPasswordPage extends StatelessWidget with WatchItMixin {
  final AuthenticationService authService = getIt<AuthenticationService>();

  ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme appTheme = AppConstants.AppTheme(context);

    final bool isLoading = watchValue(
      (ValueNotifier<bool> m) => m,
      instanceName: "isAppLoading",
    );

    void goToLogin() async {
      if (context.mounted) {
        context.pop();
      }
    }

    void showStatus(
      bool isSuccess, {
      String errorMessage = "Error sending password reset email",
    }) {
      authService.setForgotPasswordDetails(ForgotPasswordModel());
      AppUtils().hideKeyboard(context);
      if (isSuccess) {
        SimpleToast.showSuccessToast(
          "Password reset link sent to your email address",
          context,
          onCompleted: goToLogin,
        );
      } else {
        SimpleToast.showErrorToast(errorMessage, context);
      }
    }

    void handleSubmit(ForgotPasswordModel details) async {
      authService.resetPassword(details).then((response) {
        showStatus(response.isSuccess, errorMessage: response.displayMessage);
      });
    }

    return DefaultLayout(
      isShowBackButton: true,
      isLoading: isLoading,
      footer: SimpleAppText.small(
        "Built with ❤️ in Zambia",
        align: TextAlign.center,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SimpleAppText(
            "Forgot Password",
            fontWeight: FontWeight.w900,
            fontSize: 20,
          ),
          EmptySpace.small(),
          SimpleAppText.small(
            "Enter the email associated with your account to reset the password",
            align: .center,
          ),
          EmptySpace.large(),
          ForgotPasswordForm(onSubmit: handleSubmit),
        ],
      ),
    );
  }
}
