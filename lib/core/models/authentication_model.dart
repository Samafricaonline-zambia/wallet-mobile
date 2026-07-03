import 'dart:convert';

class AuthenticationModel {
  String phone;
  String password;

  AuthenticationModel({required this.phone, required this.password});

  AuthenticationModel copyWith({
    String? phone,
    String? password,
    bool? rememberMe,
  }) {
    return AuthenticationModel(
      phone: phone ?? this.phone,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return {'phone': phone, 'password': password};
  }

  factory AuthenticationModel.empty() =>
      AuthenticationModel(phone: "", password: "");

  factory AuthenticationModel.fromMap(Map<String, dynamic> map) {
    return AuthenticationModel(
      phone: map['phone'] ?? '',
      password: map['password'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthenticationModel.fromJson(String source) =>
      AuthenticationModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'AuthenticationModel(phone: $phone, password: $password)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthenticationModel &&
        other.phone == phone &&
        other.password == password;
  }

  @override
  int get hashCode => phone.hashCode ^ password.hashCode;
}

// core/models/auth_response.dart
class AuthResponse {
  final bool status;
  final String message;
  final String tokenType;
  final String accessToken;
  final User user;

  const AuthResponse({
    required this.status,
    required this.message,
    required this.tokenType,
    required this.accessToken,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      tokenType: json['token_type'] ?? 'Bearer',
      accessToken: json['access_token'] ?? '',
      user: User.fromJson(json['user'] ?? {}),
    );
  }

  factory AuthResponse.fromJsonString(String jsonString) =>
      AuthResponse.fromJson(json.decode(jsonString));

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'token_type': tokenType,
      'access_token': accessToken,
      'user': user.toJson(),
    };
  }

  // Helper getters
  bool get isSuccess => status;
  String get fullToken => '$tokenType $accessToken';
  bool get isLoggedIn => status && accessToken.isNotEmpty;
  String get displayName => user.name;

  String get maskedPhone {
    if (user.phone.length < 10) return user.phone;
    final start = user.phone.substring(0, 3);
    final end = user.phone.substring(user.phone.length - 3);
    return '$start****$end';
  }

  String get maskedEmail {
    final parts = user.email.split('@');
    if (parts[0].length < 3) return user.email;
    final start = parts[0].substring(0, 3);
    return '$start***@${parts[1]}';
  }

  @override
  String toString() => json.encode({
    'status': status,
    'message': message,
    'token_type': tokenType,
    'access_token': accessToken,
    'user': user.toJson(),
  });
}

class User {
  final int id;
  final String name;
  final String email;
  final String phone;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email, 'phone': phone};
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, phone: $phone)';
  }
}

class ForgotPasswordModel {
  final String? email;

  const ForgotPasswordModel({this.email});
  ForgotPasswordModel copyWith({String? email}) {
    return ForgotPasswordModel(email: email ?? this.email);
  }

  String toJson() => json.encode(toMap());

  Map<String, Object?> toMap() {
    return {'email': email};
  }

  factory ForgotPasswordModel.fromMap(Map<String, dynamic> map) {
    return ForgotPasswordModel(email: map["email"] ?? "");
  }

  static ForgotPasswordModel fromJson(String source) =>
      ForgotPasswordModel.fromMap(json.decode(source));

  @override
  String toString() {
    return '''ChangePasswordModel(
                email:$email,
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is ForgotPasswordModel &&
        other.runtimeType == runtimeType &&
        other.email == email;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, email);
  }
}
