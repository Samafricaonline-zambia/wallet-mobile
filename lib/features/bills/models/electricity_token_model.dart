import 'dart:convert';

import 'package:collection/collection.dart';

class ElectricityTokensModel {
  final bool status;
  final List<ElectricityTokenModel> tokens;
  ElectricityTokensModel({required this.status, required this.tokens});

  ElectricityTokensModel copyWith({
    bool? status,
    List<ElectricityTokenModel>? tokens,
  }) {
    return ElectricityTokensModel(
      status: status ?? this.status,
      tokens: tokens ?? this.tokens,
    );
  }

  Map<String, dynamic> toMap() {
    return {'status': status, 'tokens': tokens.map((x) => x.toMap()).toList()};
  }

  factory ElectricityTokensModel.fromMap(Map<String, dynamic> map) {
    return ElectricityTokensModel(
      status: map['status'] ?? false,
      tokens: List<ElectricityTokenModel>.from(
        map['tokens']?.map((x) => ElectricityTokenModel.fromMap(x)),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ElectricityTokensModel.fromJson(String source) =>
      ElectricityTokensModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'ElectricityTokensModel(status: $status, tokens: $tokens)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is ElectricityTokensModel &&
        other.status == status &&
        listEquals(other.tokens, tokens);
  }

  @override
  int get hashCode => status.hashCode ^ tokens.hashCode;
}

class ElectricityTokenModel {
  final int id;
  final String token;
  final String time;
  ElectricityTokenModel({
    required this.id,
    required this.token,
    required this.time,
  });

  ElectricityTokenModel copyWith({int? id, String? token, String? time}) {
    return ElectricityTokenModel(
      id: id ?? this.id,
      token: token ?? this.token,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'token': token, 'time': time};
  }

  factory ElectricityTokenModel.fromMap(Map<String, dynamic> map) {
    return ElectricityTokenModel(
      id: map['id']?.toInt() ?? 0,
      token: map['token'] ?? '',
      time: map['time'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ElectricityTokenModel.fromJson(String source) =>
      ElectricityTokenModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'ElectricityTokenModel(id: $id, token: $token, time: $time)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ElectricityTokenModel &&
        other.id == id &&
        other.token == token &&
        other.time == time;
  }

  @override
  int get hashCode => id.hashCode ^ token.hashCode ^ time.hashCode;
}
