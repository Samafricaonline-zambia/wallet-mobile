import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/models/registration_model.dart';
import 'package:sampay_wallet/core/services/configure_dependencies.dart';
import 'package:sampay_wallet/services/authentication_service.dart';

class RegistrationService extends ChangeNotifier {
  final AuthenticationService authService = getIt<AuthenticationService>();
  ValueNotifier<RegistrationModel> newUser = ValueNotifier<RegistrationModel>(
    RegistrationModel.empty(),
  );

  void updatenNewUser(RegistrationModel value) {
    newUser.value = value;

    notifyListeners();
  }
}
