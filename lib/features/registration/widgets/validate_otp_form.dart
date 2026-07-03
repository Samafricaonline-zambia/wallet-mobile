import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:sampay_wallet/core/models/registration_model.dart';
import 'package:sampay_wallet/core/services/configure_dependencies.dart';
import 'package:sampay_wallet/core/validations/validations.dart';
import 'package:sampay_wallet/core/widgets/empty_space.dart';
import 'package:sampay_wallet/core/widgets/simple_form.dart';
import 'package:sampay_wallet/core/widgets/simple_resend.dart';
import 'package:sampay_wallet/features/registration/services/registration_service.dart';
import 'package:watch_it/watch_it.dart';

class VerifyOTPForm extends StatelessWidget with WatchItMixin {
  final RegistrationService registrationService = getIt<RegistrationService>();
  final Function(RegistrationModel value)? onSubmit;
  final Function(RegistrationModel value)? onResend;
  VerifyOTPForm({super.key, this.onSubmit, this.onResend});

  @override
  Widget build(BuildContext context) {
    final RegistrationModel newUser = watchValue(
      (ValueNotifier<RegistrationModel> m) => m,
      instanceName: "newUser",
    );

    return SimpleForm(
      actionTitle: "Verify",
      onSubmit: () => onSubmit?.call(newUser),
      children: [
        Pinput(
          autofocus: true,
          length: 6,
          validator: (v) => AppValidations.validateCharCount(v),
          onChanged: (value) =>
              registrationService.updatenNewUser(newUser.copyWith(code: value)),
        ),
        EmptySpace.small(),
        SimpleResendCounter(onResendClick: () => onResend?.call(newUser)),
      ],
    );
  }
}
