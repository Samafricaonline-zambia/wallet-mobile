import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/app_icons.dart';
import 'package:sampay_wallet/core/models/authentication_model.dart';
import 'package:sampay_wallet/core/services/configure_dependencies.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/core/validations/validations.dart';
import 'package:sampay_wallet/core/widgets/empty_space.dart';
import 'package:sampay_wallet/core/widgets/simple_form.dart';
import 'package:sampay_wallet/core/widgets/simple_text_field.dart';
import 'package:sampay_wallet/services/authentication_service.dart';
import 'package:watch_it/watch_it.dart';

class ForgotPasswordForm extends StatelessWidget with WatchItMixin {
  final Function(ForgotPasswordModel forgotPasswordDetails)? onSubmit;
  final AuthenticationService authService = getIt<AuthenticationService>();

  ForgotPasswordForm({super.key, this.onSubmit});

  @override
  Widget build(BuildContext context) {
    final ForgotPasswordModel forgotPasswordDetails = watchValue(
      (ValueNotifier<ForgotPasswordModel> m) => m,
      instanceName: "forgotPasswordDetails",
    );

    return SimpleForm(
      onSubmit: () {
        onSubmit?.call(forgotPasswordDetails);
      },
      actionTitle: "Send Reset Link",
      isFullWidth: true,
      children: [
        SimpleTextField(
          labelText: "Email Address",
          icon: AppIcons.email,
          initialValue: AppUtils()
              .valueOrDefault(forgotPasswordDetails.email)
              .toString(),
          keyboardType: .emailAddress,
          validator: (v) => AppValidations.validateEmail(
            v,
            message: "Enter correct email address",
          ),
          onChanged: (value) => authService.setForgotPasswordDetails(
            forgotPasswordDetails.copyWith(email: value),
          ),
        ),
      ],
    );
  }
}
