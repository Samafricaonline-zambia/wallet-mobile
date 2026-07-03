// core/services/storage_service.dart
import 'package:dartz/dartz_unsafe.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  SharedPreferences? _preferences;

  // Initialize storage service
  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // Save string value
  Future<bool> save(String key, String value) async {
    try {
      return await _preferences?.setString(key, value) ?? false;
    } catch (e) {
      return false;
    }
  }

  // Read string value
  String read(String key) => _preferences?.getString(key) ?? "";

  // Delete value
  Future<bool> delete(String key) async {
    try {
      return await _preferences?.remove(key) ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> clear() async {
    try {
      return await _preferences?.clear() ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<List<Map<String, String>>?> allKeyValues() async {
    try {
      final allKeys = _preferences?.getKeys();
      final List<Map<String, String>> returnValue = [];
      if (allKeys!.isNotEmpty) {
        for (var key in allKeys) {
          final value = read(key);

          debugPrint("$key: $value");
          returnValue.add({key: value});
        }
      }

      return returnValue;
    } catch (e) {
      return null;
    }
  }
}
