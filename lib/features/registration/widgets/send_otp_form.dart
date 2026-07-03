import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/app_icons.dart';
import 'package:sampay_wallet/core/models/registration_model.dart';
import 'package:sampay_wallet/core/services/configure_dependencies.dart';
import 'package:sampay_wallet/core/validations/validations.dart';
import 'package:sampay_wallet/core/widgets/simple_form.dart';
import 'package:sampay_wallet/core/widgets/simple_text_field.dart';
import 'package:sampay_wallet/features/registration/services/registration_service.dart';
import 'package:watch_it/watch_it.dart';

class SendOTPForm extends StatelessWidget with WatchItMixin {
  final RegistrationService registrationService = getIt<RegistrationService>();
  final Function(RegistrationModel value)? onSubmit;
  SendOTPForm({super.key, this.onSubmit});

  @override
  Widget build(BuildContext context) {
    final RegistrationModel newUser = watchValue(
      (ValueNotifier<RegistrationModel> m) => m,
      instanceName: "newUser",
    );

    return SimpleForm(
      actionTitle: "Send Code",
      onSubmit: () => onSubmit?.call(newUser),
      children: [
        SimpleTextField(
          labelText: "Phone number",
          icon: AppIcons.phone,
          prefixText: "+260",
          initialValue: newUser.phone,
          keyboardType: .phone,
          validator: (v) => AppValidations.validatePhoneNumber(v),
          onChanged: (value) => registrationService.updatenNewUser(
            newUser.copyWith(phone: value),
          ),
        ),
      ],
    );
  }
}
