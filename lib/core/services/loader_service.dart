import 'package:flutter/material.dart';

class AppLoaderService extends ChangeNotifier {
  ValueNotifier<bool> isLoading = ValueNotifier(false);

  AppLoaderService();

  void updateIsLoading(bool value) {
    isLoading.value = value;

    notifyListeners();
  }
}
