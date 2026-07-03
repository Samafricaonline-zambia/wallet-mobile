import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/app_icons.dart';
import 'package:sampay_wallet/core/extensions/widget_extensions.dart';
import 'package:sampay_wallet/core/models/authentication_model.dart';
import 'package:sampay_wallet/core/services/configure_dependencies.dart';
import 'package:sampay_wallet/core/themes/app_theme.dart';
import 'package:sampay_wallet/core/validations/validations.dart';
import 'package:sampay_wallet/core/widgets/simple_app_text.dart';
import 'package:sampay_wallet/core/widgets/empty_space.dart';
import 'package:sampay_wallet/core/widgets/simple_flex.dart';
import 'package:sampay_wallet/core/widgets/simple_form.dart';
import 'package:sampay_wallet/core/widgets/simple_text_field.dart';
import 'package:sampay_wallet/features/login/widgets/remember_me.dart';
import 'package:sampay_wallet/services/authentication_service.dart';
import 'package:watch_it/watch_it.dart';

class SignInForm extends StatelessWidget with WatchItMixin {
  final AuthenticationService authService = getIt<AuthenticationService>();
  final VoidCallback? onForgotPasswordClicked;
  final Function(bool value)? onRememberMeClicked;
  final Function(AuthenticationModel credentials)? onSignInClicked;

  SignInForm({
    super.key,
    this.onForgotPasswordClicked,
    this.onRememberMeClicked,
    this.onSignInClicked,
  });

  @override
  Widget build(BuildContext context) {
    final AuthenticationModel credentials = watchValue(
      (ValueNotifier<AuthenticationModel> m) => m,
      instanceName: "credentials",
    );

    final bool rememberMe = watchValue(
      (ValueNotifier<bool> m) => m,
      instanceName: "rememberMe",
    );

    return SimpleForm(
      actionTitle: "Sign In",
      isFullWidth: false,
      onSubmit: () => onSignInClicked?.call(credentials),
      children: [
        SimpleTextField(
          labelText: "Mobile number",
          icon: AppIcons.phone,
          prefixText: "+260",
          initialValue: credentials.phone,
          keyboardType: .phone,
          validator: (v) => AppValidations.validatePhoneNumber(v),
          onChanged: (value) =>
              authService.updateCredentials(credentials.copyWith(phone: value)),
        ),
        EmptySpace.small(),
        SimpleTextField(
          labelText: "Password",
          isPasswordField: true,
          initialValue: credentials.password,
          keyboardType: .text,
          validator: (v) => AppValidations.validateNotNull(
            v,
            message: "Password cannot be empty",
          ),
          onChanged: (value) => authService.updateCredentials(
            credentials.copyWith(password: value),
          ),
        ),
        EmptySpace.small(),
        SimpleFlex(
          leftChild: RememberMe(
            value: rememberMe,
            onChanged: (value) => authService.updateRememberMe(value),
          ),
          rightChild: SimpleAppText(
            "Forgot password?",
            color: AppTheme.currentTheme.colorScheme.primary,
          ).onTap(onForgotPasswordClicked),
        ),
      ],
    );
  }
}
