import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sampay_wallet/core/extensions/widget_extensions.dart';
import 'package:sampay_wallet/core/layouts/default.dart';
import 'package:sampay_wallet/core/models/authentication_model.dart';
import 'package:sampay_wallet/core/routes/app_router.dart';
import 'package:sampay_wallet/core/themes/app_theme.dart';
import 'package:sampay_wallet/core/utils/biometric_utils.dart';
import 'package:sampay_wallet/core/widgets/simple_flex.dart';
import 'package:sampay_wallet/services/authentication_service.dart';
import 'package:sampay_wallet/core/services/configure_dependencies.dart';
import 'package:sampay_wallet/core/widgets/simple_app_text.dart';
import 'package:sampay_wallet/core/widgets/empty_space.dart';
import 'package:sampay_wallet/core/widgets/simple_toast.dart';
import 'package:sampay_wallet/features/login/widgets/login_form.dart';
import 'package:watch_it/watch_it.dart';

class LoginPage extends StatelessWidget with WatchItMixin {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    AuthenticationService authService = getIt<AuthenticationService>();

    void handleSignIn(AuthenticationModel credentials) {
      authService.signIn(credentials).then((response) {
        if (!response.isSuccess) {
          if (context.mounted) {
            SimpleToast(
              response.errorMessage ?? response.displayMessage,
              context,
            );
          }
        } else {
          // If remember me selected, launch biometric to save the token
          if (authService.rememberMe.value && response.accessToken != null) {
            BiometricUtils.saveSecurely(response.accessToken!).then((
              isSavedSecurely,
            ) {
              if (context.mounted) {
                if (!isSavedSecurely) {
                  SimpleToast.showErrorToast(
                    "Biometric authentication not available or not used to store details. ",
                    context,
                  );
                }

                context.pushReplacement(AppRoutes.dashboard);
              }
            });
          } else {
            if (context.mounted) {
              context.pushReplacement(AppRoutes.dashboard);
            }
          }
        }
      });
    }

    final bool isLoading = watchValue(
      (ValueNotifier<bool> m) => m,
      instanceName: "isAppLoading",
    );

    return DefaultLayout(
      isLoading: isLoading,
      footer: SimpleAppText.small(
        "Built with ❤️ in Zambia",
        align: TextAlign.center,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          EmptySpace(),
          SimpleAppText.title(
            "Please provide your mobile number to login",
            align: TextAlign.center,
          ),
          EmptySpace(),
          SignInForm(
            onForgotPasswordClicked: () {
              context.push(AppRoutes.forgotPassword);
            },
            onSignInClicked: handleSignIn,
          ),
          EmptySpace.large(),
          SimpleFlex(
            alignment: .spaceEvenly,
            children: [
              SimpleAppText.title("Don't have an account?"),
              SimpleAppText.title(
                "Signup now",
                color: AppTheme.currentTheme.colorScheme.primary,
              ).onTap(() {
                //context.push(AppRoutes.registration);
                context.push(
                  AppRoutes.webview,
                  extra: {
                    'url':
                        "https://samafricaonline.com/sam_pay/public/register",
                    'title': "Sampay Sign-up",
                    'exitOn':
                        "https://samafricaonline.com/sam_pay/public/login",
                    "exitTo": AppRoutes.login,
                  },
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}
