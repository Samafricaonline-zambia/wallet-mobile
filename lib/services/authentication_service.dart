import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/api_endpoints.dart';
import 'package:sampay_wallet/core/extensions/general_extensions.dart';
import 'package:sampay_wallet/core/models/authentication_model.dart';
import 'package:sampay_wallet/core/models/registration_model.dart';
import 'package:sampay_wallet/core/services/configure_dependencies.dart';
import 'package:sampay_wallet/core/services/loader_service.dart';
import 'package:sampay_wallet/core/services/network_service.dart';
import 'package:sampay_wallet/core/services/storage_service.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/core/utils/biometric_utils.dart';
import 'package:sampay_wallet/services/app_state_service.dart';

class AuthenticationService extends ChangeNotifier {
  final NetworkService networkService = getIt<NetworkService>();
  final AppStateService appState = getIt<AppStateService>();
  final AppLoaderService appLoaderService = getIt<AppLoaderService>();
  final StorageService storageService = getIt<StorageService>();
  //ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<bool> rememberMe = ValueNotifier(true);
  ValueNotifier<ForgotPasswordModel> forgotPasswordDetails =
      ValueNotifier<ForgotPasswordModel>(ForgotPasswordModel());

  ValueNotifier<AuthenticationModel> credentials =
      ValueNotifier<AuthenticationModel>(
        AuthenticationModel(
          phone: kDebugMode
              ? const String.fromEnvironment('DEBUG_PHONE', defaultValue: '')
              : "",
          password: kDebugMode
              ? const String.fromEnvironment('DEBUG_PASSWORD', defaultValue: '')
              : "",
        ),
      );

  AuthenticationService();

  Future<void> init() async {}

  void updateRememberMe(bool value) {
    rememberMe.value = value;

    notifyListeners();
  }

  void setForgotPasswordDetails(ForgotPasswordModel value) {
    forgotPasswordDetails.value = value;

    notifyListeners();
  }

  Future<bool> validateAccessToken(String accessToken) async {
    final NetworkResponse response = await networkService.get(
      ApiEndpoints.walletBalance,
      bearerToken: accessToken,
    );

    appState.updateIsAccessTokenValid(response.isSuccess);
    notifyListeners();
    return response.isSuccess;
  }

  void updateCredentials(AuthenticationModel value) {
    credentials.value = value;

    notifyListeners();
  }

  Future<NetworkResponse> signIn(AuthenticationModel newCredentials) async {
    try {
      appLoaderService.updateIsLoading(true);
      credentials.value = newCredentials;

      await logout();

      final payload = {
        "phone": AppUtils().formatPhoneNumber(
          newCredentials.phone,
          prefixWith: "+260",
        ),
        "password": newCredentials.password,
      };
      final NetworkResponse response = await networkService.post(
        ApiEndpoints.login,
        jsonBody: payload.toJson,
      );

      if (response.isSuccess) {
        final signInResponse = AuthResponse.fromJson(response.data);

        appState.updateLoggedInUser(signInResponse);
      } else {
        appState.updateLoggedInUser(null);
      }

      return response;
    } catch (e) {
      return NetworkResponse.error(message: e.toString());
    } finally {
      appLoaderService.updateIsLoading(false);
      notifyListeners();
    }
  }

  Future<NetworkResponse> resetPassword(
    ForgotPasswordModel newCredentials,
  ) async {
    try {
      appLoaderService.updateIsLoading(true);
      final NetworkResponse response = await networkService.post(
        ApiEndpoints.forgotPassword,
        jsonBody: newCredentials.toJson(),
      );

      if (response.isSuccess) {
        final signInResponse = AuthResponse.fromJson(response.data);

        appState.updateLoggedInUser(signInResponse);
      } else {
        appState.updateLoggedInUser(null);
      }

      return response;
    } catch (e) {
      return NetworkResponse.error(message: e.toString());
    } finally {
      appLoaderService.updateIsLoading(false);
      notifyListeners();
    }
  }

  Future<void> logout({VoidCallback? onComplete}) async {
    storageService.clear();
    await BiometricUtils.clearSecuredStore();

    onComplete?.call();
  }

  Future<NetworkResponse> sendOTP(RegistrationModel request) async {
    try {
      appLoaderService.updateIsLoading(true);
      final payload = {
        'phone': AppUtils().formatPhoneNumber(
          request.phone,
          prefixWith: "+260",
        ),
      };

      final NetworkResponse response = await networkService.post(
        ApiEndpoints.sendOtp,
        jsonBody: payload.toJson,
      );

      return response;
    } catch (e) {
      return NetworkResponse.error(message: e.toString());
    } finally {
      appLoaderService.updateIsLoading(false);
      notifyListeners();
    }
  }

  Future<NetworkResponse> verifyOTP(RegistrationModel request) async {
    try {
      appLoaderService.updateIsLoading(true);
      final payload = {
        'phone': AppUtils().formatPhoneNumber(
          request.phone,
          prefixWith: "+260",
        ),
        'otp': request.code,
      };

      final NetworkResponse response = await networkService.post(
        ApiEndpoints.verifyOtp,
        jsonBody: payload.toJson,
      );

      return response;
    } catch (e) {
      return NetworkResponse.error(message: e.toString());
    } finally {
      appLoaderService.updateIsLoading(false);
      notifyListeners();
    }
  }

  Future<NetworkResponse> registerUser(RegistrationModel request) async {
    try {
      appLoaderService.updateIsLoading(true);
      final payload = {
        "phone": AppUtils().formatPhoneNumber(request.phone, prefixWith: "0"),
        "name": request.name,
        "email": request.email,
        "password": request.password,
        "password_confirmation": request.confirmPassword,
        "ref": AppUtils().generateReference(prefix: "REF"),
        "rid": "DSA456",
      };

      final NetworkResponse response = await networkService.post(
        ApiEndpoints.register,
        jsonBody: payload.toJson,
      );

      return response;
    } catch (e) {
      return NetworkResponse.error(message: e.toString());
    } finally {
      appLoaderService.updateIsLoading(false);
      notifyListeners();
    }
  }
}
