import 'package:flutter/cupertino.dart';
import 'package:flutter_locker/flutter_locker.dart';

class BiometricUtils {
  static const String authKey = "authToken";
  static Future<bool> saveSecurely(String authToken) async {
    try {
      // Check if device sypports biometric auth
      final isBiometricAuthSupported = await FlutterLocker.canAuthenticate();

      if (!isBiometricAuthSupported) return false;

      await FlutterLocker.save(
        SaveSecretRequest(
          key: BiometricUtils.authKey,
          secret: authToken,
          androidPrompt: AndroidPrompt(
            title: 'Authenticate to remember your login details',
            cancelLabel: 'Cancel',
          ),
        ),
      );

      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  static Future<String> retreiveAuthToken() async {
    try {
      final isBiometricAuthSupported = await FlutterLocker.canAuthenticate();

      if (!isBiometricAuthSupported) return "";

      return await FlutterLocker.retrieve(
        RetrieveSecretRequest(
          key: BiometricUtils.authKey,
          androidPrompt: AndroidPrompt(
            title: 'Authenticate to proceed',
            cancelLabel: 'Cancel',
          ),
          iOsPrompt: IOsPrompt(touchIdText: 'Authenticate to proceed'),
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
      return "";
    }
  }

  static Future<void> clearSecuredStore() async {
    await FlutterLocker.delete(BiometricUtils.authKey);
  }
}
