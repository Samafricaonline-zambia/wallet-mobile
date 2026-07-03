import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sampay_wallet/core/layouts/default.dart';
import 'package:sampay_wallet/core/models/authentication_model.dart';
import 'package:sampay_wallet/core/models/registration_model.dart';
import 'package:sampay_wallet/core/routes/app_router.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/core/widgets/simple_slider.dart';
import 'package:sampay_wallet/core/widgets/simple_toast.dart';
import 'package:sampay_wallet/features/registration/widgets/register_user_form.dart';
import 'package:sampay_wallet/features/registration/widgets/send_otp_form.dart';
import 'package:sampay_wallet/features/registration/widgets/validate_otp_form.dart';
import 'package:sampay_wallet/services/authentication_service.dart';
import 'package:sampay_wallet/core/services/configure_dependencies.dart';
import 'package:sampay_wallet/core/widgets/simple_app_text.dart';
import 'package:sampay_wallet/core/widgets/empty_space.dart';
import 'package:watch_it/watch_it.dart';

class RegistrationPage extends WatchingStatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  int activePageIndex = 0;

  void updateActivePageIndex(int value) {
    setState(() {
      activePageIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationService authService = getIt<AuthenticationService>();

    final bool isLoading = watchValue(
      (ValueNotifier<bool> m) => m,
      instanceName: "isAppLoading",
    );

    void handleOnSendOTP(RegistrationModel request) async {
      updateActivePageIndex(++activePageIndex);

      authService.sendOTP(request).then((value) {
        if (AppUtils().isContextValid(context)) {
          if (value.isSuccess) {
            SimpleToast.showSuccessToast(
              value.displayMessage,
              context,
              onCompleted: () => updateActivePageIndex(1),
            );
          } else {
            SimpleToast.showErrorToast(value.displayMessage, context);
          }
        }
      });
    }

    void handleOnVerifyOTP(RegistrationModel request) async {
      authService.verifyOTP(request).then((value) {
        if (AppUtils().isContextValid(context)) {
          if (value.isSuccess) {
            SimpleToast.showSuccessToast(
              value.displayMessage,
              context,
              onCompleted: () => updateActivePageIndex(2),
            );
          } else {
            SimpleToast.showErrorToast(value.displayMessage, context);
          }
        }
      });
    }

    void handleOnRegisterUser(RegistrationModel request) async {
      authService.registerUser(request).then((value) {
        if (AppUtils().isContextValid(context)) {
          if (value.isSuccess) {
            SimpleToast.showSuccessToast(
              value.displayMessage,
              context,
              onCompleted: () {
                context.go(AppRoutes.login);
              },
            );
          } else {
            SimpleToast.showErrorToast(value.displayMessage, context);
          }
        }
      });
    }

    return DefaultLayout(
      isLoading: isLoading,
      isShowBackButton: true,
      footer: SimpleAppText.small(
        "Built with ❤️ in Zambia",
        align: TextAlign.center,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          EmptySpace(),
          SimpleAppText.title(
            "Please provide your mobile number to begin registration",
            align: TextAlign.center,
          ),
          EmptySpace(),
          SimpleSlider(
            activeIndex: activePageIndex,
            height: 500,

            children: [
              SizedBox(
                width: AppUtils().getScreenWidth(context),
                child: SendOTPForm(onSubmit: handleOnSendOTP),
              ),
              SizedBox(
                width: AppUtils().getScreenWidth(context),
                child: VerifyOTPForm(
                  onSubmit: handleOnVerifyOTP,
                  onResend: handleOnSendOTP,
                ),
              ),
              SizedBox(
                width: AppUtils().getScreenWidth(context),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: RegisterUserForm(onSubmit: handleOnRegisterUser),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
