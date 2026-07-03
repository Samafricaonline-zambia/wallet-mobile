import 'dart:convert';

extension NumberFormatting on Map<String, dynamic> {
  String get toJson {
    return json.encode(this);
  }
}
