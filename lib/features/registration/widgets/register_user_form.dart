import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/app_icons.dart';
import 'package:sampay_wallet/core/models/registration_model.dart';
import 'package:sampay_wallet/core/services/configure_dependencies.dart';
import 'package:sampay_wallet/core/validations/validations.dart';
import 'package:sampay_wallet/core/widgets/empty_space.dart';
import 'package:sampay_wallet/core/widgets/simple_form.dart';
import 'package:sampay_wallet/core/widgets/simple_text_field.dart';
import 'package:sampay_wallet/features/registration/services/registration_service.dart';
import 'package:watch_it/watch_it.dart';

class RegisterUserForm extends StatelessWidget with WatchItMixin {
  final RegistrationService registrationService = getIt<RegistrationService>();
  final Function(RegistrationModel value)? onSubmit;
  RegisterUserForm({super.key, this.onSubmit});

  @override
  Widget build(BuildContext context) {
    final RegistrationModel newUser = watchValue(
      (ValueNotifier<RegistrationModel> m) => m,
      instanceName: "newUser",
    );

    return SimpleForm(
      actionTitle: "Submit",
      onSubmit: () => onSubmit?.call(newUser),
      children: [
        SimpleTextField(
          labelText: "Phone Number",
          icon: AppIcons.phone,
          isDisabled: true,
          initialValue: newUser.phone,
          keyboardType: .phone,
          validator: (v) => AppValidations.validatePhoneNumber(v),
          onChanged: (value) => registrationService.updatenNewUser(
            newUser.copyWith(phone: value),
          ),
        ),
        EmptySpace.small(),
        SimpleTextField(
          labelText: "Full name",
          icon: AppIcons.profile,
          initialValue: newUser.name,
          keyboardType: .name,
          validator: (v) =>
              AppValidations.validateNotNull(v, message: "Enter a valid name"),
          onChanged: (value) =>
              registrationService.updatenNewUser(newUser.copyWith(name: value)),
        ),
        EmptySpace.small(),
        SimpleTextField(
          labelText: "Email",
          icon: AppIcons.email,
          initialValue: newUser.email,
          keyboardType: .emailAddress,
          validator: (v) => AppValidations.validateEmail(v),
          onChanged: (value) => registrationService.updatenNewUser(
            newUser.copyWith(email: value),
          ),
        ),
        EmptySpace.small(),
        SimpleTextField(
          labelText: "Password",
          isPasswordField: true,
          initialValue: newUser.password,
          keyboardType: .text,
          validator: (v) => AppValidations.validatePassword(v),
          onChanged: (value) => registrationService.updatenNewUser(
            newUser.copyWith(password: value),
          ),
        ),
        EmptySpace.small(),
        SimpleTextField(
          labelText: "Confirm Password",
          isPasswordField: true,
          initialValue: newUser.confirmPassword,
          keyboardType: .text,
          validator: (v) =>
              AppValidations.validateConfirmPassword(v, newUser.password),
          onChanged: (value) => registrationService.updatenNewUser(
            newUser.copyWith(confirmPassword: value),
          ),
        ),
      ],
    );
  }
}
