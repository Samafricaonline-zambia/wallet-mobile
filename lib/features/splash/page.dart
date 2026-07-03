import 'package:flutter/material.dart';
import 'package:flutter_locker/flutter_locker.dart';
import 'package:go_router/go_router.dart';
import 'package:sampay_wallet/core/layouts/default.dart';
import 'package:sampay_wallet/core/routes/app_router.dart';
import 'package:sampay_wallet/core/services/network_service.dart';
import 'package:sampay_wallet/core/utils/biometric_utils.dart';
import 'package:sampay_wallet/services/app_state_service.dart';
import 'package:sampay_wallet/services/authentication_service.dart';
import 'package:sampay_wallet/core/services/configure_dependencies.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthenticationService authService = getIt<AuthenticationService>();
  final AppStateService appState = getIt<AppStateService>();
  final NetworkService paymentService = getIt<NetworkService>(
    instanceName: "paymentService",
  );

  void gotoDashboard() async {
    context.go(AppRoutes.dashboard);
  }

  void gotoLogin() async {
    authService.logout(onComplete: () => context.go(AppRoutes.login));
  }

  @override
  void initState() {
    super.initState();

    AppUtils().executeDelayed(() async {
      String securedAuthToken = await BiometricUtils.retreiveAuthToken();

      if (securedAuthToken.isEmpty) {
        if (appState.loggedInUser.value != null) {
          securedAuthToken = appState.loggedInUser.value!.accessToken;
        }
      }

      if (await authService.validateAccessToken(securedAuthToken)) {
        gotoDashboard();
        return;
      }

      gotoLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(isShowLoadingState: true);
  }
}
