import 'dart:convert';

class RegistrationModel {
  final String phone;
  final String code;
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final String ref;
  final String rid;

  const RegistrationModel({
    required this.phone,
    required this.code,
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
    this.ref = "REF123",
    this.rid = "DSA456",
  });
  RegistrationModel copyWith({
    String? phone,
    String? code,
    String? name,
    String? email,
    String? password,
    String? confirmPassword,
    String? ref,
    String? rid,
  }) {
    return RegistrationModel(
      phone: phone ?? this.phone,
      code: code ?? this.code,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      ref: ref ?? this.ref,
      rid: rid ?? this.rid,
    );
  }

  factory RegistrationModel.empty() => RegistrationModel(
    phone: "",
    code: "",
    name: "",
    email: "",
    password: "",
    confirmPassword: "",
    ref: "",
    rid: "",
  );

  String toJson() => json.encode(toMap());

  factory RegistrationModel.fromJson(String value) =>
      fromMap(json.decode(value));

  Map<String, Object?> toMap() {
    return {
      'phone': phone,
      'code': code,
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': confirmPassword,
      'ref': ref,
      'rid': rid,
    };
  }

  static RegistrationModel fromMap(Map<String, dynamic?> json) {
    return RegistrationModel(
      phone: json['phone'] ?? "",
      code: json['code'] ?? "",
      name: json['name'] ?? "",
      email: json['email'] ?? "",
      password: json['password'] ?? "",
      confirmPassword: json['password_confirmation'] ?? "",
      ref: json['ref'] ?? "",
      rid: json['rid'] ?? "",
    );
  }

  @override
  String toString() {
    return 'phone:$phone, code:$code, name:$name, email:$email, password:$password, confirmPassword:$confirmPassword, ref:$ref, rid:$rid';
  }

  @override
  bool operator ==(Object other) {
    return other is RegistrationModel &&
        other.runtimeType == runtimeType &&
        other.phone == phone &&
        other.code == code &&
        other.name == name &&
        other.email == email &&
        other.password == password &&
        other.confirmPassword == confirmPassword &&
        other.ref == ref &&
        other.rid == rid;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      phone,
      code,
      name,
      email,
      password,
      confirmPassword,
      ref,
      rid,
    );
  }
}
